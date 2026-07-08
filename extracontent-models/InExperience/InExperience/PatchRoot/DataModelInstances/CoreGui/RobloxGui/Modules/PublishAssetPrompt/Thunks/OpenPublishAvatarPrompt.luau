local ParentParent = script.Parent.Parent
local OpenPublishAvatarPrompt = require(ParentParent.Actions.OpenPublishAvatarPrompt)
local PromptType = require(ParentParent.PromptType)

return function(s1: string, p1) -- line: 12
	-- upvalues: OpenPublishAvatarPrompt (copy), PromptType (copy)
	return function(p2) -- line: 13
		-- upvalues: OpenPublishAvatarPrompt (copy), PromptType (copy), s1 (copy), p1 (copy)
		p2:dispatch(OpenPublishAvatarPrompt(PromptType.PublishAvatar, s1, p1))
	end
end
