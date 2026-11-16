local parent = script.Parent
local parent2 = parent.Parent
require(parent.Adapter)
require(parent2.CommonMark)
require(parent.Parsers.FormattingTags.FormattingTag)
require(parent.Parsers.RobloxMarkdown.Mention.Mention)
require(parent.Parsers.RobloxMarkdown.Underline.Underline)
require(parent.Adapter.createParser)

return {
	ParserDocument = nil,
	ParserNode = nil,
	Mention = nil,
	FormattingTag = nil,
	FormattingTagText = nil,
	Underline = nil,
	Parser = nil,
	ParserConfig = nil,
	Extension = nil,
	AdapterAsName = nil,
	AdapterAttributes = nil,
	AdapterBlockName = nil,
	AdapterBlockRule = nil,
	AdapterBuilder = nil,
	AdapterContext = nil,
	AdapterEntryOptions = nil,
	AdapterExtension = nil,
	AdapterFallback = nil,
	AdapterFlattenOptions = nil,
	AdapterGap = nil,
	AdapterGapKind = nil,
	AdapterHandler = nil,
	AdapterInlineName = nil,
	AdapterInlineRule = nil,
	AdapterListOptions = nil,
	AdapterPassName = nil,
	AdapterQuoteOptions = nil,
	AdapterRendererName = nil,
	AdapterStyle = nil
}
