local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local Promise = require(parent.Promise)
local ToastRodux = require(parent.ToastRodux)

local AVATAR_EDITOR_CONSTANTS = AvatarExperienceCommon.Constants.AVATAR_EDITOR_CONSTANTS
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local Constants = AvatarExperienceAnalytics.Constants
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local getGearAssetIdFromState = AvatarExperienceCommon.Utils.getGearAssetIdFromState

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local FIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local FFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local FFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local v = {
	toastMessage = "Feature.Avatar.Message.InvalidName",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local v2 = {
	toastMessage = "Feature.Avatar.Message.ReachedMaxOutfits",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local v3 = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingOutfit",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p: string, callback, p2, callback2)
	return function(p3, p4)
		local avatarEditorService = p4.avatarEditorService
		return PerformFetch.Single(AVATAR_EDITOR_CONSTANTS.CreateOutfitKey, function(object)
			local state = object:getState()
			local avatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
			local v4 = Enum.HumanoidRigType[avatarType]

			local gearAssetIdFromState = getGearAssetIdFromState(state.AvatarExperience)

			local v5 = callback(state, p2)

			task.spawn(function()
				task.wait(FIntAXLookOutfitCreationDelayMs / 1000)

				Promise.new(function(callback3, callback4)
					if FFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							Constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					local v6 = avatarEditorService:NoPromptCreateOutfit(v5, v4, p, gearAssetIdFromState)

					while not v6 do
						if FFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								Constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
							)
						end

						avatarEditorService.PromptCreateOutfitCompleted:Wait()

						if FFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								Constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
							)
						end

						v6 = avatarEditorService:NoPromptCreateOutfit(v5, v4, p, 0)

						if not FFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(Constants.AVATAR_EDITOR_SERVICE_ERRORS.NoPromptCreateOutfit)
						end
					end

					local v7, v8 = avatarEditorService.PromptCreateOutfitCompleted:Wait()

					if v7 == Enum.AvatarPromptResult.Success then
						if FFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								Constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXCreateCostume)

						callback2()

						callback3()
					else
						if v8 == Enum.CreateOutfitFailure.InvalidName then
							object:dispatch(SetCurrentToastMessage(v))
						elseif v8 == Enum.CreateOutfitFailure.OutfitLimitReached then
							object:dispatch(SetCurrentToastMessage(v2))
						elseif v8 == Enum.CreateOutfitFailure.Other then
							object:dispatch(SetCurrentToastMessage(v3))
						end

						if not FFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(Constants.AVATAR_EDITOR_SERVICE_ERRORS.CreateOutfit)
						end

						if FFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								Constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								v8 or v7
							)
						end

						callback4()
					end
				end)
			end)

			return Promise.resolve()
		end)(p3):catch(function(_) end)
	end
end
