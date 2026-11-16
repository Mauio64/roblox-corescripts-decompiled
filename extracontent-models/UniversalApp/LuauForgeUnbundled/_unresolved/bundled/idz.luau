local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/gxt")
local module2 = require("@luauforge/bundled/gey")
local module3 = require("@luauforge/bundled/idc")
local module4 = require("@luauforge/bundled/gxq")
local module5 = require("@luauforge/bundled/fBQ")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableUserAccessServiceIntegration = SharedFlags.FFlagEnableUserAccessServiceIntegration
local fFlagCheckUserModerationAfterLogin = SharedFlags.FFlagCheckUserModerationAfterLogin
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local fFlagUseSignalsForModeration = SharedFlags.FFlagUseSignalsForModeration
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/bundled/fQv").GetModerationStore else nil

return function(p2, p3)
	return function(object)
		local v5

		if fFlagUseSignalsForModeration then
			v5 = getModerationStore(false).getUserModerated(false) or false
		else
			local moderation = object:getState().Moderation
			v5 = moderation and moderation.userModerated or false
		end

		if v5 then
			return
		end

		if fFlagCheckUserModerationAfterLogin then
			local v6

			if fFlagUseSignalsForAuthenticationStatus then
				v6 = getAuthenticationStatusStore(false).getStatus(false)
			else
				v6 = object:getState().AuthenticationStatus.status
			end

			if v6 ~= module5.LOGGED_IN then
				return
			end
		end

		if module3(p3) then
			logging.warn("The user is moderated.")

			if fFlagUseSignalsForModeration then
				getModerationStore(false).setModerationStatus(true)
			else
				object:dispatch(module2(true))
			end

			if fFlagEnableUserAccessServiceIntegration then
				object:dispatch(module4(p2))
			else
				object:dispatch(module(p2))
			end
		end
	end
end
