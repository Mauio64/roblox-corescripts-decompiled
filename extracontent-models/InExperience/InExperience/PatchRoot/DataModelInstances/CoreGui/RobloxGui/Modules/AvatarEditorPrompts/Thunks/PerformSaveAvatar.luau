local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

local GetConformedHumanoidDescription = require(parent.GetConformedHumanoidDescription)

return function(object)
	local addedAssets = object:getState().analyticsInfo.addedAssets or {}
	local removedAssets = object:getState().analyticsInfo.removedAssets or {}

	GetConformedHumanoidDescription(object:getState().promptInfo.humanoidDescription, false):andThen(function(p)
		AvatarEditorService:PerformSaveAvatarWithDescription(p, addedAssets, removedAssets)
	end, function(_)
		AvatarEditorService:SignalSaveAvatarFailed()
	end)

	object:dispatch(CloseOpenPrompt())
end
