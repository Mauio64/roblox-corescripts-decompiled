local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent

require(Markdown.Types)
local React = require(parent.React)
local Dash = require(parent.Dash)
local InlineLayout = require(parent.InlineLayout)
local MarkdownCore = require(parent.MarkdownCore)
local Flags = MarkdownCore.Flags

local inlineLayout = InlineLayout.Components.InlineLayout
local mergeContexts = require(Markdown.Utils.mergeContexts)
local isInlineElement = InlineLayout.Utils.isInlineElement

local function renderInline(p, p2, horizontalAlignment)
	local createElement = React.createElement

	if not Flags.FFlagMarkdownTables then
		horizontalAlignment = nil
	end

	return createElement(inlineLayout, {
		HorizontalAlignment = horizontalAlignment,
		VerticalPadding = UDim.new(0, 0),
		Elements = Dash.filter(p2.processChildren(p, mergeContexts(p2, { isInline = true })), isInlineElement)
	})
end

return renderInline
