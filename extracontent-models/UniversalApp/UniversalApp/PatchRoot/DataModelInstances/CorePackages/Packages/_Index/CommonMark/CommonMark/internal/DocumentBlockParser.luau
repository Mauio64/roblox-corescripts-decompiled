local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new()
	return (setmetatable({ _document = Nodes.Document() }, object))
end

function object.isContainer(_): boolean
	return true
end

function object.canContain(_, _): boolean
	return true
end

function object:getBlock()
	return self._document
end

function object.tryContinue(_, object2)
	return BlockContinue.atIndex(object2:getIndex())
end

return object
