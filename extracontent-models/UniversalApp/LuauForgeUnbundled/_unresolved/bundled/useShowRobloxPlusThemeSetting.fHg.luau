local CorePackages = game:GetService("CorePackages")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module = require("@luauforge/bundled/fHh")

local function useShowRobloxPlusThemeSetting()
	local v5 = useAppPolicy(function(p2)
		local getAccountType = p2.getAccountType

		if getAccountType then
			return (getAccountType())
		end

		return nil
	end)

	local v7 = useSignalState(module.RobloxSubscriptionSignals.get().getHasRobloxSubscription)
	local v8 = v5 == "Kids"
	return {
		isRobloxPlusUpsellEligible = not v8,
		hasRobloxPlusSubscription = v7 == true,
		canSeeExclusiveThemes = not v8
	}
end

return useShowRobloxPlusThemeSetting
