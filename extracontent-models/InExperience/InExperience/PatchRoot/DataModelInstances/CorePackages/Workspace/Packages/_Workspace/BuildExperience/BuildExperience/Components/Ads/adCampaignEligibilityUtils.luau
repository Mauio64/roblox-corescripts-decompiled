local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.AdCampaignEligibility)
require(parent.DataHydration.CreatorAgentChat)
local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)

local function isUsableOffer(offer): boolean
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
		return offer.fundingType == "free" or offer.priceRobux > 0
	end

	return false
end

local function getSelectableOffers(p)
	if p == nil or typeof(p.offers) ~= "table" then
		return nil
	end

	local feedback = nil
	local plays = nil

	for _, offer in p.offers do
		local v = isUsableOffer(offer)

		if v then
			if offer.fundingType == "paid" then
				v = true
			elseif offer.fundingType == "free" then
				v = p.freeCreditsRemaining > 0
			else
				v = false
			end
		end

		if v and offer.campaignOption == "feedback" then
			feedback = offer
		elseif v and offer.campaignOption == "plays" then
			plays = offer
		end
	end

	if feedback == nil and plays == nil then
		return nil
	end

	return { feedback = feedback, plays = plays }
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

	for _, offer in data.offers do
		if isUsableOffer(offer) and offer.fundingType == "free" then
			return true
		end
	end

	return false
end

local function freeCreditsRemaining(p) -- 1 equivalent call inferred from this helper
	return if p == nil then 0 else p.freeCreditsRemaining
end

local function hasFreeCredit(data): boolean -- 1 equivalent call inferred from this helper
	return freeCreditsRemaining(data) > 0 -- inferred equivalent call
end

local AdCampaignEligibilityUtils = {}

function AdCampaignEligibilityUtils.getDefaultOffer(p)
	if p.feedback ~= nil and p.feedback.fundingType == "free" then
		return p.feedback
	end

	if p.plays == nil or p.plays.fundingType ~= "free" then
		return p.feedback or p.plays
	end

	return p.plays
end

AdCampaignEligibilityUtils.isEligibleForFreePromotion = isEligibleForFreePromotion
AdCampaignEligibilityUtils.freeCreditsRemaining = freeCreditsRemaining
AdCampaignEligibilityUtils.hasFreeCredit = hasFreeCredit

function AdCampaignEligibilityUtils.hasUsableOffer(p): boolean
	if FFlagEnablePaidAds then
		return getSelectableOffers(p) ~= nil
	end

	local offer

	if p ~= nil then
		offer = p.offer
	end

	return offer ~= nil and offer.durationDays > 0
end

AdCampaignEligibilityUtils.getSelectableOffers = getSelectableOffers

function AdCampaignEligibilityUtils.canCreateCampaign(data)
	if data == nil or data.userEligible ~= true or data.universeEligible ~= true then
		return false
	end

	if FFlagEnablePaidAds then
		return getSelectableOffers(data) ~= nil
	end

	local v = isEligibleForFreePromotion(data) and hasFreeCredit(data) -- inferred equivalent call

	if not v then
		return v
	end

	if FFlagEnablePaidAds then
		return getSelectableOffers(data) ~= nil
	end

	local offer

	if data ~= nil then
		offer = data.offer
	end

	return offer ~= nil and offer.durationDays > 0
end

function AdCampaignEligibilityUtils.campaignSheetTerms(p, runStartMs: number)
	local offer

	if p ~= nil then
		offer = p.offer
	end

	local durationDays

	if offer ~= nil then
		durationDays = offer.durationDays
	end

	local estimatedPriceRobux

	if offer ~= nil then
		estimatedPriceRobux = offer.displayAmountRobux
	end

	local campaignOffers

	if FFlagEnablePaidAds then
		campaignOffers = getSelectableOffers(p)
	end

	return {
		runStartMs = runStartMs,
		durationDays = durationDays,
		estimatedPriceRobux = estimatedPriceRobux,
		campaignOffers = campaignOffers
	}
end

return AdCampaignEligibilityUtils
