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

local byte = string.byte

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new()
	return (setmetatable({ _block = Nodes.BlockQuote() }, object))
end

local function isMarker(object2, nextNonSpaceIndex: number): boolean -- 2 equivalent calls inferred from this helper
	local content = object2:getLine():getContent()
	return object2:getIndent() < Parsing.CODE_BLOCK_INDENT
		and nextNonSpaceIndex < #content
		and byte(content, nextNonSpaceIndex + 1) == 62
end

function object.isContainer(_): boolean
	return true
end

function object.canContain(_, _): boolean
	return true
end

function object:getBlock()
	return self._block
end

function object.tryContinue(_, object2)
	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()

	if not isMarker(object2, nextNonSpaceIndex) then -- inferred equivalent call
		return BlockContinue.none()
	end

	local v = object2:getColumn() + object2:getIndent() + 1

	if Characters.isSpaceOrTab(object2:getLine():getContent(), nextNonSpaceIndex + 1) then
		v += 1
	end

	return BlockContinue.atColumn(v)
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.tryStart(_, object2, _)
	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()

	if not isMarker(object2, nextNonSpaceIndex) then -- inferred equivalent call
		return BlockStart.none()
	end

	local v = object2:getColumn() + object2:getIndent() + 1

	if Characters.isSpaceOrTab(object2:getLine():getContent(), nextNonSpaceIndex + 1) then
		v += 1
	end

	return BlockStart.of(object.new()):atColumn(v)
end

object.Factory = class

return object
