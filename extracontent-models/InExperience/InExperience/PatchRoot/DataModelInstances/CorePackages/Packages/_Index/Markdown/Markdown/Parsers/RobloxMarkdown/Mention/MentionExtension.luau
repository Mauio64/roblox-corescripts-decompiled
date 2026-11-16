local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(Markdown.Adapter.AdapterTypes)
require(parent.CommonMark)
require(script.Parent.Mention)
local MentionInlineParser = require(script.Parent.MentionInlineParser)

local function mentionText(p)
	return `@{p.name or p.id}`
end

return {
	create = function()
		return {
			extendParser = function(object)
				object:customInlineContentParserFactory(MentionInlineParser.Factory.new())
			end,
			extendHtmlRenderer = function(object)
				local MentionHtmlNodeRenderer = require(script.Parent.MentionHtmlNodeRenderer)
				object:nodeRendererFactory({
					create = function(_, p)
						return (MentionHtmlNodeRenderer.new(p))
					end
				})
			end,
			extendAdapter = function(object)
				object:inline("Mention", { text = mentionText })
			end
		}
	end
}
