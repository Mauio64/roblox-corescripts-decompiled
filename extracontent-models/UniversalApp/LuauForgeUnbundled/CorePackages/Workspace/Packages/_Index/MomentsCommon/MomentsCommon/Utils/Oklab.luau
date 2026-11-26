local function fromSrgb(p2)
	local v6 = vector.dot(p2, Vector3.new(0.41222146, 0.53633255, 0.051445995)) ^ (1 / 3)
	local v7 = vector.dot(p2, Vector3.new(0.2119035, 0.6806995, 0.10739696)) ^ (1 / 3)
	local v8 = vector.dot(p2, Vector3.new(0.08830246, 0.28171885, 0.6299787)) ^ (1 / 3)

	return (vector.create(
		v6 * 0.2104542553 + v7 * 0.793617785 - v8 * 0.0040720468,
		v6 * 1.9779984951 - v7 * 2.428592205 + v8 * 0.4505937099,
		v6 * 0.0259040371 + v7 * 0.7827717662 - v8 * 0.808675766
	))
end

local function toSrgb(data)
	local vector2 = vector.create(
		data.x + 0.3963377774 * data.y + 0.2158037573 * data.z,
		data.x - 0.1055613458 * data.y - 0.0638541728 * data.z,
		data.x - 0.0894841775 * data.y - 1.291485548 * data.z
	)

	local v6 = vector2 * vector2 * vector2

	local x = v6.x
	local y = v6.y
	local z = v6.z

	return (vector.create(
		x * 4.0767416621 - y * 3.3077115913 + z * 0.2309699292,
		x * -1.2684380046 + y * 2.6097574011 - z * 0.3413193965,
		x * -0.0041960863 - y * 0.7034186147 + z * 1.707614701
	))
end

return {
	fromColor3 = function(data)
		local vector2 = vector.create(data.R, data.G, data.B)
		local v6 = vector.dot(vector2, Vector3.new(0.41222146, 0.53633255, 0.051445995)) ^ (1 / 3)
		local v7 = vector.dot(vector2, Vector3.new(0.2119035, 0.6806995, 0.10739696)) ^ (1 / 3)
		local v8 = vector.dot(vector2, Vector3.new(0.08830246, 0.28171885, 0.6299787)) ^ (1 / 3)

		return (vector.create(
			v6 * 0.2104542553 + v7 * 0.793617785 - v8 * 0.0040720468,
			v6 * 1.9779984951 - v7 * 2.428592205 + v8 * 0.4505937099,
			v6 * 0.0259040371 + v7 * 0.7827717662 - v8 * 0.808675766
		))
	end,
	toColor3 = function(p2)
		local v6 = toSrgb(p2)
		return Color3.new(v6.x, v6.y, v6.z)
	end,
	lerp = function(data, data2, p2)
		local vector2 = vector.create(data.R, data.G, data.B)
		local v6 = vector.dot(vector2, Vector3.new(0.41222146, 0.53633255, 0.051445995)) ^ (1 / 3)
		local v7 = vector.dot(vector2, Vector3.new(0.2119035, 0.6806995, 0.10739696)) ^ (1 / 3)
		local v8 = vector.dot(vector2, Vector3.new(0.08830246, 0.28171885, 0.6299787)) ^ (1 / 3)

		local vector3 = vector.create(
			v6 * 0.2104542553 + v7 * 0.793617785 - v8 * 0.0040720468,
			v6 * 1.9779984951 - v7 * 2.428592205 + v8 * 0.4505937099,
			v6 * 0.0259040371 + v7 * 0.7827717662 - v8 * 0.808675766
		)

		local vector4 = vector.create(data2.R, data2.G, data2.B)
		local v9 = vector.dot(vector4, Vector3.new(0.41222146, 0.53633255, 0.051445995)) ^ (1 / 3)
		local v10 = vector.dot(vector4, Vector3.new(0.2119035, 0.6806995, 0.10739696)) ^ (1 / 3)
		local v11 = vector.dot(vector4, Vector3.new(0.08830246, 0.28171885, 0.6299787)) ^ (1 / 3)

		local lerped = vector.lerp(
			vector3,
			vector.create(
				v9 * 0.2104542553 + v10 * 0.793617785 - v11 * 0.0040720468,
				v9 * 1.9779984951 - v10 * 2.428592205 + v11 * 0.4505937099,
				v9 * 0.0259040371 + v10 * 0.7827717662 - v11 * 0.808675766
			),
			p2
		)

		local clamped = vector.clamp(toSrgb(lerped), Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
		return Color3.new(clamped.x, clamped.y, clamped.z)
	end
}
