local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module2 = require("@luauforge/bundled/dFm")
local module3 = require("@luauforge/bundled/dzE")
local module4 = require("@luauforge/bundled/fCW")
local module5 = require("@luauforge/bundled/dWC")
local module6 = require("@luauforge/bundled/dWB")
local module7 = require("@luauforge/bundled/fCV")
local module8 = require("@luauforge/bundled/dFs")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module10 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local v5 = {
	toastMessage = "Feature.Avatar.Message.FailedWritePPE",
	isLocalized = false,
	toastType = module3.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Label.PPEFinishedToast",
	isLocalized = false,
	toastType = module3.InformationMessage
}

return function(p2, p3, p4, p5, p6, p7)
	module.isType(p3, "userdata", "WritePPEConfig thunk expects thumbnailType to be a userdata")
	module.isTypeOrNil(p4, "string", "WritePPEConfig thunk expects emoteAssetId to be a string or nil")
	module.isType(p5, "number", "WritePPEConfig thunk expects cameraDistanceScale to be a number")
	module.isType(p6, "number", "WritePPEConfig thunk expects cameraYRotDeg to be a number")
	module.isType(p7, "number", "WritePPEConfig thunk expects fieldOfViewDeg to be a number")

	local ppeConfigWriteStatusKey = module4.PPEConfigWriteStatusKeys[p3]
	return function(p8, p9)
		local avatarEditorService = p9.avatarEditorService
		return performFetch.Single(ppeConfigWriteStatusKey, function(object)
			if p3 == module5.Closeup then
				p2.clickFinalSave(p3, p5 == 1 and p6 == 0, p4)
			end

			return Promise.new(function(callback, p10)
				local v7 = p4 and tonumber(p4) or 0
				local convertThumbnailTypeToEnum = module7.ConvertThumbnailTypeToEnum(p3)

				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatarThumbnailCustomization,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local v8 = avatarEditorService:NoPromptSaveAvatarThumbnailCustomization(
					convertThumbnailTypeToEnum,
					v7,
					p5,
					p6,
					p7
				)

				while not v8 do
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatarThumbnailCustomization,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
						)
					end

					avatarEditorService.PromptSaveAvatarThumbnailCustomizationCompleted:Wait()

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatarThumbnailCustomization,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					v8 = avatarEditorService:NoPromptSaveAvatarThumbnailCustomization(
						convertThumbnailTypeToEnum,
						v7,
						p5,
						p6,
						p7
					)
				end

				local v9, v10 = avatarEditorService.PromptSaveAvatarThumbnailCustomizationCompleted:Wait()

				if v9 == Enum.AvatarPromptResult.Success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatarThumbnailCustomization,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					if p3 == module5.Closeup then
						object:dispatch(module2(v6))
					end

					object:dispatch(module6(p3))
					callback()
				else
					if tostring(v10) ~= tostring(Enum.SaveAvatarThumbnailCustomizationFailure.Other) then
						module8(string.format(
							"Call to AvatarEditorService:NoPromptSaveAvatarThumbnailCustomization failed with error code \"%s\"",
							(tostring(v10))
						))
					end

					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.NoPromptSaveAvatarThumbnailCustomization)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatarThumbnailCustomization,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							v10 or v9
						)
					end

					object:dispatch(module2(v5))
					logging.warn("WebApi failure in WritePPEConfig")
				end
			end)
		end)(p8)
	end
end
