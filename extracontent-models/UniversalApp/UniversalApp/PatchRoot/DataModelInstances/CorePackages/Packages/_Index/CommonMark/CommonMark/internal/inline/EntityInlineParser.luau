local CommonMark = script:FindFirstAncestor("CommonMark")
local AsciiMatcher = require(CommonMark.text.AsciiMatcher)
require(CommonMark.text.CharMatcher)
local Html5Entities = require(CommonMark.internal.util.Html5Entities)
require(CommonMark.parser.beta.InlineContentParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.beta.InlineParserState)
local Nodes = require(CommonMark.node.Nodes)
local ParsedInline = require(CommonMark.parser.beta.ParsedInline)
require(CommonMark.parser.beta.Position)
require(CommonMark.parser.beta.Scanner)

local byte = string.byte

local EntityInlineParser = {}
EntityInlineParser.__index = EntityInlineParser

local v = AsciiMatcher.builder():range(48, 57):range(65, 70):range(97, 102):build()
local v2 = AsciiMatcher.builder():range(48, 57):build()
local v3 = AsciiMatcher.builder():range(65, 90):range(97, 122):build()
local v4 = v3:newBuilder():range(48, 57):build()

function EntityInlineParser.new()
	return (setmetatable({}, EntityInlineParser))
end

function EntityInlineParser:tryParse(object)
	local scanner = object:scanner()
	local position = scanner:position()

	scanner:next()

	local v5 = scanner:peek()

	if v5 == 35 then
		scanner:next()

		if scanner:nextChar(120) or scanner:nextChar(88) then
			local match = scanner:match(v)

			if match >= 1 and match <= 6 and scanner:nextChar(59) then
				return self:entity(scanner, position)
			end
		else
			local match = scanner:match(v2)

			if match >= 1 and match <= 7 and scanner:nextChar(59) then
				return self:entity(scanner, position)
			end
		end
	elseif v3:matches(v5) then
		scanner:match(v4)

		if scanner:nextChar(59) then
			return self:entity(scanner, position)
		end
	end

	return ParsedInline.none()
end

function EntityInlineParser:entity(object, p)
	local content = object:getSource(p, object:position()):getContent()
	return ParsedInline.of(Nodes.Text(Html5Entities.entityToString(content)), object:position())
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.getTriggerCharacters(_)
	return { [38] = true }
end

function class.create(_)
	return EntityInlineParser.new()
end

EntityInlineParser.Factory = class

return EntityInlineParser
