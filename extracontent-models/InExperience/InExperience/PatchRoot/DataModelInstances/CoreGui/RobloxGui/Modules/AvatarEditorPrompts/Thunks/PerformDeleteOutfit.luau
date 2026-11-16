local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

return function(object)
	AvatarEditorService:PerformDeleteOutfit()

	object:dispatch(CloseOpenPrompt())
end
