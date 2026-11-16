local parent = script:FindFirstAncestor("GameFilters").Parent
local Foundation = require(parent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

return function(props)
	local v = useTokens()
	local v2 = Responsive.usePreferredInput() == Responsive.Input.Directional

	local headingSmall = v.Typography.HeadingSmall
	local emphasis = v.Color.Content.Emphasis

	local createElement = React.createElement
	local size

	if not FFlagLuaAppChartsFilterOptionTextTag then
		size = UDim2.fromScale(1, 0)
	end

	local v3 = {
		BackgroundTransparency = 1,
		Size = size,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder,
		[React.Change.AbsoluteSize] = function(p)
			props.onHeightChanged(p.AbsoluteSize.Y)
		end
	}
	local v4 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.Medium),
			PaddingBottom = UDim.new(0, v.Padding.Medium),
			PaddingLeft = UDim.new(0, v.Padding.XXLarge),
			PaddingRight = UDim.new(0, v.Padding.XXLarge)
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
	local v5 = {
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
	local font

	if not FoundationFontFaceMigration then
		font = headingSmall.Font
	end

	v5.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(headingSmall.Font)
	end

	v5.FontFace = fontFace
	v5.TextSize = headingSmall.FontSize
	v5.TextColor3 = emphasis.Color3
	v5.TextXAlignment = Enum.TextXAlignment.Left
	v5.TextYAlignment = Enum.TextYAlignment.Center
	v4.Title = createElement2("TextLabel", v5)
	local closeButton

	if not v2 then
		closeButton = React.createElement(IconButton, {
			LayoutOrder = 2,
			icon = "icons/navigation/close",
			size = IconSize.Small,
			onActivated = props.onCloseButtonActivated
		})
	end

	v4.CloseButton = closeButton
	return createElement("Frame", v3, v4)
end
