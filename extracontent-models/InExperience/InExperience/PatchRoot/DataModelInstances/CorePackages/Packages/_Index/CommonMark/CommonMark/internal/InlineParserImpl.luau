local CommonMark = script:FindFirstAncestor("CommonMark")
local AutolinkInlineParser = require(CommonMark.internal.inline.AutolinkInlineParser)
local BackslashInlineParser = require(CommonMark.internal.inline.BackslashInlineParser)
local BackticksInlineParser = require(CommonMark.internal.inline.BackticksInlineParser)
local Bracket = require(CommonMark.internal.Bracket)
local Characters = require(CommonMark.text.Characters)
local CoreLinkProcessor = require(CommonMark.internal.inline.CoreLinkProcessor)
local Delimiter = require(CommonMark.internal.Delimiter)
require(CommonMark.parser.delimiter.DelimiterProcessor)
local EmphasisDelimiterProcessor = require(CommonMark.internal.inline.EmphasisDelimiterProcessor)
local EntityInlineParser = require(CommonMark.internal.inline.EntityInlineParser)
local Escaping = require(CommonMark.internal.util.Escaping)
local HtmlInlineParser = require(CommonMark.internal.inline.HtmlInlineParser)
require(CommonMark.parser.beta.InlineContentParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.InlineParserContext)
local Integer = require(CommonMark.internal.port.Integer)
require(CommonMark.parser.beta.LinkInfo)
require(CommonMark.parser.beta.LinkProcessor)
local LinkResult = require(CommonMark.parser.beta.LinkResult)
local LinkScanner = require(CommonMark.internal.util.LinkScanner)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.beta.Position)
local Scanner = require(CommonMark.parser.beta.Scanner)
require(CommonMark.parser.SourceLines)
local SourceSpans = require(CommonMark.node.SourceSpans)
local StaggeredDelimiterProcessor = require(CommonMark.internal.StaggeredDelimiterProcessor)

local byte = string.byte
local gsub = string.gsub
local sub = string.sub

local v = Scanner.END

local InlineParserImpl = {}
InlineParserImpl.__index = InlineParserImpl

local frozen = table.freeze({
	"Code",
	"HtmlInline",
	"Autolink",
	"Entity",
	"BackslashEscape",
	"Emphasis",
	"Link",
	"Image",
	"HardLineBreak"
})

local result = {}

for _, v2 in ipairs(frozen) do
	result[v2] = true
end

table.freeze(result)

function InlineParserImpl.getDefaultInlineTypes()
	return frozen
end

function InlineParserImpl.checkEnabledInlineTypes(list)
	for _, item in ipairs(list) do
		if result[item] then
			continue
		end

		local joined = table.concat(frozen, ", ")
		error(`Can't enable inline type {item}, possible options are: [{joined}]`)
	end
end

local function calculateEnabledInlineTypes(context)
	local getEnabledInlineTypes = context.getEnabledInlineTypes
	local v2

	if getEnabledInlineTypes ~= nil then
		v2 = getEnabledInlineTypes(context)
	end

	if v2 == nil then
		return result
	end

	InlineParserImpl.checkEnabledInlineTypes(v2)
	local result2 = {}

	for _, v3 in ipairs(v2) do
		result2[v3] = true
	end

	return result2
end

local function addDelimiterProcessorForChar(p: number, item, p2) -- 3 equivalent calls inferred from this helper
	local v2 = p2[p]
	p2[p] = item

	if v2 ~= nil then
		error(`Delimiter processor conflict with delimiter char '{string.char(p)}'`)
	end
end

local function addDelimiterProcessors(list, delimiterProcessors)
	for _, item in ipairs(list) do
		local openingCharacter = item:getOpeningCharacter()
		local closingCharacter = item:getClosingCharacter()

		if openingCharacter == closingCharacter then
			local v2 = delimiterProcessors[openingCharacter]

			if v2 == nil or v2:getOpeningCharacter() ~= v2:getClosingCharacter() then
				addDelimiterProcessorForChar(openingCharacter, item, delimiterProcessors) -- inferred equivalent call
			else
				local v3

				if getmetatable(v2) == StaggeredDelimiterProcessor then
					v3 = v2
				else
					v3 = StaggeredDelimiterProcessor.new(openingCharacter)
					v3:add(v2)
				end

				v3:add(item)
				delimiterProcessors[openingCharacter] = v3
			end
		else
			addDelimiterProcessorForChar(openingCharacter, item, delimiterProcessors) -- inferred equivalent call
			addDelimiterProcessorForChar(closingCharacter, item, delimiterProcessors) -- inferred equivalent call
		end
	end
