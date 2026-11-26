local AvatarEditorService = game:GetService("AvatarEditorService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/LuauPolyfill")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceAnalytics")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceFlags")
local buildProfileConfigurationApplyConfig = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Requests/buildProfileConfigurationApplyConfig")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_ERRORS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_ERRORS
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local function saveProfileConfiguration(p2)
	return Promise.new(function(callback, callback2)
		local v5

		if AvatarExperienceFlags.FFlagAXProfileConfigurationMultiFieldApply then
			v5 = buildProfileConfigurationApplyConfig(p2)
		else
			v5 = { BackgroundAssetId = p2 }
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
			)
		end

		local v6 = AvatarEditorService:NoPromptApplyProfileConfiguration(v5)

		while not v6 do
			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
				)
			end

			AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

			if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(AVATAR_EDITOR_SERVICE_ERRORS.NoPromptApplyProfileConfiguration)
			end

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
				)
			end

			v6 = AvatarEditorService:NoPromptApplyProfileConfiguration(v5)
		end

		local v7 = AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

		if v7 == Enum.AvatarPromptResult.Success then
			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
				)
			end

			callback({ avatarPromptResult = v7 })
		else
			if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(AVATAR_EDITOR_SERVICE_ERRORS.PromptApplyProfileConfigurationCompleted)
			end

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
					v7
				)
			end

			callback2({ avatarPromptResult = v7 })
		end
	end)
end

return saveProfileConfiguration
