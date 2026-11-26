local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local catalogItemCard = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceCommon").Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail

local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local FFlagProfilePlatformFixResaleLimitedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformFixResaleLimitedPrice")

local function MarketplaceAssetTile(props)
	local v5 = useLocalization({
		free = TextKeys.CatalogLabelFree,
		offSale = TextKeys.CatalogLabelOffSale
	})
	local v6

	if props.itemType == Enums.ItemTypes.Bundle then
		v6 = constants.RbxthumbTypes.BundleThumbnail
	else
		v6 = constants.RbxthumbTypes.Asset
	end

	local v7 = nil
	local v8

	if props.isOffSale then
		if FFlagProfilePlatformFixResaleLimitedPrice and props.lowestResalePrice and props.lowestResalePrice > 0 then
			v8 = {
				type = Enums.PriceLineContentType.Price,
				price = props.lowestResalePrice
			}
		else
			v8 = { type = Enums.PriceLineContentType.Text, text = v5.offSale }
		end
	elseif props.price == 0 then
		v8 = { type = Enums.PriceLineContentType.Text, text = v5.free }
	else
		v8 = props.price and {
			type = Enums.PriceLineContentType.Price,
			price = props.price
		} or v7
	end

	return React.createElement(catalogItemCard, {
		title = props.name,
		presentationSlot = React.createElement(itemCardThumbnail, {
			url = getRbxthumbWithTypeSizeAndOptions(props.assetId, v6, 150)
		}),
		onActivated = props.onActivated,
		priceLineContent = v8,
		Size = UDim2.fromScale(1, 1),
		Selectable = true
	})
end

return MarketplaceAssetTile
