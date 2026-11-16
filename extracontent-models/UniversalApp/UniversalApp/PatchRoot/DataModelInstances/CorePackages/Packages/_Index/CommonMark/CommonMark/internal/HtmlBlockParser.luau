local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local AsciiMatcher = require(CommonMark.text.AsciiMatcher)
local BlockContent = require(CommonMark.internal.BlockContent)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
require(CommonMark.parser.block.BlockParserFactory)
local BlockStart = require(CommonMark.parser.block.BlockStart)
require(CommonMark.text.CharMatcher)
local HtmlInlineParser = require(CommonMark.internal.inline.HtmlInlineParser)
require(CommonMark.parser.block.MatchedBlockParser)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)
local Scanner = require(CommonMark.parser.beta.Scanner)
local SourceLine = require(CommonMark.parser.SourceLine)

local byte = string.byte
local find = string.find
local gsub = string.gsub
local lower = string.lower
local sub = string.sub

local function isWhitespace(p: number?): boolean -- 2 equivalent arithmetic calls inferred from this helper
	return p == 32 or p == 9 or p == 10 or p == 11 or p == 12 or p == 13
end

local v = {
	["\n"] = true,
	["\r"] = true,
	["\r\n"] = true,
	["\194\133"] = true,
	[" "] = true,
	[" "] = true
}

local function isDollar(value: string, index: number): boolean -- 1 equivalent call inferred from this helper
	if index == #value then
		return true
	end

	if byte(value, index + 1) == 10 and index > 0 and byte(value, index - 1 + 1) == 13 then
		return false
	end

	return v[sub(value, index + 1)] == true
end

local function nameAt(value: string, p: number)
	local _, v2 = find(value, "^[A-Za-z0-9]*", p + 1)

	return lower((sub(value, p + 1, v2))), v2
end

local v2 = { script = true, pre = true, style = true, textarea = true }

local function isType1Opener(value: string)
	if byte(value, 1) ~= 60 then
		return false
	end

	local _, v3 = find(value, "^[A-Za-z0-9]*", 2)

	if not v2[lower((sub(value, 2, v3)))] then
		return false
	end

	local v4 = byte(value, v3 + 1)
	local v5 = isWhitespace(v4) -- inferred equivalent call

	if v5 then
		return v5
	end

	if v4 == 62 then
		v5 = true
		return true
	end

	if v3 == #value then
		return true
	end

	if byte(value, v3 + 1) == 10 and v3 > 0 and byte(value, v3 - 1 + 1) == 13 then
		return false
	end

	return v[sub(value, v3 + 1)] == true
end

local function findType1Closer(value: string): boolean
	local v3 = lower(value)
	return find(v3, "</script>", 1, true) ~= nil
		or find(v3, "</pre>", 1, true) ~= nil
		or find(v3, "</style>", 1, true) ~= nil
		or find(v3, "</textarea>", 1, true) ~= nil
end

local function isType2Opener(value: string): boolean
	return sub(value, 1, 4) == "<!--"
end

local function findType2Closer(value: string): boolean
	return find(value, "-->", 1, true) ~= nil
end

local function isType3Opener(value: string): boolean
	return sub(value, 1, 2) == "<?"
end

local function findType3Closer(value: string): boolean
	return find(value, "?>", 1, true) ~= nil
end

local function isType4Opener(value: string): boolean
	return find(value, "^<![A-Z]") ~= nil
end

local function findType4Closer(value: string): boolean
	return find(value, ">", 1, true) ~= nil
end

local function isType5Opener(value: string): boolean
	return sub(value, 1, 9) == "<![CDATA["
end

local function findType5Closer(value: string): boolean
	return find(value, "]]>", 1, true) ~= nil
end

local set = {}

for _, v3 in {
	"address",
	"article",
	"aside",
	"base",
	"basefont",
	"blockquote",
	"body",
	"caption",
	"center",
	"col",
	"colgroup",
	"dd",
	"details",
	"dialog",
	"dir",
	"div",
	"dl",
	"dt",
	"fieldset",
	"figcaption",
	"figure",
	"footer",
	"form",
	"frame",
	"frameset",
	"h1",
	"h2",
	"h3",
	"h4",
	"h5",
	"h6",
	"head",
	"header",
	"hr",
	"html",
	"iframe",
	"legend",
	"li",
	"link",
	"main",
	"menu",
	"menuitem",
	"nav",
	"noframes",
	"ol",
	"optgroup",
	"option",
	"p",
	"param",
	"search",
	"section",
	"summary",
	"table",
	"tbody",
	"td",
	"tfoot",
	"th",
	"thead",
	"title",
	"tr",
	"track",
	"ul"
} do
	set[v3] = true
