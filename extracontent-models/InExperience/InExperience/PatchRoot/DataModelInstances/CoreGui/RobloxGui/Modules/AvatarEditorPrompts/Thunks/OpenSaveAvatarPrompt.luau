local ParentParent = script.Parent.Parent
local OpenPrompt = require(ParentParent.Actions.OpenPrompt)
local PromptType = require(ParentParent.PromptType)

return function(p1, p2) -- line: 6
	-- upvalues: OpenPrompt (copy), PromptType (copy)
	return function(p3) -- line: 7
		-- upvalues: OpenPrompt (copy), PromptType (copy), p1 (copy), p2 (copy)
		p3:dispatch(OpenPrompt(PromptType.SaveAvatar, {
			humanoidDescription = p1,
			rigType = p2
		}))
	end
end
