local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

local GetConformedHumanoidDescription = require(parent.GetConformedHumanoidDescription)

return function(p)
	return function(object)
		GetConformedHumanoidDescription(object:getState().promptInfo.humanoidDescription, false):andThen(function(p2)
			AvatarEditorService:PerformCreateOutfitWithDescription(p2, p)
		end, function(_)
			AvatarEditorService:SignalCreateOutfitFailed()
		end)

		object:dispatch(CloseOpenPrompt())
	end
end
