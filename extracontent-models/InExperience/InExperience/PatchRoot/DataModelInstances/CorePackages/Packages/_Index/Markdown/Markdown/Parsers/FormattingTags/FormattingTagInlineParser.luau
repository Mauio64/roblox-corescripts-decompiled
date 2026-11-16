local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)
local FormattingTag = require(script.Parent.FormattingTag)

local byte = string.byte

local v = { [98] = true, [105] = true, [117] = true, [115] = true }

local FormattingTagInlineParser = {}
FormattingTagInlineParser.__index = FormattingTagInlineParser

function FormattingTagInlineParser.new()
	return (setmetatable({}, FormattingTagInlineParser))
end

function FormattingTagInlineParser.tryParse(_, object)
	local scanner = object:scanner()
	local position = scanner:position()
	scanner:next()
	scanner:nextChar(47)

	if not v[scanner:peek()] then
		return CommonMark.Parser.Beta.ParsedInline.none()
	end

	scanner:next()

	if not scanner:nextChar(62) then
		return CommonMark.Parser.Beta.ParsedInline.none()
	end

	local content = scanner:getSource(position, scanner:position()):getContent()
	return CommonMark.Parser.Beta.ParsedInline.of(FormattingTag.text(content), scanner:position())
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
	return FormattingTagInlineParser.new()
end

FormattingTagInlineParser.Factory = class

return FormattingTagInlineParser
