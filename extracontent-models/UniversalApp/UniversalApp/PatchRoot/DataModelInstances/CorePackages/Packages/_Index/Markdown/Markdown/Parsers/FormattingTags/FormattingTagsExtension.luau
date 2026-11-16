local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(Markdown.Adapter.AdapterTypes)
require(parent.CommonMark)
require(script.Parent.FormattingTag)
local FormattingTagInlineParser = require(script.Parent.FormattingTagInlineParser)
local FormattingTagPostProcessor = require(script.Parent.FormattingTagPostProcessor)

local frozen = table.freeze({ b = "BOLD_2", i = "ITALIC", u = "UNDERLINE", s = "STRIKE" })

local function adaptFormattingTag(object, object2)
	if object:getFirstChild() == nil then
		return
	end

	object2:adaptInlinesOf(object, (object2:append(object2.parent, "STYLED_TEXT", {
		style = frozen[object.tagName]
	})))
end

local function literalOf(p)
	return p.literal
end

return {
	create = function(p)
		local v

		if p == nil then
			v = false
		else
			v = p.parseTags == true
		end

		local maxNesting

		if p == nil then
			maxNesting = nil
		else
			maxNesting = p.maxNesting
		end

		return {
			extendParser = function(object)
				if v then
					object:customInlineContentParserFactory(FormattingTagInlineParser.Factory.new())
				end

				object:postProcessor((FormattingTagPostProcessor.new(maxNesting)))
			end,
			extendHtmlRenderer = function(object)
				local FormattingTagHtmlNodeRenderer = require(script.Parent.FormattingTagHtmlNodeRenderer)
				object:nodeRendererFactory({
					create = function(_, p2)
						return (FormattingTagHtmlNodeRenderer.new(p2))
					end
				})
			end,
			extendAdapter = function(object)
				object:inline("FormattingTag", adaptFormattingTag)
				object:inline("FormattingTagText", { text = literalOf })
			end
		}
	end
}
