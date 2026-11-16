local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")

local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local BaseTextElement = require(InlineLayoutElements.BaseTextElement)
local getFontFace = require(parent.Utils.getFontFace)

local View = Foundation.View

local SelectableTextElement = {}

function mapProps(p)
	return Dash.omit(p, { "id", "EngineTags" })
end

local function TextElementWrapper(props)
	local fontFace = getFontFace(props.fontStyle)
	local v = typeof(props.textStyle) ~= "table" and {} or props.textStyle
	local v2

	if typeof(props.viewTags) == "string" then
		v2 = {}
		v2[props.viewTags] = true

		if not v2 then
			v2 = props.viewTags or {}
		end
	else
		v2 = props.viewTags or {}
	end

	return React.createElement(View, {
		tag = Dash.join({ ["size-full-0 auto-y"] = true }, v2),
		LayoutOrder = props.LayoutOrder
	}, {
		SelectableText = React.createElement("TextBox", {
			Text = props.Text,
			FontFace = fontFace,
			TextSize = props.fontStyle and props.fontStyle.FontSize,
			TextColor3 = v.Color3,
			TextTransparency = v.Transparency,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextEditable = false,
			ZIndex = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = false,
			ClearTextOnFocus = false,
			RichText = false,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
end

function SelectableTextElement.new(p)
	return BaseTextElement.new(TextElementWrapper, Dash.omit(p, { "EngineTags" }), mapProps)
end

return SelectableTextElement
