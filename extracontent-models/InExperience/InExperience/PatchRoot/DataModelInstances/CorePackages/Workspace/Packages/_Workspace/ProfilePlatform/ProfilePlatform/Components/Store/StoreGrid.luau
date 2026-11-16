local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local Enums = require(ProfilePlatform.Common.Enums)
local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
require(ProfilePlatform.Common.AssetInfo)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local FFlagProfileStoreEnableFreeItemPriceLabelFix = require(ProfilePlatform.Flags.FFlagProfileStoreEnableFreeItemPriceLabelFix)
local FFlagProfileStoreShowLimitedResalePrice = require(ProfilePlatform.Flags.FFlagProfileStoreShowLimitedResalePrice)

local Asset = Constants.RbxthumbTypes.Asset
local BundleThumbnail = Constants.RbxthumbTypes.BundleThumbnail
local function fn(p: number)
	return p + 49
end

local function isLimitedItem(data): boolean
	local itemRestrictions = data.itemRestrictions

	if not itemRestrictions then
		return false
	end

	for _, itemRestriction in itemRestrictions do
		if
			itemRestriction == ItemRestrictions.Limited
			or itemRestriction == ItemRestrictions.LimitedUnique
			or itemRestriction == ItemRestrictions.Collectible
		then
			return true
		end
	end

	return false
end

local function isOnlyAvailableFromResale(props): boolean -- 1 equivalent call inferred from this helper
	if not (props.hasResellers and props.lowestResalePrice and props.lowestResalePrice > 0) then
		return false
	end

	local v = not isLimitedItem(props)

	if not v then
		if props.unitsAvailableForConsumption == nil then
			v = false
		else
			v = props.unitsAvailableForConsumption > 0
		end
	end

	return props.isOffSale == true or not v
end

local function StoreGrid(props)
	local v = useLocalization({ store = TextKeys.Store, free = TextKeys.CatalogLabelFree })

	local renderItem = React.useCallback(function(props2, layoutOrder: number)
		local v2

		if props2.itemType == Enums.ItemTypes.Bundle then
			v2 = BundleThumbnail
		else
			v2 = Asset
		end

		local v3 = props2.price and {
			type = Enums.PriceLineContentType.Price,
			price = props2.price
		}

		local priceLineContent = FFlagProfileStoreEnableFreeItemPriceLabelFix
			and props2.price
			and props2.price == 0
			and { type = Enums.PriceLineContentType.Text, text = v.free }
			or v3

		if FFlagProfileStoreShowLimitedResalePrice and props2.lowestResalePrice then
			priceLineContent = isOnlyAvailableFromResale(props2) -- inferred equivalent call
				and { type = Enums.PriceLineContentType.Price, price = props2.lowestResalePrice }
				or priceLineContent
		end

		local createElement = React.createElement
		local v4 = {
			LayoutOrder = layoutOrder,
			title = props2.name,
			presentationSlot = React.createElement(ItemCardThumbnail, {
				url = getRbxthumbWithTypeSizeAndOptions(props2.id, v2, 150)
			}),
			onActivated = function()
				props.openItemDetails(props2.id, props2.itemType, layoutOrder)
			end,
			priceLineContent = 0,
			AutomaticSize = 0
		}

		if not (FFlagProfileStoreEnableFreeItemPriceLabelFix or FFlagProfileStoreShowLimitedResalePrice) then
			priceLineContent = props2.price and {
				type = Enums.PriceLineContentType.Price,
				price = props2.price
			}
		end

		v4.priceLineContent = priceLineContent

		v4.AutomaticSize = Enum.AutomaticSize.Y
		return createElement(CatalogItemCard, v4), "ItemCard"
	end, { props.openItemDetails })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = props.layoutOrder,
		items = props.assets,
		renderItem = renderItem,
		getItemHeight = fn,
		title = v.store,
		onActivateHeader = props.navigateToCatalogSearch,
		overrides = {
			numColumns = props.numColumns or 3
		}
	})
end

return StoreGrid
