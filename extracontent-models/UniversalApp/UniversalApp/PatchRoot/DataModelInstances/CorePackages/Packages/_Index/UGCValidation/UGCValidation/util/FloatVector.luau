local t1 = {}

function t1.new(...) -- line: 12
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.data = {}

	local t2 = { ... }

	if #t2 == 1 and typeof(t2[1]) == "table" then
		t2 = if getmetatable(t2[1]) ~= t1 then t2[1] else t2[1].data
	end

	for _, v5 in t2 do
		if typeof(v5) ~= "number" then
			error("arg to FloatVector.new() not a number")
		else
			table.insert(self.data, v5)
		end
	end

	return self
end
function t1.getSize(p1) -- line: 37
	return #p1.data
end
function t1.checkCompatible(p2, p3) -- line: 41
	-- upvalues: t1 (copy)
	if typeof(p2) ~= typeof(t1) or typeof(p3) ~= typeof(t1) then
		error("vector operation on non-vector type")

		return false
	end

	if #p2.data ~= #p3.data then
		error("operating on vectors of different dimension")

		return false
	end

	return true
end
function t1.__index(p4, p5) -- line: 54
	-- upvalues: t1 (copy)
	if typeof(p5) == "number" then
		return p4.data[p5]
	end

	return t1[p5]
end
function t1.__newindex(p6, p7, p8) -- line: 62
	if typeof(p7) == "number" then
		p6.data[p7] = p8

		return
	end

	rawset(p6, p7, p8)
end
function t1.__add(p9, p10) -- line: 71
	-- upvalues: t1 (copy)
	t1.checkCompatible(p9, p10)

	local t3 = {}

	for i = 1, #p9.data do
		table.insert(t3, p9.data[i] + p10.data[i])
	end

	return t1.new(t3)
end
function t1.__sub(p11, p12) -- line: 80
	-- upvalues: t1 (copy)
	t1.checkCompatible(p11, p12)

	local t4 = {}

	for i = 1, #p11.data do
		table.insert(t4, p11.data[i] - p12.data[i])
	end

	return t1.new(t4)
end
function t1.__mul(p13, p14) -- line: 89
	-- upvalues: t1 (copy)
	if typeof(p13) == typeof(t1) and typeof(p14) == "number" then
		local t5 = {}

		for _, v26 in p13.data do
			table.insert(t5, v26 * p14)
		end

		return t1.new(t5)
	end

	t1.checkCompatible(p13, p14)

	local t6 = {}

	for i = 1, #p13.data do
		table.insert(t6, p13.data[i] * p14.data[i])
	end

	return t1.new(t6)
end
function t1.__div(p15, p16) -- line: 106
	-- upvalues: t1 (copy)
	if typeof(p15) == typeof(t1) and typeof(p16) == "number" then
		local t7 = {}

		for _, v33 in p15.data do
			table.insert(t7, v33 / p16)
		end

		return t1.new(t7)
	end

	t1.checkCompatible(p15, p16)

	local t8 = {}

	for i = 1, #p15.data do
		table.insert(t8, p15.data[i] / p16.data[i])
	end

	return t1.new(t8)
end
function t1.dot(p17, p18) -- line: 123
	-- upvalues: t1 (copy)
	t1.checkCompatible(p17, p18)

	local n1 = 0

	for i = 1, #p17.data do
		n1 += p17.data[i] * p18.data[i]
	end

	return n1
end
function t1.cross(p19, p20) -- line: 133
	-- upvalues: t1 (copy)
	t1.checkCompatible(p19, p20)

	if #p19.data ~= 3 or #p20.data ~= 3 then
		error("cross product is only defined for two 3 dimensional vectors")

		return nil
	end

	return t1.new(p19.data[2] * p20.data[3] - p19.data[3] * p20.data[2], p19.data[3] * p20.data[1] - p19.data[1] * p20.data[3], p19.data[1] * p20.data[2] - p19.data[2] * p20.data[1])
end
function t1.magnitude(p21) -- line: 146
	local n2 = 0

	for _, v45 in p21.data do
		n2 += v45 ^ 2
	end

	return (math.sqrt(n2))
end
function t1.fuzzyEq(t9: {[any]: any}, p22, n3: number) -- line: 154
	-- upvalues: t1 (copy)
	if not t1.checkCompatible(t9, p22) then
		return false
	end

	local v49 = n3 or 1E-05

	for i = 1, #t9.data do
		if v49 < math.abs(t9.data[i] - p22.data[i]) then
			return false
		end
	end

	return true
end

return t1
