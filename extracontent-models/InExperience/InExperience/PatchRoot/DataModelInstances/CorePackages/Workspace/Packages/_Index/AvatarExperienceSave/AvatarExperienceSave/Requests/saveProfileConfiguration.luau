local AvatarEditorService = game:GetService("AvatarEditorService")
local parent = script:FindFirstAncestor("AvatarExperienceSave").Parent

local Promise = require(parent.Promise)
require(parent.LuauPolyfill)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local buildProfileConfigurationApplyConfig = require(script.Parent.buildProfileConfigurationApplyConfig)

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_ERRORS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_ERRORS
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local FFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local FFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local function saveProfileConfiguration(backgroundAssetId)
	return Promise.new(function(callback, callback2)
		local v

		if AvatarExperienceFlags.FFlagAXProfileConfigurationMultiFieldApply then
			v = buildProfileConfigurationApplyConfig(backgroundAssetId)
		else
			v = { BackgroundAssetId = backgroundAssetId }
		end

		if FFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
			)
		end

		local v2 = AvatarEditorService:NoPromptApplyProfileConfiguration(v)

		while not v2 do
			if FFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
				)
			end

			AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

			if not FFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(AVATAR_EDITOR_SERVICE_ERRORS.NoPromptApplyProfileConfiguration)
			end

			if FFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
				)
			end

			v2 = AvatarEditorService:NoPromptApplyProfileConfiguration(v)
		end

		local avatarPromptResult = AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

		if avatarPromptResult == Enum.AvatarPromptResult.Success then
			if FFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
				)
			end

			callback({ avatarPromptResult = avatarPromptResult })
		else
			if not FFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(AVATAR_EDITOR_SERVICE_ERRORS.PromptApplyProfileConfigurationCompleted)
			end

			if FFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
					avatarPromptResult
				)
			end

			callback2({ avatarPromptResult = avatarPromptResult })
		end
	end)
end

return saveProfileConfiguration
