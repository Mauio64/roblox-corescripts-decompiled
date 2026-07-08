local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)

return function(p1) -- line: 9
	-- upvalues: AvatarEditorService (copy), CloseOpenPrompt (copy)
	AvatarEditorService:SignalDeleteOutfitPermissionDenied()
	p1:dispatch(CloseOpenPrompt())
end
