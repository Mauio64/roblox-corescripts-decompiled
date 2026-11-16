local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.block.BlockParserFactory)
local Definitions = require(CommonMark.internal.Definitions)
require(CommonMark.parser.delimiter.DelimiterProcessor)
local DocumentParser = require(CommonMark.internal.DocumentParser)
require(CommonMark.Extension)
local IncludeSourceSpans = require(CommonMark.parser.IncludeSourceSpans)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.InlineParser)
require(CommonMark.parser.InlineParserContext)
local InlineParserContextImpl = require(CommonMark.internal.InlineParserContextImpl)
require(CommonMark.parser.InlineParserFactory)
local InlineParserImpl = require(CommonMark.internal.InlineParserImpl)
require(CommonMark.parser.beta.LinkProcessor)
require(CommonMark.node.Node)
require(CommonMark.parser.PostProcessor)

local Parser = {}
Parser.__index = Parser

function Parser:new()
	local object = setmetatable({
		_blockParserFactories = DocumentParser.calculateBlockParserFactories(
			self._blockParserFactories,
			self._enabledBlockTypes
		),
		_inlineParserFactory = self:getInlineParserFactory(),
		_postProcessors = self._postProcessors,
		_inlineContentParserFactories = self._inlineContentParserFactories,
		_delimiterProcessors = self._delimiterProcessors,
		_linkProcessors = self._linkProcessors,
		_linkMarkers = self._linkMarkers,
		_includeSourceSpans = self._includeSourceSpans,
		_maxOpenBlockParsers = self._maxOpenBlockParsers,
		_maxInlineNesting = self._maxInlineNesting,
		_enabledInlineTypes = self._enabledInlineTypes,
		_linkReferenceDefinitions = self._linkReferenceDefinitions
	}, Parser)

	local v = InlineParserContextImpl.new(
		object._inlineContentParserFactories,
		object._delimiterProcessors,
		object._linkProcessors,
		object._linkMarkers,
		object._maxInlineNesting,
		Definitions.new(),
		object._enabledInlineTypes
	)

	object._inlineParserFactory:create(v)
	return object
end

local class = {}
class.__index = class

function Parser.builder()
	return class.new()
end

function Parser:parse(p: string)
	return self:postProcess((self:createDocumentParser():parse(p)))
end

function Parser:parseReader(p: string)
	return self:postProcess((self:createDocumentParser():parseReader(p)))
end

function Parser:createDocumentParser()
	return DocumentParser.new(
		self._blockParserFactories,
		self._inlineParserFactory,
		self._inlineContentParserFactories,
		self._delimiterProcessors,
		self._linkProcessors,
		self._linkMarkers,
		self._includeSourceSpans,
		self._maxOpenBlockParsers,
		self._maxInlineNesting,
		self._enabledInlineTypes,
		self._linkReferenceDefinitions
	)
end

function Parser:postProcess(p)
	for _, postProcessor in ipairs(self._postProcessors) do
		p = postProcessor:process(p)
	end

	return p
end

function class.new()
	return (setmetatable({
		_blockParserFactories = {},
		_inlineContentParserFactories = {},
		_delimiterProcessors = {},
		_linkProcessors = {},
		_postProcessors = {},
		_linkMarkers = {},
		_enabledBlockTypes = DocumentParser.getDefaultBlockParserTypes(),
		_enabledInlineTypes = nil,
		_linkReferenceDefinitions = true,
		_inlineParserFactory = nil,
		_includeSourceSpans = IncludeSourceSpans.NONE,
		_maxOpenBlockParsers = 100,
		_maxInlineNesting = 100
	}, class))
end

function class.build(p)
	return Parser.new(p)
end

function class.extensions(p, list)
	for _, item in ipairs(list) do
		local extendParser = item.extendParser

		if extendParser ~= nil then
			extendParser(p)
		end
	end

	return p
end

function class:enabledBlockTypes(enabledBlockTypes)
	DocumentParser.checkEnabledBlockTypes(enabledBlockTypes)
	self._enabledBlockTypes = enabledBlockTypes
	return self
end

function class:enabledInlineTypes(enabledInlineTypes)
	if enabledInlineTypes ~= nil then
		InlineParserImpl.checkEnabledInlineTypes(enabledInlineTypes)
	end

	self._enabledInlineTypes = enabledInlineTypes
	return self
end

function class:linkReferenceDefinitions(linkReferenceDefinitions: boolean)
	self._linkReferenceDefinitions = linkReferenceDefinitions
	return self
end

function class:includeSourceSpans(includeSourceSpans)
	self._includeSourceSpans = includeSourceSpans
	return self
end

function class:maxOpenBlockParsers(maxOpenBlockParsers: number)
	if maxOpenBlockParsers < 0 then
		error("maxOpenBlockParsers must be >= 0")
	end

	self._maxOpenBlockParsers = maxOpenBlockParsers
	return self
end

function class:maxInlineNesting(maxInlineNesting: number)
	if maxInlineNesting < 0 then
		error("maxInlineNesting must be >= 0")
	end

	self._maxInlineNesting = maxInlineNesting
	return self
end

function class:customBlockParserFactory(p)
	table.insert(self._blockParserFactories, p)
	return self
end

function class:customInlineContentParserFactory(p)
	table.insert(self._inlineContentParserFactories, p)
	return self
end

function class:customDelimiterProcessor(p)
	table.insert(self._delimiterProcessors, p)
	return self
end

function class:linkProcessor(p)
	table.insert(self._linkProcessors, p)
	return self
end

function class:linkMarker(p: number)
	self._linkMarkers[p] = true
	return self
end

function class:postProcessor(p)
	table.insert(self._postProcessors, p)
	return self
end

function class:inlineParserFactory(inlineParserFactory)
	self._inlineParserFactory = inlineParserFactory
	return self
end

local v = {
	create = function(self, p)
		return (InlineParserImpl.new(p))
	end
}

function class:getInlineParserFactory()
	local inlineParserFactory = self._inlineParserFactory
	return if inlineParserFactory == nil then v else inlineParserFactory
end

Parser.Builder = class

return Parser
