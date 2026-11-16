local script = script
local AbstractBlockParser = require(script.parser.block.AbstractBlockParser)
local AbstractVisitor = require(script.node.AbstractVisitor)
local ApiOptions = require(script.internal.port.ApiOptions)
local AsciiMatcher = require(script.text.AsciiMatcher)
local AutolinkInlineParser = require(script.internal.inline.AutolinkInlineParser)
local BlockContinue = require(script.parser.block.BlockContinue)
require(script.parser.block.BlockParser)
require(script.parser.block.BlockParserFactory)
local BlockQuoteParser = require(script.internal.BlockQuoteParser)
local BlockStart = require(script.parser.block.BlockStart)
require(script.text.CharMatcher)
local Characters = require(script.text.Characters)
local CustomBlock = require(script.node.CustomBlock)
local CustomNode = require(script.node.CustomNode)
require(script.parser.delimiter.DelimiterProcessor)
require(script.parser.delimiter.DelimiterRun)
local EmphasisDelimiterProcessor = require(script.internal.inline.EmphasisDelimiterProcessor)
require(script.Extension)
require(script.parser.IncludeSourceSpans)
require(script.parser.beta.InlineContentParser)
require(script.parser.beta.InlineContentParserFactory)
require(script.parser.InlineParser)
require(script.parser.InlineParserContext)
require(script.parser.beta.InlineParserState)
require(script.parser.beta.LinkInfo)
require(script.parser.beta.LinkProcessor)
local LinkResult = require(script.parser.beta.LinkResult)
local LinkedHashMap = require(script.internal.port.LinkedHashMap)
require(script.parser.block.MatchedBlockParser)
local Nodes = require(script.node.Nodes)
local ParsedInline = require(script.parser.beta.ParsedInline)
require(script.parser.block.ParserState)
require(script.parser.beta.Position)
local Scanner = require(script.parser.beta.Scanner)
local SourceLine = require(script.parser.SourceLine)
local SourceLines = require(script.parser.SourceLines)
local SourceSpan = require(script.node.SourceSpan)
local SourceSpans = require(script.node.SourceSpans)
local StrikethroughExtension = require(script.ext.gfm.strikethrough.StrikethroughExtension)
require(script.node.Visitor)

local CommonMark = {}

CommonMark.Node = table.freeze({
	AbstractVisitor = AbstractVisitor,
	CustomBlock = CustomBlock,
	CustomNode = CustomNode,
	Nodes = Nodes,
	SourceSpan = SourceSpan,
	SourceSpans = SourceSpans
})

CommonMark.Parser = table.freeze({
	SourceLine = SourceLine,
	SourceLines = SourceLines,
	Beta = table.freeze({ LinkResult = LinkResult, ParsedInline = ParsedInline, Scanner = Scanner }),
	Block = table.freeze({
		AbstractBlockParser = AbstractBlockParser,
		BlockContinue = BlockContinue,
		BlockStart = BlockStart
	}),
	Delimiter = table.freeze({ EmphasisLikeDelimiterProcessor = EmphasisDelimiterProcessor })
})

local function freezeWithLazyMembers(list, items)
	local clone = table.clone(list)
	local function member(p: string) -- 1 equivalent call inferred from this helper
		local v = clone[p]

		if v == nil and items[p] ~= nil then
			v = items[p]()
			clone[p] = v
		end

		return v
	end

	setmetatable(list, table.freeze({
		__index = function(_, p)
			return member(p) -- inferred equivalent call
		end,
		__iter = function()
			for k in items do
				if clone[k] == nil and items[k] ~= nil then
					clone[k] = items[k]()
				end
			end

			return next, clone
		end
	}))

	table.freeze(list)
	return list
end

CommonMark.Renderer = table.freeze({
	Html = freezeWithLazyMembers({ DefaultUrlSanitizer = nil, LinkedHashMap = LinkedHashMap }, {
		DefaultUrlSanitizer = function()
			return require(script.renderer.html.DefaultUrlSanitizer)
		end
	})
})

CommonMark.Text = table.freeze({ AsciiMatcher = AsciiMatcher, Characters = Characters })

CommonMark.Ext = table.freeze({
	Gfm = table.freeze({
		Strikethrough = table.freeze({ StrikethroughExtension = StrikethroughExtension })
	})
})

CommonMark.Internal = table.freeze({
	AutolinkInlineParser = AutolinkInlineParser,
	BlockQuoteParser = BlockQuoteParser
})

function CommonMark:parse(p)
	return ApiOptions.getParser(p):parse(self)
end

function CommonMark.renderHtml(p, p2)
	return ApiOptions.getHtmlRenderer(p2):render(p)
end

return CommonMark