end

local function isType6Opener(value: string)
	if byte(value, 1) ~= 60 then
		return false
	end

	local v3 = byte(value, 2) == 47 and 2 or 1
	local _, v4 = find(value, "^[A-Za-z0-9]*", v3 + 1)

	if not set[lower((sub(value, v3 + 1, v4)))] then
		return false
	end

	local v5 = byte(value, v4 + 1)
	local v6 = isWhitespace(v5) -- inferred equivalent call

	if v6 then
		return v6
	end

	if v5 == 62 or v5 == 47 and byte(value, v4 + 1 + 1) == 62 then
		v6 = true
		return true
	end

	if v4 == #value then
		return true
	end

	if byte(value, v4 + 1) == 10 and v4 > 0 and byte(value, v4 - 1 + 1) == 13 then
		return false
	end

	return v[sub(value, v4 + 1)] == true
end

local v3 = AsciiMatcher.builder():range(65, 90):range(97, 122):build()

local v4 = AsciiMatcher.builder():range(0, 32):anyOf("\"'=<>`"):build()

local function isType7Opener(value: string)
	if byte(value, 1) ~= 60 then
		return false
	end

	if find(value, "\0", 1, true) ~= nil then
		value = gsub(value, "%z", "\1")
	end

	local v5 = Scanner.new({ SourceLine.of(value, nil) }, 0, 1)
	local v6 = v5:peek()
	local v7

	if v3:matches(v6) then
		v7 = HtmlInlineParser.tryOpenTag(v5, v4)
	elseif v6 == 47 then
		v7 = HtmlInlineParser.tryClosingTag(v5)
	else
		v7 = false
	end

	if not v7 then
		return false
	end

	v5:whitespace()
	return isDollar(value, v5:position().index) -- inferred equivalent call
end

local v5 = {
	{ opener = isType1Opener, closer = findType1Closer },
	{ opener = isType2Opener, closer = findType2Closer },
	{ opener = isType3Opener, closer = findType3Closer },
	{ opener = isType4Opener, closer = findType4Closer },
	{ opener = isType5Opener, closer = findType5Closer },
	{ opener = isType6Opener, closer = nil },
	{ opener = isType7Opener, closer = nil }
}

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(closingPattern)
	return (setmetatable(
		{
			_block = Nodes.HtmlBlock(),
			_closingPattern = closingPattern,
			_finished = false,
			_content = BlockContent.new()
		},
		object
	))
end

function object:getBlock()
	return self._block
end

function object:tryContinue(object2)
	if self._finished or object2:isBlank() and self._closingPattern == nil then
		return BlockContinue.none()
	end

	return BlockContinue.atIndex(object2:getIndex())
end

function object:addLine(object2)
	self._content:add(object2:getContent())

	local closingPattern = self._closingPattern

	if closingPattern ~= nil and closingPattern(object2:getContent()) then
		self._finished = true
	end
end

function object:closeBlock()
	self._block.literal = self._content:getString()
	self._content = nil
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.tryStart(_, object2, object3)
	local nextNonSpaceIndex = object2:getNextNonSpaceIndex()
	local content = object2:getLine():getContent()

	if object2:getIndent() < 4 and byte(content, nextNonSpaceIndex + 1) == 60 then
		for i = 1, 7 do
			if not (i ~= 7 or object3:getMatchedBlockParser():getBlock().kind ~= "Paragraph" and not object2:getActiveBlockParser():canHaveLazyContinuationLines()) then
				continue
			end

			local opener = v5[i].opener
			local closer = v5[i].closer

			if opener((sub(content, nextNonSpaceIndex + 1))) then
				return BlockStart.of(object.new(closer)):atIndex(object2:getIndex())
			end
		end
	end

	return BlockStart.none()
end

object.Factory = class

object._BLOCK_PATTERNS = v5

return object
