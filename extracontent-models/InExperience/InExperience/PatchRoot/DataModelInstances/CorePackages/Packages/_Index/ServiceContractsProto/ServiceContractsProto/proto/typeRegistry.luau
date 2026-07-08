local t1 = {}

t1.__index = t1
require(script.Parent.message)

function t1.new(t2: {[any]: any}) -- line: 14
	-- upvalues: t1 (copy)
	local t3 = {}

	for _, v6 in t2 do
		t3[v6.descriptor.fullName] = v6
	end

	return (setmetatable({
		_types = t3
	}, t1))
end
function t1.findMessage(p1, s1: string) -- line: 26
	return p1._types[s1]
end
function t1.register(p2, p3) -- line: 30
	p2._types[p3.descriptor.fullName] = p3
end

local v2 = t1.new({})

return {
	TypeRegistry = t1,
	default = v2
}
