local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local IconSize = Enums.IconSize

require(AvatarExperienceInspectAndBuy.Types)

local function ResellableInstancesLabel(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), Enums (copy), IconSize (copy)
	local v10 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "auto-xy size-full-0",
		LayoutOrder = t1.LayoutOrder
	}, {
		UIPadding = if not t1.padding then nil else React.createElement("UIPadding", {
			PaddingLeft = t1.padding.left,
			PaddingRight = t1.padding.right,
			PaddingTop = t1.padding.top,
			PaddingBottom = t1.padding.bottom
		}),
		Inner = React.createElement(Foundation.View, {
			tag = "auto-y padding-medium size-full-0 row align-x-left align-y-center gap-small radius-medium",
			backgroundStyle = v10.Color.Surface.Surface_300
		}, {
			Icon = React.createElement(Foundation.Icon, {
				LayoutOrder = 1,
				name = Enums.IconName.ShoppingBasketCheck,
				variant = Enums.IconVariant.Filled,
				size = IconSize.Medium
			}),
			Text = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium content-emphasis text-truncate-end",
				Text = t1.ownedItemsLabel
			})
		})
	})
end

return ResellableInstancesLabel
