local Parent = script:FindFirstAncestor("GameFilters").Parent
local Foundation = require(Parent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local FFlagLuaAppChartsFilterOptionTextTag = require(Parent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), Responsive (copy), React (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), IconButton (copy), IconSize (copy)
	local v10 = useTokens()
	local v11 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local HeadingSmall = v10.Typography.HeadingSmall
	local Emphasis = v10.Color.Content.Emphasis

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = if not FFlagLuaAppChartsFilterOptionTextTag then UDim2.fromScale(1, 0) else nil,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder,
		[React.Change.AbsoluteSize] = function(p1) -- line: 31
			-- upvalues: t1 (copy)
			t1.onHeightChanged(p1.AbsoluteSize.Y)
		end
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v10.Padding.Medium),
			PaddingBottom = UDim.new(0, v10.Padding.Medium),
			PaddingLeft = UDim.new(0, v10.Padding.XXLarge),
			PaddingRight = UDim.new(0, v10.Padding.XXLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = t1.title,
			Font = HeadingSmall.Font,
			TextSize = HeadingSmall.FontSize,
			TextColor3 = Emphasis.Color3,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		CloseButton = if not v11 then React.createElement(IconButton, {
			LayoutOrder = 2,
			icon = "icons/navigation/close",
			size = IconSize.Small,
			onActivated = t1.onCloseButtonActivated
		}) else nil
	})
end
