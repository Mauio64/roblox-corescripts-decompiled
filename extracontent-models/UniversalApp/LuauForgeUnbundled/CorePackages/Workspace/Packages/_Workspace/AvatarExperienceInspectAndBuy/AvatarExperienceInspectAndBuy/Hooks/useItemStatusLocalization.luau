local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Constants")
local assetLocalizationKeys = Constants.AssetLocalizationKeys
local bundleLocalizationKeys = Constants.BundleLocalizationKeys
local priceStatusLocalizationKeys = Constants.PriceStatusLocalizationKeys
local itemDetailsLocalizationKeys = Constants.ItemDetailsLocalizationKeys
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Cryo")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Localization").Hooks.useLocalization

return function(p2)
	local v5 = React.useMemo(function()
		if p2 and p2.itemType == itemTypeEnum.Bundle then
			return bundleLocalizationKeys
		end

		return assetLocalizationKeys
	end, { p2 })

	return (useLocalization((React.useMemo(function()
		return Cryo.Dictionary.join(v5, priceStatusLocalizationKeys, itemDetailsLocalizationKeys, {
			ownedItems = {
				itemDetailsLocalizationKeys.ownedItems,
				QUANTITY = not (p2 and p2.collectibleItemDetails) and 0 or p2.collectibleItemDetails.resellableCount
			}
		})
	end, { v5, p2 }))))
end
