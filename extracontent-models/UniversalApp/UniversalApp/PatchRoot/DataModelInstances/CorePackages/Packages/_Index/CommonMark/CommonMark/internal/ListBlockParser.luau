local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.parser.block.BlockParserFactory)
local BlockStart = require(CommonMark.parser.block.BlockStart)
local ListItemParser = require(CommonMark.internal.ListItemParser)
require(CommonMark.parser.block.MatchedBlockParser)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)
local Parsing = require(CommonMark.internal.util.Parsing)

local byte = string.byte
local char = string.char
local sub = string.sub

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(block)
	return (setmetatable({ _block = block, _hadBlankLine = false, _linesAfterBlank = 0 }, object))
end

function object.isContainer(_): boolean
	return true
end

function object:canContain(p): boolean
	if p.kind ~= "ListItem" then
		return false
	end

	if self._hadBlankLine and self._linesAfterBlank == 1 then
		self._block.tight = false
		self._hadBlankLine = false
	end

	return true
end

function object:getBlock()
	return self._block
end

function object:tryContinue(object2)
	if object2:isBlank() then
		self._hadBlankLine = true
		self._linesAfterBlank = 0
	elseif self._hadBlankLine then
		self._linesAfterBlank += 1
	end

	return BlockContinue.atIndex(object2:getIndex())
end

local class = {}
class.__index = class

function class.new(listBlock, contentColumn: number)
	return (setmetatable({ listBlock = listBlock, contentColumn = contentColumn }, class))
end

local class2 = {}
class2.__index = class2

function class2.new(listBlock, indexAfterMarker: number)
	return (setmetatable({ listBlock = listBlock, indexAfterMarker = indexAfterMarker }, class2))
end

local function isSpaceTabOrEnd(value: string, p: number): boolean -- 2 equivalent calls inferred from this helper
	if p < #value then
		local v = byte(value, p + 1)
		return v == 32 or v == 9
	end

	return true
end

local function parseOrderedList(value: string, p: number)
	local count = 0

	for i = p, #value - 1 do
		local v = byte(value, i + 1)

		if v >= 48 and v <= 57 then
			count += 1

			if count > 9 then
				return nil
			end
		else
			if v ~= 46 and v ~= 41 then
				return nil
			end

			if count >= 1 and isSpaceTabOrEnd(value, i + 1) then -- inferred equivalent call
				local v2 = sub(value, p + 1, i)
				local orderedList = Nodes.OrderedList()

				orderedList.markerStartNumber = tonumber(v2)
				orderedList.markerDelimiter = char(v)
				return class2.new(orderedList, i + 1)
			end

			return nil
		end
	end

	return nil
end

local function parseListMarker(value: string, p: number)
	local v = byte(value, p + 1)

	if v ~= 45 and v ~= 43 and v ~= 42 then
		return parseOrderedList(value, p)
	end

	if not isSpaceTabOrEnd(value, p + 1) then -- inferred equivalent call
		return nil
	end

	local bulletList = Nodes.BulletList()
	bulletList.marker = char(v)
	return class2.new(bulletList, p + 1)
end

local function parseList(value: string, nextNonSpaceIndex: number, p: number, flag: boolean)
	local v = parseListMarker(value, nextNonSpaceIndex)

	if v == nil then
		return nil
	end

	local listBlock = v.listBlock

	local indexAfterMarker = v.indexAfterMarker
	local v2 = p + (indexAfterMarker - nextNonSpaceIndex)
	local v3 = v2
	local v4 = false

	for i = indexAfterMarker, #value - 1 do
		local v5 = byte(value, i + 1)

		if v5 == 9 then
			v3 += Parsing.columnsToNextTabStop(v3)
		elseif v5 == 32 then
			v3 += 1
		else
			v4 = true
			break
		end
	end

	if flag then
		if listBlock.kind == "OrderedList" and listBlock.markerStartNumber ~= 1 or not v4 then
			return nil
		end
	end

	if not v4 or v3 - v2 > Parsing.CODE_BLOCK_INDENT then
		v3 = v2 + 1
	end

	return class.new(listBlock, v3)
end

local function listsMatch(data, listBlock): boolean -- 1 equivalent call inferred from this helper
	if data.kind == "BulletList" and listBlock.kind == "BulletList" then
		return data.marker == listBlock.marker
	end

	if data.kind == "OrderedList" and listBlock.kind == "OrderedList" then
		return data.markerDelimiter == listBlock.markerDelimiter
	end

	return false
end

local class3 = {}
class3.__index = class3

function class3.new()
	return (setmetatable({}, class3))
end

function class3.tryStart(_, object2, object3)
	local matchedBlockParser = object3:getMatchedBlockParser()

	if object2:getIndent() >= Parsing.CODE_BLOCK_INDENT then
		return BlockStart.none()
	end

	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()
	local v = object2:getColumn() + object2:getIndent()
	local v2 = not object3:getParagraphLines():isEmpty()
	local v3 = parseList(object2:getLine():getContent(), nextNonSpaceIndex, v, v2)

	if v3 == nil then
		return BlockStart.none()
	end

	local contentColumn = v3.contentColumn
	local v4 = ListItemParser.new(object2:getIndent(), contentColumn - object2:getColumn())

	if getmetatable(matchedBlockParser) == object and listsMatch(matchedBlockParser:getBlock(), v3.listBlock) then -- inferred equivalent call
		return BlockStart.of(v4):atColumn(contentColumn)
	end

	local v5 = object.new(v3.listBlock)

	v3.listBlock.tight = true

	return BlockStart.of(v5, v4):atColumn(contentColumn)
end

object.Factory = class3

return object
