local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Modules = CoreGui.RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(CorePackages.Packages.Promise)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local GetFFlagAvatarEditorServiceCreateOutfitSupportsGears = require(Modules.AvatarExperience.Flags.GetFFlagAvatarEditorServiceCreateOutfitSupportsGears)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXUpdateSlotBasedEditorToastAndPrompts = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUpdateSlotBasedEditorToastAndPrompts
local FFlagAXBackgroundsOutfitPersistence = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBackgroundsOutfitPersistence
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
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

return function(s1: string, p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?, p4) -- line: 51
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), Utils2 (copy), GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), FFlagAXBackgroundsOutfitPersistence (copy), AvatarExperienceCommon (copy), Promise (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils (copy), SetCurrentToastMessage (copy), ToastType (copy), t1 (copy), t2 (copy), t3 (copy)
	ArgCheck.isTypeOrNil(s1, "string", "CreateOutfit thunk expects name to be a string or nil")
	ArgCheck.isType(p1, "table", "CreateOutfit thunk expects avatarEditorAnalytics to be a table")
	ArgCheck.isTypeOrNil(p2, "function", "CreateOutfit thunk expects checkIsMounted to be a function or nil")
	ArgCheck.isTypeOrNil(p3, "function", "CreateOutfit thunk expects onComplete to be a callback or nil")
	ArgCheck.isTypeOrNil(p4, "Instance", "CreateOutfit thunk expects altHumanoidDescription to be an Instance or nil")

	return function(p5, p6) -- line: 72
		-- upvalues: PerformFetch (copy), Constants (copy), p4 (copy), Utils2 (copy), GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), FFlagAXBackgroundsOutfitPersistence (copy), AvatarExperienceCommon (copy), Promise (copy), s1 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), p1 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils (copy), SetCurrentToastMessage (copy), ToastType (copy), p3 (copy), t1 (copy), t2 (copy), t3 (copy)
		local avatarEditorService = p6.avatarEditorService

		return PerformFetch.Single(Constants.CreateOutfitKey, function(p7) -- line: 74
			-- upvalues: p4 (copy), Utils2 (copy), GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), FFlagAXBackgroundsOutfitPersistence (copy), AvatarExperienceCommon (copy), Promise (copy), avatarEditorService (copy), s1 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), p1 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils (copy), SetCurrentToastMessage (copy), ToastType (copy), p3 (copy), t1 (copy), t2 (copy), t3 (copy)
			local v31 = p7:getState()
			local AvatarType = v31.AvatarExperience.AvatarEditor.Character.AvatarType
			local v33 = Enum.HumanoidRigType[AvatarType]
			local n1 = 0
			local u35 = if p4 == nil then Utils2.getHumanoidDescriptionFromState(v31.AvatarExperience) else p4

			if GetFFlagAvatarEditorServiceCreateOutfitSupportsGears() then
				n1 = Utils2.getGearAssetIdFromState(v31.AvatarExperience)
			end

			local v36 = if not FFlagAXBackgroundsOutfitPersistence then nil else {
				ProfileConfiguration = AvatarExperienceCommon.Backgrounds.buildOutfitProfileConfiguration(v31.AvatarExperience)
			}

			return Promise.new(function(resolve, reject) -- line: 98
				-- upvalues: GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), avatarEditorService (copy), u35 (ref), v33 (copy), s1 (copy), n1 (ref), v36 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), p1 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils (copy), p7 (copy), SetCurrentToastMessage (copy), ToastType (copy), p3 (copy), t1 (copy), t2 (copy), t3 (copy)
				local v40 = if not GetFFlagAvatarEditorServiceCreateOutfitSupportsGears() then avatarEditorService:NoPromptCreateOutfit(u35, v33, s1, 0, v36) else avatarEditorService:NoPromptCreateOutfit(u35, v33, s1, n1, v36)

				while not v40 do
					avatarEditorService.PromptCreateOutfitCompleted:Wait()
					v40 = avatarEditorService:NoPromptCreateOutfit(u35, v33, s1, 0, v36)

					if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
						reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.NoPromptCreateOutfit)
					end
				end

				local v41, v42 = avatarEditorService.PromptCreateOutfitCompleted:Wait()

				if v41 == Enum.AvatarPromptResult.Success then
					p1.outfitCreated(s1)

					if FFlagAXUpdateSlotBasedEditorToastAndPrompts then
						local v43 = Utils.translateString("Feature.Avatar.Message.AvatarAdded", {
							avatarName = s1
						})

						p7:dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v43,
							toastType = ToastType.SuccessConfirmation
						}))
					end

					resolve()

					if p3 ~= nil then
						p3(true)

						return
					end
				else
					if v42 == Enum.CreateOutfitFailure.InvalidName then
						p7:dispatch(SetCurrentToastMessage(t1))
					elseif v42 == Enum.CreateOutfitFailure.OutfitLimitReached then
						p7:dispatch(SetCurrentToastMessage(t2))
					elseif v42 == Enum.CreateOutfitFailure.Other then
						p7:dispatch(SetCurrentToastMessage(t3))
					end

					if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
						reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.CreateOutfit)
					end

					reject()

					if p3 ~= nil then
						p3(false)
					end
				end
			end)
		end)(p5):catch(function(_) -- line: 175
		end)
	end
end
