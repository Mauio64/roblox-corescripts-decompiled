local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.parser.block.BlockParserFactory)
local BlockStart = require(CommonMark.parser.block.BlockStart)
local Characters = require(CommonMark.text.Characters)
require(CommonMark.parser.block.MatchedBlockParser)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)
local Parsing = require(CommonMark.internal.util.Parsing)
require(CommonMark.parser.SourceLine)

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new()
	return (setmetatable({ _block = Nodes.IndentedCodeBlock(), _lines = {} }, object))
end

function object:getBlock()
	return self._block
end

function object.tryContinue(_, object2)
	if object2:getIndent() >= Parsing.CODE_BLOCK_INDENT then
		return BlockContinue.atColumn(object2:getColumn() + Parsing.CODE_BLOCK_INDENT)
	end

	if object2:isBlank() then
		return BlockContinue.atIndex(object2:getNextNonSpaceIndex())
	end

	return BlockContinue.none()
end

function object:addLine(object2)
	table.insert(self._lines, object2:getContent())
end

function object:closeBlock()
	local lines = self._lines
	local v = #lines - 1

	while v >= 0 and Characters.isBlank(lines[v + 1]) do
		v -= 1
	end

	local v2 = 0
	local v3 = {}

	for i = 0, v do
		local v4 = v2 + 1
		v3[v4] = lines[i + 1]
		v2 = v4 + 1
		v3[v2] = "\n"
	end

	local joined = table.concat(v3)
	self._block.literal = joined
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.tryStart(_, object2, _)
	if
		object2:getIndent() >= Parsing.CODE_BLOCK_INDENT
		and not object2:isBlank()
		and object2:getActiveBlockParser():getBlock().kind ~= "Paragraph"
	then
		return BlockStart.of(object.new()):atColumn(object2:getColumn() + Parsing.CODE_BLOCK_INDENT)
	end

	return BlockStart.none()
end

object.Factory = class

return object
