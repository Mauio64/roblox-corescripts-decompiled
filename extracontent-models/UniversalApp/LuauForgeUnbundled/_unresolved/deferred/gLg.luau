local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")

local module2 = require("@luauforge/bundled/dPU")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module3 = require("@luauforge/bundled/egt")

local module4 = require("@luauforge/bundled/dST")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module6 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local function keyMapper(p2)
	return module2.SetFavoriteAssetKey .. p2
end

return function(p2, p3)
	module.isType(p2, "string", "SetAssetFavorite thunk expects assetId")
	module.isType(p3, "boolean", "SetAssetFavorite thunk expects isFavorited")

	return function(p4, p5)
		local avatarEditorService = p5.avatarEditorService
		return performFetch.Single(module2.SetFavoriteAssetKey .. p2, function(object)
			return Promise.new(function(callback, callback2)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSetFavorite,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local v6 = avatarEditorService:NoPromptSetFavorite(p2, Enum.AvatarItemType.Asset, p3)

				while not v6 do
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
						)
					end

					avatarEditorService.PromptSetFavoriteCompleted:Wait()

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					v6 = avatarEditorService:NoPromptSetFavorite(p2, Enum.AvatarItemType.Asset, p3)

					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module6.Counter.AvatarEditorServiceErrors.NoPromptSetFavorite)
					end
				end

				local v7 = avatarEditorService.PromptSetFavoriteCompleted:Wait()

				if v7 == Enum.AvatarPromptResult.Success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					object:dispatch(module4(p2, p3))
					callback()
				else
					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module6.Counter.AvatarEditorServiceErrors.SetAssetFavorite)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSetFavorite,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							v7
						)
					end

					object:dispatch(module3({ HttpError = Enum.HttpError.OK }))
					callback2()
				end
			end)
		end)(p4)
	end
end
