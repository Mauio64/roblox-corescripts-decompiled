local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
require(AvatarExperienceInspectAndBuy.Types)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local Constants = require(AvatarExperienceInspectAndBuy.Constants)
local AssetLocalizationKeys = Constants.AssetLocalizationKeys
local BundleLocalizationKeys = Constants.BundleLocalizationKeys
local PriceStatusLocalizationKeys = Constants.PriceStatusLocalizationKeys
local ItemDetailsLocalizationKeys = Constants.ItemDetailsLocalizationKeys
local Cryo = require(parent.Cryo)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

return function(p)
	local v = React.useMemo(function()
		if p and p.itemType == ItemTypeEnum.Bundle then
			return BundleLocalizationKeys
		end

		return AssetLocalizationKeys
	end, { p })

	return (useLocalization((React.useMemo(function()
		return Cryo.Dictionary.join(v, PriceStatusLocalizationKeys, ItemDetailsLocalizationKeys, {
			ownedItems = {
				ItemDetailsLocalizationKeys.ownedItems,
				QUANTITY = not (p and p.collectibleItemDetails) and 0 or p.collectibleItemDetails.resellableCount
			}
		})
	end, { v, p }))))
end
