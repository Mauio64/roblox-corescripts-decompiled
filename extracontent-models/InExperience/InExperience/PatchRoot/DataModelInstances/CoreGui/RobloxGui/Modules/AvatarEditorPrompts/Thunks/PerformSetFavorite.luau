local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)

return function(p1) -- line: 6
	-- upvalues: AvatarEditorService (copy), CloseOpenPrompt (copy)
	AvatarEditorService:PerformSetFavorite()
	p1:dispatch(CloseOpenPrompt())
end
