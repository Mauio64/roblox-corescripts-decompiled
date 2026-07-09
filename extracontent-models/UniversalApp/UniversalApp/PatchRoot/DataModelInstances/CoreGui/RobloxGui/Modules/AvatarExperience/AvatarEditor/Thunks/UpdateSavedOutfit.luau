local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(CorePackages.Packages.Promise)
local Modules = CoreGui.RobloxGui.Modules
local UpdateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.UpdateOutfit)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

require(Modules.AvatarExperience.Common.Types)
require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)
local GetFFlagAvatarEditorServiceCreateOutfitSupportsGears = require(Modules.AvatarExperience.Flags.GetFFlagAvatarEditorServiceCreateOutfitSupportsGears)
local FFlagAXUpdateSlotBasedEditorToastAndPrompts = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUpdateSlotBasedEditorToastAndPrompts
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = AvatarExperienceFlags.FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local t1 = {
	toastMessage = "Feature.Avatar.Message.UpdateOutfitSuccess",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.Avatar.Message.FailedUpdateOutfit",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p1, p2, p3, b1: boolean?, p4) -- line: 56
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), Utils (copy), GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), FFlagAXBackgroundsOutfitPersistence (copy), AvatarExperienceCommon (copy), Promise (copy), UpdateOutfit (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils2 (copy), FFlagAXInventoryDurablesSupport (copy), SetCurrentToastMessage (copy), ToastType (copy), t1 (copy), t2 (copy)
	ArgCheck.isType(p2, "string", "UpdateSavedOutfit thunk expects outfitId to be a string")
	ArgCheck.isType(p1, "table", "UpdateSavedOutfit thunk expects avatarEditorAnalytics to be a table")
	ArgCheck.isType(p2, "string", "UpdateSavedOutfit thunk expects outfitId to be a string")

	return function(p5, p6) -- line: 71
		-- upvalues: PerformFetch (copy), p2 (copy), Constants (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p3 (copy), Utils (copy), GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), FFlagAXBackgroundsOutfitPersistence (copy), AvatarExperienceCommon (copy), Promise (copy), UpdateOutfit (copy), p4 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils2 (copy), FFlagAXInventoryDurablesSupport (copy), b1 (copy), SetCurrentToastMessage (copy), ToastType (copy), t1 (copy), t2 (copy)
		local avatarEditorService = p6.avatarEditorService
		local Single = PerformFetch.Single
		local v33 = p2

		return Single(Constants.UpdateOutfitKey .. v33, function(p7) -- line: 73
			-- upvalues: FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p3 (copy), Utils (copy), GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), FFlagAXBackgroundsOutfitPersistence (copy), AvatarExperienceCommon (copy), Promise (copy), avatarEditorService (copy), p2 (copy), UpdateOutfit (copy), p4 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), Utils2 (copy), FFlagAXInventoryDurablesSupport (copy), b1 (copy), SetCurrentToastMessage (copy), ToastType (copy), t1 (copy), t2 (copy)
			local v35 = p7:getState()
			local v36 = if not (FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables) or not p3 then Utils.getHumanoidDescriptionFromState(v35.AvatarExperience) else Utils.getHumanoidDescriptionFromOutfitInfo(p3)
			local AvatarType = v35.AvatarExperience.AvatarEditor.Character.AvatarType
			local v38 = Enum.HumanoidRigType[AvatarType]
			local n1 = 0

			if GetFFlagAvatarEditorServiceCreateOutfitSupportsGears() then
				n1 = Utils.getGearAssetIdFromState(v35.AvatarExperience)
			end

			local v40 = if not FFlagAXBackgroundsOutfitPersistence then nil else {
				ProfileConfiguration = AvatarExperienceCommon.Backgrounds.buildOutfitProfileConfiguration(v35.AvatarExperience)
			}

			return Promise.new(function(resolve, reject) -- line: 96
				-- upvalues: Utils (copy), avatarEditorService (copy), p2 (copy), v36 (copy), v38 (copy), n1 (ref), v40 (copy), p7 (copy), UpdateOutfit (copy), p4 (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), v35 (copy), Utils2 (copy), FFlagAXInventoryDurablesSupport (copy), b1 (copy), SetCurrentToastMessage (copy), ToastType (copy), t1 (copy), t2 (copy)
				if Utils.doAESCallAndAwaitResult(avatarEditorService, avatarEditorService.NoPromptUpdateOutfit, avatarEditorService.PromptUpdateOutfitCompleted, p2, v36, v38, n1, v40) == Enum.AvatarPromptResult.Success then
					p7:dispatch(UpdateOutfit(p2, p4))

					local v43 = FFlagAXUpdateSlotBasedEditorToastAndPrompts and (v35.AvatarExperience.AvatarEditor.OutfitInfos[p2] and v35.AvatarExperience.AvatarEditor.OutfitInfos[p2].name)

					if FFlagAXUpdateSlotBasedEditorToastAndPrompts and v43 then
						local v44 = Utils2.translateString("Feature.Avatar.Message.AvatarUpdated", {
							avatarName = v43
						})

						if FFlagAXInventoryDurablesSupport and not b1 then
							p7:dispatch(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = v44,
								toastType = ToastType.SuccessConfirmation
							}))
						end
					else
						p7:dispatch(SetCurrentToastMessage(t1))
					end

					resolve()

					return
				end

				p7:dispatch(SetCurrentToastMessage(t2))
				reject()
			end)
		end)(p5)
	end
end
