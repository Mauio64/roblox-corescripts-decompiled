local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation").Hooks.useTokens

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local fFlagAXItemCardComponentsMemo = AvatarExperienceFlags.FFlagAXItemCardComponentsMemo
local fFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

local function CornerSlot(props)
	local constrainedWidth = if fFlagAXMarketplaceLicensingItemCards then props.constrainedWidth else nil
	local createElement = React.createElement
	local v7 = if constrainedWidth then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY
	local v6 = {
		AutomaticSize = v7,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = 0,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = 0,
		ZIndex = 0
	}
	local v8 = if constrainedWidth then UDim2.new(constrainedWidth.Scale, constrainedWidth.Offset, 0, 0) else nil
	v6.Size = v8

	v6.ClipsDescendants = constrainedWidth ~= nil
	v6.ZIndex = props.ZIndex
	return createElement("Frame", v6, props.children)
end

local function ItemCardHeaderCornersOverlay(props)
	local small = useTokens().Gap.Small
	local v5

	if fFlagAXMarketplaceItemCardIndicatorStack then
		v5 = small + (props.bottomInset or 0)
	else
		v5 = small
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v8

	if props.topLeftSlot then
		local createElement2 = React.createElement
		local v10 = {
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromOffset(small, small),
			constrainedWidth = 0,
			ZIndex = 0
		}
		local v11 = if props.constrainTopLeftSlot then UDim.new(1, -2 * small) else nil
		v10.constrainedWidth = v11
		v10.ZIndex = props.ZIndex or 2
		v8 = createElement2(CornerSlot, v10, props.topLeftSlot)
	end

	local v9 = if props.topRightSlot then React.createElement(CornerSlot, {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -small, 0, small),
		ZIndex = props.ZIndex or 2
	}, props.topRightSlot) else nil

	local v10 = if props.bottomLeftSlot then React.createElement(CornerSlot, {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, small, 1, -v5),
		ZIndex = props.ZIndex or 2
	}, props.bottomLeftSlot) else nil

	local v11 = if props.bottomRightSlot then React.createElement(CornerSlot, {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -small, 1, -v5),
		ZIndex = props.ZIndex or 2
	}, props.bottomRightSlot) else nil
	return createElement(fragment, nil, {
		ItemCardHeaderTopLeftSlot = v8,
		ItemCardHeaderTopRightSlot = v9,
		ItemCardHeaderBottomLeftSlot = v10,
		ItemCardHeaderBottomRightSlot = v11
	})
end

if fFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardHeaderCornersOverlay))
end

return ItemCardHeaderCornersOverlay
