local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Style").useDesignTokens

local function WidgetLayout(props)
	local v5 = useDesignTokens()
	local createElement = React.createElement
	local v7 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		BorderSizePixel = 0
	}

	local v9 = if props.padding then React.createElement("UIPadding", {
		PaddingLeft = props.padding.left,
		PaddingRight = props.padding.right,
		PaddingTop = props.padding.top,
		PaddingBottom = props.padding.bottom
	}) else nil
	local v8 = {
		UIPadding = v9,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Size.Size_300)
		}),
		TopContent = 0,
		ItemGroup = 0
	}

	local v10 = if props.headerSlot then React.createElement("Frame", {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, props.headerSlot) else nil
	v8.TopContent = v10

	local v11 = if props.contentSlot then React.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, props.contentSlot) else nil
	v8.ItemGroup = v11
	return createElement("Frame", v7, v8)
end

return WidgetLayout
