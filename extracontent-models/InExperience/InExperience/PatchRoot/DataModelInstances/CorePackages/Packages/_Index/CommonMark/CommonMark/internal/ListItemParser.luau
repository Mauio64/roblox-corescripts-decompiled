local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(markerIndent: number, contentIndent: number)
	local listItem = Nodes.ListItem()
	listItem.markerIndent = markerIndent
	listItem.contentIndent = contentIndent
	return (setmetatable({
		_block = listItem,
		_contentIndent = contentIndent,
		_hadBlankLine = false
	}, object))
end

function object.isContainer(_): boolean
	return true
end

function object:canContain(_): boolean
	if self._hadBlankLine then
		local parent = self._block:getParent()

		if parent ~= nil and (parent.kind == "BulletList" or parent.kind == "OrderedList") then
			parent.tight = false
		end
	end

	return true
end

function object:getBlock()
	return self._block
end

function object:tryContinue(object2)
	if object2:isBlank() then
		if self._block:getFirstChild() == nil then
			return BlockContinue.none()
		end

		local block = object2:getActiveBlockParser():getBlock()

		self._hadBlankLine = block.kind == "Paragraph" or block.kind == "ListItem"
		return BlockContinue.atIndex(object2:getNextNonSpaceIndex())
	elseif object2:getIndent() >= self._contentIndent then
		return BlockContinue.atColumn(object2:getColumn() + self._contentIndent)
	else
		return BlockContinue.none()
	end
end

return object