end

local function calculateDelimiterProcessors(p, p2)
	local delimiterProcessors = {}

	if p2.Emphasis then
		addDelimiterProcessors(
			{ EmphasisDelimiterProcessor.new(42), EmphasisDelimiterProcessor.new(95) },
			delimiterProcessors
		)
	end

	addDelimiterProcessors(p, delimiterProcessors)
	return delimiterProcessors
end

local function calculateLinkMarkers(customLinkMarkers, p) -- 1 equivalent call inferred from this helper
	local linkMarkers = {}

	for k in pairs(customLinkMarkers) do
		linkMarkers[k] = true
	end

	if p.Image then
		linkMarkers[33] = true
	end

	return linkMarkers
end

local function calculateSpecialCharacters(linkMarkers, delimiterProcessors, inlineContentParserFactories, bracketsEnabled: boolean)
	local clone = table.clone(linkMarkers)

	for k in pairs(delimiterProcessors) do
		clone[k] = true
	end

	for _, item in ipairs(inlineContentParserFactories) do
		for k in pairs(item:getTriggerCharacters()) do
			clone[k] = true
		end
	end

	if bracketsEnabled then
		clone[91] = true
		clone[93] = true
	end

	clone[33] = true
	clone[10] = true
	return clone
end

function InlineParserImpl.new(context)
	local self = setmetatable({ _nestingDepths = {}, _delimiterIndexes = {}, _disallowWalked = {} }, InlineParserImpl)
	self._context = context
	local enabledInlineTypes = calculateEnabledInlineTypes(context)
	self._enabledInlineTypes = enabledInlineTypes
	local customLinkProcessors = context:getCustomLinkProcessors()
	local customLinkMarkers = context:getCustomLinkMarkers()
	self._bracketsEnabled = enabledInlineTypes.Link == true
		or enabledInlineTypes.Image == true
		or #customLinkProcessors > 0
		or next(customLinkMarkers) ~= nil
	self._inlineContentParserFactories = self:calculateInlineContentParserFactories(context:getCustomInlineContentParserFactories())
	self._delimiterProcessors = calculateDelimiterProcessors(context:getCustomDelimiterProcessors(), enabledInlineTypes)
	self._linkProcessors = self:calculateLinkProcessors(customLinkProcessors)
	self._linkMarkers = calculateLinkMarkers(customLinkMarkers, enabledInlineTypes) -- inferred equivalent call
	self._maxInlineNesting = context:getMaxInlineNesting()
	self._limitInlineNesting = self._maxInlineNesting ~= Integer.MAX_VALUE
	self._specialCharacters = calculateSpecialCharacters(
		self._linkMarkers,
		self._delimiterProcessors,
		self._inlineContentParserFactories,
		self._bracketsEnabled
	)

	return self
end

function InlineParserImpl:calculateInlineContentParserFactories(p)
	local clone = table.clone(p)
	local enabledInlineTypes = self._enabledInlineTypes

	if enabledInlineTypes.BackslashEscape then
		table.insert(clone, BackslashInlineParser.Factory.new(enabledInlineTypes.HardLineBreak == true))
	end

	if enabledInlineTypes.Code then
		table.insert(clone, BackticksInlineParser.Factory.new())
	end

	if enabledInlineTypes.Entity then
		table.insert(clone, EntityInlineParser.Factory.new())
	end

	if enabledInlineTypes.Autolink then
		table.insert(clone, AutolinkInlineParser.Factory.new())
	end

	if enabledInlineTypes.HtmlInline then
		table.insert(clone, HtmlInlineParser.Factory.new())
	end

	return clone
end

function InlineParserImpl:calculateLinkProcessors(p)
	local clone = table.clone(p)
	local enabledInlineTypes = self._enabledInlineTypes

	if enabledInlineTypes.Link or enabledInlineTypes.Image then
		table.insert(clone, CoreLinkProcessor.new(enabledInlineTypes.Link == true, enabledInlineTypes.Image == true))
	end

	return clone
end

