local function compare(vector3: Vector3?, vector3_2: Vector3?, p1: ((...any) -> ...any)) -- line: 5
	if vector3 and vector3_2 then
		return (Vector3.new(p1(vector3.X, vector3_2.X), p1(vector3.Y, vector3_2.Y), p1(vector3.Z, vector3_2.Z)))
	end

	return vector3 or vector3_2
end
local function calculateMinMax(vector3: Vector3?, vector3_3: Vector3?, vector3_4: Vector3?, vector3_5: Vector3?) -- line: 14
	local min = math.min
	local v11 = if not vector3 or not vector3_4 then vector3 or vector3_4 else Vector3.new(min(vector3.X, vector3_4.X), min(vector3.Y, vector3_4.Y), (min(vector3.Z, vector3_4.Z)))
	local max = math.max

	if vector3_3 and vector3_5 then
		return v11, (Vector3.new(max(vector3_3.X, vector3_5.X), max(vector3_3.Y, vector3_5.Y), (max(vector3_3.Z, vector3_5.Z))))
	end

	return v11, vector3_3 or vector3_5
end

return calculateMinMax
