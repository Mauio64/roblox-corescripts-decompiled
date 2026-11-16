local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXItemCardComponentsMemo = AvatarExperienceFlags.FFlagAXItemCardComponentsMemo
local FFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

local function CornerSlot(props)
	local constrainedWidth

	if FFlagAXMarketplaceLicensingItemCards then
		constrainedWidth = props.constrainedWidth
	end

	local createElement = React.createElement
	local automaticSize

	if constrainedWidth then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	local v = {
		AutomaticSize = automaticSize,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = 0,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = 0,
		ZIndex = 0
	}
	local size

	if constrainedWidth then
		size = UDim2.new(constrainedWidth.Scale, constrainedWidth.Offset, 0, 0)
	end

	v.Size = size

	v.ClipsDescendants = constrainedWidth ~= nil
	v.ZIndex = props.ZIndex
	return createElement("Frame", v, props.children)
end

local function ItemCardHeaderCornersOverlay(props)
	local small = useTokens().Gap.Small
	local v

	if FFlagAXMarketplaceItemCardIndicatorStack then
		v = small + (props.bottomInset or 0)
	else
		v = small
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local itemCardHeaderTopLeftSlot

	if props.topLeftSlot then
		local createElement2 = React.createElement
		local v2 = {
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromOffset(small, small),
			constrainedWidth = 0,
			ZIndex = 0
		}
		local constrainedWidth

		if props.constrainTopLeftSlot then
			constrainedWidth = UDim.new(1, -2 * small)
		end

		v2.constrainedWidth = constrainedWidth
		v2.ZIndex = props.ZIndex or 2
		itemCardHeaderTopLeftSlot = createElement2(CornerSlot, v2, props.topLeftSlot)
	end

	local itemCardHeaderTopRightSlot

	if props.topRightSlot then
		itemCardHeaderTopRightSlot = React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -small, 0, small),
			ZIndex = props.ZIndex or 2
		}, props.topRightSlot)
	end

	local itemCardHeaderBottomLeftSlot

	if props.bottomLeftSlot then
		itemCardHeaderBottomLeftSlot = React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, small, 1, -v),
			ZIndex = props.ZIndex or 2
		}, props.bottomLeftSlot)
	end

	local itemCardHeaderBottomRightSlot

	if props.bottomRightSlot then
		itemCardHeaderBottomRightSlot = React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -small, 1, -v),
			ZIndex = props.ZIndex or 2
		}, props.bottomRightSlot)
	end

	return createElement(fragment, nil, {
		ItemCardHeaderTopLeftSlot = itemCardHeaderTopLeftSlot,
		ItemCardHeaderTopRightSlot = itemCardHeaderTopRightSlot,
		ItemCardHeaderBottomLeftSlot = itemCardHeaderBottomLeftSlot,
		ItemCardHeaderBottomRightSlot = itemCardHeaderBottomRightSlot
	})
end

if FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardHeaderCornersOverlay))
end

return ItemCardHeaderCornersOverlay
