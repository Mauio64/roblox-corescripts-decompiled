local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)

require(AvatarExperienceInspectAndBuy.Types)

local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local Constants = require(AvatarExperienceInspectAndBuy.Constants)
local AssetLocalizationKeys = Constants.AssetLocalizationKeys
local BundleLocalizationKeys = Constants.BundleLocalizationKeys
local PriceStatusLocalizationKeys = Constants.PriceStatusLocalizationKeys
local ItemDetailsLocalizationKeys = Constants.ItemDetailsLocalizationKeys
local Cryo = require(AvatarExperienceInspectAndBuyParent.Cryo)
local useLocalization = require(AvatarExperienceInspectAndBuyParent.Localization).Hooks.useLocalization

return function(p1) -- line: 17
	-- upvalues: React (copy), ItemTypeEnum (copy), BundleLocalizationKeys (copy), AssetLocalizationKeys (copy), Cryo (copy), PriceStatusLocalizationKeys (copy), ItemDetailsLocalizationKeys (copy), useLocalization (copy)
	local v14 = React.useMemo(function() -- line: 18
		-- upvalues: p1 (copy), ItemTypeEnum (copy), BundleLocalizationKeys (copy), AssetLocalizationKeys (copy)
		if p1 and p1.itemType == ItemTypeEnum.Bundle then
			return BundleLocalizationKeys
		end

		return AssetLocalizationKeys
	end, { p1 })
	local v15 = React.useMemo(function() -- line: 22
		-- upvalues: Cryo (copy), v14 (copy), PriceStatusLocalizationKeys (copy), ItemDetailsLocalizationKeys (copy), p1 (copy)
		return Cryo.Dictionary.join(v14, PriceStatusLocalizationKeys, ItemDetailsLocalizationKeys, {
			ownedItems = {
				ItemDetailsLocalizationKeys.ownedItems,
				QUANTITY = (not p1 or not p1.collectibleItemDetails) and 0 or p1.collectibleItemDetails.resellableCount
			}
		})
	end, {
		v14,
		p1
	})

	return (useLocalization(v15))
end
