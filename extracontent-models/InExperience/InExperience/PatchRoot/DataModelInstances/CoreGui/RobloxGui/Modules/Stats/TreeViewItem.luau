local TreeViewItem = {}
TreeViewItem.__index = TreeViewItem

function TreeViewItem.new(id, parent)
	local v = {}
	setmetatable(v, TreeViewItem)

	v._id = id
	v._parent = parent
	v._children = {}
	return v
end

function TreeViewItem:getValue()
	return self._value
end

function TreeViewItem:getLabel()
	return self._label
end

function TreeViewItem:getChildren()
	return self._children
end

function TreeViewItem:getId()
	return self._id
end

function TreeViewItem:getStackDepth()
	if self._parent == nil then
		return 0
	end

	return 1 + self._parent:getStackDepth()
end

function TreeViewItem:setLabelAndValue(label, p)
	self._label = label
	self._value = p
end

function TreeViewItem:getOrMakeChildById(p)
	for _, v in ipairs(self._children) do
		if v:getId() == p then
			return v
		end
	end

	local v = TreeViewItem.new(p, self)
	table.insert(self._children, v)
	return v
end

function TreeViewItem:removeChildren()
	if not self._children then
		return
	end

	for _, v in ipairs(self._children) do
		v:removeChildren()
	end

	self._id = nil
	self._parent = nil
	self._children = nil
end

function TreeViewItem:removeChild(p)
	for _, v in ipairs(self._children) do
		if v:getId() == p then
			v:removeChildren()
			break
		end
	end
end

return TreeViewItem
