local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local GetConformedHumanoidDescription = require(ParentParent.GetConformedHumanoidDescription)

return function(p1) -- line: 8
	-- upvalues: GetConformedHumanoidDescription (copy), AvatarEditorService (copy), CloseOpenPrompt (copy)
	local humanoidDescription = p1:getState().promptInfo.humanoidDescription

	GetConformedHumanoidDescription(humanoidDescription, false):andThen(function(p2) -- line: 12
		-- upvalues: AvatarEditorService (copy)
		AvatarEditorService:PerformUpdateOutfit(p2)
	end, function(_) -- line: 14
		-- upvalues: AvatarEditorService (copy)
		AvatarEditorService:SignalUpdateOutfitFailed()
	end)
	p1:dispatch(CloseOpenPrompt())
end
