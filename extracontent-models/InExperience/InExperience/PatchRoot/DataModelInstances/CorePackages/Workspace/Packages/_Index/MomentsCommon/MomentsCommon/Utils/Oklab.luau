local t1 = {}

local function fromSrgb(vector3: Vector3) -- line: 7
	local v5 = vector.dot(vector3, (Vector3.new(0.4122214615345001, 0.5363325476646423, 0.05144599452614784))) ^ 0.3333333333333333
	local v6 = vector.dot(vector3, (Vector3.new(0.21190349757671356, 0.6806995272636414, 0.10739696025848389))) ^ 0.3333333333333333
	local v7 = vector.dot(vector3, (Vector3.new(0.08830246329307556, 0.2817188501358032, 0.6299787163734436))) ^ 0.3333333333333333

	return (vector.create(v5 * 0.2104542553 + v6 * 0.793617785 - v7 * 0.0040720468, v5 * 1.9779984951 - v6 * 2.428592205 + v7 * 0.4505937099, v5 * 0.0259040371 + v6 * 0.7827717662 - v7 * 0.808675766))
end
local function toSrgb(vector3: Vector3) -- line: 19
	local v9 = vector.create(vector3.x + vector3.y * 0.3963377774 + vector3.z * 0.2158037573, vector3.x - vector3.y * 0.1055613458 - vector3.z * 0.0638541728, vector3.x - vector3.y * 0.0894841775 - vector3.z * 1.291485548)
	local v10 = v9 * v9 * v9
	local x = v10.x
	local y = v10.y
	local z = v10.z

	return (vector.create(x * 4.0767416621 - y * 3.3077115913 + z * 0.2309699292, x * -1.2684380046 + y * 2.6097574011 - z * 0.3413193965, x * -0.0041960863 - y * 0.7034186147 + z * 1.707614701))
end

function t1.fromColor3(color3: Color3) -- line: 38
	local v15 = vector.create(color3.R, color3.G, color3.B)
	local v16 = vector.dot(v15, (Vector3.new(0.4122214615345001, 0.5363325476646423, 0.05144599452614784))) ^ 0.3333333333333333
	local v17 = vector.dot(v15, (Vector3.new(0.21190349757671356, 0.6806995272636414, 0.10739696025848389))) ^ 0.3333333333333333
	local v18 = vector.dot(v15, (Vector3.new(0.08830246329307556, 0.2817188501358032, 0.6299787163734436))) ^ 0.3333333333333333

	return (vector.create(v16 * 0.2104542553 + v17 * 0.793617785 - v18 * 0.0040720468, v16 * 1.9779984951 - v17 * 2.428592205 + v18 * 0.4505937099, v16 * 0.0259040371 + v17 * 0.7827717662 - v18 * 0.808675766))
end
function t1.toColor3(vector3: Vector3) -- line: 42
	-- upvalues: toSrgb (copy)
	local v20 = toSrgb(vector3)

	return Color3.new(v20.x, v20.y, v20.z)
end
function t1.lerp(color3: Color3, color3_2: Color3, n1: number) -- line: 47
	-- upvalues: toSrgb (copy)
	local v24 = vector.create(color3.R, color3.G, color3.B)
	local v25 = vector.dot(v24, (Vector3.new(0.4122214615345001, 0.5363325476646423, 0.05144599452614784))) ^ 0.3333333333333333
	local v26 = vector.dot(v24, (Vector3.new(0.21190349757671356, 0.6806995272636414, 0.10739696025848389))) ^ 0.3333333333333333
	local v27 = vector.dot(v24, (Vector3.new(0.08830246329307556, 0.2817188501358032, 0.6299787163734436))) ^ 0.3333333333333333
	local v28 = vector.create(v25 * 0.2104542553 + v26 * 0.793617785 - v27 * 0.0040720468, v25 * 1.9779984951 - v26 * 2.428592205 + v27 * 0.4505937099, v25 * 0.0259040371 + v26 * 0.7827717662 - v27 * 0.808675766)
	local v29 = vector.create(color3_2.R, color3_2.G, color3_2.B)
	local v30 = vector.dot(v29, (Vector3.new(0.4122214615345001, 0.5363325476646423, 0.05144599452614784))) ^ 0.3333333333333333
	local v31 = vector.dot(v29, (Vector3.new(0.21190349757671356, 0.6806995272636414, 0.10739696025848389))) ^ 0.3333333333333333
	local v32 = vector.dot(v29, (Vector3.new(0.08830246329307556, 0.2817188501358032, 0.6299787163734436))) ^ 0.3333333333333333
	local v33 = vector.lerp(v28, vector.create(v30 * 0.2104542553 + v31 * 0.793617785 - v32 * 0.0040720468, v30 * 1.9779984951 - v31 * 2.428592205 + v32 * 0.4505937099, v30 * 0.0259040371 + v31 * 0.7827717662 - v32 * 0.808675766), n1)
	local v34 = vector.clamp(toSrgb(v33), Vector3.new(0, 0, 0), (Vector3.new(1, 1, 1)))

	return Color3.new(v34.x, v34.y, v34.z)
end

return t1
