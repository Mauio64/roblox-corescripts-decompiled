local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Responsive")
local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
		Title = 0,
		CloseButton = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 1,
		Text = props.title,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = true
	}
	local v13 = if not foundationFontFaceMigration then headingSmall.Font else nil
	v12.Font = v13
	local v14 = if foundationFontFaceMigration then normalizeFontFace(headingSmall.Font) else nil
	v12.FontFace = v14
	v12.TextSize = headingSmall.FontSize
	v12.TextColor3 = emphasis.Color3
	v12.TextXAlignment = Enum.TextXAlignment.Left
	v12.TextYAlignment = Enum.TextYAlignment.Center
	v10.Title = createElement2("TextLabel", v12)

	local v15 = if not v6 then React.createElement(iconButton, {
		LayoutOrder = 2,
		icon = "icons/navigation/close",
		size = iconSize.Small,
		onActivated = props.onCloseButtonActivated
	}) else nil
	v10.CloseButton = v15
	return createElement("Frame", v8, v10)
end
