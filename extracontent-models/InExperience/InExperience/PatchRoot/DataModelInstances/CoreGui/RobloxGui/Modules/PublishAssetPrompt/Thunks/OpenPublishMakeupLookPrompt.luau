local ParentParent = script.Parent.Parent
local OpenPublishMakeupLookPrompt = require(ParentParent.Actions.OpenPublishMakeupLookPrompt)
local PromptType = require(ParentParent.PromptType)

return function(s1: string, p1, p2) -- line: 12
	-- upvalues: OpenPublishMakeupLookPrompt (copy), PromptType (copy)
	return function(p3) -- line: 13
		-- upvalues: OpenPublishMakeupLookPrompt (copy), PromptType (copy), s1 (copy), p1 (copy), p2 (copy)
		p3:dispatch(OpenPublishMakeupLookPrompt(PromptType.PublishMakeupLook, s1, p1, p2))
	end
end