function InlineParserImpl:createInlineContentParsers()
	local inlineContentParsers = {}

	for _, inlineContentParserFactory in ipairs(self._inlineContentParserFactories) do
		local v2 = inlineContentParserFactory:create()

		for k in pairs(inlineContentParserFactory:getTriggerCharacters()) do
			local v3 = inlineContentParsers[k]

			if v3 == nil then
				v3 = {}
				inlineContentParsers[k] = v3
			end

			table.insert(v3, v2)
		end
	end

	return inlineContentParsers
end

function InlineParserImpl:scanner()
	return self._scanner
end

function InlineParserImpl:parse(p, object)
	self:reset(p)

	while true do
		local inline = self:parseInline()

		if inline == nil then
			break
		end

		for _, v2 in ipairs(inline) do
			object:appendChild(v2)
		end
	end

	self:processDelimiters(nil)
	self:mergeChildTextNodes(object)
end

function InlineParserImpl:reset(object)
	self._scanner = Scanner.of(object)
	self._includeSourceSpans = #object:getSourceSpans() > 0
	self._trailingSpaces = 0
	self._lastDelimiter = nil
	self._lastBracket = nil
	table.clear(self._disallowWalked)
	table.clear(self._nestingDepths)
	table.clear(self._delimiterIndexes)
	self._delimiterCount = 0
	self._inlineParsers = self:createInlineContentParsers()
end

function InlineParserImpl:text(object)
	local text = Nodes.Text(object:getContent())
	text:setSourceSpans(object:getSourceSpans())
	return text
end

function InlineParserImpl:parseInline()
	local scanner = self._scanner
	local v2 = scanner:peek()

	if v2 == 91 and self._bracketsEnabled then
		return { self:parseOpenBracket() }
	end

	if v2 == 93 and self._bracketsEnabled then
		return { self:parseCloseBracket() }
	end

	if v2 == 10 then
		return { self:parseLineBreak() }
	end

	if v2 == v then
		return nil
	end

	if self._linkMarkers[v2] then
		local position = scanner:position()
		local linkMarker = self:parseLinkMarker()

		if linkMarker ~= nil then
			return linkMarker
		end

		scanner:setPosition(position)
	end

	if not self._specialCharacters[v2] then
		return { self:parseText() }
	end

	local inlineParser = self._inlineParsers[v2]

	if inlineParser ~= nil then
		local position = scanner:position()

		for _, v3 in ipairs(inlineParser) do
			local v4 = v3:tryParse(self)

			if v4 == nil then
				scanner:setPosition(position)
			else
				local node = v4:getNode()
				scanner:setPosition(v4:getPosition())

				if self._includeSourceSpans and #node:getSourceSpans() == 0 then
					node:setSourceSpans(scanner:getSource(position, scanner:position()):getSourceSpans())
				end

				return { node }
			end
		end
	end

	local delimiterProcessor = self._delimiterProcessors[v2]

	if delimiterProcessor ~= nil then
		local delimiters = self:parseDelimiters(delimiterProcessor, v2)

		if delimiters ~= nil then
			return delimiters
		end
	end

	return { self:parseText() }
end

function InlineParserImpl:parseDelimiters(p, p2: number)
	local v2 = self:scanDelimiters(p, p2)

	if v2 == nil then
		return nil
	end

	local characters = v2.characters

	local v3 = Delimiter.new(characters, p2, v2.canOpen, v2.canClose, self._lastDelimiter)
	self._lastDelimiter = v3
	self._delimiterCount += 1
	self._delimiterIndexes[v3] = self._delimiterCount

	if v3.previous ~= nil then
		v3.previous.next = v3
	end

	return characters
end

function InlineParserImpl:parseOpenBracket()
	local scanner = self._scanner
	local position = scanner:position()
	scanner:next()
	local position2 = scanner:position()

	local openBracket = self:text(scanner:getSource(position, position2))

	self:addBracket(Bracket.link(openBracket, position, position2, self._lastBracket, self._lastDelimiter))

	return openBracket
end

function InlineParserImpl:parseLinkMarker()
	local scanner = self._scanner
	local position = scanner:position()
	scanner:next()
	local position2 = scanner:position()

	if not scanner:nextChar(91) then
		return nil
	end

	local position3 = scanner:position()
	local text = self:text(scanner:getSource(position, position2))
	local text2 = self:text(scanner:getSource(position2, position3))

	self:addBracket(Bracket.withMarker(
		text,
		position,
		text2,
		position2,
		position3,
		self._lastBracket,
		self._lastDelimiter
	))

	return { text, text2 }
