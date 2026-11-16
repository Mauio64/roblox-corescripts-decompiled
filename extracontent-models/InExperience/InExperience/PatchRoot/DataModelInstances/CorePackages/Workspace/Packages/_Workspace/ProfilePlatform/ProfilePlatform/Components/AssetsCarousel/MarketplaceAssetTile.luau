local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail

local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)

local function MarketplaceAssetTile(props)
	local v = useLocalization({
		free = TextKeys.CatalogLabelFree,
		offSale = TextKeys.CatalogLabelOffSale
	})
	local v2

	if props.itemType == Enums.ItemTypes.Bundle then
		v2 = Constants.RbxthumbTypes.BundleThumbnail
	else
		v2 = Constants.RbxthumbTypes.Asset
	end

	local v3 = nil
	local priceLineContent

	if props.isOffSale then
		if FFlagProfilePlatformFixResaleLimitedPrice and props.lowestResalePrice and props.lowestResalePrice > 0 then
			priceLineContent = {
				type = Enums.PriceLineContentType.Price,
				price = props.lowestResalePrice
			}
		else
			priceLineContent = { type = Enums.PriceLineContentType.Text, text = v.offSale }
		end
	elseif props.price == 0 then
		priceLineContent = { type = Enums.PriceLineContentType.Text, text = v.free }
	else
		priceLineContent = props.price and {
			type = Enums.PriceLineContentType.Price,
			price = props.price
		} or v3
	end

	return React.createElement(CatalogItemCard, {
		title = props.name,
		presentationSlot = React.createElement(ItemCardThumbnail, {
			url = getRbxthumbWithTypeSizeAndOptions(props.assetId, v2, 150)
		}),
		onActivated = props.onActivated,
		priceLineContent = priceLineContent,
		Size = UDim2.fromScale(1, 1),
		Selectable = true
	})
end

return MarketplaceAssetTile
