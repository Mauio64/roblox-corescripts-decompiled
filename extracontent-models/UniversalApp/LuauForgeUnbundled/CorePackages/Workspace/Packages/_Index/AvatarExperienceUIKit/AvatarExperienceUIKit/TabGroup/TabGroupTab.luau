local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local useTokens = Foundation.Hooks.useTokens

local getFixedTabHeight = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getFixedTabHeight")

local fFlagAXCategoryMenuVisualFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXCategoryMenuVisualFixes

local text = Foundation.Text
local view = Foundation.View

local v5 = { Transparency = 1 }

local v6 = {
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}

local v7 = { Transparency = 1 }

local function TabGroupTabComponent(props, p2)
	local v8 = useTokens()
	local v9

	if props.isActive then
		v9 = props.activeTextStyle or v8.Color.Content.Emphasis
	else
		v9 = props.textStyle or v8.Color.Content.Muted
	end

	local fontStyle = props.fontStyle or v8.Typography.TitleLarge
	local v10 = props.padding or Vector2.new(v8.Padding.Small, v8.Padding.Medium)

	local createElement = React.createElement
	local v12 = {
		ref = p2,
		onActivated = props.onActivated,
		backgroundStyle = v5,
		padding = 0,
		Size = 0,
		AutomaticSize = 0,
		layout = 0,
		LayoutOrder = 0
	}

	if fFlagAXCategoryMenuVisualFixes then
		v10 = Vector2.new(v10.X, 0)
	end

	v12.padding = v10

	local v13 = if fFlagAXCategoryMenuVisualFixes then UDim2.fromOffset(0, getFixedTabHeight(v8)) else UDim2.fromScale(0, 0)
	v12.Size = v13

	local v14 = if fFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.X else Enum.AutomaticSize.XY
	v12.AutomaticSize = v14
	v12.layout = if fFlagAXCategoryMenuVisualFixes then v6 else nil
	v12.LayoutOrder = props.LayoutOrder
	return createElement(view, v12, {
		Text = React.createElement(text, {
			Text = props.text,
			textStyle = v9,
			fontStyle = fontStyle,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v7
		})
	})
end

return (React.forwardRef(TabGroupTabComponent))
