local CommonMark = script:FindFirstAncestor("CommonMark")
local AsciiMatcher = require(CommonMark.text.AsciiMatcher)
require(CommonMark.text.CharMatcher)
require(CommonMark.parser.beta.InlineContentParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.beta.InlineParserState)
local Nodes = require(CommonMark.node.Nodes)
local ParsedInline = require(CommonMark.parser.beta.ParsedInline)

local byte = string.byte
local find = string.find
local sub = string.sub

local AutolinkInlineParser = {}
AutolinkInlineParser.__index = AutolinkInlineParser

local v = AsciiMatcher.builder():c(60):c(62):build()

local function isUri(content: string): boolean -- 1 equivalent call inferred from this helper
	local _, v2 = find(content, "^[A-Za-z][A-Za-z0-9.+%-]*:")

	if v2 == nil then
		return false
	end

	local v3 = v2 - 1
	return not (v3 < 2 or v3 > 32) and find(content, "[%z\1- <>]", v2 + 1) == nil
end

local function isDomainLabel(value: string): boolean -- 1 equivalent call inferred from this helper
	if #value > 63 then
		return false
	end

	return find(value, "^[A-Za-z0-9]$") ~= nil or find(value, "^[A-Za-z0-9][A-Za-z0-9%-]*[A-Za-z0-9]$") ~= nil
end

local function isEmail(content: string)
	local _, v2 = find(content, "^[A-Za-z0-9.!#$%%&'*+/=?^_`{|}~%-]+@")

	if v2 == nil then
		return false
	end

	local v3 = v2 + 1

	while true do
		local v4 = find(content, ".", v3, true)
		local v5

		if v4 == nil then
			v5 = #content
		else
			v5 = v4 - 1
		end

		if not isDomainLabel(sub(content, v3, v5)) then -- inferred equivalent call
			return false
		end

		if v4 == nil then
			return true
		end

		v3 = v4 + 1
	end
end

function AutolinkInlineParser.new()
	return (setmetatable({}, AutolinkInlineParser))
end

function AutolinkInlineParser.tryParse(_, object)
	local scanner = object:scanner()
	scanner:next()
	local position = scanner:position()

	if scanner:findMatcher(v) > 0 then
		if scanner:peek() ~= 62 then
			return ParsedInline.none()
		end

		local source = scanner:getSource(position, scanner:position())
		local content = source:getContent()
		scanner:next()

		local v2 = nil

		if isUri(content) then -- inferred equivalent call
			v2 = content
		elseif isEmail(content) then
			v2 = "mailto:" .. content
		end

		if v2 ~= nil then
			local link = Nodes.Link(v2, nil)
			local text = Nodes.Text(content)
			text:setSourceSpans(source:getSourceSpans())
			link:appendChild(text)
			return ParsedInline.of(link, scanner:position())
		end
	end

	return ParsedInline.none()
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
	return AutolinkInlineParser.new()
end

AutolinkInlineParser.Factory = class

AutolinkInlineParser._isUri = isUri
AutolinkInlineParser._isEmail = isEmail

return AutolinkInlineParser
