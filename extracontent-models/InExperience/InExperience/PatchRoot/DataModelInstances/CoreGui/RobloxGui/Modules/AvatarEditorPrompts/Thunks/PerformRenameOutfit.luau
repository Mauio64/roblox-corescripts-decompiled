local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)

return function(p1) -- line: 6
	-- upvalues: AvatarEditorService (copy), CloseOpenPrompt (copy)
	return function(p2) -- line: 7
		-- upvalues: AvatarEditorService (copy), p1 (copy), CloseOpenPrompt (copy)
		AvatarEditorService:PerformRenameOutfit(p1)
		p2:dispatch(CloseOpenPrompt())
	end
end
