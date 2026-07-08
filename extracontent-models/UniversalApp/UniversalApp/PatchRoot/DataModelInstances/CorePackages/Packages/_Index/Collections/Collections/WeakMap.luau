local ParentParent = script.Parent.Parent

require(ParentParent.ES7Types)

local t1 = {}

t1.__index = t1

function t1.new() -- line: 37
	-- upvalues: t1 (copy)
	return (setmetatable({
		_weakMap = setmetatable({}, {
			__mode = "k"
		})
	}, t1))
end
function t1.get(p1, p2) -- line: 42
	return p1._weakMap[p2]
end
function t1.set(p3, p4, p5) -- line: 46
	p3._weakMap[p4] = p5

	return p3
end
function t1.has(p6, p7) -- line: 51
	return p6._weakMap[p7] ~= nil
end

return t1
