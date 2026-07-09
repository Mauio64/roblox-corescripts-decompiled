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
local RevokeOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeOutfit)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local t1 = {
	toastMessage = "Feature.Avatar.Message.FailedDeleteCostume",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local function keyMapper(s1: string) -- line: 28
	-- upvalues: Constants (copy)
	return Constants.DeleteOutfitsKey .. s1
end

return function(s2: string) -- line: 32
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), Promise (copy), Utils (copy), RevokeOutfit (copy), SetCurrentToastMessage (copy), t1 (copy)
	ArgCheck.isType(s2, "string", "DeleteOutfit thunk expects id to be a string")

	return function(p1, p2) -- line: 35
		-- upvalues: PerformFetch (copy), s2 (copy), Constants (copy), Promise (copy), Utils (copy), RevokeOutfit (copy), SetCurrentToastMessage (copy), t1 (copy)
		local avatarEditorService = p2.avatarEditorService
		local Single = PerformFetch.Single
		local v20 = s2

		return Single(Constants.DeleteOutfitsKey .. v20, function(p3) -- line: 37
			-- upvalues: Promise (copy), Utils (copy), avatarEditorService (copy), s2 (copy), RevokeOutfit (copy), SetCurrentToastMessage (copy), t1 (copy)
			return Promise.new(function(resolve, reject) -- line: 38
				-- upvalues: Utils (copy), avatarEditorService (copy), s2 (copy), p3 (copy), RevokeOutfit (copy), SetCurrentToastMessage (copy), t1 (copy)
				if Utils.doAESCallAndAwaitResult(avatarEditorService, avatarEditorService.NoPromptDeleteOutfit, avatarEditorService.PromptDeleteOutfitCompleted, s2) == Enum.AvatarPromptResult.Success then
					p3:dispatch(RevokeOutfit(s2))
					resolve()

					return
				end

				p3:dispatch(SetCurrentToastMessage(t1))
				reject()
			end)
		end)(p1)
	end
end
