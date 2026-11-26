local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local enums = Foundation.Enums
local iconSize = enums.IconSize
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

local function ResellableInstancesLabel(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v6 = { LayoutOrder = props.LayoutOrder, tag = "auto-xy size-full-0" }

	local v8 = if props.padding then React.createElement("UIPadding", {
		PaddingLeft = props.padding.left,
		PaddingRight = props.padding.right,
		PaddingTop = props.padding.top,
		PaddingBottom = props.padding.bottom
	}) else nil
	return createElement(view, v6, {
		UIPadding = v8,
		Inner = React.createElement(
			Foundation.View,
			{
				tag = "auto-y padding-medium size-full-0 row align-x-left align-y-center gap-small radius-medium",
				backgroundStyle = v5.Color.Surface.Surface_300
			},
			{
				Icon = React.createElement(Foundation.Icon, {
					name = enums.IconName.ShoppingBasketCheck,
					variant = enums.IconVariant.Filled,
					size = iconSize.Medium,
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
