local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/gxr")
local tutils = require(CorePackages.Packages.tutils)
local module3 = require("@luauforge/bundled/gey")
local module4 = require("@luauforge/bundled/gxs")

local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/bundled/fQv").GetModerationStore else nil

local module5 = require("@luauforge/bundled/gxt")
local module6 = require("@luauforge/bundled/gxx")
local module7 = require("@luauforge/bundled/fDK")
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess

local getUserAccessStore = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/fDT").GetUserAccessStore else nil

return function(p2)
	return performFetch.Single(
		"luaapp.usermoderationapi.UserModeration.get_v2_not_approved",
		function(object)
			return module2(p2):andThen(function(p3)
				local responseBody = p3.responseBody

				local unwrapped, v5 = module6.fromJsonData(responseBody):unwrap()

				if unwrapped == false then
					logging.warn("Failed to parse Use detail. Data: " .. tutils.toString(responseBody))
					return module.reject(p3)
				end

				if v5.restriction == nil then
					if fFlagUseSignalsForModeration then
						getModerationStore(false).setModerationStatus(false)
					else
						object:dispatch(module3(false))
					end

					if fFlagUseSignalsForUserAccess then
						getUserAccessStore(false).setUserAccessRestrictionDetail(nil)
					else
						object:dispatch(module4(nil))
					end

					return module.resolve(nil)
				end

				if fFlagUseSignalsForUserAccess then
					getUserAccessStore(false).setUserAccessRestrictionDetail(v5.restriction)
				else
					object:dispatch(module4(v5.restriction))
				end

				if v5.restriction.source == module7.Moderation then
					object:dispatch(module5(p2))
				end

				return module.resolve(v5.restriction)
			end, function(p3)
				logging.warn(tutils.print(p3))
				return module.reject(p3)
			end)
		end
	)
end
