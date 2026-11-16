local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

return function(p)
	return function(object)
		AvatarEditorService:PerformRenameOutfit(p)

		object:dispatch(CloseOpenPrompt())
	end
end
