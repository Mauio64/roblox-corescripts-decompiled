local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.SourceSpan)

local Node = {}
Node.__index = Node

local frozen = table.freeze({})

function Node.new(kind: string, isBlock: boolean)
	return (setmetatable({
		kind = kind,
		isBlock = isBlock,
		_parent = nil,
		_firstChild = nil,
		_lastChild = nil,
		_prev = nil,
		_next = nil,
		_sourceSpans = nil
	}, Node))
end

function Node.accept(p, p2)
	local v = p2["visit" .. p.kind]

	if v == nil then
		if p.isBlock then
			v = p2.visitCustomBlock
		else
			v = p2.visitCustomNode
		end
	end

	v(p2, p)
end

function Node:getNext()
	return self._next
end

function Node:getPrevious()
	return self._prev
end

function Node:getFirstChild()
	return self._firstChild
end

function Node:getLastChild()
	return self._lastChild
end

function Node:getParent()
	return self._parent
end

function Node:setParent(parent)
	if self.isBlock and not parent.isBlock then
		error("Parent of block must also be block (can not be inline)")
	end

	self._parent = parent
end

function Node:appendChild(object)
	object:unlink()
	object:setParent(self)

	if self._lastChild == nil then
		self._firstChild = object
	else
		self._lastChild._next = object
		object._prev = self._lastChild
	end

	self._lastChild = object
end

function Node:prependChild(object)
	object:unlink()
	object:setParent(self)

	if self._firstChild == nil then
		self._firstChild = object
		self._lastChild = object
	else
		self._firstChild._prev = object
		object._next = self._firstChild
		self._firstChild = object
	end
end

function Node:unlink()
	if self._prev == nil then
		if self._parent ~= nil then
			self._parent._firstChild = self._next
		end
	else
		self._prev._next = self._next
	end

	if self._next == nil then
		if self._parent ~= nil then
			self._parent._lastChild = self._prev
		end
	else
		self._next._prev = self._prev
	end

	self._parent = nil
	self._next = nil
	self._prev = nil
end

function Node:insertAfter(object)
	object:unlink()
	object._next = self._next

	if object._next ~= nil then
		object._next._prev = object
	end

	object._prev = self
	self._next = object
	object._parent = self._parent

	if object._next == nil then
		object._parent._lastChild = object
	end
end

function Node:insertBefore(object)
	object:unlink()
	object._prev = self._prev

	if object._prev ~= nil then
		object._prev._next = object
	end

	object._next = self
	self._prev = object
	object._parent = self._parent

	if object._prev == nil then
		object._parent._firstChild = object
	end
end

function Node:getSourceSpans()
	if self._sourceSpans == nil then
		return frozen
	end

	return self._sourceSpans
end

function Node:setSourceSpans(list)
	if #list == 0 then
		self._sourceSpans = nil
	else
		self._sourceSpans = table.clone(list)
	end
end

function Node:addSourceSpan(p)
	if self._sourceSpans == nil then
		self._sourceSpans = {}
	end

	table.insert(self._sourceSpans, p)
end

function Node:toString()
	return `{self.kind}\{{self:toStringAttributes()}}`
end

Node.toStringAttributesByKind = {}

function Node:toStringAttributes()
	local toStringAttribute = Node.toStringAttributesByKind[self.kind]

	if toStringAttribute == nil then
		return ""
	end

	return (toStringAttribute(self))
end

return Node
