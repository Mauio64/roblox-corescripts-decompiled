local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local getFixedTabHeight = require(AvatarExperienceUIKit.Utils.getFixedTabHeight)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes

local Text = Foundation.Text
local View = Foundation.View

local backgroundStyle = { Transparency = 1 }

local v = {
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}

local backgroundStyle2 = { Transparency = 1 }

local function TabGroupTabComponent(props, ref)
	local v2 = useTokens()
	local textStyle

	if props.isActive then
		textStyle = props.activeTextStyle or v2.Color.Content.Emphasis
	else
		textStyle = props.textStyle or v2.Color.Content.Muted
	end

	local fontStyle = props.fontStyle or v2.Typography.TitleLarge
	local padding = props.padding or Vector2.new(v2.Padding.Small, v2.Padding.Medium)

	local createElement = React.createElement
	local v3 = {
		ref = ref,
		onActivated = props.onActivated,
		backgroundStyle = backgroundStyle,
		padding = 0,
		Size = 0,
		AutomaticSize = 0,
		layout = 0,
		LayoutOrder = 0
	}

	if FFlagAXCategoryMenuVisualFixes then
		padding = Vector2.new(padding.X, 0)
	end

	v3.padding = padding
	local size

	if FFlagAXCategoryMenuVisualFixes then
		size = UDim2.fromOffset(0, getFixedTabHeight(v2))
	else
		size = UDim2.fromScale(0, 0)
	end

	v3.Size = size
	local automaticSize

	if FFlagAXCategoryMenuVisualFixes then
		automaticSize = Enum.AutomaticSize.X
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	v3.AutomaticSize = automaticSize
	local layout

	if FFlagAXCategoryMenuVisualFixes then
		layout = v
	end

	v3.layout = layout
	v3.LayoutOrder = props.LayoutOrder
	return createElement(View, v3, {
		Text = React.createElement(Text, {
			Text = props.text,
			textStyle = textStyle,
			fontStyle = fontStyle,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = backgroundStyle2
		})
	})
end

return (React.forwardRef(TabGroupTabComponent))
