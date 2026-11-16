local CommonMark = script:FindFirstAncestor("CommonMark")
local Escaping = require(CommonMark.internal.util.Escaping)
local LinkScanner = require(CommonMark.internal.util.LinkScanner)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.beta.Position)
local Scanner = require(CommonMark.parser.beta.Scanner)
require(CommonMark.parser.SourceLine)
local SourceLines = require(CommonMark.parser.SourceLines)
require(CommonMark.node.SourceSpan)

local byte = string.byte
local gsub = string.gsub
local sub = string.sub

local LinkReferenceDefinitionParser = {}
LinkReferenceDefinitionParser.__index = LinkReferenceDefinitionParser

LinkReferenceDefinitionParser.State = table.freeze({
	START_DEFINITION = "START_DEFINITION",
	LABEL = "LABEL",
	DESTINATION = "DESTINATION",
	START_TITLE = "START_TITLE",
	TITLE = "TITLE",
	PARAGRAPH = "PARAGRAPH"
})

local state = LinkReferenceDefinitionParser.State

function LinkReferenceDefinitionParser.new(flag: boolean?)
	local state2

	if flag == false then
		state2 = state.PARAGRAPH
	else
		state2 = state.START_DEFINITION
	end

	return (setmetatable({
		_state = state2,
		_paragraphLines = {},
		_definitions = {},
		_sourceSpans = {},
		_label = nil,
		_destination = nil,
		_titleDelimiter = 0,
		_title = nil,
		_referenceValid = false
	}, LinkReferenceDefinitionParser))
end

function LinkReferenceDefinitionParser:parse(p)
	table.insert(self._paragraphLines, p)

	if self._state == state.PARAGRAPH then
		return
	end

	local v = Scanner.of(SourceLines.of(p))

	while v:hasNext() do
		local v2 = nil

		local _state = self._state

		if _state == state.START_DEFINITION then
			v2 = self:startDefinition(v)
		elseif _state == state.LABEL then
			v2 = self:label(v)
		elseif _state == state.DESTINATION then
			v2 = self:destination(v)
		elseif _state == state.START_TITLE then
			v2 = self:startTitle(v)
		elseif _state == state.TITLE then
			v2 = self:title(v)
		else
			error(`Unknown parsing state: {_state}`)
		end

		if not v2 then
			self._state = state.PARAGRAPH

			self:finishReference()
			break
		end
	end
end

function LinkReferenceDefinitionParser:addSourceSpan(p)
	table.insert(self._sourceSpans, p)
end

function LinkReferenceDefinitionParser:getParagraphLines()
	return SourceLines.ofList(self._paragraphLines)
end

function LinkReferenceDefinitionParser:getParagraphSourceSpans()
	return self._sourceSpans
end

function LinkReferenceDefinitionParser:getDefinitions()
	self:finishReference()
	return self._definitions
end

function LinkReferenceDefinitionParser:getState()
	return self._state
end

local function removeLast(p: number, list)
	if #list <= p then
		table.clear(list)
		return
	end

	for _ = 0, p - 1 do
		table.remove(list)
	end
end

function LinkReferenceDefinitionParser:removeLines(p: number)
	local sourceSpans = self._sourceSpans

	local frozen = table.freeze(table.move(sourceSpans, math.max(#sourceSpans - p, 0) + 1, #sourceSpans, 1, {}))
	removeLast(p, self._paragraphLines)
	removeLast(p, sourceSpans)
	return frozen
end

function LinkReferenceDefinitionParser:startDefinition(object): boolean
	self:finishReference()

	object:whitespace()

	if not object:nextChar(91) then
		return false
	end

	self._state = state.LABEL
	local label = {}
	self._label = label

	if not object:hasNext() then
		table.insert(label, "\n")
	end

	return true
end

local function codePointCount(joined: string) -- 1 equivalent call inferred from this helper
	local _, v = gsub(joined, "[^\128-\191]", "")
	return v
end

function LinkReferenceDefinitionParser:label(object): boolean
	local position = object:position()

	if not LinkScanner.scanLinkLabelContent(object) then
		return false
	end

	local label = self._label
	table.insert(label, object:getSource(position, object:position()):getContent())

	if not object:hasNext() then
		table.insert(label, "\n")
		return true
	end

	if not (object:nextChar(93) and object:nextChar(58)) then
		return false
	end

	local joined = table.concat(label)

	if codePointCount(joined) > 999 or Escaping.normalizeLabelContent(joined) == "" then -- inferred equivalent call
		return false
	end

	self._state = state.DESTINATION

	object:whitespace()
	return true
end

function LinkReferenceDefinitionParser:destination(object): boolean
	object:whitespace()
	local position = object:position()

	if not LinkScanner.scanLinkDestination(object) then
		return false
	end

	local content = object:getSource(position, object:position()):getContent()

	if byte(content, 1) == 60 then
		content = sub(content, 2, #content - 1)
	end

	self._destination = content

	local whitespace = object:whitespace()

	if object:hasNext() then
		if whitespace == 0 then
			return false
		end
	else
		self._referenceValid = true
		table.clear(self._paragraphLines)
	end

	self._state = state.START_TITLE
	return true
end

function LinkReferenceDefinitionParser:startTitle(object): boolean
	object:whitespace()

	if not object:hasNext() then
		self._state = state.START_DEFINITION
		return true
	end

	self._titleDelimiter = 0
	local titleDelimiter = object:peek()

	if titleDelimiter == 34 or titleDelimiter == 39 then
		self._titleDelimiter = titleDelimiter
	elseif titleDelimiter == 40 then
		self._titleDelimiter = 41
	end

	if self._titleDelimiter == 0 then
		self._state = state.START_DEFINITION
	else
		self._state = state.TITLE
		local title = {}
		self._title = title
		object:next()

		if not object:hasNext() then
			table.insert(title, "\n")
		end
	end

	return true
end

function LinkReferenceDefinitionParser:title(object): boolean
	local position = object:position()

	if not LinkScanner.scanLinkTitleContent(object, self._titleDelimiter) then
		self._title = nil
		return false
	end

	local title = self._title
	table.insert(title, object:getSource(position, object:position()):getContent())

	if not object:hasNext() then
		table.insert(title, "\n")
		return true
	end

	object:next()
	object:whitespace()

	if object:hasNext() then
		self._title = nil
		return false
	end

	self._referenceValid = true
	table.clear(self._paragraphLines)

	self._state = state.START_DEFINITION
	return true
end

function LinkReferenceDefinitionParser:finishReference()
	if not self._referenceValid then
		return
	end

	local unescapeString = Escaping.unescapeString(self._destination)
	local v

	if self._title ~= nil then
		v = Escaping.unescapeString(table.concat(self._title))
	end

	local linkReferenceDefinition = Nodes.LinkReferenceDefinition(table.concat(self._label), unescapeString, v)
	linkReferenceDefinition:setSourceSpans(self._sourceSpans)
	table.clear(self._sourceSpans)
	table.insert(self._definitions, linkReferenceDefinition)

	self._label = nil
	self._referenceValid = false
	self._destination = nil
	self._title = nil
end

return LinkReferenceDefinitionParser
