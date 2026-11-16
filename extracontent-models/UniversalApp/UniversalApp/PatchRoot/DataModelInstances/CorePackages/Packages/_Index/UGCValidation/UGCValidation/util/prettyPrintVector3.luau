local v = {}

local function prettyPrintVector3(vector3: Vector3, value: number?)
	local v2 = value or 2

	if not v[v2] then
		local v3 = string.format("%%.%df", v2)
		v[v2] = string.format("%s, %s, %s", v3, v3, v3)
	end

	return string.format(v[v2], vector3.X, vector3.Y, vector3.Z)
end

return prettyPrintVector3
