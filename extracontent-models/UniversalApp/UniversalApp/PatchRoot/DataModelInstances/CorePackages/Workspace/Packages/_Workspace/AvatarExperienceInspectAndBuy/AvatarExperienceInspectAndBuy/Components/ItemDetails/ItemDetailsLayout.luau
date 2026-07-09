local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local ItemDetailsView = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ItemDetailsView)
local BuyActionBarLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.BuyActionBarLayout)

require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

local useTokens = Foundation.Hooks.useTokens
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local Cryo = require(AvatarExperienceInspectAndBuyParent.Cryo)

local function ItemDetailsLayout(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), Cryo (copy), ViewType (copy), Foundation (copy), ItemDetailsView (copy), BuyActionBarLayout (copy)
	local v12 = useTokens()
	local Size_2700 = v12.Size.Size_2700
	local v14 = React.useMemo(function() -- line: 27
		-- upvalues: Cryo (copy), t1 (copy), Size_2700 (copy)
		return Cryo.Dictionary.join(t1.itemDetailsViewProps, {
			buyActionBarOffset = Size_2700
		})
	end, {
		t1.itemDetailsViewProps,
		Size_2700
	})
	local v15 = t1.view == ViewType.Compact

	return React.createElement(Foundation.View, {
		tag = "size-full"
	}, {
		ItemDetailsView = React.createElement(ItemDetailsView, v14),
		BuyActionBarLayout = if not v15 then nil else React.createElement(BuyActionBarLayout, {
			enableTopBorder = true,
			ZIndex = 2,
			buyActionBarProps = t1.buyActionBarProps,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			padding = UDim.new(0, v12.Padding.Medium),
			Size = UDim2.new(1, 0, 0, Size_2700)
		})
	})
end

return ItemDetailsLayout
