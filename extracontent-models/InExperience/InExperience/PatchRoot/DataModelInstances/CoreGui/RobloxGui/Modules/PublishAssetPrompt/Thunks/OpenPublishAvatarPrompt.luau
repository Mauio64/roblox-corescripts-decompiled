local parent = script.Parent.Parent
local OpenPublishAvatarPrompt = require(parent.Actions.OpenPublishAvatarPrompt)
local PromptType = require(parent.PromptType)

return function(p: string, p2)
	return function(object)
		object:dispatch(OpenPublishAvatarPrompt(PromptType.PublishAvatar, p, p2))
	end
end
