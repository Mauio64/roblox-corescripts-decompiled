local AvatarEditorService = game:GetService("AvatarEditorService")
local Parent = script:FindFirstAncestor("AvatarExperienceSave").Parent
local Promise = require(Parent.Promise)

require(Parent.LuauPolyfill)

local function saveAvatar(p1, p2, t1: {[any]: any}, n1: number?) -- line: 28
	-- upvalues: Promise (copy), AvatarEditorService (copy)
	return Promise.new(function(resolve, reject) -- line: 34
		-- upvalues: AvatarEditorService (copy), p1 (copy), p2 (copy), t1 (copy), n1 (copy)
		local v11 = AvatarEditorService:NoPromptSaveAvatar(p1, p2, t1, n1)

		while not v11 do
			AvatarEditorService.PromptSaveAvatarCompleted:Wait()
			v11 = AvatarEditorService:NoPromptSaveAvatar(p1, p2, t1, n1)
		end

		local v12, v13 = AvatarEditorService.PromptSaveAvatarCompleted:Wait()

		if v12 == Enum.AvatarPromptResult.Success then
			resolve({
				avatarPromptResult = v12,
				humanoidDescriptionWithValidAssets = v13
			})

			return
		end

		reject({
			avatarPromptResult = v12
		})
	end)
end

return saveAvatar
