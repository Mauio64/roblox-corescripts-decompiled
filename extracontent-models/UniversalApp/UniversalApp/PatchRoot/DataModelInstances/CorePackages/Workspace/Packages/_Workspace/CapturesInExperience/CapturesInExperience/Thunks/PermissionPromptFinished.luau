local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local PromptDismissed = require(ParentParent.Actions.PromptDismissed)

return function(n1: number, b1: boolean) -- line: 7
	-- upvalues: PromptDismissed (copy), CaptureService (copy)
	return function(p1) -- line: 8
		-- upvalues: PromptDismissed (copy), n1 (copy), CaptureService (copy), b1 (copy)
		p1:dispatch(PromptDismissed(n1))

		if game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
			CaptureService:OnCapturePermissionsPromptFinished(n1, b1)
		end
	end
end
