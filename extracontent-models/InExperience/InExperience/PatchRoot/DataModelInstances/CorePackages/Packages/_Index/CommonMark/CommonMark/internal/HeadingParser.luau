local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.parser.block.BlockParserFactory)
local BlockStart = require(CommonMark.parser.block.BlockStart)
local Characters = require(CommonMark.text.Characters)
require(CommonMark.parser.InlineParser)
require(CommonMark.parser.block.MatchedBlockParser)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)
local Parsing = require(CommonMark.internal.util.Parsing)
local Scanner = require(CommonMark.parser.beta.Scanner)
require(CommonMark.parser.SourceLine)
local SourceLines = require(CommonMark.parser.SourceLines)

local byte = string.byte

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(level: number, content)
	local heading = Nodes.Heading()
	heading.level = level
	return (setmetatable({ _block = heading, _content = content }, object))
end

function object:getBlock()
	return self._block
end

function object.tryContinue(_, _)
	return BlockContinue.none()
end

function object:parseInlines(object2)
	object2:parse(self._content, self._block)
end

local function getAtxHeading(p)
	local v = Scanner.of(SourceLines.of(p))
	local matchMultiple = v:matchMultiple(35)

	if matchMultiple == 0 or matchMultiple > 6 then
		return nil
	end

	if not v:hasNext() then
		return object.new(matchMultiple, SourceLines.empty())
	end

	local v2 = v:peek()

	if v2 ~= 32 and v2 ~= 9 then
		return nil
	end

	v:whitespace()
	local position = v:position()
	local v3 = position
	local v4 = true

	while v:hasNext() do
		local v5 = v:peek()

		if v5 == 35 then
			if v4 then
				v:matchMultiple(35)
				local whitespace = v:whitespace()

				if v:hasNext() then
					v3 = v:position()
				end

				v4 = whitespace > 0
			else
				v:next()
				v3 = v:position()
			end
		elseif v5 == 32 or v5 == 9 then
			v:next()
			v4 = true
		else
			v:next()
			v3 = v:position()
			v4 = false
		end
	end

	local source = v:getSource(position, v3)

	if source:getContent() == "" then
		return object.new(matchMultiple, SourceLines.empty())
	end

	return object.new(matchMultiple, source)
end

local function isSetextHeadingRest(value: string, p: number, p2: number): boolean -- 2 equivalent calls inferred from this helper
	local skip = Characters.skip(p2, value, p, #value)
	return Characters.skipSpaceTab(value, skip, #value) >= #value
end

local function getSetextHeadingLevel(value: string, nextNonSpaceIndex: number): number -- 1 equivalent call inferred from this helper
	local v = byte(value, nextNonSpaceIndex + 1)

	if v == 61 then
		if isSetextHeadingRest(value, nextNonSpaceIndex + 1, 61) then -- inferred equivalent call
			return 1
		end
	elseif v == 45 and isSetextHeadingRest(value, nextNonSpaceIndex + 1, 45) then -- inferred equivalent call
		return 2
	end

	return 0
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.tryStart(_, object2, object3)
	if object2:getIndent() >= Parsing.CODE_BLOCK_INDENT then
		return BlockStart.none()
	end

	local line = object2:getLine()
	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()

	if byte(line:getContent(), nextNonSpaceIndex + 1) == 35 then
		local atxHeading = getAtxHeading(line:substring(nextNonSpaceIndex, #line:getContent()))

		if atxHeading ~= nil then
			return BlockStart.of(atxHeading):atIndex(#line:getContent())
		end
	end

	local setextHeadingLevel = getSetextHeadingLevel(line:getContent(), nextNonSpaceIndex) -- inferred equivalent call

	if setextHeadingLevel > 0 then
		local paragraphLines = object3:getParagraphLines()

		if not paragraphLines:isEmpty() then
			return BlockStart.of(object.new(setextHeadingLevel, paragraphLines)):atIndex(#line:getContent()):replaceParagraphLines(#paragraphLines:getLines())
		end
	end

	return BlockStart.none()
end

object.Factory = class

return object
