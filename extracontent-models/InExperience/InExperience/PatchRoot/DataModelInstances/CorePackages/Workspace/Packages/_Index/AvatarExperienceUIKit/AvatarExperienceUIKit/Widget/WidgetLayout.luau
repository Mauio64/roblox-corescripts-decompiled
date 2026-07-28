local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens

local function WidgetLayout(t1: {[any]: any}) -- line: 19
	-- upvalues: useDesignTokens (copy), React (copy)
	local v6 = useDesignTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		UIPadding = if not t1.padding then nil else React.createElement("UIPadding", {
			PaddingLeft = t1.padding.left,
			PaddingRight = t1.padding.right,
			PaddingTop = t1.padding.top,
			PaddingBottom = t1.padding.bottom
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v6.Size.Size_300)
		}),
		TopContent = if not t1.headerSlot then nil else React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, t1.headerSlot),
		ItemGroup = if not t1.contentSlot then nil else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, t1.contentSlot)
	})
end

return WidgetLayout
