local CorePackages = game:GetService("CorePackages")
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local RobloxSubscriptionPurchaseApp = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp)

local function useShowRobloxPlusThemeSetting() -- line: 12
	-- upvalues: useAppPolicy (copy), RobloxSubscriptionPurchaseApp (copy), useSignalState (copy)
	local v6 = useAppPolicy(function(p1) -- line: 13
		local getAccountType = p1.getAccountType

		if getAccountType then
			return (getAccountType())
		end

		return nil
	end)
	local v7 = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals.get()

	return useSignalState(v7.getHasRobloxSubscription) == true and v6 ~= "Kids"
end

return useShowRobloxPlusThemeSetting
