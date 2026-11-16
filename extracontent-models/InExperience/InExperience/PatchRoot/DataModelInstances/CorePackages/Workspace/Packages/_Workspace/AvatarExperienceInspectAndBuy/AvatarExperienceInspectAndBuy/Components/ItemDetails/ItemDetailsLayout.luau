local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ItemDetailsView = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ItemDetailsView)
local BuyActionBarLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.BuyActionBarLayout)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
local useTokens = Foundation.Hooks.useTokens
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local Cryo = require(parent.Cryo)

local function ItemDetailsLayout(props)
	local v = useTokens()

	local size_2700 = v.Size.Size_2700

	local v2 = React.useMemo(function()
		return Cryo.Dictionary.join(props.itemDetailsViewProps, { buyActionBarOffset = size_2700 })
	end, { props.itemDetailsViewProps, size_2700 })

	local v3 = props.view == ViewType.Compact
	local createElement = React.createElement
	local view = Foundation.View

	local v4 = {
		ItemDetailsView = React.createElement(ItemDetailsView, v2),
		BuyActionBarLayout = 0
	}
	local buyActionBarLayout

	if v3 then
		buyActionBarLayout = React.createElement(BuyActionBarLayout, {
			buyActionBarProps = props.buyActionBarProps,
			enableTopBorder = true,
			ZIndex = 2,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			padding = UDim.new(0, v.Padding.Medium),
			Size = UDim2.new(1, 0, 0, size_2700)
		})
	end

	v4.BuyActionBarLayout = buyActionBarLayout
	return createElement(view, { tag = "size-full" }, v4)
end

return ItemDetailsLayout
