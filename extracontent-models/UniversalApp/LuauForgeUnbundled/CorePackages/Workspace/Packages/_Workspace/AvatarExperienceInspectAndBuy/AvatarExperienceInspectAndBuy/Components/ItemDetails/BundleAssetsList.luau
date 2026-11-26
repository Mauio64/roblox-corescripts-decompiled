local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceUIKit")
local itemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local itemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local itemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local getItemWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").getItemWidth

local function BundleAssetsList(props)
	local v5 = useTokens()
	local itemData = props.itemData
	local v6 = props.view == ViewType.WideLandscape
	local v7 = props.view == ViewType.Compact
	local v8, v9 = React.useBinding(Vector2.new(0, 0))

	local children = {}
	local v10 = (v6 or v7) and 4 or 6

	if itemData.assetsInBundle then
		for k, v11 in itemData.assetsInBundle do
			local v12 = "AssetItemCard" .. k
			local createElement = React.createElement
			local v14 = {
				Size = v8:map(function(p2)
					local itemWidth = getItemWidth(p2.X, v10, v5.Gap.Medium)
					return UDim2.new(0, itemWidth, 1, 0)
				end),
				AutomaticSize = Enum.AutomaticSize.Y,
				headerSlot = React.createElement(
					itemCardHeader,
					{ LayoutOrder = 1 },
					React.createElement(itemCardThumbnail, {
						url = "rbxthumb://type=Asset&id=" .. v11.id .. "&w=420&h=420"
					})
				),
				footerSlot = 0
			}

			local v15 = if v11.name then React.createElement(Foundation.Text, {
				tag = "auto-y text-body-small content-emphasis text-truncate-split text-align-x-left size-full-0 text-wrap",
				LayoutOrder = 2,
				Text = v11.name
			}) else nil
			v14.footerSlot = v15
			children[v12] = createElement(itemCard, v14)
		end
	end

	local v11 = React.useCallback(function(p2)
		v9(p2.AbsoluteSize)
	end, {})

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 col align-x-left align-y-top gap-small",
		LayoutOrder = props.LayoutOrder or 5,
		onAbsoluteSizeChanged = v11
	}, {
		IncludedPartsLabel = React.createElement(
			Foundation.View,
			{ tag = "auto-xy padding-top-xxlarge", LayoutOrder = 1 },
			{
				Label = React.createElement(Foundation.Text, {
					tag = "text-title-medium text-align-x-left content-emphasis",
					Text = props.headerLabel,
					LayoutOrder = 1
				})
			}
		),
		BundleAssets = React.createElement(
			Foundation.View,
			{
				tag = "auto-y size-full-0 padding-y-small row align-x-left align-y-top gap-medium wrap",
				LayoutOrder = 2
			},
			children
		)
	})
end

return BundleAssetsList
