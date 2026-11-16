require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")

local function isUsableOffer(offer)
	local v5

	if
		typeof(offer) == "table"
		and (offer.campaignOption == "feedback" or offer.campaignOption == "plays")
		and (offer.fundingType == "free" or offer.fundingType == "paid")
		and typeof(offer.durationDays) == "number"
		and offer.durationDays % 1 == 0
		and offer.durationDays > 0
		and typeof(offer.priceRobux) == "number"
		and offer.priceRobux % 1 == 0
		and offer.priceRobux >= 0
	then
		v5 = offer.fundingType == "free" or offer.priceRobux > 0
	else
		v5 = false
	end

	return v5
end

local function getSelectableOffers(p2)
	if p2 == nil or typeof(p2.offers) ~= "table" then
		return nil
	end

	local v5 = nil
	local v6 = nil

	for k, offer in p2.offers do
		local v7 = isUsableOffer(offer)

		if v7 then
			v7 = offer.fundingType == "paid" or offer.fundingType == "free" and p2.freeCreditsRemaining > 0
		end

		if v7 and offer.campaignOption == "feedback" then
			v5 = offer
		elseif v7 and offer.campaignOption == "plays" then
			v6 = offer
		end
	end

	if v5 == nil and v6 == nil then
		return nil
	end

	return { feedback = v5, plays = v6 }
end

local function isEligibleForFreePromotion(data): boolean
	if data == nil or data.userEligible ~= true or data.universeEligible ~= true then
		return false
	end

	if not FFlagEnablePaidAds then
		return data.cardType == "promote_free"
	end

	if typeof(data.offers) ~= "table" then
		return false
	end

	for k, offer in data.offers do
		if isUsableOffer(offer) and offer.fundingType == "free" then
			return true
		end
	end

	return false
end

return {
	getDefaultOffer = function(p2)
		if p2.feedback ~= nil and p2.feedback.fundingType == "free" then
			return p2.feedback
		end

		if p2.plays == nil or p2.plays.fundingType ~= "free" then
			return p2.feedback or p2.plays
		end

		return p2.plays
	end,
	isEligibleForFreePromotion = isEligibleForFreePromotion,
	freeCreditsRemaining = function(p2)
		if p2 == nil then
			return 0
		end

		return p2.freeCreditsRemaining
	end,
	hasFreeCredit = function(p2): boolean
		return (p2 == nil and 0 or p2.freeCreditsRemaining) > 0
	end,
	hasUsableOffer = function(p2): boolean
		if FFlagEnablePaidAds then
			return getSelectableOffers(p2) ~= nil
		end

		local offer = if p2 ~= nil then p2.offer else nil
		return offer ~= nil and offer.durationDays > 0
	end,
	getSelectableOffers = getSelectableOffers,
	canCreateCampaign = function(data)
		if data == nil or data.userEligible ~= true or data.universeEligible ~= true then
			return false
		end

		if FFlagEnablePaidAds then
			return getSelectableOffers(data) ~= nil
		end

		local v5 = isEligibleForFreePromotion(data) and (data == nil and 0 or data.freeCreditsRemaining) > 0

		if not v5 then
			return v5
		end

		if FFlagEnablePaidAds then
			return getSelectableOffers(data) ~= nil
		end

		local offer = if data ~= nil then data.offer else nil
		v5 = not (offer == nil) and offer.durationDays > 0
		return v5
	end,
	campaignSheetTerms = function(p2, p3)
		local offer = if p2 ~= nil then p2.offer else nil

		local v6 = if offer ~= nil then offer.durationDays else nil
		local v7 = if offer ~= nil then offer.displayAmountRobux else nil
		local v8 = if FFlagEnablePaidAds then getSelectableOffers(p2) else nil
		return {
			runStartMs = p3,
			durationDays = v6,
			estimatedPriceRobux = v7,
			campaignOffers = v8
		}
	end
}
