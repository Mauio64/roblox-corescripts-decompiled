local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.parser.block.BlockParserFactory)
local BlockStart = require(CommonMark.parser.block.BlockStart)
local Characters = require(CommonMark.text.Characters)
local Escaping = require(CommonMark.internal.util.Escaping)
require(CommonMark.parser.block.MatchedBlockParser)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)
local Parsing = require(CommonMark.internal.util.Parsing)
require(CommonMark.parser.SourceLine)

local byte = string.byte
local char = string.char
local sub = string.sub

local unescapeString = Escaping.unescapeString

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(fenceChar: number, openingFenceLength: number, fenceIndent: number)
	local fencedCodeBlock = Nodes.FencedCodeBlock()
	fencedCodeBlock.fenceCharacter = char(fenceChar)
	fencedCodeBlock:setOpeningFenceLength(openingFenceLength)
	fencedCodeBlock.fenceIndent = fenceIndent
	return (setmetatable({
		_block = fencedCodeBlock,
		_fenceChar = fenceChar,
		_openingFenceLength = openingFenceLength,
		_firstLine = nil,
		_otherLines = {}
	}, object))
end

function object:getBlock()
	return self._block
end

function object:tryContinue(object2)
	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()
	local index = object2:getIndex()
	local content = object2:getLine():getContent()

	if
		object2:getIndent() < Parsing.CODE_BLOCK_INDENT
		and nextNonSpaceIndex < #content
		and self:tryClosing(content, nextNonSpaceIndex)
	then
		return BlockContinue.finished()
	end

	local fenceIndent = self._block.fenceIndent
	local v = #content

	while fenceIndent > 0 and index < v and byte(content, index + 1) == 32 do
		index += 1
		fenceIndent -= 1
	end

	return BlockContinue.atIndex(index)
end

function object:addLine(object2)
	if self._firstLine == nil then
		self._firstLine = object2:getContent()
		return
	end

	table.insert(self._otherLines, object2:getContent())
	table.insert(self._otherLines, "\n")
end

local function trim(firstLine: string)
	local count = #firstLine
	local count2 = 0

	while count2 < count and byte(firstLine, count2 + 1) <= 32 do
		count2 += 1
	end

	while count2 < count and byte(firstLine, count - 1 + 1) <= 32 do
		count -= 1
	end

	return (sub(firstLine, count2 + 1, count))
end

function object:closeBlock()
	self._block.info = unescapeString(trim(self._firstLine))
	self._block.literal = table.concat(self._otherLines)
end

local function checkOpener(value: string, nextNonSpaceIndex: number, indent: number)
	local count = 0
	local count2 = 0

	for i = nextNonSpaceIndex, #value - 1 do
		local v = byte(value, i + 1)

		if v == 96 then
			count += 1
		elseif v == 126 then
			count2 += 1
		else
			break
		end
	end

	if count >= 3 and count2 == 0 then
		if Characters.find(96, value, nextNonSpaceIndex + count) == -1 then
			return object.new(96, count, indent)
		end

		return nil
	elseif count2 >= 3 and count == 0 then
		return object.new(126, count2, indent)
	else
		return nil
	end
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.tryStart(_, object2, _)
	local indent = object2:getIndent()

	if Parsing.CODE_BLOCK_INDENT <= indent then
		return BlockStart.none()
	end

	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()
	local v = checkOpener(object2:getLine():getContent(), nextNonSpaceIndex, indent)

	if v == nil then
		return BlockStart.none()
	end

	return BlockStart.of(v):atIndex(nextNonSpaceIndex + v._block:getOpeningFenceLength())
end

object.Factory = class

function object:tryClosing(list: string, p: number): boolean
	local v = Characters.skip(self._fenceChar, list, p, #list) - p

	if v < self._openingFenceLength or Characters.skipSpaceTab(list, p + v, #list) ~= #list then
		return false
	end

	self._block:setClosingFenceLength(v)
	return true
end

return object
