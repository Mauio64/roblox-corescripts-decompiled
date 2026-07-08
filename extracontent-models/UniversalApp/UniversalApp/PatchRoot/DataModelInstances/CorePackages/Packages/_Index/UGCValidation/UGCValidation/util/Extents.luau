local t1 = {}

t1.__index = t1

function t1.new() -- line: 14
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.min = Vector3.new(1e999, 1e999, 1e999)
	self.max = Vector3.new(-1e999, -1e999, -1e999)

	return self
end
function t1.fromMinMax(vector3: Vector3, vector3_2: Vector3) -- line: 22
	-- upvalues: t1 (copy)
	local v5 = t1.new()
	local t2 = {
		X = vector3.X,
		Y = vector3.Y,
		Z = vector3.Z
	}
	local t3 = {
		X = vector3_2.X,
		Y = vector3_2.Y,
		Z = vector3_2.Z
	}

	for _, v9 in {
		"X",
		"Y",
		"Z"
	} do
		if t3[v9] ~= -1e999 and t2[v9] ~= 1e999 and t2[v9] > t3[v9] then
			local v10 = t2[v9]

			t2[v9] = t3[v9]
			t3[v9] = v10
		end
	end

	v5.min = Vector3.new(t2.X, t2.Y, t2.Z)
	v5.max = Vector3.new(t3.X, t3.Y, t3.Z)

	return v5
end
function t1.unionExtents(p1, p2) -- line: 42
	-- upvalues: t1 (copy)
	local v13 = t1.new()

	v13.min = p1.min:Min(p2.min)
	v13.max = p1.max:Max(p2.max)

	return v13
end
function t1.intersectExtents(p3, p4) -- line: 49
	-- upvalues: t1 (copy)
	local t4 = {
		X = 1e999,
		Y = 1e999,
		Z = 1e999
	}
	local t5 = {
		X = -1e999,
		Y = -1e999,
		Z = -1e999
	}

	for _, v19 in {
		"X",
		"Y",
		"Z"
	} do
		if not (p3.max[v19] < p3.min[v19]) and not (p4.max[v19] < p4.min[v19]) then
			local v20 = math.max(p3.min[v19], p4.min[v19])
			local v21 = math.min(p3.max[v19], p4.max[v19])

			if v20 <= v21 then
				t4[v19] = v20
				t5[v19] = v21
			end
		end
	end

	local v22 = t1.new()

	v22.min = Vector3.new(t4.X, t4.Y, t4.Z)
	v22.max = Vector3.new(t5.X, t5.Y, t5.Z)

	return v22
end
function t1.expandToInclude(t6: {[any]: any}, vector3: Vector3) -- line: 72
	-- upvalues: t1 (copy)
	local v25 = t1.new()

	v25.min = t6.min:Min(vector3)
	v25.max = t6.max:Max(vector3)

	return v25
end
function t1.isValid(p5) -- line: 79
	for _, v28 in {
		"X",
		"Y",
		"Z"
	} do
		if p5.max[v28] < p5.min[v28] then
			return false
		end
	end

	return true
end
function t1.size(p6) -- line: 88
	if p6:isValid() then
		return p6.max - p6.min
	end

	return nil
end
function t1.center(p7) -- line: 95
	if p7:isValid() then
		return (p7.max + p7.min) / 2
	end

	return nil
end

return t1
