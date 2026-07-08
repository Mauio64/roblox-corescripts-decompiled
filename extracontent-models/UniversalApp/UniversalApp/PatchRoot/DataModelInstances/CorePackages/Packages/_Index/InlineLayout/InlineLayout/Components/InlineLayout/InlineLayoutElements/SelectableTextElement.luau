local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")
local Dash = require(ParentParent.Dash)
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local BaseTextElement = require(InlineLayoutElements.BaseTextElement)
local getFontFace = require(Parent.Utils.getFontFace)
local View = Foundation.View
local t1 = {}

function mapProps(p1) -- line: 23
	-- upvalues: Dash (copy)
	return Dash.omit(p1, {
		"id",
		"EngineTags"
	})
end

local function TextElementWrapper(p2) -- line: 27
	-- upvalues: getFontFace (copy), React (copy), View (copy), Dash (copy)
	local v14 = getFontFace(p2.fontStyle)
	local v15 = if typeof(p2.textStyle) ~= "table" then {} else p2.textStyle
	local v16 = typeof(p2.viewTags) == "string" and {
		[p2.viewTags] = true
	} or (p2.viewTags or {})

	return React.createElement(View, {
		tag = Dash.join({
			["size-0-0 auto-xy"] = true
		}, v16),
		LayoutOrder = p2.LayoutOrder
	}, {
		SelectableText = React.createElement("TextBox", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextEditable = false,
			ZIndex = 0,
			TextWrapped = false,
			ClearTextOnFocus = false,
			RichText = false,
			Text = p2.Text,
			FontFace = v14,
			TextSize = p2.fontStyle and p2.fontStyle.FontSize,
			TextColor3 = v15.Color3,
			TextTransparency = v15.Transparency,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
end

function t1.new(p3) -- line: 59
	-- upvalues: BaseTextElement (copy), TextElementWrapper (copy), Dash (copy)
	return BaseTextElement.new(TextElementWrapper, Dash.omit(p3, { "EngineTags" }), mapProps)
end

return t1
