local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module2 = require("@luauforge/bundled/dME")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/dPB")
require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")

local function keyMapper(p2)
	return module2.GetFavoriteBundleKey .. p2
end

return function(p2)
	module.isType(p2, "string", "GetBundleFavorite thunk expects bundleId")

	return function(p3, p4)
		local avatarEditorService = p4.avatarEditorService
		return performFetch.Single(module2.GetFavoriteBundleKey .. p2, function(object)
			return Promise.new(function(callback, callback2)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetFavorite,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local success, result = pcall(function()
					return avatarEditorService:GetFavoriteAsync(p2, Enum.AvatarItemType.Bundle)
				end)

				if success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					object:dispatch(module5(p2, result))
					callback()
				else
					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module4.Counter.AvatarEditorServiceErrors.GetBundleFavorite)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							result
						)
					end

					logging.warn("GetBundleFavorite failure: " .. tostring(result))
					callback2()
				end
			end)
		end)(p3)
	end
end
