extends Node3D
## Builds the whole valley procedurally at startup — terrain, river, forest,
## dusk light, station-pad markers. No imported assets: every shape is code.
## Session 1 co-build: edit a constant, press F5, feel the difference.
##
## LEVEL1-SPEC look targets: heightmapped low-poly valley (~600x600m feel),
## pines, trail, river, ridge; dusk palette.

# ---------------- WORLD SHAPE ----------------
const WORLD_SIZE := 600.0            # meters, square valley
const GRID_QUADS := 150              # terrain resolution (150x150 quads)
const BASE_HILL_HEIGHT := 6.0        # rolling ground
const DETAIL_HEIGHT := 1.6           # small bumps
const RIDGE_X := 240.0               # the east ridge (Pad 1 lives up there)
const RIDGE_HEIGHT := 55.0
const RIDGE_WIDTH := 90.0
const WEST_WALL_X := -285.0          # valley wall behind the sunset
const WEST_WALL_HEIGHT := 28.0
const WEST_WALL_WIDTH := 110.0
const RIVER_DEPTH := 7.0             # channel carve
const RIVER_HALF_WIDTH := 15.0       # carve falloff
const WATER_HALF_WIDTH := 12.0       # visible water strip
const WATER_RISE := 1.6              # water level above channel bottom
const MEADOW_CENTER := Vector2(-60.0, 100.0)
const MEADOW_RADIUS := 85.0
const MEADOW_FLATTEN := 0.75         # 0..1 how flat the meadow gets

# ---------------- FOREST ----------------
const TREE_TARGET := 1300
const TREE_SEED := 20260708
const TREE_THIN_ABOVE := 34.0        # treeline starts thinning here
const TREELINE_TOP := 46.0           # no trees above this height
const RIVER_CLEARANCE := 13.0        # no trees this close to the water
const TRAIL_CLEARANCE := 5.0         # no trees on the trail

# ---------------- THE TRAIL (meadow -> ford -> up the ridge) ----------------
const TRAIL: Array[Vector2] = [
	Vector2(-55.0, 115.0), Vector2(-25.0, 70.0), Vector2(0.0, 30.0),
	Vector2(40.0, -10.0), Vector2(120.0, -30.0), Vector2(200.0, -20.0),
	Vector2(235.0, -10.0),
]

# ---------------- STATION PADS (the Session-3 siting tradeoff, staked out) --
const PADS := [
	{ "label": "PAD 1 - RIDGE",    "pos": Vector2(235.0, -10.0) },  # sightlines, long hike
	{ "label": "PAD 2 - MEADOW",   "pos": Vector2(-60.0, 100.0) },  # sun, half-blind
	{ "label": "PAD 3 - TREELINE", "pos": Vector2(90.0, 170.0) },   # fast, poor LoS
]

# ---------------- DUSK ----------------
const SUN_ROTATION_DEG := Vector3(-11.0, -115.0, 0.0)  # low western sun
const SUN_COLOR := Color(1.0, 0.62, 0.42)
const SUN_ENERGY := 1.2
const SKY_TOP := Color(0.10, 0.12, 0.27)
const SKY_HORIZON := Color(0.92, 0.51, 0.32)
const FOG_COLOR := Color(0.45, 0.33, 0.38)
const FOG_DENSITY := 0.0022

const PLAYER_SPAWN := Vector2(-40.0, 140.0)

var _base_noise := FastNoiseLite.new()
var _detail_noise := FastNoiseLite.new()
var _mottle_noise := FastNoiseLite.new()

func _ready() -> void:
	_base_noise.seed = 7
	_base_noise.frequency = 0.005
	_detail_noise.seed = 13
	_detail_noise.frequency = 0.03
	_mottle_noise.seed = 99
	_mottle_noise.frequency = 0.08

	_build_environment()
	_build_sun()
	_build_terrain()
	_build_water()
	_build_trees()
	_build_pads()
	_place_player()

# ================= HEIGHT FIELD (the single source of truth) =================

func river_x(z: float) -> float:
	return 60.0 * sin(z * 0.008) - 40.0

func meadow_factor(x: float, z: float) -> float:
	var d2 := (Vector2(x, z) - MEADOW_CENTER).length_squared()
	return exp(-d2 / (MEADOW_RADIUS * MEADOW_RADIUS))

