local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/egs")

local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module3 = require("@luauforge/deferred/gIx")
local getLocalUser = require("@luauforge/bundled/ciE").Thunks.GetLocalUser

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode
local getCountryCodeStore

if fFlagUseSignalsForCountryCode then
	getCountryCodeStore = require("@luauforge/bundled/dAW").GetCountryCodeStore
else
	getCountryCodeStore = nil
end

local fFlagUseSignalsForIsLocalUserUnder13 = SharedFlags.FFlagUseSignalsForIsLocalUserUnder13
local getIsLocalUserUnder13Store

if fFlagUseSignalsForIsLocalUserUnder13 then
	getIsLocalUserUnder13Store = require("@luauforge/bundled/ciE").Stores.GetIsLocalUserUnder13Store
else
	getIsLocalUserUnder13Store = nil
end

return function(p2)
	return function(object)
		local state = object:getState()
		local user = state.Users[state.LocalUserId]
		local v5

		if fFlagUseSignalsForIsLocalUserUnder13 then
			v5 = getIsLocalUserUnder13Store(false).getIsLocalUserUnder13(false)
		else
			v5 = state.IsLocalUserUnder13
		end

		local v6

		if fFlagUseSignalsForCountryCode then
			v6 = getCountryCodeStore(false).getCountryCode(false)
		else
			v6 = state.CountryCode
		end

		return module3(p2):andThen(function(p3)
			local v7 = if fFlagEnableBlackbirdCheck then user.hasRobloxSubscription else nil

			local v8 = Models.new(
				user.id,
				p3.responseBody.name,
				user.membership.Value,
				v5,
				v6,
				p3.responseBody.displayName,
				v7
			)

			v8:setToLocalPlayer()
			v8:setToLocalStorage()
			object:dispatch(getLocalUser())
			return module.resolve()
		end, function(p3)
			logging.warn("Failed to update local user info")
			return module.reject(p3)
		end)
	end
end
