local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module = require("@luauforge/bundled/dzP")
local Promise = require(CorePackages.Packages.Promise)
local module2 = require("@luauforge/bundled/dRg")
local module3 = require("@luauforge/bundled/fCe")
local module4 = require("@luauforge/bundled/dFm")
local module5 = require("@luauforge/bundled/dzE")
local module6 = require("@luauforge/bundled/fCI")

local module7 = require("@luauforge/bundled/fCJ")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module9 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local fFlagAXBackgroundsOutfitPersistence = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundsOutfitPersistence
local fFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXOutfitPageRevamp
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local getHumanoidDescriptionFromStateForOutfitType = AvatarExperienceCommon.Utils.getHumanoidDescriptionFromStateForOutfitType
local outfitTypes = AvatarExperienceCommon.Enums.OutfitTypes

local v5 = {
	toastMessage = "Feature.Avatar.Message.InvalidName",
	isLocalized = false,
	toastType = module5.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.ReachedMaxOutfits",
	isLocalized = false,
	toastType = module5.InformationMessage
}

local v7 = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingOutfit",
	isLocalized = false,
	toastType = module5.InformationMessage
}

return function(p2, p3, p4, callback, p5, p6)
	module.isTypeOrNil(p2, "string", "CreateOutfit thunk expects name to be a string or nil")
	module.isType(p3, "table", "CreateOutfit thunk expects avatarEditorAnalytics to be a table")
	module.isTypeOrNil(p4, "function", "CreateOutfit thunk expects checkIsMounted to be a function or nil")

	module.isTypeOrNil(
		callback,
		"function",
		"CreateOutfit thunk expects onComplete to be a callback or nil"
	)
	module.isTypeOrNil(
		p5,
		"Instance",
		"CreateOutfit thunk expects altHumanoidDescription to be an Instance or nil"
	)

	if fFlagAXOutfitPageRevamp then
		module.isTypeOrNil(p6, "string", "CreateOutfit thunk expects outfitType to be a string or nil")
	end

	return function(p7, p8)
		local avatarEditorService = p8.avatarEditorService
		return performFetch.Single(module2.CreateOutfitKey, function(object)
			local state = object:getState()
			local avatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
			local v8 = Enum.HumanoidRigType[avatarType]
			local v9 = 0

			local v10 = fFlagAXOutfitPageRevamp and p6 == outfitTypes.Makeup
			local v11

			if fFlagAXOutfitPageRevamp then
				v11 = if v10 then Enum.OutfitType.Makeup else Enum.OutfitType.Avatar
			else
				v11 = nil
			end

			local v12

			if p5 == nil then
				if fFlagAXOutfitPageRevamp and v10 then
					v12 = getHumanoidDescriptionFromStateForOutfitType(state.AvatarExperience, p6)
				else
					v12 = module6.getHumanoidDescriptionFromState(state.AvatarExperience)
				end
			else
				v12 = p5
			end

			if module7() then
				v9 = module6.getGearAssetIdFromState(state.AvatarExperience)
			end

			local v13 = fFlagAXBackgroundsOutfitPersistence
				and {
					ProfileConfiguration = AvatarExperienceCommon.Backgrounds.buildOutfitProfileConfiguration(state.AvatarExperience)
				}
				or nil

			return Promise.new(function(callback2, callback3)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local v14

				if fFlagAXOutfitPageRevamp then
					v14 = avatarEditorService:NoPromptCreateOutfit(v12, v8, p2, v9, v13, v11)
				elseif module7() then
					v14 = avatarEditorService:NoPromptCreateOutfit(v12, v8, p2, v9, v13)
				else
					v14 = avatarEditorService:NoPromptCreateOutfit(v12, v8, p2, 0, v13)
				end

				while not v14 do
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
						)
					end

					avatarEditorService.PromptCreateOutfitCompleted:Wait()

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					if fFlagAXOutfitPageRevamp then
						v14 = avatarEditorService:NoPromptCreateOutfit(v12, v8, p2, v9, v13, v11)
					else
						v14 = avatarEditorService:NoPromptCreateOutfit(v12, v8, p2, 0, v13)
					end

					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module9.Counter.AvatarEditorServiceErrors.NoPromptCreateOutfit)
					end
				end

				local v15, v16 = avatarEditorService.PromptCreateOutfitCompleted:Wait()

				if v15 == Enum.AvatarPromptResult.Success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					p3.outfitCreated(p2)

					object:dispatch(module4({
						toastMessage = module3.translateString("Feature.Avatar.Message.AvatarAdded", {
							avatarName = p2
						}),
						isLocalized = true,
						toastType = module5.SuccessConfirmation
					}))

					callback2()

					if callback ~= nil then
						callback(true)
					end
				else
					if v16 == Enum.CreateOutfitFailure.InvalidName then
						object:dispatch(module4(v5))
					elseif v16 == Enum.CreateOutfitFailure.OutfitLimitReached then
						object:dispatch(module4(v6))
					elseif v16 == Enum.CreateOutfitFailure.Other then
						object:dispatch(module4(v7))
					end

					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module9.Counter.AvatarEditorServiceErrors.CreateOutfit)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptCreateOutfit,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							v16 or v15
						)
					end

					callback3()

					if callback ~= nil then
						callback(false)
					end
				end
			end)
		end)(p7):catch(function(p9) end)
	end
end
