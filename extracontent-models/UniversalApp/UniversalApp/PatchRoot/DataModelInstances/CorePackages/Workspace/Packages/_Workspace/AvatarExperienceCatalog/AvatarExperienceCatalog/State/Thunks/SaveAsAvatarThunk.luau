local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local PerformFetch = require(Parent.Http).PerformFetch
local Promise = require(Parent.Promise)
local ToastRodux = require(Parent.ToastRodux)
local AVATAR_EDITOR_CONSTANTS = AvatarExperienceCommon.Constants.AVATAR_EDITOR_CONSTANTS
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local Constants = AvatarExperienceAnalytics.Constants
local getGearAssetIdFromState = AvatarExperienceCommon.Utils.getGearAssetIdFromState
local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local FIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local t1 = {
	toastMessage = "Feature.Avatar.Message.InvalidName",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.Message.ReachedMaxOutfits",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t3 = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingOutfit",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(s1: string, p1: ((...any) -> ...any), t4: {[any]: any}, p2: ((...any) -> ...any)) -- line: 41
	-- upvalues: PerformFetch (copy), AVATAR_EDITOR_CONSTANTS (copy), getGearAssetIdFromState (copy), FIntAXLookOutfitCreationDelayMs (copy), Promise (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), reportAvatarEventCounterV1 (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy), t3 (copy)
	return function(p3, p4) -- line: 47
		-- upvalues: PerformFetch (copy), AVATAR_EDITOR_CONSTANTS (copy), getGearAssetIdFromState (copy), p1 (copy), t4 (copy), FIntAXLookOutfitCreationDelayMs (copy), Promise (copy), s1 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), reportAvatarEventCounterV1 (copy), p2 (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy), t3 (copy)
		local avatarEditorService = p4.avatarEditorService

		return PerformFetch.Single(AVATAR_EDITOR_CONSTANTS.CreateOutfitKey, function(p5) -- line: 49
			-- upvalues: getGearAssetIdFromState (copy), p1 (copy), t4 (copy), FIntAXLookOutfitCreationDelayMs (copy), Promise (copy), avatarEditorService (copy), s1 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), reportAvatarEventCounterV1 (copy), p2 (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy), t3 (copy)
			local v27 = p5:getState()
			local AvatarType = v27.AvatarExperience.AvatarEditor.Character.AvatarType
			local v29 = Enum.HumanoidRigType[AvatarType]
			local v30 = getGearAssetIdFromState(v27.AvatarExperience)
			local v31 = p1(v27, t4)

			task.spawn(function() -- line: 59
				-- upvalues: FIntAXLookOutfitCreationDelayMs (copy), Promise (copy), avatarEditorService (copy), v31 (copy), v29 (copy), s1 (copy), v30 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), reportAvatarEventCounterV1 (copy), p2 (copy), p5 (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy), t3 (copy)
				task.wait(FIntAXLookOutfitCreationDelayMs / 1000)
				Promise.new(function(resolve, reject) -- line: 63
					-- upvalues: avatarEditorService (copy), v31 (copy), v29 (copy), s1 (copy), v30 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), reportAvatarEventCounterV1 (copy), p2 (copy), p5 (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy), t3 (copy)
					local v35 = avatarEditorService:NoPromptCreateOutfit(v31, v29, s1, v30)

					while not v35 do
						avatarEditorService.PromptCreateOutfitCompleted:Wait()
						v35 = avatarEditorService:NoPromptCreateOutfit(v31, v29, s1, 0)
						reportAvatarEventCounterNoAnalyticsArgument(Constants.AVATAR_EDITOR_SERVICE_ERRORS.NoPromptCreateOutfit)
					end

					local v36, v37 = avatarEditorService.PromptCreateOutfitCompleted:Wait()

					if v36 == Enum.AvatarPromptResult.Success then
						reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXCreateCostume)
						p2()
						resolve()

						return
					end

					if v37 == Enum.CreateOutfitFailure.InvalidName then
						p5:dispatch(SetCurrentToastMessage(t1))
					elseif v37 == Enum.CreateOutfitFailure.OutfitLimitReached then
						p5:dispatch(SetCurrentToastMessage(t2))
					elseif v37 == Enum.CreateOutfitFailure.Other then
						p5:dispatch(SetCurrentToastMessage(t3))
					end

					reportAvatarEventCounterNoAnalyticsArgument(Constants.AVATAR_EDITOR_SERVICE_ERRORS.CreateOutfit)
					reject()
				end)
			end)

			return Promise.resolve()
		end)(p3):catch(function(_) -- line: 110
		end)
	end
end
