local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").PerformFetch
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/ToastRodux")

local AVATAR_EDITOR_CONSTANTS = AvatarExperienceCommon.Constants.AVATAR_EDITOR_CONSTANTS
local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local constants = AvatarExperienceAnalytics.Constants
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local getGearAssetIdFromState = AvatarExperienceCommon.Utils.getGearAssetIdFromState

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local fIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local v5 = {
	toastMessage = "Feature.Avatar.Message.InvalidName",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.ReachedMaxOutfits",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local v7 = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingOutfit",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

return function(p2, callback, p3, callback2)
	return function(p4, p5)
		local avatarEditorService = p5.avatarEditorService
		return performFetch.Single(AVATAR_EDITOR_CONSTANTS.CreateOutfitKey, function(object)
			local state = object:getState()
			local avatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
			local v8 = Enum.HumanoidRigType[avatarType]

			local gearAssetIdFromState = getGearAssetIdFromState(state.AvatarExperience)

			local v9 = callback(state, p3)

			task.spawn(function()
				task.wait(fIntAXLookOutfitCreationDelayMs / 1000)

				Promise.new(function(callback3, callback4)
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					local v10 = avatarEditorService:NoPromptCreateOutfit(v9, v8, p2, gearAssetIdFromState)

					while not v10 do
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
							)
						end

						avatarEditorService.PromptCreateOutfitCompleted:Wait()

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
							)
						end

						v10 = avatarEditorService:NoPromptCreateOutfit(v9, v8, p2, 0)

						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(constants.AVATAR_EDITOR_SERVICE_ERRORS.NoPromptCreateOutfit)
						end
					end

					local v11, v12 = avatarEditorService.PromptCreateOutfitCompleted:Wait()

					if v11 == Enum.AvatarPromptResult.Success then
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXCreateCostume)

						callback2()

						callback3()
					else
						if v12 == Enum.CreateOutfitFailure.InvalidName then
							object:dispatch(setCurrentToastMessage(v5))
						elseif v12 == Enum.CreateOutfitFailure.OutfitLimitReached then
							object:dispatch(setCurrentToastMessage(v6))
						elseif v12 == Enum.CreateOutfitFailure.Other then
							object:dispatch(setCurrentToastMessage(v7))
						end

						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(constants.AVATAR_EDITOR_SERVICE_ERRORS.CreateOutfit)
						end

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								constants.AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								v12 or v11
							)
						end

						callback4()
					end
				end)
			end)

			return Promise.resolve()
		end)(p4):catch(function(p6) end)
	end
end
