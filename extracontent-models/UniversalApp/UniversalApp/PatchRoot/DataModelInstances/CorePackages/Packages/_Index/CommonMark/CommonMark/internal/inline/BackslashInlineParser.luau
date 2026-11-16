local CommonMark = script:FindFirstAncestor("CommonMark")
local Escaping = require(CommonMark.internal.util.Escaping)
require(CommonMark.parser.beta.InlineContentParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.beta.InlineParserState)
local Nodes = require(CommonMark.node.Nodes)
local ParsedInline = require(CommonMark.parser.beta.ParsedInline)

local byte = string.byte
local char = string.char
local find = string.find

local BackslashInlineParser = {}
BackslashInlineParser.__index = BackslashInlineParser

local v = "^" .. Escaping.ESCAPABLE .. "$"

function BackslashInlineParser.new(flag: boolean?)
	return (setmetatable({
		_hardLineBreakEnabled = flag ~= false
	}, BackslashInlineParser))
end

function BackslashInlineParser:tryParse(object)
	local scanner = object:scanner()

	scanner:next()

	local v2 = scanner:peek()

	if v2 == 10 and self._hardLineBreakEnabled then
		scanner:next()
		return ParsedInline.of(Nodes.HardLineBreak(), scanner:position())
	end

	if find(char(v2), v) == nil then
		return ParsedInline.of(Nodes.Text("\\"), scanner:position())
	end

	scanner:next()
	return ParsedInline.of(Nodes.Text((char(v2))), scanner:position())
end

local class = {}
class.__index = class

function class.new(hardLineBreakEnabled: boolean?)
	return (setmetatable({ _hardLineBreakEnabled = hardLineBreakEnabled }, class))
end

function class.getTriggerCharacters(_)
	return { [92] = true }
end

function class:create()
	return BackslashInlineParser.new(self._hardLineBreakEnabled)
end

BackslashInlineParser.Factory = class

return BackslashInlineParser
