local module = require("@luauforge/bundled/icF")
local module2 = require("@luauforge/bundled/icM")
local module3 = require("@luauforge/bundled/icP")

local fFlagSubscriptionSheetCampaignLocalizations = module3.Flags.FFlagSubscriptionSheetCampaignLocalizations

local v5 = {
	["Feature.RobloxSubscription.Heading.OnboardingLook"] = "Lorem ipsum dolor sit amet",
	["Feature.RobloxSubscription.Description.OnboardingLook"] = "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
	["Feature.RobloxSubscription.Label.AppThemes"] = "Lorem ipsum",
	["Feature.RobloxSubscription.Label.ProfileFrames"] = "Lorem ipsum dolor",
	["Feature.RobloxSubscription.Label.NoProfileFrame"] = "Sit amet",
	["Feature.RobloxSubscription.Action.TryAnotherLook"] = "Sit amet consectetur",
	["Feature.RobloxSubscription.Action.ResetLook"] = "Adipiscing elit"
}

local v6 = {}

local function usePlaceholderLocalization(items)
	local v7

	if fFlagSubscriptionSheetCampaignLocalizations then
		v7 = module2.useSignalState(module3.CampaignLocalizations.getCampaignLocalizations)
	else
		v7 = v6
	end

	return module.useMemo(function()
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
