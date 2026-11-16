local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.internal.Definitions)
require(CommonMark.parser.delimiter.DelimiterProcessor)
require(CommonMark.parser.beta.InlineContentParserFactory)
require(CommonMark.parser.InlineParserContext)
require(CommonMark.parser.beta.LinkProcessor)
require(CommonMark.node.LinkReferenceDefinition)

local InlineParserContextImpl = {}
InlineParserContextImpl.__index = InlineParserContextImpl

function InlineParserContextImpl.new(inlineContentParserFactories, delimiterProcessors, linkProcessors, linkMarkers, maxInlineNesting: number, definitions, enabledInlineTypes)
	return (setmetatable({
		_inlineContentParserFactories = inlineContentParserFactories,
		_delimiterProcessors = delimiterProcessors,
		_linkProcessors = linkProcessors,
		_linkMarkers = linkMarkers,
		_maxInlineNesting = maxInlineNesting,
		_definitions = definitions,
		_enabledInlineTypes = enabledInlineTypes
	}, InlineParserContextImpl))
end

function InlineParserContextImpl:getCustomInlineContentParserFactories()
	return self._inlineContentParserFactories
end

function InlineParserContextImpl:getCustomDelimiterProcessors()
	return self._delimiterProcessors
end

function InlineParserContextImpl:getCustomLinkProcessors()
	return self._linkProcessors
end

function InlineParserContextImpl:getCustomLinkMarkers()
	return self._linkMarkers
end

function InlineParserContextImpl:getMaxInlineNesting()
	return self._maxInlineNesting
end

function InlineParserContextImpl:getEnabledInlineTypes()
	return self._enabledInlineTypes
end

function InlineParserContextImpl:getLinkReferenceDefinition(p: string)
	return self._definitions:getDefinition("LinkReferenceDefinition", p)
end

function InlineParserContextImpl:getDefinition(p: string, p2: string)
	return self._definitions:getDefinition(p, p2)
end

return InlineParserContextImpl
