local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dPN")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local applyProfileConfiguration = require("@luauforge/bundled/dKU").Actions.ApplyProfileConfiguration
require("@luauforge/bundled/dKT")
require("@luauforge/bundled/AK")

return function(p2, p3)
	local players = p3.players or Players
	return performFetch.Single("avatareditor.getprofileconfiguration", function(object)
		return Promise.new(function(callback, callback2)
			local userId = players.LocalPlayer and players.LocalPlayer.UserId

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.GetProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
				)
			end

			local success, result = pcall(function()
				return players:GetProfileConfigurationFromUserIdAsync(userId)
			end)

			if success and result then
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetProfileConfiguration,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
					)
				end

				object:dispatch(applyProfileConfiguration({
					BackgroundAssetId = result.BackgroundAssetId
				}))
				callback(result)
			else
				if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
					reportAvatarEventCounterNoAnalyticsArgument(module.Counter.AvatarEditorServiceErrors.GetProfileConfiguration)
				end

				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetProfileConfiguration,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
						result
					)
				end

				logging.warn("WebApi failure in GetProfileConfiguration")
				callback2({ HttpError = Enum.HttpError.OK })
			end
		end)
	end)(p2)
end
