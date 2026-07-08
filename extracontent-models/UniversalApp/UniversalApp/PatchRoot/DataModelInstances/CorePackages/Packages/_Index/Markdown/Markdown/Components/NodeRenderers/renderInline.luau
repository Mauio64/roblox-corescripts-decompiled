local Markdown = script:FindFirstAncestor("Markdown")
local MarkdownParent = Markdown.Parent

require(Markdown.Types)

local React = require(MarkdownParent.React)
local Dash = require(MarkdownParent.Dash)
local InlineLayout = require(MarkdownParent.InlineLayout)
local InlineLayout2 = InlineLayout.Components.InlineLayout
local mergeContexts = require(Markdown.Utils.mergeContexts)
local isInlineElement = InlineLayout.Utils.isInlineElement

local function renderInline(p1, p2) -- line: 13
	-- upvalues: React (copy), InlineLayout2 (copy), Dash (copy), mergeContexts (copy), isInlineElement (copy)
	return React.createElement(InlineLayout2, {
		VerticalPadding = UDim.new(0, 0),
		Elements = Dash.filter(p2.processChildren(p1, mergeContexts(p2, {
			isInline = true
		})), isInlineElement)
	})
end

return renderInline
