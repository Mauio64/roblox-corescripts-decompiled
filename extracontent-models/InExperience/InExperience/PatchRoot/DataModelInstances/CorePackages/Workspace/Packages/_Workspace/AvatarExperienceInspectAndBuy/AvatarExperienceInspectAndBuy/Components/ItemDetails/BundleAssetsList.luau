local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceUIKit = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local ItemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local ItemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)

require(AvatarExperienceInspectAndBuy.Types)

local getItemWidth = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils).getItemWidth

local function BundleAssetsList(t1: {[any]: any}) -- line: 44
	-- upvalues: useTokens (copy), ViewType (copy), React (copy), ItemCard (copy), getItemWidth (copy), ItemCardHeader (copy), ItemCardThumbnail (copy), Foundation (copy)
	local v14 = useTokens()
	local itemData = t1.itemData
	local v16 = t1.view == ViewType.WideLandscape
	local v17 = t1.view == ViewType.Compact
	local v18, v19 = React.useBinding(Vector2.new(0, 0))
	local t2 = {}
	local v21 = not v16 and not v17 and 6 or 4

	if itemData.assetsInBundle then
		for v22, v23 in itemData.assetsInBundle do
			t2["AssetItemCard" .. v22] = React.createElement(ItemCard, {
				Size = v18:map(function(vector2: Vector2) -- line: 57
					-- upvalues: getItemWidth (copy), v21 (copy), v14 (copy)
					local v26 = getItemWidth(vector2.X, v21, v14.Gap.Medium)

					return UDim2.new(0, v26, 1, 0)
				end),
				AutomaticSize = Enum.AutomaticSize.Y,
				headerSlot = React.createElement(ItemCardHeader, {
					LayoutOrder = 1
				}, React.createElement(ItemCardThumbnail, {
					url = "rbxthumb://type=Asset&id=" .. v23.id .. "&w=420&h=420"
				})),
				footerSlot = if not v23.name then nil else React.createElement(Foundation.Text, {
					tag = "auto-y text-body-small content-emphasis text-truncate-split text-align-x-left size-full-0 text-wrap",
					LayoutOrder = 2,
					Text = v23.name
				})
			})
		end
	end

	local v24 = React.useCallback(function(p1) -- line: 81
		-- upvalues: v19 (copy)
		v19(p1.AbsoluteSize)
	end, {})

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 col align-x-left align-y-top gap-small",
		LayoutOrder = t1.LayoutOrder or 5,
		onAbsoluteSizeChanged = v24
	}, {
		IncludedPartsLabel = React.createElement(Foundation.View, {
			tag = "auto-xy padding-top-xxlarge",
			LayoutOrder = 1
		}, {
			Label = React.createElement(Foundation.Text, {
				tag = "text-title-medium text-align-x-left content-emphasis",
				LayoutOrder = 1,
				Text = t1.headerLabel
			})
		}),
		BundleAssets = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 padding-y-small row align-x-left align-y-top gap-medium wrap",
			LayoutOrder = 2
		}, t2)
	})
end

return BundleAssetsList
