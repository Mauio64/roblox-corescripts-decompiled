local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dzP")
local Promise = require(CorePackages.Packages.Promise)

local module2 = require("@luauforge/bundled/hbd")
local module3 = require("@luauforge/bundled/dRg")
local module4 = require("@luauforge/bundled/dFm")
local module5 = require("@luauforge/bundled/dzE")
require("@luauforge/bundled/dPs")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local module8 = require("@luauforge/bundled/fCI")
local module9 = require("@luauforge/bundled/dPN")
local getHumanoidDescriptionFromStateForOutfitType = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getHumanoidDescriptionFromStateForOutfitType
local module10 = require("@luauforge/bundled/fCe")

local module11 = require("@luauforge/bundled/fCJ")

local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getEquippedAvatarOutfitIdStore = AvatarExperienceCommon.Stores.getEquippedAvatarOutfitIdStore

local v5 = {
	toastMessage = "Feature.Avatar.Message.UpdateOutfitSuccess",
	isLocalized = false,
	toastType = module5.SuccessConfirmation
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.FailedUpdateOutfit",
	isLocalized = false,
	toastType = module5.InformationMessage
}

return function(p2, p3, p4, p5, p6)
	module.isType(p3, "string", "UpdateSavedOutfit thunk expects outfitId to be a string")
	module.isType(p2, "table", "UpdateSavedOutfit thunk expects avatarEditorAnalytics to be a table")

	module.isType(p3, "string", "UpdateSavedOutfit thunk expects outfitId to be a string")

	return function(p7, p8)
		local avatarEditorService = p8.avatarEditorService
		return performFetch.Single(module3.UpdateOutfitKey .. p3, function(object)
			local state = object:getState()
			local v8

			if fFlagEnableSplitPaneAvatarOverlay then
				v8 = state.AvatarExperience.AvatarEditor.OutfitInfos[p3]
			else
				v8 = nil
			end

			local outfitType

			if fFlagAXOutfitPageRevamp and state.AvatarExperience.AvatarEditor.OutfitInfos[p3] then
				outfitType = state.AvatarExperience.AvatarEditor.OutfitInfos[p3].outfitType
			end

			local v9

			if p4 then
				v9 = module8.getHumanoidDescriptionFromOutfitInfo(p4)
			elseif fFlagAXOutfitPageRevamp then
				v9 = getHumanoidDescriptionFromStateForOutfitType(state.AvatarExperience, outfitType)
			else
				v9 = module8.getHumanoidDescriptionFromState(state.AvatarExperience)
			end

			local avatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
			local v10 = Enum.HumanoidRigType[avatarType]

			local v11 = not module11() and 0 or module8.getGearAssetIdFromState(state.AvatarExperience)

			local v12 = fFlagAXBackgroundsOutfitPersistence
				and {
					ProfileConfiguration = AvatarExperienceCommon.Backgrounds.buildOutfitProfileConfiguration(state.AvatarExperience)
				}
				or nil

			return Promise.new(function(callback, callback2)
				if module8.doAESCallAndAwaitResult(
					avatarEditorService,
					avatarEditorService.NoPromptUpdateOutfit,
					avatarEditorService.PromptUpdateOutfitCompleted,
					p3,
					v9,
					v10,
					v11,
					v12
				) == Enum.AvatarPromptResult.Success then
					if
						fFlagEnableSplitPaneAvatarOverlay
						and v8 ~= nil
						and v8.outfitType == module9.OutfitTypes.Avatar
						and v8.isEditable
					then
						getEquippedAvatarOutfitIdStore(false).setLastEquippedAvatarOutfitId(p3)
					end

					object:dispatch(module2(p3, p6))
					local name = state.AvatarExperience.AvatarEditor.OutfitInfos[p3]
						and state.AvatarExperience.AvatarEditor.OutfitInfos[p3].name

					if name then
						local translateString = module10.translateString(
							"Feature.Avatar.Message.AvatarUpdated",
							{ avatarName = name }
						)

						if fFlagAXInventoryDurablesSupport and not p5 then
							object:dispatch(module4({
								toastMessage = translateString,
								isLocalized = true,
								toastType = module5.SuccessConfirmation
							}))
						end
					else
						object:dispatch(module4(v5))
					end

					callback()
				else
					object:dispatch(module4(v6))
					callback2()
				end
			end)
		end)(p7)
	end
end
