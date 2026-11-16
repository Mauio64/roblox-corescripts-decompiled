local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(Markdown.Adapter)
local CommonMark = require(parent.CommonMark)
local Flags = require(Markdown.Flags)
local FormattingTagsExtension = require(Markdown.Parsers.FormattingTags.FormattingTagsExtension)
require(Markdown.Types)
local createParser = require(Markdown.Adapter.createParser)

local frozen = table.freeze(FormattingTagsExtension.create({ maxNesting = 100 }))

local frozen2 = table.freeze(Flags.FFlagMarkdownFormattingTags and { frozen } or {})

local parser = createParser({ extensions = frozen2 })

local frozen3 = table.freeze({ extensions = frozen2 })

local CommonMark2 = {
	["parseOptions"] = parser.parseOptions,
	renderOptions = frozen3,
	formattingTagsExtension = frozen,
	parse = function(p: string)
		return parser.parseDocument(p)
	end,
	toRendererAst = function(p, p2)
		return parser.toRendererAst(p, p2)
	end
}

function CommonMark2.safeParse(p: string)
	return pcall(CommonMark2.parse, p)
end

function CommonMark2.renderHtml(p)
	return CommonMark.renderHtml(p, frozen3)
end

return CommonMark2
