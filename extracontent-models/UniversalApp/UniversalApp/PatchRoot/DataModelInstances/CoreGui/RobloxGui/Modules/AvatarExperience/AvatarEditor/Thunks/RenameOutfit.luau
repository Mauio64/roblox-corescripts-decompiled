local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(CorePackages.Packages.Promise)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local OutfitRenamed = require(Modules.AvatarExperience.AvatarEditor.Actions.OutfitRenamed)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXUpdateSlotBasedEditorToastAndPrompts = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUpdateSlotBasedEditorToastAndPrompts
local t1 = {
	isLocalized = false,
	toastMessage = not FFlagAXUpdateSlotBasedEditorToastAndPrompts and "Feature.Avatar.Message.RenameCostumeSuccess" or "Feature.Avatar.Message.AvatarRenamed",
	toastType = ToastType.InformationMessage
}
local t2 = {
	isLocalized = false,
	toastMessage = not FFlagAXUpdateSlotBasedEditorToastAndPrompts and "Feature.Avatar.Message.FailedRenameCostume" or "Feature.Avatar.Message.FailedAvatarRename",
	toastType = ToastType.InformationMessage
}

local function keyMapper(p1) -- line: 41
	-- upvalues: Constants (copy)
	return Constants.RenameOutfitKey .. p1
end

return function(p2, s1: string, s2: string) -- line: 45
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), Promise (copy), Utils (copy), OutfitRenamed (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy)
	ArgCheck.isType(p2, "table", "RenameOutfit thunk expects avatarEditorAnalytics to be a table")
	ArgCheck.isType(s1, "string", "RenameOutfit thunk expects id to be a string")
	ArgCheck.isType(s2, "string", "RenameOutfit thunk expects name to be a string")

	return function(p3, p4) -- line: 50
		-- upvalues: PerformFetch (copy), s1 (copy), Constants (copy), Promise (copy), Utils (copy), s2 (copy), OutfitRenamed (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy)
		local avatarEditorService = p4.avatarEditorService
		local Single = PerformFetch.Single
		local v24 = s1

		return Single(Constants.RenameOutfitKey .. v24, function(p5) -- line: 52
			-- upvalues: Promise (copy), Utils (copy), avatarEditorService (copy), s1 (copy), s2 (copy), OutfitRenamed (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy)
			return Promise.new(function(resolve, reject) -- line: 53
				-- upvalues: Utils (copy), avatarEditorService (copy), s1 (copy), s2 (copy), p5 (copy), OutfitRenamed (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy)
				if Utils.doAESCallAndAwaitResult(avatarEditorService, avatarEditorService.NoPromptRenameOutfit, avatarEditorService.PromptRenameOutfitCompleted, s1, s2) == Enum.AvatarPromptResult.Success then
					p5:dispatch(OutfitRenamed(s1, s2))
					p5:dispatch(SetCurrentToastMessage(t1))
					resolve()

					return
				end

				p5:dispatch(SetCurrentToastMessage(t2))
				reject()
			end)
		end)(p3)
	end
end
