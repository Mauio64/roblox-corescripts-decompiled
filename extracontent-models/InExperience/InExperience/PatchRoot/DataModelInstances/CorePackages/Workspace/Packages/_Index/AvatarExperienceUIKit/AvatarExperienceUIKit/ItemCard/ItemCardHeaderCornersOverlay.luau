local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function CornerSlot(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		ZIndex = t1.ZIndex
	}, t1.children)
end
local function ItemCardHeaderCornersOverlay(t2: {[any]: any}) -- line: 36
	-- upvalues: useTokens (copy), React (copy), CornerSlot (copy)
	local Small = useTokens().Gap.Small

	return React.createElement(React.Fragment, nil, {
		ItemCardHeaderTopLeftSlot = if not t2.topLeftSlot then nil else React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromOffset(Small, Small),
			ZIndex = t2.ZIndex or 2
		}, t2.topLeftSlot),
		ItemCardHeaderTopRightSlot = if not t2.topRightSlot then nil else React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -Small, 0, Small),
			ZIndex = t2.ZIndex or 2
		}, t2.topRightSlot),
		ItemCardHeaderBottomLeftSlot = if not t2.bottomLeftSlot then nil else React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, Small, 1, -Small),
			ZIndex = t2.ZIndex or 2
		}, t2.bottomLeftSlot),
		ItemCardHeaderBottomRightSlot = if not t2.bottomRightSlot then nil else React.createElement(CornerSlot, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -Small, 1, -Small),
			ZIndex = t2.ZIndex or 2
		}, t2.bottomRightSlot)
	})
end

if require(Parent.AvatarExperienceFlags).FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardHeaderCornersOverlay))
end

return ItemCardHeaderCornersOverlay
