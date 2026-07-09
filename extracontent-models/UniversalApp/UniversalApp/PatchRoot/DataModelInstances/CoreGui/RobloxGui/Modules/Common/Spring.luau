local exp = math.exp
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 9
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.f = p1
	self.p = p2
	self.v = p2 * 0

	return self
end
function t1.update(p3, p4, p5) -- line: 17
	-- upvalues: exp (copy)
	local v9 = p3.f * 2 * 3.141592653589793
	local p = p3.p
	local v = p3.v
	local v12 = p5 - p
	local v13 = exp(-v9 * p4)
	local v14 = p5 + (v * p4 - v12 * (v9 * p4 + 1)) * v13
	local v15 = (v9 * p4 * (v12 * v9 - v) + v) * v13

	p3.p = v14
	p3.v = v15

	return v14
end
function t1.reset(p6, p7) -- line: 34
	p6.p = p7
	p6.v = p7 * 0
end

return t1
