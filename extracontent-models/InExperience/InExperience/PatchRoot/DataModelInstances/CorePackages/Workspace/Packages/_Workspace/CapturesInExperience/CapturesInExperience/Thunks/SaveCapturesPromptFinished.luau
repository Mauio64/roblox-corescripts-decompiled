local parent = script.Parent.Parent

local CaptureService = game:GetService("CaptureService")

local PromptDismissed = require(parent.Actions.PromptDismissed)

return function(p, p2)
	return function(object)
		object:dispatch(PromptDismissed(p))

		CaptureService:OnSavePromptFinished(p, p2)
	end
end
