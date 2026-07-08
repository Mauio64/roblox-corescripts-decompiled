local t1 = {}

local function prettyPrintVector3(vector3: Vector3, n1: number?) -- line: 7
	-- upvalues: t1 (copy)
	local v5 = n1 or 2

	if not t1[v5] then
		local v6 = string.format("%%.%df", v5)

		t1[v5] = string.format("%s, %s, %s", v6, v6, v6)
	end

	return string.format(t1[v5], vector3.X, vector3.Y, vector3.Z)
end

return prettyPrintVector3
