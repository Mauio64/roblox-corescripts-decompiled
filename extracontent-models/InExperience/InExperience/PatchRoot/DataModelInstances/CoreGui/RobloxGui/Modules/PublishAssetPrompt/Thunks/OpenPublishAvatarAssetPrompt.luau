local parent = script.Parent.Parent
local OpenPublishAvatarAssetPrompt = require(parent.Actions.OpenPublishAvatarAssetPrompt)
local PromptType = require(parent.PromptType)

return function(p, p2: string, p3)
	return function(object)
		object:dispatch(OpenPublishAvatarAssetPrompt(PromptType.PublishAvatarAsset, p, p2, p3))
	end
end
