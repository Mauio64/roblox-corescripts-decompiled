local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

local GetConformedHumanoidDescription = require(parent.GetConformedHumanoidDescription)

return function(object)
	GetConformedHumanoidDescription(object:getState().promptInfo.humanoidDescription, false):andThen(function(p)
		AvatarEditorService:PerformUpdateOutfit(p)
	end, function(_)
		AvatarEditorService:SignalUpdateOutfitFailed()
	end)

	object:dispatch(CloseOpenPrompt())
end
