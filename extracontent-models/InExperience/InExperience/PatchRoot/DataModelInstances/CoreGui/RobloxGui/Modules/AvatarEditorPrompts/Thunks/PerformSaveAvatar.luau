local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local GetConformedHumanoidDescription = require(ParentParent.GetConformedHumanoidDescription)

return function(p1) -- line: 8
	-- upvalues: GetConformedHumanoidDescription (copy), AvatarEditorService (copy), CloseOpenPrompt (copy)
	local v6 = p1:getState().analyticsInfo.addedAssets or {}
	local v7 = p1:getState().analyticsInfo.removedAssets or {}
	local humanoidDescription = p1:getState().promptInfo.humanoidDescription

	GetConformedHumanoidDescription(humanoidDescription, false):andThen(function(p2) -- line: 15
		-- upvalues: AvatarEditorService (copy), v6 (copy), v7 (copy)
		AvatarEditorService:PerformSaveAvatarWithDescription(p2, v6, v7)
	end, function(_) -- line: 17
		-- upvalues: AvatarEditorService (copy)
		AvatarEditorService:SignalSaveAvatarFailed()
	end)
	p1:dispatch(CloseOpenPrompt())
end
