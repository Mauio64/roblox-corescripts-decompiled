local AvatarEditorService = game:GetService("AvatarEditorService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/LuauPolyfill")

local function saveAvatar(p2, p3, p4, p5)
	return Promise.new(function(callback, callback2)
		local v5 = AvatarEditorService:NoPromptSaveAvatar(p2, p3, p4, p5)

		while not v5 do
			AvatarEditorService.PromptSaveAvatarCompleted:Wait()
			v5 = AvatarEditorService:NoPromptSaveAvatar(p2, p3, p4, p5)
		end

		local v6, v7 = AvatarEditorService.PromptSaveAvatarCompleted:Wait()

		if v6 == Enum.AvatarPromptResult.Success then
			callback({
				avatarPromptResult = v6,
				humanoidDescriptionWithValidAssets = v7
			})
		else
			callback2({ avatarPromptResult = v6 })
		end
	end)
end

return saveAvatar
