local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(Markdown.Adapter.AdapterTypes)
require(parent.CommonMark)
local UnderlineDelimiterProcessor = require(script.Parent.UnderlineDelimiterProcessor)

return {
	create = function()
		return {
			extendParser = function(object)
				object:customDelimiterProcessor(UnderlineDelimiterProcessor.new())
			end,
			extendHtmlRenderer = function(object)
				local UnderlineHtmlNodeRenderer = require(script.Parent.UnderlineHtmlNodeRenderer)
				object:nodeRendererFactory({
					create = function(_, p)
						return (UnderlineHtmlNodeRenderer.new(p))
					end
				})
			end,
			extendAdapter = function(object)
				object:inline("Underline", { style = "UNDERLINE" })
			end
		}
	end
}
