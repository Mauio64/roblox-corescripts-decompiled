local ParentParent = script.Parent.Parent
local OpenPublishAvatarAssetPrompt = require(ParentParent.Actions.OpenPublishAvatarAssetPrompt)
local PromptType = require(ParentParent.PromptType)

return function(p1, s1: string, p2) -- line: 12
	-- upvalues: OpenPublishAvatarAssetPrompt (copy), PromptType (copy)
	return function(p3) -- line: 13
		-- upvalues: OpenPublishAvatarAssetPrompt (copy), PromptType (copy), p1 (copy), s1 (copy), p2 (copy)
		p3:dispatch(OpenPublishAvatarAssetPrompt(PromptType.PublishAvatarAsset, p1, s1, p2))
	end
end
