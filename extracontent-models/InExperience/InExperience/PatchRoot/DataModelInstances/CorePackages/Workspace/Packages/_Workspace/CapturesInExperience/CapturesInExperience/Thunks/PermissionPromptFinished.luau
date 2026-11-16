local parent = script.Parent.Parent

local CaptureService = game:GetService("CaptureService")

local PromptDismissed = require(parent.Actions.PromptDismissed)

return function(p: number, flag: boolean)
	return function(object)
		object:dispatch(PromptDismissed(p))

		if game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
			CaptureService:OnCapturePermissionsPromptFinished(p, flag)
		end
	end
end
