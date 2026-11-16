local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.parser.block.BlockParserFactory)
local BlockStart = require(CommonMark.parser.block.BlockStart)
require(CommonMark.parser.block.MatchedBlockParser)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)

local byte = string.byte
local sub = string.sub

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(literal: string)
	local thematicBreak = Nodes.ThematicBreak()
	thematicBreak.literal = literal
	return (setmetatable({ _block = thematicBreak }, object))
end

function object:getBlock()
	return self._block
end

function object.tryContinue(_, _)
	return BlockContinue.none()
end

local function isThematicBreak(content: string, nextNonSpaceIndex: number): boolean
	local count = 0
	local count2 = 0
	local count3 = 0

	for i = nextNonSpaceIndex, #content - 1 do
		local v = byte(content, i + 1)

		if v == 45 then
			count3 += 1
		elseif v == 95 then
			count2 += 1
		elseif v == 42 then
			count += 1
		elseif v ~= 32 and v ~= 9 then
			return false
		end
	end

	if count3 >= 3 and count2 == 0 and count == 0 or count2 >= 3 and count3 == 0 and count == 0 then
		return true
	elseif count >= 3 and count3 == 0 then
		return count2 == 0
	else
		return false
	end
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.tryStart(_, object2, _)
	if object2:getIndent() >= 4 then
		return BlockStart.none()
	end

	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()
	local content = object2:getLine():getContent()

	if not isThematicBreak(content, nextNonSpaceIndex) then
		return BlockStart.none()
	end

	local v = sub(content, object2:getIndex() + 1, #content)
	return BlockStart.of(object.new(v)):atIndex(#content)
end

object.Factory = class

return object
