local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local function WidgetLayout(props)
	local v = useDesignTokens()
	local createElement = React.createElement
	local v2 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		BorderSizePixel = 0
	}
	local uiPadding

	if props.padding then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = props.padding.left,
			PaddingRight = props.padding.right,
			PaddingTop = props.padding.top,
			PaddingBottom = props.padding.bottom
		})
	end

	local v3 = {
		UIPadding = uiPadding,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Size.Size_300)
		}),
		TopContent = 0,
		ItemGroup = 0
	}
	local topContent

	if props.headerSlot then
		topContent = React.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, props.headerSlot)
	end

	v3.TopContent = topContent
	local itemGroup

	if props.contentSlot then
		itemGroup = React.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, props.contentSlot)
	end

	v3.ItemGroup = itemGroup
	return createElement("Frame", v2, v3)
end

return WidgetLayout