end

function InlineParserImpl:parseCloseBracket()
	local scanner = self._scanner
	local position = scanner:position()
	scanner:next()
	local position2 = scanner:position()

	local lastBracket = self._lastBracket

	if lastBracket == nil then
		return self:text(scanner:getSource(position, position2))
	end

	if not lastBracket.allowed then
		self:removeLastBracket()
		return self:text(scanner:getSource(position, position2))
	end

	local linkOrImage = self:parseLinkOrImage(lastBracket, position)

	if linkOrImage ~= nil then
		return linkOrImage
	end

	scanner:setPosition(position2)

	self:removeLastBracket()
	return self:text(scanner:getSource(position, position2))
end

function InlineParserImpl:parseLinkOrImage(p, p2)
	local scanner = self._scanner
	local linkInfo = self:parseLinkInfo(p, p2)

	if linkInfo == nil then
		return nil
	end

	local position = scanner:position()

	for _, linkProcessor in ipairs(self._linkProcessors) do
		local v2 = linkProcessor:process(linkInfo, scanner, self._context)

		if v2 == nil then
			scanner:setPosition(position)
		else
			local node = v2:getNode()
			local position2 = v2:getPosition()
			local includeMarker = v2:isIncludeMarker()

			local kind = v2:getType()

			if kind == LinkResult.Type.WRAP then
				scanner:setPosition(position2)
				return self:wrapBracket(p, node, includeMarker)
			end

			if kind == LinkResult.Type.REPLACE then
				scanner:setPosition(position2)
				return self:replaceBracket(p, node, includeMarker)
			end
		end
	end

	return nil
end

local class = {}
class.__index = class

function class.new(destination: string, title: string?)
	return (setmetatable({ destination = destination, title = title }, class))
end

local class2 = {}
class2.__index = class2

function class2.new(marker, openingBracket, scanner, textStart, textEnd, label: string?, destination: string?, title: string?, afterTextBracket)
	return (setmetatable({
		_marker = marker,
		_openingBracket = openingBracket,
		_text = nil,
		_scanner = scanner,
		_textStart = textStart,
		_textEnd = textEnd,
		_label = label,
		_destination = destination,
		_title = title,
		_afterTextBracket = afterTextBracket
	}, class2))
end

function class2:marker()
	return self._marker
end

function class2:openingBracket()
	return self._openingBracket
end

function class2:text()
	local text = self._text

	if text ~= nil then
		return text
	end

	local content = self._scanner:getSource(self._textStart, self._textEnd):getContent()
	self._text = content
	return content
end

function class2:label()
	return self._label
end

function class2:destination()
	return self._destination
end

function class2:title()
	return self._title
end

function class2:afterTextBracket()
	return self._afterTextBracket
end

