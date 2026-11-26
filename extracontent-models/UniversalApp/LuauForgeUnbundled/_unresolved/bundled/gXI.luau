local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/dFs")

local module2 = require("@luauforge/bundled/egs")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module3 = require("@luauforge/bundled/gXJ")
local module4 = require("@luauforge/bundled/gXK")
local module5 = require("@luauforge/bundled/gXL")
local tutils = require(CorePackages.Packages.tutils)
local module6 = require("@luauforge/bundled/gJe")

local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/bundled/guU").GetModerationStore else nil

return function(p2)
	return performFetch.Single(
		"luaapp.usermoderationapi.UserModeration.get_v1_not_approved",
		function(object)
			return module4(p2):andThen(function(p3)
				local responseBody = p3.responseBody
				logging.warn("The user is moderated with type: `" .. tostring(responseBody.punishmentTypeDescription) .. "`")
				logging.warn("Verification category is: `" .. tostring(responseBody.verificationCategory) .. "`")

				if responseBody.punishmentTypeDescription == nil then
					if fFlagUseSignalsForModeration then
						getModerationStore(false).setModerationStatus(false)
					else
						object:dispatch(module6(false))
					end

					return module2.resolve()
				else
					local v5 = module3.fromJsonData(responseBody)

					local unwrapped, v6 = v5:unwrap()

					if unwrapped == false then
						logging.warn("Failed to parse moderation detail.")
						module("(Moderation) Failed to parse moderation detail. Data: " .. tutils.toString(responseBody))
						return module2.reject(p3)
					end

					if fFlagUseSignalsForModeration then
						getModerationStore(false).setModerationDetail(v6)
					else
						object:dispatch(module5(v6))
					end

					return module2.resolve(v5)
				end
			end, function(p3)
				logging.warn("Failed to get moderation detail: ")
				logging.warn(tutils.print(p3))
				module("(Moderation) Failed to get moderation detail: " .. tutils.toString(p3))
				return module2.reject(p3)
			end)
		end
	)
end
