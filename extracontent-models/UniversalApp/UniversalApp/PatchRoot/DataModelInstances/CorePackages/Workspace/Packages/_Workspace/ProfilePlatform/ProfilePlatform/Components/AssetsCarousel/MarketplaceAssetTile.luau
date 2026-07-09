local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local CatalogItemCard = require(ProfilePlatformParent.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(ProfilePlatformParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local UserLib = require(ProfilePlatformParent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)

local function MarketplaceAssetTile(t1: {[any]: any}) -- line: 46
	-- upvalues: useLocalization (copy), TextKeys (copy), Enums (copy), Constants (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy), React (copy), CatalogItemCard (copy), ItemCardThumbnail (copy), getRbxthumbWithTypeSizeAndOptions (copy)
	local v15 = useLocalization({
		free = TextKeys.CatalogLabelFree,
		offSale = TextKeys.CatalogLabelOffSale
	})
	local v16 = if t1.itemType ~= Enums.ItemTypes.Bundle then Constants.RbxthumbTypes.Asset else Constants.RbxthumbTypes.BundleThumbnail
	local v17 = nil

	if t1.isOffSale then
		v17 = if not FFlagProfilePlatformFixResaleLimitedPrice or (not t1.lowestResalePrice or not (t1.lowestResalePrice > 0)) then {
			type = Enums.PriceLineContentType.Text,
			text = v15.offSale
		} else {
			type = Enums.PriceLineContentType.Price,
			price = t1.lowestResalePrice
		}
	elseif t1.price == 0 then
		v17 = {
			type = Enums.PriceLineContentType.Text,
			text = v15.free
		}
	elseif t1.price then
		v17 = {
			type = Enums.PriceLineContentType.Price,
			price = t1.price
		}
	end

	return React.createElement(CatalogItemCard, {
		Selectable = true,
		title = t1.name,
		presentationSlot = React.createElement(ItemCardThumbnail, {
			url = getRbxthumbWithTypeSizeAndOptions(t1.assetId, v16, 150)
		}),
		onActivated = t1.onActivated,
		priceLineContent = v17,
		Size = UDim2.fromScale(1, 1)
	})
end

return MarketplaceAssetTile
