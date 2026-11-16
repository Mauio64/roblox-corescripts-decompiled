local parent = script.Parent.Parent
local OpenPublishMakeupLookPrompt = require(parent.Actions.OpenPublishMakeupLookPrompt)
local PromptType = require(parent.PromptType)

return function(p: string, p2, p3)
	return function(object)
		object:dispatch(OpenPublishMakeupLookPrompt(PromptType.PublishMakeupLook, p, p2, p3))
	end
end
