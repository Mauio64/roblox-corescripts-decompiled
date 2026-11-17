local function fromSrgb(vector3: Vector3) -- 3 equivalent calls inferred from this helper
	local v = vector.dot(vector3, Vector3.new(0.41222146, 0.53633255, 0.051445995)) ^ (1 / 3)
	local v2 = vector.dot(vector3, Vector3.new(0.2119035, 0.6806995, 0.10739696)) ^ (1 / 3)
	local v3 = vector.dot(vector3, Vector3.new(0.08830246, 0.28171885, 0.6299787)) ^ (1 / 3)

	return (vector.create(
		v * 0.2104542553 + v2 * 0.793617785 - v3 * 0.0040720468,
		v * 1.9779984951 - v2 * 2.428592205 + v3 * 0.4505937099,
		v * 0.0259040371 + v2 * 0.7827717662 - v3 * 0.808675766
	))
end

local function toSrgb(vector3: Vector3)
	local vector2 = vector.create(
		vector3.x + vector3.y * 0.3963377774 + vector3.z * 0.2158037573,
		vector3.x - vector3.y * 0.1055613458 - vector3.z * 0.0638541728,
		vector3.x - vector3.y * 0.0894841775 - vector3.z * 1.291485548
	)

	local v = vector2 * vector2 * vector2

	local x = v.x
	local y = v.y
	local z = v.z

	return (vector.create(
		x * 4.0767416621 - y * 3.3077115913 + z * 0.2309699292,
		x * -1.2684380046 + y * 2.6097574011 - z * 0.3413193965,
		x * -0.0041960863 - y * 0.7034186147 + z * 1.707614701
	))
end

local Oklab = {}

function Oklab.fromColor3(color: Color3)
	return fromSrgb(vector.create(color.R, color.G, color.B)) -- inferred equivalent call
end

function Oklab.toColor3(vector3: Vector3)
	local v = toSrgb(vector3)
	return Color3.new(v.x, v.y, v.z)
end

function Oklab.lerp(color: Color3, color2: Color3, p: number)
	local lerped = vector.lerp(
		fromSrgb(vector.create(color.R, color.G, color.B)), -- inferred equivalent call
		fromSrgb(vector.create(color2.R, color2.G, color2.B)), -- inferred equivalent call
		p
	)

	local clamped = vector.clamp(toSrgb(lerped), Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
	return Color3.new(clamped.x, clamped.y, clamped.z)
end

return Oklab
