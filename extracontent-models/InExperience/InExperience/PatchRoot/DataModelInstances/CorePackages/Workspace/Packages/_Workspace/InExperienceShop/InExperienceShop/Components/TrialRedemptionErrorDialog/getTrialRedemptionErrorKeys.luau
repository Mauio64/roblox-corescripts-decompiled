local v = {
	title = "Feature.InExperienceShop.GenericTransactionErrorTitle",
	body = "Feature.InExperienceShop.GenericTransactionErrorBody"
}

local v2 = {
	ActiveFreeTrialExists = {
		title = "Feature.InExperienceShop.Description.ActiveFreeTrialExistsTitle",
		body = "Feature.InExperienceShop.Description.ActiveFreeTrialExistsBody"
	},
	GamePassAlreadyOwned = {
		title = "Feature.InExperienceShop.Description.GamePassAlreadyOwnedTitle",
		body = "Feature.InExperienceShop.Description.GamePassAlreadyOwnedBody"
	},
	FreeTrialAlreadyRedeemed = {
		title = "Feature.InExperienceShop.Description.FreeTrialAlreadyRedeemedTitle",
		body = "Feature.InExperienceShop.Description.FreeTrialAlreadyRedeemedBody"
	},
	GamePassTrialNotEnabled = {
		title = "Feature.InExperienceShop.Description.GamePassTrialNotEnabledTitle",
		body = "Feature.InExperienceShop.Description.GamePassTrialNotEnabledBody"
	},
	GamePassNotPurchasable = {
		title = "Feature.InExperienceShop.Description.GamePassNotPurchasableTitle",
		body = "Feature.InExperienceShop.Description.GamePassNotPurchasableBody"
	},
	GamePassNotInUniverse = {
		title = "Feature.InExperienceShop.Description.GamePassNotInUniverseTitle",
		body = "Feature.InExperienceShop.Description.GamePassNotInUniverseBody"
	}
}

local function getTrialRedemptionErrorKeys(p: string?)
	if p == nil then
		return v
	end

	return v2[p] or v
end

return getTrialRedemptionErrorKeys
