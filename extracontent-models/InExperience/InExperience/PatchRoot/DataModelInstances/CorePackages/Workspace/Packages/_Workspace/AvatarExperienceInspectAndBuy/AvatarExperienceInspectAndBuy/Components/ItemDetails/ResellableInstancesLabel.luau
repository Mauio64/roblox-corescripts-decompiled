local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local IconSize = Enums.IconSize
require(AvatarExperienceInspectAndBuy.Types)

local function ResellableInstancesLabel(props)
	local v = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = { LayoutOrder = props.LayoutOrder, tag = "auto-xy size-full-0" }
	local uiPadding

	if props.padding then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = props.padding.left,
			PaddingRight = props.padding.right,
			PaddingTop = props.padding.top,
			PaddingBottom = props.padding.bottom
		})
	end

	return createElement(view, v2, {
		UIPadding = uiPadding,
		Inner = React.createElement(
			Foundation.View,
			{
				tag = "auto-y padding-medium size-full-0 row align-x-left align-y-center gap-small radius-medium",
				backgroundStyle = v.Color.Surface.Surface_300
			},
			{
				Icon = React.createElement(Foundation.Icon, {
					name = Enums.IconName.ShoppingBasketCheck,
					variant = Enums.IconVariant.Filled,
					size = IconSize.Medium,
					LayoutOrder = 1
				}),
				Text = React.createElement(Foundation.Text, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-medium content-emphasis text-truncate-end",
					Text = props.ownedItemsLabel
				})
			}
		)
	})
end

return ResellableInstancesLabel
