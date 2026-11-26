local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LoginStatus
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local module = require("@luauforge/bundled/hQI")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dAW").GetCountryCodeStore else nil

local function selectIsVN(p2): boolean
	return p2.CountryCode == "VN"
end

local function CheckForVngAppUpsell(p2)
	local v5

	if fFlagUseSignalsForAuthenticationStatus then
		local v6 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN

		local v7 = if fFlagUseSignalsForCountryCode then useSignalState(getCountryCodeStore(false).getCountryCode) == "VN" else useSelector(selectIsVN)
		v5 = v6 and v7
	elseif fFlagUseSignalsForCountryCode then
		local v6 = useSelector(function(p3): boolean
			return p3.AuthenticationStatus.status == loginStatus.LOGGED_IN
		end)

		local v7 = useSignalState(getCountryCodeStore(false).getCountryCode) == "VN"
		v5 = v6 and v7
	else
		v5 = useSelector(function(p3): boolean
			local countryCode = p3.CountryCode
			return p3.AuthenticationStatus.status == loginStatus.LOGGED_IN and countryCode == "VN"
		end)
	end

	local v6 = useAppPolicy(function(p3)
		return p3.getVngAppUpsell()
	end)

	if v5 and v6 then
		return React.createElement(module)
	end

	return nil
end

return CheckForVngAppUpsell
