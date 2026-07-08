local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 19
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._id = p1
	t2._parent = p2
	t2._children = {}

	return t2
end
function t1.getValue(p3) -- line: 29
	return p3._value
end
function t1.getLabel(p4) -- line: 33
	return p4._label
end
function t1.getChildren(p5) -- line: 37
	return p5._children
end
function t1.getId(p6) -- line: 41
	return p6._id
end
function t1.getStackDepth(p7) -- line: 45
	if p7._parent == nil then
		return 0
	end

	return 1 + p7._parent:getStackDepth()
end
function t1.setLabelAndValue(p8, p9, p10) -- line: 53
	p8._label = p9
	p8._value = p10
end
function t1.getOrMakeChildById(p11, p12) -- line: 58
	-- upvalues: t1 (copy)
	for _, v in ipairs(p11._children) do
		if p12 == v:getId() then
			return v
		end
	end

	local v17 = t1.new(p12, p11)

	table.insert(p11._children, v17)

	return v17
end
function t1.removeChildren(p13) -- line: 70
	if not p13._children then
		return
	end

	for _, v in ipairs(p13._children) do
		v:removeChildren()
	end

	p13._id = nil
	p13._parent = nil
	p13._children = nil
end
function t1.removeChild(p14, p15) -- line: 82
	for _, v in ipairs(p14._children) do
		if p15 == v:getId() then
			v:removeChildren()

			return
		end
	end
end

return t1
