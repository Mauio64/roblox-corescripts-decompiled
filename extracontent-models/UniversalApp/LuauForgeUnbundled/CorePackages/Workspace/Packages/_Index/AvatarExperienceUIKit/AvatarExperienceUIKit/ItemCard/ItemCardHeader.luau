local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Style").useDesignTokens
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local fFlagAXAddTransparencyToItemCardHeader = AvatarExperienceFlags.FFlagAXAddTransparencyToItemCardHeader

local function ItemCardHeader(props)
	local v5 = useDesignTokens()
	local udim = UDim.new(0, v5.Radius.Medium)

	local shimmer = v5.Color.Common.Shimmer

	local createElement = React.createElement
	local v8 = if props.Size then props.Size else UDim2.fromScale(1, 1)
	local v7 = {
		Size = v8,
		BorderSizePixel = 0,
		BackgroundColor3 = shimmer.Color3,
		BackgroundTransparency = 0,
		LayoutOrder = 0,
		ZIndex = 0
	}

	local v9 = if fFlagAXAddTransparencyToItemCardHeader then props.BackgroundTransparency or shimmer.Transparency else shimmer.Transparency
	v7.BackgroundTransparency = v9

	v7.LayoutOrder = props.LayoutOrder
	v7.ZIndex = props.ZIndex
	local v10 = {
		CornerRadius = React.createElement("UICorner", { CornerRadius = udim }),
		AspectRatio = 0,
		ItemCardHeaderChildren = 0,
		ItemCardHeaderOverlaySlot = 0
	}

	local v11 = if not props.Size then React.createElement("UIAspectRatioConstraint", {
		AspectRatio = props.aspectRatio or 1,
		AspectType = Enum.AspectType.FitWithinMaxSize,
		DominantAxis = Enum.DominantAxis.Width
	}) else nil
	v10.AspectRatio = v11

	v10.ItemCardHeaderChildren = React.createElement(React.Fragment, nil, props.children)
	v10.ItemCardHeaderOverlaySlot = props.overlaySlot
	return createElement("Frame", v7, v10)
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardHeader))
end

return ItemCardHeader
