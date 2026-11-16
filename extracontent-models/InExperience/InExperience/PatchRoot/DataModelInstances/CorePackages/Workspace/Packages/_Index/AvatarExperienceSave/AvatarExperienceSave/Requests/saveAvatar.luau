local AvatarEditorService = game:GetService("AvatarEditorService")
local parent = script:FindFirstAncestor("AvatarExperienceSave").Parent

local Promise = require(parent.Promise)
require(parent.LuauPolyfill)

local function saveAvatar(p, p2, p3, p4: number?)
	return Promise.new(function(callback, callback2)
		local v = AvatarEditorService:NoPromptSaveAvatar(p, p2, p3, p4)

		while not v do
			AvatarEditorService.PromptSaveAvatarCompleted:Wait()
			v = AvatarEditorService:NoPromptSaveAvatar(p, p2, p3, p4)
		end

		local avatarPromptResult, humanoidDescriptionWithValidAssets = AvatarEditorService.PromptSaveAvatarCompleted:Wait()

		if avatarPromptResult == Enum.AvatarPromptResult.Success then
			callback({
				avatarPromptResult = avatarPromptResult,
				humanoidDescriptionWithValidAssets = humanoidDescriptionWithValidAssets
			})
		else
			callback2({ avatarPromptResult = avatarPromptResult })
		end
	end)
end

return saveAvatar
