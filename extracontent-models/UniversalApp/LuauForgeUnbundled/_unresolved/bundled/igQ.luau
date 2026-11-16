local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/fuD")
local module2 = require("@luauforge/bundled/dMx")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module4 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")

return function(p2, p3)
	local avatarEditorService = p3.avatarEditorService
	return performFetch.Single(module2.GetAvatarRulesKey, function(p4)
		return Promise.new(function(callback, callback2)
			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.GetAvatarRules,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
				)
			end

			local success, result = pcall(function()
				return avatarEditorService:GetAvatarRulesAsync()
			end)

			if success then
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetAvatarRules,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
					)
				end

				callback((module.tableToCamelCaseKeys(result)))
			else
				if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
					reportAvatarEventCounterNoAnalyticsArgument(module4.Counter.AvatarEditorServiceErrors.GetAvatarRules)
				end

				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetAvatarRules,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
						result
					)
				end

				logging.warn("WebApi failure in GetAvatarRules")
				callback2({ HttpError = Enum.HttpError.OK })
			end
		end)
	end)(p2)
end
