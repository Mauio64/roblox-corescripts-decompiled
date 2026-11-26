local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local MessageBusService = game:GetService("MessageBusService")
local SafetyService = game:GetService("SafetyService")

local messageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")

return {
	start = function()
		SafetyService.IsCaptureModeForReport = true
		ExperienceStateCaptureService:ToggleCaptureMode()
	end,
	subscribeOnceToExitReason = function(p2)
		return MessageBusService:Subscribe(messageId, p2, true, false)
	end
}
