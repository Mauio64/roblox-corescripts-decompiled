local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local CampaignLocalizations = require(RobloxSubscriptionPurchaseApp.Store.CampaignLocalizations)

local SharedFlags = require(parent.SharedFlags)
local FFlagSubscriptionSheetCampaignLocalizations = SharedFlags.FFlagSubscriptionSheetCampaignLocalizations

local v = {
	["Feature.RobloxSubscription.Heading.TTGrant"] = "Lorem ipsum dolor sit amet",
	["Feature.RobloxSubscription.Description.TTGrant"] = "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
	["Feature.RobloxSubscription.Action.TTClaim"] = "Lorem ipsum",
	["Feature.RobloxSubscription.Label.TTBenefitCustomize"] = "Lorem ipsum dolor",
	["Feature.RobloxSubscription.Label.TTBenefitDiscount"] = "Sit amet consectetur",
	["Feature.RobloxSubscription.Label.TTBenefitPrivateServer"] = "Adipiscing elit sed",
	["Feature.RobloxSubscription.Label.TTBenefitRobux"] = "Eiusmod tempor incididunt"
}

local v2 = {}

local function usePlaceholderLocalization(items)
	local v3

	if FFlagSubscriptionSheetCampaignLocalizations then
		v3 = SignalsReact.useSignalState(CampaignLocalizations.getCampaignLocalizations)
	else
		v3 = v2
	end

	return React.useMemo(function()
		local result = {}

		for k, item in items do
			local v4 = v3[item]

			if FFlagSubscriptionSheetCampaignLocalizations and v4 then
				result[k] = v4
			else
				result[k] = v[item] or item
			end
		end

		return result
	end, { items, v3 })
end

return usePlaceholderLocalization
