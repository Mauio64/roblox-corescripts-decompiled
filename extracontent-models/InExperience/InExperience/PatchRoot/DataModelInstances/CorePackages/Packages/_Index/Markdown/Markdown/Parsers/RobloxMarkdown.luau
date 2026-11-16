local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(Markdown.Adapter)
local CommonMark = require(parent.CommonMark)
local Flags = require(Markdown.Flags)
local FormattingTagsExtension = require(Markdown.Parsers.FormattingTags.FormattingTagsExtension)
local MentionExtension = require(script.Mention.MentionExtension)
local NoNestedQuote = require(script.NoNestedQuote)
require(Markdown.Types)
local UnderlineExtension = require(script.Underline.UnderlineExtension)
local createParser = require(Markdown.Adapter.createParser)

local frozen = table.freeze({
	"Heading",
	"FencedCodeBlock",
	"IndentedCodeBlock",
	"ThematicBreak",
	"ListBlock"
})

local frozen2 = table.freeze({
	"Code",
	"BackslashEscape",
	"Emphasis",
	"Link",
	"Image",
	"HardLineBreak"
})

local frozen3 = table.freeze(FormattingTagsExtension.create({ parseTags = true, maxNesting = 32 }))

local values = {
	table.freeze(NoNestedQuote.extension()),
	table.freeze(CommonMark.Ext.Gfm.Strikethrough.StrikethroughExtension.builder():requireTwoTildes(false):build()),
	table.freeze(UnderlineExtension.create()),
	table.freeze(MentionExtension.create())
}

if Flags.FFlagMarkdownFormattingTags then
	table.insert(values, frozen3)
end

local frozen4 = table.freeze(values)

local parser = createParser({
	extensions = frozen4,
	parserOptions = {
		enabledBlockTypes = frozen,
		enabledInlineTypes = frozen2,
		linkReferenceDefinitions = false,
		maxOpenBlockParsers = 32,
		maxInlineNesting = 32
	}
})

local frozen5 = table.freeze({ extensions = frozen4 })

local RobloxMarkdown = {
	["parseOptions"] = parser.parseOptions,
	renderOptions = frozen5,
	formattingTagsExtension = frozen3,
	parse = function(p: string)
		return parser.parseDocument(p)
	end,
	toRendererAst = function(p, p2)
		return parser.toRendererAst(p, p2)
	end
}

function RobloxMarkdown.safeParse(p: string)
	return pcall(RobloxMarkdown.parse, p)
end

function RobloxMarkdown.renderHtml(p)
	return CommonMark.renderHtml(p, frozen5)
end

return RobloxMarkdown