local function parseLinkDestination(object)
	local v2 = object:peek()
	local position = object:position()

	if not LinkScanner.scanLinkDestination(object) then
		return nil
	end

	local v3

	if v2 == 60 then
		local content = object:getSource(position, object:position()):getContent()
		v3 = sub(content, 2, #content - 1)
	else
		v3 = object:getSource(position, object:position()):getContent()
	end

	return Escaping.unescapeString(v3)
end

local function parseLinkTitle(object)
	local position = object:position()

	if not LinkScanner.scanLinkTitle(object) then
		return nil
	end

	local content = object:getSource(position, object:position()):getContent()
	local v2 = sub(content, 2, #content - 1)
	return Escaping.unescapeString(v2)
end

local function parseInlineDestinationTitle(scanner)
	if not scanner:nextChar(40) then
		return nil
	end

	scanner:whitespace()
	local v2 = parseLinkDestination(scanner)

	if v2 == nil then
		return nil
	end

	local v3

	if scanner:whitespace() >= 1 then
		v3 = parseLinkTitle(scanner)
		scanner:whitespace()
	end

	if scanner:nextChar(41) then
		return class.new(v2, v3)
	end

	return nil
end

function InlineParserImpl:parseLinkInfo(data, p)
	local scanner = self._scanner

	local position = scanner:position()

	local v2 = parseInlineDestinationTitle(scanner)

	if v2 ~= nil then
		return class2.new(
			data.markerNode,
			data.bracketNode,
			scanner,
			data.contentPosition,
			p,
			nil,
			v2.destination,
			v2.title,
			position
		)
	end

	scanner:setPosition(position)

	local linkLabel = InlineParserImpl.parseLinkLabel(scanner)

	if linkLabel == nil then
		scanner:setPosition(position)
	end

	local v3 = linkLabel == nil or linkLabel == ""

	if data.bracketAfter and v3 and data.markerNode == nil then
		return nil
	end

	return class2.new(
		data.markerNode,
		data.bracketNode,
		scanner,
		data.contentPosition,
		p,
		linkLabel,
		nil,
		nil,
		position
	)
end

function InlineParserImpl:wrapBracket(data, object, flag: boolean)
	local scanner = self._scanner

	if self._limitInlineNesting and data.contentNestingDepth >= self._maxInlineNesting then
		return nil
	end

	local v2 = data.bracketNode:getNext()

	while v2 ~= nil do
		local nextNode = v2:getNext()
		object:appendChild(v2)
		v2 = nextNode
	end

	if self._includeSourceSpans then
		local v3

		if flag and data.markerPosition ~= nil then
			v3 = data.markerPosition
		else
			v3 = data.bracketPosition
		end

		object:setSourceSpans(scanner:getSource(v3, scanner:position()):getSourceSpans())
	end

	self:processDelimiters(data.previousDelimiter)
	self:mergeChildTextNodes(object)

	if flag and data.markerNode ~= nil then
		data.markerNode:unlink()
	end

	data.bracketNode:unlink()
	self:removeLastBracket()

	self:recordNestingDepth(object, data.contentNestingDepth + 1)

	if data.markerNode == nil then
		self:disallowPreviousLinks()
	end

	return object
end

function InlineParserImpl:replaceBracket(data, object, flag: boolean)
	local scanner = self._scanner

	while self._lastDelimiter ~= nil and self._lastDelimiter ~= data.previousDelimiter do
		self:removeDelimiterKeepNode(self._lastDelimiter)
	end

	if self._includeSourceSpans then
		local v2

		if flag and data.markerPosition ~= nil then
			v2 = data.markerPosition
		else
			v2 = data.bracketPosition
		end

		object:setSourceSpans(scanner:getSource(v2, scanner:position()):getSourceSpans())
	end

	self:removeLastBracket()
	local v2

	if flag and data.markerNode ~= nil then
		v2 = data.markerNode
	else
		v2 = data.bracketNode
	end

	while v2 ~= nil do
		local nextNode = v2:getNext()
		v2:unlink()
		v2 = nextNode
	end

	self:recordNestingDepth(object, self:nestingDepthOfSiblings(object:getFirstChild(), nil) + 1)

	if data.markerNode == nil or not flag then
		self:disallowPreviousLinks()
	end

	return object
end

function InlineParserImpl:addBracket(lastBracket)
	if self._lastBracket ~= nil then
		self._lastBracket.bracketAfter = true
	end

	self._lastBracket = lastBracket
end

function InlineParserImpl:removeLastBracket()
	local lastBracket = self._lastBracket
	self._lastBracket = lastBracket.previous

	if self._lastBracket ~= nil and lastBracket.contentNestingDepth > self._lastBracket.contentNestingDepth then
		self._lastBracket.contentNestingDepth = lastBracket.contentNestingDepth
	end
end

function InlineParserImpl:disallowPreviousLinks()
	local v2 = self._lastBracket

	while v2 ~= nil and not self._disallowWalked[v2] do
		self._disallowWalked[v2] = true

		if v2.markerNode == nil then
			v2.allowed = false
		end

		v2 = v2.previous
	end
end

local function codePointCount(content: string) -- 1 equivalent call inferred from this helper
	local _, v2 = gsub(content, "[^\128-\191]", "")
	return v2
end

function InlineParserImpl.parseLinkLabel(object)
	if not object:nextChar(91) then
		return nil
	end

	local position = object:position()

	if not LinkScanner.scanLinkLabelContent(object) then
		return nil
	end

	local position2 = object:position()

	if not object:nextChar(93) then
		return nil
	end

	local content = object:getSource(position, position2):getContent()

	if codePointCount(content) > 999 then -- inferred equivalent call
		return nil
	end

	return content
end

function InlineParserImpl:parseLineBreak()
	self._scanner:next()
	local v2

	if self._trailingSpaces >= 2 then
		v2 = self._enabledInlineTypes.HardLineBreak == true
	else
		v2 = false
	end

	self._trailingSpaces = 0

	if v2 then
		return Nodes.HardLineBreak()
	end

	return Nodes.SoftLineBreak()
end

function InlineParserImpl:parseText()
	local scanner = self._scanner
	local specialCharacters = self._specialCharacters
	local position = scanner:position()
	scanner:next()
	local v2

	while true do
		v2 = scanner:peek()

		if v2 == v or specialCharacters[v2] then
			break
		end

		scanner:next()
	end

	local source = scanner:getSource(position, scanner:position())
	local content = source:getContent()

	if v2 == 10 then
		local v3 = Characters.skipBackwards(32, content, #content - 1, 0) + 1
		self._trailingSpaces = #content - v3
		content = sub(content, 1, v3)
	elseif v2 == v then
		content = sub(content, 1, Characters.skipSpaceTabBackwards(content, #content - 1, 0) + 1)
	end

	local text = Nodes.Text(content)
	text:setSourceSpans(source:getSourceSpans())
	return text
end

local v2 = {
	new = function(p: number, p2: number)
		return p * 6 + p2
	end
}

local class3 = {}
class3.__index = class3

function class3.new(characters, canOpen: boolean, canClose: boolean)
	return (setmetatable({ characters = characters, canOpen = canOpen, canClose = canClose }, class3))
end

function InlineParserImpl:scanDelimiters(object, p: number)
	local scanner = self._scanner
	local v3 = scanner:peekPreviousCodePoint()
	local v4 = scanner:position()

	if scanner:matchMultiple(p) < object:getMinLength() then
		scanner:setPosition(v4)
		return nil
	end

	scanner:setPosition(v4)
	local v5 = {}

	while scanner:nextChar(p) do
		table.insert(v5, self:text(scanner:getSource(v4, scanner:position())))
		v4 = scanner:position()
	end

	local v6 = scanner:peekCodePoint()

	local v7 = v3 == v or Characters.isPunctuationCodePoint(v3)
	local v8 = v3 == v or Characters.isWhitespaceCodePoint(v3)
	local v9 = v6 == v or Characters.isPunctuationCodePoint(v6)
	local v10 = v6 == v or Characters.isWhitespaceCodePoint(v6)
	local v11 = not v10 and (not v9 or v8 or v7)
	local v12 = not v8 and (not v7 or v10 or v9)
	local v13, v14

	if p == 95 then
		v13 = v11 and (not v12 or v7)
		v14 = v12 and (not v11 or v9)
	else
		v13 = v11 and p == object:getOpeningCharacter()
		v14 = v12 and p == object:getClosingCharacter()
	end

	return class3.new(v5, v13, v14)
end

function InlineParserImpl:processDelimiters(p)
	local v3 = self._lastDelimiter
	local previouses = {}

	while v3 ~= nil and v3.previous ~= p do
		v3 = v3.previous
	end

	while v3 ~= nil do
		local delimiterProcessor = self._delimiterProcessors[v3.delimiterChar]

		if v3:canClose() and delimiterProcessor ~= nil then
			local v4 = v2.new(v3.delimiterChar, v3:originalLength() % 3 + (v3:canOpen() and 3 or 0))

			local v5 = previouses[v4]
			local v6

			if not (v5 == nil or delimiterProcessor._rejectsByMultipleOf3Rule ~= true) then
				v6 = self._delimiterIndexes[v5]
			end

			local openingCharacter = delimiterProcessor:getOpeningCharacter()

			local previous = v3.previous

			local v7 = v3:getCloser()
			local flag = false
			local v8 = 0
			local v9 = nil
			local v10 = 0
			local maxValue = 0

			while
				previous ~= nil
				and previous ~= p
				and previous ~= v5
				and (v6 == nil or v6 < self._delimiterIndexes[previous])
			do
				if self._limitInlineNesting then
					maxValue = math.max(maxValue, self:nestingDepthOfSiblings(previous:getOpener():getNext(), v7))
					v7 = previous:getOpener()

					if self._maxInlineNesting <= maxValue then
						break
					end
				end

				if previous:canOpen() and previous.delimiterChar == openingCharacter then
					v8 = delimiterProcessor:process(previous, v3)

					if v8 > 0 then
						v10 = maxValue + 1

						v9 = previous:getOpener():getNext()
						flag = true
						break
					end
				end

				previous = previous.previous
			end

			if flag then
				for _ = 0, v8 - 1 do
					table.remove(previous.characters):unlink()
				end

				for _ = 0, v8 - 1 do
					table.remove(v3.characters, 1):unlink()
				end

				self:removeDelimitersBetween(previous, v3)

				if v9 ~= nil then
					self:recordNestingDepth(v9, v10)
				end

				if previous:length() == 0 then
					self:removeDelimiterAndNodes(previous)
				end

				if v3:length() == 0 then
					local nextNode = v3.next
					self:removeDelimiterAndNodes(v3)
					v3 = nextNode
				end
			else
				previouses[v4] = v3.previous

				if not v3:canOpen() then
					self:removeDelimiterKeepNode(v3)
				end

				v3 = v3.next
			end
		else
			v3 = v3.next
		end
	end

	while self._lastDelimiter ~= nil and self._lastDelimiter ~= p do
		self:removeDelimiterKeepNode(self._lastDelimiter)
	end
end

function InlineParserImpl:recordNestingDepth(p, contentNestingDepth: number)
	if not self._limitInlineNesting then
		return
	end

	self._nestingDepths[p] = contentNestingDepth

	if self._lastBracket ~= nil and self._lastBracket.contentNestingDepth < contentNestingDepth then
		self._lastBracket.contentNestingDepth = contentNestingDepth
	end
end

function InlineParserImpl:nestingDepthOfSiblings(object, p)
	local v3 = 0

	while object ~= nil and object ~= p do
		local nestingDepth = self._nestingDepths[object]

		if nestingDepth ~= nil and v3 < nestingDepth then
			v3 = nestingDepth
		end

		object = object:getNext()
	end

	return v3
end

function InlineParserImpl:removeDelimitersBetween(p, p2)
	local v3 = p2.previous

	while v3 ~= nil and v3 ~= p do
		local previous = v3.previous
		self:removeDelimiterKeepNode(v3)
		v3 = previous
	end
end

function InlineParserImpl:removeDelimiterAndNodes(p)
	self:removeDelimiter(p)
end

function InlineParserImpl:removeDelimiterKeepNode(p)
	self:removeDelimiter(p)
end

function InlineParserImpl:removeDelimiter(p)
	if p.previous ~= nil then
		p.previous.next = p.next
	end

	if p.next == nil then
		self._lastDelimiter = p.previous
	else
		p.next.previous = p.previous
	end
end

function InlineParserImpl:mergeChildTextNodes(object)
	if object:getFirstChild() == nil then
		return
	end

	local v3 = { object }

	while #v3 > 0 do
		self:mergeTextNodesInclusive(table.remove(v3), v3)
	end
end

function InlineParserImpl:mergeTextNodesInclusive(object, firstChilds)
	local firstChild = object:getFirstChild()
	local lastChild = object:getLastChild()
	local v3 = nil
	local v4 = nil
	local total = 0

	while firstChild ~= nil do
		if firstChild.kind == "Text" then
			if v3 == nil then
				v3 = firstChild
			end

			total += #firstChild.literal
			v4 = firstChild
		else
			self:mergeIfNeeded(v3, v4, total)
			v3 = nil
			v4 = nil
			total = 0

			if firstChild:getFirstChild() ~= nil then
				table.insert(firstChilds, firstChild)
			end
		end

		if firstChild == lastChild then
			break
		end

		firstChild = firstChild:getNext()
	end

	self:mergeIfNeeded(v3, v4, total)
end

function InlineParserImpl:mergeIfNeeded(object, object2, _: number)
	if object ~= nil and object2 ~= nil and object ~= object2 then
		local literals = { object.literal }
		local v3 = 1
		local v4

		if self._includeSourceSpans then
			v4 = SourceSpans.new()
			v4:addAll(object:getSourceSpans())
		end

		local v5 = object:getNext()
		local nextNode = object2:getNext()

		while v5 ~= nextNode do
			v3 += 1
			literals[v3] = v5.literal

			if v4 ~= nil then
				v4:addAll(v5:getSourceSpans())
			end

			local nextNode2 = v5:getNext()
			v5:unlink()
			v5 = nextNode2
		end

		object.literal = table.concat(literals)

		if v4 ~= nil then
			object:setSourceSpans(v4:getSourceSpans())
		end
	end
end

return InlineParserImpl
