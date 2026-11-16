local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local ItemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local ItemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
require(AvatarExperienceInspectAndBuy.Types)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local getItemWidth = itemDetailsUtils.getItemWidth

local function BundleAssetsList(props)
	local v = useTokens()
	local itemData = props.itemData
	local v2 = props.view == ViewType.WideLandscape
	local v3 = props.view == ViewType.Compact
	local v4, v5 = React.useBinding(Vector2.new(0, 0))

	local children = {}
	local v6 = (v2 or v3) and 4 or 6

	if itemData.assetsInBundle then
		for k, v7 in itemData.assetsInBundle do
			local v8 = "AssetItemCard" .. k
			local createElement = React.createElement
			local v9 = {
				Size = v4:map(function(vector2: Vector2)
					local itemWidth = getItemWidth(vector2.X, v6, v.Gap.Medium)
					return UDim2.new(0, itemWidth, 1, 0)
				end),
				AutomaticSize = Enum.AutomaticSize.Y,
				headerSlot = React.createElement(
					ItemCardHeader,
					{ LayoutOrder = 1 },
					React.createElement(ItemCardThumbnail, {
						url = "rbxthumb://type=Asset&id=" .. v7.id .. "&w=420&h=420"
					})
				),
				footerSlot = 0
			}
			local footerSlot

			if v7.name then
				footerSlot = React.createElement(Foundation.Text, {
					tag = "auto-y text-body-small content-emphasis text-truncate-split text-align-x-left size-full-0 text-wrap",
					LayoutOrder = 2,
					Text = v7.name
				})
			end

			v9.footerSlot = footerSlot
			children[v8] = createElement(ItemCard, v9)
		end
	end

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v5(p.AbsoluteSize)
	end, {})

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 col align-x-left align-y-top gap-small",
		LayoutOrder = props.LayoutOrder or 5,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
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
