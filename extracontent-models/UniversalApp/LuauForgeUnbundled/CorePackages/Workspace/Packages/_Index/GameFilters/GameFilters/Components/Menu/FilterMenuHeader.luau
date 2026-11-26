local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Responsive")
local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag

return function(props)
	local v5 = useTokens()
	local v6 = Responsive.usePreferredInput() == Responsive.Input.Directional

	local headingSmall = v5.Typography.HeadingSmall
	local emphasis = v5.Color.Content.Emphasis

	local createElement = React.createElement

	local v9 = if not fFlagLuaAppChartsFilterOptionTextTag then UDim2.fromScale(1, 0) else nil
	local v8 = {
		BackgroundTransparency = 1,
		Size = v9,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder,
		[React.Change.AbsoluteSize] = function(p2)
			props.onHeightChanged(p2.AbsoluteSize.Y)
		end
	}
	local v10 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Padding.Medium),
			PaddingBottom = UDim.new(0, v5.Padding.Medium),
			PaddingLeft = UDim.new(0, v5.Padding.XXLarge),
			PaddingRight = UDim.new(0, v5.Padding.XXLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1,
			Text = props.title,
			FontFace = normalizeFontFace(headingSmall.Font),
			TextSize = headingSmall.FontSize,
			TextColor3 = emphasis.Color3,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true
		}),
		CloseButton = 0
	}

	local v11 = if not v6 then React.createElement(iconButton, {
		LayoutOrder = 2,
		icon = "icons/navigation/close",
		size = iconSize.Small,
		onActivated = props.onCloseButtonActivated
	}) else nil
	v10.CloseButton = v11
	return createElement("Frame", v8, v10)
end
