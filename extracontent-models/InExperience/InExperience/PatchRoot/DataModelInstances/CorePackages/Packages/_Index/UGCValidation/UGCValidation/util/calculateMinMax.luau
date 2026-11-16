local function compare(vector3: Vector3?, vector3_2: Vector3?, callback)
	if vector3 and vector3_2 then
		return (Vector3.new(
			callback(vector3.X, vector3_2.X),
			callback(vector3.Y, vector3_2.Y),
			callback(vector3.Z, vector3_2.Z)
		))
	end

	return vector3 or vector3_2
end

local function calculateMinMax(vector3: Vector3?, vector3_2: Vector3?, vector3_3: Vector3?, vector3_4: Vector3?)
	local min = math.min
	local v

	if vector3 and vector3_3 then
		v = Vector3.new(min(vector3.X, vector3_3.X), min(vector3.Y, vector3_3.Y), (min(vector3.Z, vector3_3.Z)))
	else
		v = vector3 or vector3_3
	end

	local max = math.max

	if vector3_2 and vector3_4 then
		return
			v,
			(Vector3.new(max(vector3_2.X, vector3_4.X), max(vector3_2.Y, vector3_4.Y), (max(vector3_2.Z, vector3_4.Z))))
	end

	return v, vector3_2 or vector3_4
end

return calculateMinMax
