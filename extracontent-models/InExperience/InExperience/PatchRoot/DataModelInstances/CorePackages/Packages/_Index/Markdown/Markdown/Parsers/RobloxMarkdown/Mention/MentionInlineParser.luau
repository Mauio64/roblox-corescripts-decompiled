local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)
local Mention = require(script.Parent.Mention)

local byte = string.byte

local v = CommonMark.Text.AsciiMatcher.builder():range(48, 57):build()
local v2 = CommonMark.Text.AsciiMatcher.builder():range(65, 90):range(97, 122):range(48, 57):c(95):build()

local MentionInlineParser = {}
MentionInlineParser.__index = MentionInlineParser

function MentionInlineParser.new()
	return (setmetatable({}, MentionInlineParser))
end

function MentionInlineParser.tryParse(_, object)
	local scanner = object:scanner()
	scanner:next()

	if not scanner:nextChar(64) then
		return CommonMark.Parser.Beta.ParsedInline.none()
	end

	local position = scanner:position()

	if scanner:match(v) == 0 then
		return CommonMark.Parser.Beta.ParsedInline.none()
	end

	local content = scanner:getSource(position, scanner:position()):getContent()
	local v3

	if scanner:nextChar(58) then
		local position2 = scanner:position()

		if scanner:match(v2) == 0 then
			return CommonMark.Parser.Beta.ParsedInline.none()
		end

		v3 = scanner:getSource(position2, scanner:position()):getContent()
	end

	if scanner:nextChar(62) then
		return CommonMark.Parser.Beta.ParsedInline.of(Mention(content, v3), scanner:position())
	end

	return CommonMark.Parser.Beta.ParsedInline.none()
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
	return MentionInlineParser.new()
end

MentionInlineParser.Factory = class

return MentionInlineParser