func terrain_height(x: float, z: float) -> float:
	var h := _base_noise.get_noise_2d(x, z) * BASE_HILL_HEIGHT
	h += _detail_noise.get_noise_2d(x, z) * DETAIL_HEIGHT
	var rdx := (x - RIDGE_X) / RIDGE_WIDTH
	h += RIDGE_HEIGHT * exp(-rdx * rdx)
	var wdx := (x - WEST_WALL_X) / WEST_WALL_WIDTH
	h += WEST_WALL_HEIGHT * exp(-wdx * wdx)
	# north/south rims so the valley feels held
	var ndz := (z + 290.0) / 120.0
	h += 20.0 * exp(-ndz * ndz)
	var sdz := (z - 300.0) / 130.0
	h += 16.0 * exp(-sdz * sdz)
	# the meadow flattens out
	h = lerpf(h, 3.5, meadow_factor(x, z) * MEADOW_FLATTEN)
	# the river carves last
	var rd := (x - river_x(z)) / RIVER_HALF_WIDTH
	h -= RIVER_DEPTH * exp(-rd * rd)
	return h

func height_normal(x: float, z: float) -> Vector3:
	var e := WORLD_SIZE / GRID_QUADS
	return Vector3(
		terrain_height(x - e, z) - terrain_height(x + e, z),
		2.0 * e,
		terrain_height(x, z - e) - terrain_height(x, z + e)
	).normalized()

func trail_distance(p: Vector2) -> float:
	var best := 1e9
	for i in range(TRAIL.size() - 1):
		best = minf(best, _seg_dist(p, TRAIL[i], TRAIL[i + 1]))
	return best

func _seg_dist(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var t := clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
	return p.distance_to(a + ab * t)

# ================= DUSK LIGHT + SKY =================

func _build_environment() -> void:
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = SKY_TOP
	sky_mat.sky_horizon_color = SKY_HORIZON
	sky_mat.sky_curve = 0.09
	sky_mat.ground_bottom_color = Color(0.06, 0.05, 0.08)
	sky_mat.ground_horizon_color = Color(0.7, 0.42, 0.32)
	sky_mat.sun_angle_max = 30.0
	sky_mat.sun_curve = 0.12

	var sky := Sky.new()
	sky.sky_material = sky_mat

	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_sky_contribution = 1.0
	env.ambient_light_energy = 1.3
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.fog_enabled = true
	env.fog_light_color = FOG_COLOR
	env.fog_density = FOG_DENSITY
	env.fog_sky_affect = 0.1

	var we := WorldEnvironment.new()
	we.name = "DuskEnvironment"
	we.environment = env
	add_child(we)

func _build_sun() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = SUN_ROTATION_DEG
	sun.light_color = SUN_COLOR
	sun.light_energy = SUN_ENERGY
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 300.0
	add_child(sun)

# ================= TERRAIN =================

func _build_terrain() -> void:
	var plane := PlaneMesh.new()
	plane.size = Vector2(WORLD_SIZE, WORLD_SIZE)
	plane.subdivide_width = GRID_QUADS - 1
	plane.subdivide_depth = GRID_QUADS - 1

	var arrays := plane.get_mesh_arrays()
	var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	var colors := PackedColorArray()
	colors.resize(verts.size())
	for i in verts.size():
		var v := verts[i]
		var h := terrain_height(v.x, v.z)
		verts[i] = Vector3(v.x, h, v.z)
		colors[i] = _ground_color(v.x, v.z, h)

	# Flat-shaded (faceted) low-poly look: unroll indices, one normal per face.
	var fverts := PackedVector3Array()
	var fnorms := PackedVector3Array()
	var fcols := PackedColorArray()
	fverts.resize(indices.size())
	fnorms.resize(indices.size())
	fcols.resize(indices.size())
	for t in range(0, indices.size(), 3):
		var a := verts[indices[t]]
		var b := verts[indices[t + 1]]
		var c := verts[indices[t + 2]]
		var n := (b - a).cross(c - a).normalized()
		if n.y < 0.0:
			n = -n
		for k in 3:
			fverts[t + k] = verts[indices[t + k]]
			fnorms[t + k] = n
			fcols[t + k] = colors[indices[t + k]]
	var farrays := []
	farrays.resize(Mesh.ARRAY_MAX)
	farrays[Mesh.ARRAY_VERTEX] = fverts
	farrays[Mesh.ARRAY_NORMAL] = fnorms
	farrays[Mesh.ARRAY_COLOR] = fcols

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, farrays)

	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 1.0
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh.surface_set_material(0, mat)

	var mi := MeshInstance3D.new()
	mi.name = "Terrain"
	mi.mesh = mesh
	add_child(mi)

	# Physics: exact trimesh of the visual terrain. Layers 1+2
	# (players collide on 1, the camera spring arm only checks 2).
	var body := StaticBody3D.new()
	body.name = "TerrainBody"
	body.collision_layer = 1 | 2
	var cs := CollisionShape3D.new()
	cs.shape = mesh.create_trimesh_shape()
	body.add_child(cs)
	mi.add_child(body)

