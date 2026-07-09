local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXAddTransparencyToItemCardHeader = AvatarExperienceFlags.FFlagAXAddTransparencyToItemCardHeader
local FFlagAXCatalogItemCardDarkerBackground = AvatarExperienceFlags.FFlagAXCatalogItemCardDarkerBackground

local function ItemCardHeader(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagAXCatalogItemCardDarkerBackground (copy), React (copy), FFlagAXAddTransparencyToItemCardHeader (copy)
	local v10 = useDesignTokens()
	local uDim = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Radius.Medium else v10.Radius.Medium)
	local v12 = if not FFlagAXCatalogItemCardDarkerBackground then if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Color.Common.Placeholder else v10.Color.Common.Shimmer else v10.Color.Shift.Shift_100

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = if not t1.Size then UDim2.fromScale(1, 1) else t1.Size,
		BackgroundColor3 = v12.Color3,
		BackgroundTransparency = if not FFlagAXAddTransparencyToItemCardHeader then v12.Transparency else t1.BackgroundTransparency or v12.Transparency,
		LayoutOrder = t1.LayoutOrder,
		ZIndex = t1.ZIndex
	}, {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		AspectRatio = if t1.Size then nil else React.createElement("UIAspectRatioConstraint", {
			AspectRatio = t1.aspectRatio or 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ItemCardHeaderChildren = React.createElement(React.Fragment, nil, t1.children),
		ItemCardHeaderOverlaySlot = t1.overlaySlot
	})
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardHeader))
end

return ItemCardHeader
