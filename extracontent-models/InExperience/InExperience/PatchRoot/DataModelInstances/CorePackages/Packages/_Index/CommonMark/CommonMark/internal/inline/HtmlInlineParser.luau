local CommonMark = script:FindFirstAncestor("CommonMark")
local AsciiMatcher = require(CommonMark.text.AsciiMatcher)
require(CommonMark.text.CharMatcher)
require(CommonMark.parser.beta.InlineContentParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.beta.InlineParserState)
local Nodes = require(CommonMark.node.Nodes)
local ParsedInline = require(CommonMark.parser.beta.ParsedInline)
require(CommonMark.parser.beta.Position)
require(CommonMark.parser.beta.Scanner)

local byte = string.byte

local HtmlInlineParser = {}
HtmlInlineParser.__index = HtmlInlineParser

local v = AsciiMatcher.builder():range(65, 90):range(97, 122):build()

local v2 = v:newBuilder():range(48, 57):c(45):build()

local v3 = v:newBuilder():c(95):c(58):build()

local v4 = v3:newBuilder():range(48, 57):c(46):c(45):build()

local v5 = AsciiMatcher.builder():c(32):c(9):c(10):c(11):c(12):c(13):c(34):c(39):c(61):c(60):c(62):c(96):build()

local function htmlInline(position, object)
	local content = object:getSource(position, object:position()):getContent()
	local htmlInline2 = Nodes.HtmlInline()
	htmlInline2.literal = content
	return ParsedInline.of(htmlInline2, object:position())
end

local function tryOpenTag(value, p)
	value:next()
	value:match(v2)
	local v6 = value:whitespace() >= 1

	while v6 and value:match(v3) >= 1 do
		value:match(v4)

		v6 = value:whitespace() >= 1

		if not value:nextChar(61) then
			continue
		end

		value:whitespace()
		local v7 = value:peek()

		if v7 == 39 then
			value:next()

			if value:findChar(39) < 0 then
				return false
			end

			value:next()
		elseif v7 == 34 then
			value:next()

			if value:findChar(34) < 0 then
				return false
			end

			value:next()
		elseif value:findMatcher(p) <= 0 then
			return false
		end

		v6 = value:whitespace() >= 1
	end

	value:nextChar(47)
	return value:nextChar(62)
end

local function tryClosingTag(value) -- 1 equivalent call inferred from this helper
	value:next()

	if value:match(v) >= 1 then
		value:match(v2)
		value:whitespace()
		return value:nextChar(62)
	end

	return false
end

function HtmlInlineParser.new()
	return (setmetatable(
		{
			_noProcessingInstructionEnd = false,
			_noCommentEnd = false,
			_noCdataEnd = false,
			_noDeclarationEnd = false
		},
		HtmlInlineParser
	))
end

function HtmlInlineParser:tryParse(object)
	local scanner = object:scanner()
	local position = scanner:position()

	scanner:next()

	local v6 = scanner:peek()

	if v:matches(v6) then
		if tryOpenTag(scanner, v5) then
			return htmlInline(position, scanner)
		end
	elseif v6 == 47 then
		if tryClosingTag(scanner) then -- inferred equivalent call
			return htmlInline(position, scanner)
		end
	elseif v6 == 63 then
		if self:tryProcessingInstruction(scanner) then
			return htmlInline(position, scanner)
		end
	elseif v6 == 33 then
		scanner:next()
		local v7 = scanner:peek()

		if v7 == 45 then
			if self:tryComment(scanner) then
				return htmlInline(position, scanner)
			end
		elseif v7 == 91 then
			if self:tryCdata(scanner) then
				return htmlInline(position, scanner)
			end
		elseif v:matches(v7) and self:tryDeclaration(scanner) then
			return htmlInline(position, scanner)
		end
	end

	return ParsedInline.none()
end

function HtmlInlineParser:tryProcessingInstruction(object): boolean
	if self._noProcessingInstructionEnd then
		return false
	end

	object:next()
	local v6

	while true do
		v6 = object:findChar(63)

		if v6 <= 0 then
			break
		end

		object:next()

		if object:nextChar(62) then
			return true
		end
	end

	self._noProcessingInstructionEnd = v6 < 0
	return false
end

function HtmlInlineParser:tryComment(object): boolean
	if self._noCommentEnd then
		return false
	end

	object:next()

	if not object:nextChar(45) then
		return false
	end

	if object:nextChar(62) or object:nextString("->") then
		return true
	end

	while object:findChar(45) >= 0 do
		if object:nextString("-->") then
			return true
		end

		object:next()
	end

	self._noCommentEnd = true
	return false
end

function HtmlInlineParser:tryCdata(object): boolean
	if self._noCdataEnd then
		return false
	end

	object:next()

	if not object:nextString("CDATA[") then
		return false
	end

	while object:findChar(93) >= 0 do
		if object:nextString("]]>") then
			return true
		end

		object:next()
	end

	self._noCdataEnd = true

	return false
end

function HtmlInlineParser:tryDeclaration(value): boolean
	if self._noDeclarationEnd then
		return false
	end

	value:match(v)

	if value:whitespace() <= 0 then
		return false
	end

	if value:findChar(62) >= 0 then
		value:next()
		return true
	end

	self._noDeclarationEnd = true
	return false
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.getTriggerCharacters(_)
	return { [60] = true }
end

function class.create(_)
	return HtmlInlineParser.new()
end

HtmlInlineParser.Factory = class

HtmlInlineParser.tryOpenTag = tryOpenTag
HtmlInlineParser.tryClosingTag = tryClosingTag

return HtmlInlineParser
