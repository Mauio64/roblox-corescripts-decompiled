local CommonMark = script:FindFirstAncestor("CommonMark")
local Characters = require(CommonMark.text.Characters)
require(CommonMark.parser.beta.InlineContentParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.beta.InlineParserState)
local Nodes = require(CommonMark.node.Nodes)
local ParsedInline = require(CommonMark.parser.beta.ParsedInline)
require(CommonMark.parser.beta.Position)

local byte = string.byte
local gsub = string.gsub
local sub = string.sub

local BackticksInlineParser = {}
BackticksInlineParser.__index = BackticksInlineParser

function BackticksInlineParser.new()
	return (setmetatable({ _backtickPositions = {}, _scannedToEnd = false }, BackticksInlineParser))
end

function BackticksInlineParser:tryParse(object)
	local scanner = object:scanner()
	local position = scanner:position()
	local matchMultiple = scanner:matchMultiple(96)
	local position2 = scanner:position()

	if self._scannedToEnd then
		local backtickPosition = self._backtickPositions[matchMultiple]

		if backtickPosition == nil or backtickPosition:compareTo(position) <= 0 then
			local text = Nodes.Text(scanner:getSource(position, position2):getContent())
			return ParsedInline.of(text, position2)
		end
	end

	while scanner:findChar(96) > 0 do
		local position3 = scanner:position()
		local matchMultiple2 = scanner:matchMultiple(96)

		self._backtickPositions[matchMultiple2] = position3

		if matchMultiple2 == matchMultiple then
			local code = Nodes.Code()

			local literal = gsub(scanner:getSource(position2, position3):getContent(), "\n", " ")

			if
				#literal >= 3
				and byte(literal, 1) == 32
				and byte(literal, #literal) == 32
				and Characters.hasNonSpace(literal)
			then
				literal = sub(literal, 2, #literal - 1)
			end

			code.literal = literal
			return ParsedInline.of(code, scanner:position())
		end
	end

	self._scannedToEnd = true

	local text = Nodes.Text(scanner:getSource(position, position2):getContent())
	return ParsedInline.of(text, position2)
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.getTriggerCharacters(_)
	return { [96] = true }
end

function class.create(_)
	return BackticksInlineParser.new()
end

BackticksInlineParser.Factory = class

return BackticksInlineParser
