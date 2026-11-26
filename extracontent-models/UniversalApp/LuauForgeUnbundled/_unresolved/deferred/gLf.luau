local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/dzP")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module2 = require("@luauforge/bundled/dPU")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local module3 = require("@luauforge/bundled/dST")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module5 = require("@luauforge/bundled/dPN")
local function keyMapper(p2)
	return module2.GetFavoriteAssetKey .. p2
end

return function(p2)
	module.isType(p2, "string", "GetAssetFavorite thunk expects assetId")

	return function(p3, p4)
		local avatarEditorService = p4.avatarEditorService
		return performFetch.Single(module2.GetFavoriteAssetKey .. p2, function(object)
			return Promise.new(function(callback, callback2)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetFavorite,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local success, result = pcall(function()
					return avatarEditorService:GetFavoriteAsync(p2, Enum.AvatarItemType.Asset)
				end)

				if success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					object:dispatch(module3(p2, result))
					callback()
				else
					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module5.Counter.AvatarEditorServiceErrors.GetAssetFavorite)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							result
						)
					end

					logging.warn("GetAssetFavorite failure: " .. tostring(result))
					callback2()
				end
			end)
		end)(p3)
	end
end
