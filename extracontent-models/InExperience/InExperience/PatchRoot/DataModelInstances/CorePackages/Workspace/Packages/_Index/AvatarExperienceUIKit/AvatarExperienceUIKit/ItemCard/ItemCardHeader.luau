local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddTransparencyToItemCardHeader = AvatarExperienceFlags.FFlagAXAddTransparencyToItemCardHeader

local function ItemCardHeader(props)
	local v = useDesignTokens()
	local udim = UDim.new(0, v.Radius.Medium)

	local shimmer = v.Color.Common.Shimmer

	local createElement = React.createElement
	local size

	if props.Size then
		size = props.Size
	else
		size = UDim2.fromScale(1, 1)
	end

	local v2 = {
		Size = size,
		BorderSizePixel = 0,
		BackgroundColor3 = shimmer.Color3,
		BackgroundTransparency = 0,
		LayoutOrder = 0,
		ZIndex = 0
	}
	local backgroundTransparency

	if FFlagAXAddTransparencyToItemCardHeader then
		backgroundTransparency = props.BackgroundTransparency or shimmer.Transparency
	else
		backgroundTransparency = shimmer.Transparency
	end

	v2.BackgroundTransparency = backgroundTransparency

	v2.LayoutOrder = props.LayoutOrder
	v2.ZIndex = props.ZIndex
	local v3 = {
		CornerRadius = React.createElement("UICorner", { CornerRadius = udim }),
		AspectRatio = 0,
		ItemCardHeaderChildren = 0,
		ItemCardHeaderOverlaySlot = 0
	}
	local aspectRatio

	if not props.Size then
		aspectRatio = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.aspectRatio or 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		})
	end

	v3.AspectRatio = aspectRatio

	v3.ItemCardHeaderChildren = React.createElement(React.Fragment, nil, props.children)
	v3.ItemCardHeaderOverlaySlot = props.overlaySlot
	return createElement("Frame", v2, v3)
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardHeader))
end

return ItemCardHeader
