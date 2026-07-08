local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local PromptDismissed = require(ParentParent.Actions.PromptDismissed)

return function(p1, t1: {[any]: any}) -- line: 7
	-- upvalues: PromptDismissed (copy), CaptureService (copy)
	return function(p2) -- line: 8
		-- upvalues: PromptDismissed (copy), p1 (copy), CaptureService (copy), t1 (copy)
		p2:dispatch(PromptDismissed(p1))
		CaptureService:OnSavePromptFinished(p1, t1)
	end
end
