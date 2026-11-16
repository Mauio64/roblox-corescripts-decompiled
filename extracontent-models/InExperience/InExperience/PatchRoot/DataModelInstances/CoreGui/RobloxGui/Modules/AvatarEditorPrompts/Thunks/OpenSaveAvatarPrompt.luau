local parent = script.Parent.Parent
local OpenPrompt = require(parent.Actions.OpenPrompt)

local PromptType = require(parent.PromptType)

return function(humanoidDescription, rigType)
	return function(object)
		object:dispatch(OpenPrompt(PromptType.SaveAvatar, {
			humanoidDescription = humanoidDescription,
			rigType = rigType
		}))
	end
end
