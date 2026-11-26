local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local SquareCollectionGridView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/CollectionGridViews/SquareCollectionGridView")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceCommon")
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local FFlagProfileStoreEnableFreeItemPriceLabelFix = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileStoreEnableFreeItemPriceLabelFix")
local FFlagProfileStoreShowLimitedResalePrice = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileStoreShowLimitedResalePrice")

local asset = constants.RbxthumbTypes.Asset
local bundleThumbnail = constants.RbxthumbTypes.BundleThumbnail
local function fn(p2)
	return p2 + 49
end

local function isLimitedItem(p2): boolean
	local itemRestrictions2 = p2.itemRestrictions

	if not itemRestrictions2 then
		return false
	end

	for k, itemRestriction in itemRestrictions2 do
		if
			itemRestriction == itemRestrictions.Limited
			or itemRestriction == itemRestrictions.LimitedUnique
			or itemRestriction == itemRestrictions.Collectible
		then
			return true
		end
	end

	return false
end

local function isOnlyAvailableFromResale(data): boolean
	if not (data.hasResellers and data.lowestResalePrice and data.lowestResalePrice > 0) then
		return false
	end

	local v5 = not isLimitedItem(data)

	if not v5 then
		v5 = not (data.unitsAvailableForConsumption == nil) and data.unitsAvailableForConsumption > 0
	end

	return data.isOffSale == true or not v5
end

local function StoreGrid(props)
	local v5 = useLocalization({
		store = TextKeys.Store,
		free = TextKeys.CatalogLabelFree
	})

	local v6 = React.useCallback(function(props2, p2)
		local v7 = if props2.itemType == Enums.ItemTypes.Bundle then bundleThumbnail else asset

		local v8 = props2.price and {
			type = Enums.PriceLineContentType.Price,
			price = props2.price
		}

		local v9 = FFlagProfileStoreEnableFreeItemPriceLabelFix
			and props2.price
			and props2.price == 0
			and { type = Enums.PriceLineContentType.Text, text = v5.free }
			or v8

		if FFlagProfileStoreShowLimitedResalePrice and props2.lowestResalePrice then
			local v10

			if props2.hasResellers and props2.lowestResalePrice and props2.lowestResalePrice > 0 then
				local v11 = not isLimitedItem(props2)

				if not v11 then
					if props2.unitsAvailableForConsumption == nil then
						v11 = false
					else
						v11 = props2.unitsAvailableForConsumption > 0
					end
				end

				v10 = props2.isOffSale == true or not v11
			else
				v10 = false
			end

			v9 = v10 and {
					type = Enums.PriceLineContentType.Price,
					price = props2.lowestResalePrice
				}
				or v9
		end

		local createElement = React.createElement
		local v11 = {
			LayoutOrder = p2,
			title = props2.name,
			presentationSlot = React.createElement(itemCardThumbnail, {
				url = getRbxthumbWithTypeSizeAndOptions(props2.id, v7, 150)
			}),
			onActivated = function()
				props.openItemDetails(props2.id, props2.itemType, p2)
			end,
			priceLineContent = 0,
			AutomaticSize = 0
		}

		if not (FFlagProfileStoreEnableFreeItemPriceLabelFix or FFlagProfileStoreShowLimitedResalePrice) then
			v9 = props2.price and {
				type = Enums.PriceLineContentType.Price,
				price = props2.price
			}
		end

		v11.priceLineContent = v9

		v11.AutomaticSize = Enum.AutomaticSize.Y
		return createElement(catalogItemCard, v11), "ItemCard"
	end, { props.openItemDetails })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = props.layoutOrder,
		items = props.assets,
		renderItem = v6,
		getItemHeight = fn,
		title = v5.store,
		onActivateHeader = props.navigateToCatalogSearch,
		overrides = {
			numColumns = props.numColumns or 3
		}
	})
end

return StoreGrid
