local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local GetConformedHumanoidDescription = require(ParentParent.GetConformedHumanoidDescription)

return function(p1) -- line: 8
	-- upvalues: GetConformedHumanoidDescription (copy), AvatarEditorService (copy), CloseOpenPrompt (copy)
	return function(p2) -- line: 9
		-- upvalues: GetConformedHumanoidDescription (copy), AvatarEditorService (copy), p1 (copy), CloseOpenPrompt (copy)
		local humanoidDescription = p2:getState().promptInfo.humanoidDescription

		GetConformedHumanoidDescription(humanoidDescription, false):andThen(function(p3) -- line: 13
			-- upvalues: AvatarEditorService (copy), p1 (copy)
			AvatarEditorService:PerformCreateOutfitWithDescription(p3, p1)
		end, function(_) -- line: 15
			-- upvalues: AvatarEditorService (copy)
			AvatarEditorService:SignalCreateOutfitFailed()
		end)
		p2:dispatch(CloseOpenPrompt())
	end
end