func _ground_color(x: float, z: float, h: float) -> Color:
	var grass := Color(0.16, 0.29, 0.1)
	var dry := Color(0.3, 0.3, 0.13)
	var rock := Color(0.36, 0.32, 0.29)
	var c := grass.lerp(dry, clampf(h / 34.0, 0.0, 1.0))
	if h > 36.0:
		c = c.lerp(rock, clampf((h - 36.0) / 12.0, 0.0, 1.0))
	# meadow: warmer, lighter green
	c = c.lerp(Color(0.28, 0.37, 0.13), meadow_factor(x, z) * 0.7)
	# river banks: sandy
	var rd := absf(x - river_x(z))
	var bank := RIVER_HALF_WIDTH + 6.0
	if rd < bank:
		c = c.lerp(Color(0.45, 0.38, 0.26), (1.0 - rd / bank) * 0.8)
	# the trail: packed dirt
	var td := trail_distance(Vector2(x, z))
	if td < 4.0:
		c = c.lerp(Color(0.4, 0.31, 0.2), 0.85 * (1.0 - td / 4.0))
	# mottle so the ground never reads flat
	return c * (0.86 + 0.3 * _mottle_noise.get_noise_2d(x * 4.0, z * 4.0))

# ================= RIVER =================

func _build_water() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var half := WORLD_SIZE * 0.5
	var step := 6.0
	var z := -half
	while z < half - 0.01:
		var z2 := z + step
		var y1 := terrain_height(river_x(z), z) + WATER_RISE
		var y2 := terrain_height(river_x(z2), z2) + WATER_RISE
		var a := Vector3(river_x(z) - WATER_HALF_WIDTH, y1, z)
		var b := Vector3(river_x(z) + WATER_HALF_WIDTH, y1, z)
		var c := Vector3(river_x(z2) + WATER_HALF_WIDTH, y2, z2)
		var d := Vector3(river_x(z2) - WATER_HALF_WIDTH, y2, z2)
		for v in [a, b, c, a, c, d]:
			st.set_normal(Vector3.UP)
			st.add_vertex(v)
		z = z2

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.16, 0.3, 0.42, 0.85)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.roughness = 0.15
	mat.metallic = 0.2
	mat.emission_enabled = true
	mat.emission = Color(0.35, 0.22, 0.2)
	mat.emission_energy_multiplier = 0.25   # the river catches the sunset
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED

	var mi := MeshInstance3D.new()
	mi.name = "River"
	mi.mesh = st.commit()
	mi.material_override = mat
	add_child(mi)

# ================= FOREST =================

