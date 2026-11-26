local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
local CampaignLocalizations = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/CampaignLocalizations")

local fFlagSubscriptionSheetCampaignLocalizations = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagSubscriptionSheetCampaignLocalizations

local v5 = {
	["Feature.RobloxSubscription.Heading.TTGrant"] = "Lorem ipsum dolor sit amet",
	["Feature.RobloxSubscription.Description.TTGrant"] = "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
	["Feature.RobloxSubscription.Action.TTClaim"] = "Lorem ipsum",
	["Feature.RobloxSubscription.Label.TTBenefitCustomize"] = "Lorem ipsum dolor",
	["Feature.RobloxSubscription.Label.TTBenefitDiscount"] = "Sit amet consectetur",
	["Feature.RobloxSubscription.Label.TTBenefitPrivateServer"] = "Adipiscing elit sed",
	["Feature.RobloxSubscription.Label.TTBenefitRobux"] = "Eiusmod tempor incididunt"
}

local v6 = {}

local function usePlaceholderLocalization(items)
	local v7

	if fFlagSubscriptionSheetCampaignLocalizations then
		v7 = SignalsReact.useSignalState(CampaignLocalizations.getCampaignLocalizations)
	else
		v7 = v6
	end

	return React.useMemo(function()
		local result = {}

		for k, item in items do
			local v8 = v7[item]

			if fFlagSubscriptionSheetCampaignLocalizations and v8 then
				result[k] = v8
			else
				result[k] = v5[item] or item
			end
		end

		return result
	end, { items, v7 })
end

return usePlaceholderLocalization