func _build_trees() -> void:
	# One low-poly pine = brown trunk + two stacked dark cones.
	var trunk := CylinderMesh.new()
	trunk.top_radius = 0.18
	trunk.bottom_radius = 0.28
	trunk.height = 2.4
	trunk.radial_segments = 6

	var cone1 := CylinderMesh.new()
	cone1.top_radius = 0.0
	cone1.bottom_radius = 2.3
	cone1.height = 5.0
	cone1.radial_segments = 7

	var cone2 := CylinderMesh.new()
	cone2.top_radius = 0.0
	cone2.bottom_radius = 1.5
	cone2.height = 3.4
	cone2.radial_segments = 7

	var st := SurfaceTool.new()
	st.append_from(cone1, 0, Transform3D(Basis(), Vector3(0.0, 3.6, 0.0)))
	st.append_from(cone2, 0, Transform3D(Basis(), Vector3(0.0, 6.4, 0.0)))
	var foliage_mesh := st.commit()

	var trunk_mat := StandardMaterial3D.new()
	trunk_mat.albedo_color = Color(0.3, 0.2, 0.13)
	trunk_mat.roughness = 1.0
	var leaf_mat := StandardMaterial3D.new()
	leaf_mat.albedo_color = Color(1, 1, 1)
	leaf_mat.vertex_color_use_as_albedo = true  # per-tree tint via instance colors
	leaf_mat.roughness = 1.0

	# Scatter: dense on the slopes, sparse in the meadow, none in the river,
	# off the trail and the pads, thinning to bare rock up the ridge.
	var rng := RandomNumberGenerator.new()
	rng.seed = TREE_SEED
	var transforms: Array[Transform3D] = []
	var attempts := 0
	var half := WORLD_SIZE * 0.5 - 6.0
	while transforms.size() < TREE_TARGET and attempts < TREE_TARGET * 8:
		attempts += 1
		var x := rng.randf_range(-half, half)
		var z := rng.randf_range(-half, half)
		if absf(x - river_x(z)) < RIVER_CLEARANCE:
			continue
		if trail_distance(Vector2(x, z)) < TRAIL_CLEARANCE:
			continue
		if rng.randf() < meadow_factor(x, z) * 0.9:
			continue  # the meadow stays open
		var too_close := false
		for pad in PADS:
			if Vector2(x, z).distance_to(pad["pos"]) < 9.0:
				too_close = true
				break
		if too_close:
			continue
		var h := terrain_height(x, z)
		if h > TREELINE_TOP:
			continue  # bare ridge top
		if h > TREE_THIN_ABOVE and rng.randf() < (h - TREE_THIN_ABOVE) / (TREELINE_TOP - TREE_THIN_ABOVE):
			continue  # thinning treeline
		var s := rng.randf_range(0.75, 1.45)
		var basis := Basis(Vector3.UP, rng.randf_range(0.0, TAU)).scaled(Vector3(s, s * rng.randf_range(0.9, 1.25), s))
		transforms.append(Transform3D(basis, Vector3(x, h - 0.2, z)))

	var color_rng := RandomNumberGenerator.new()
	color_rng.seed = TREE_SEED + 1
	for setup in [[trunk, trunk_mat, "Trunks"], [foliage_mesh, leaf_mat, "Foliage"]]:
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_colors = setup[2] == "Foliage"
		mm.mesh = setup[0]
		mm.instance_count = transforms.size()
		for i in transforms.size():
			var t: Transform3D = transforms[i]
			if setup[2] == "Trunks":
				t = Transform3D(t.basis, t.origin + Vector3(0.0, 1.2 * t.basis.get_scale().y, 0.0))
			mm.set_instance_transform(i, t)
			if mm.use_colors:
				# pine greens drift from deep blue-green to dry yellow-green
				var g := color_rng.randf()
				mm.set_instance_color(i, Color(0.09, 0.24, 0.12).lerp(Color(0.18, 0.28, 0.1), g)
					* color_rng.randf_range(0.85, 1.15))
		var mmi := MultiMeshInstance3D.new()
		mmi.name = setup[2]
		mmi.multimesh = mm
		mmi.material_override = setup[1]
		add_child(mmi)

	# Trunk collision so you (not the camera) bump into trees — layer 1 only.
	var body := StaticBody3D.new()
	body.name = "TreeTrunks"
	body.collision_layer = 1
	var shape := CylinderShape3D.new()
	shape.radius = 0.4
	shape.height = 6.0
	for t in transforms:
		var cs := CollisionShape3D.new()
		cs.shape = shape
		cs.position = t.origin + Vector3(0.0, 3.0, 0.0)
		body.add_child(cs)
	add_child(body)

# ================= STATION PAD MARKERS =================

func _build_pads() -> void:
	var pole_mesh := CylinderMesh.new()
	pole_mesh.top_radius = 0.12
	pole_mesh.bottom_radius = 0.16
	pole_mesh.height = 6.0
	var pole_mat := StandardMaterial3D.new()
	pole_mat.albedo_color = Color(1.0, 0.75, 0.3)
	pole_mat.emission_enabled = true
	pole_mat.emission = Color(1.0, 0.6, 0.2)
	pole_mat.emission_energy_multiplier = 1.4

	for pad in PADS:
		var p: Vector2 = pad["pos"]
		var ground := terrain_height(p.x, p.y)
		var pole := MeshInstance3D.new()
		pole.mesh = pole_mesh
		pole.material_override = pole_mat
		pole.position = Vector3(p.x, ground + 3.0, p.y)
		add_child(pole)
		var label := Label3D.new()
		label.text = pad["label"]
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.font_size = 120
		label.pixel_size = 0.018
		label.outline_size = 32
		label.modulate = Color(1.0, 0.9, 0.7)
		label.position = Vector3(p.x, ground + 7.2, p.y)
		add_child(label)

# ================= SPAWN =================

func _place_player() -> void:
	# Debug knobs for machine screenshots:
	#   -- --spawn=x,z     put the player somewhere else
	#   -- --face=degrees  turn the camera (0 = looking north / -Z)
	var spawn := PLAYER_SPAWN
	var face_deg := 0.0
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--spawn="):
			var parts := arg.trim_prefix("--spawn=").split(",")
			if parts.size() >= 2:
				spawn = Vector2(parts[0].to_float(), parts[1].to_float())
		elif arg.begins_with("--face="):
			face_deg = arg.trim_prefix("--face=").to_float()
	var player := get_node_or_null("Player")
	if player:
		player.position = Vector3(spawn.x, terrain_height(spawn.x, spawn.y) + 1.2, spawn.y)
		if face_deg != 0.0:
			player.get_node("CamYaw").rotation.y = deg_to_rad(face_deg)
			player.get_node("Visual").rotation.y = deg_to_rad(face_deg)
