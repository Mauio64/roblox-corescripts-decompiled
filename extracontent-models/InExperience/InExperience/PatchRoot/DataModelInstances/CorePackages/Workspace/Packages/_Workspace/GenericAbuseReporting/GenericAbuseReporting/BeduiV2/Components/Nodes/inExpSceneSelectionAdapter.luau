local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local MessageBusService = game:GetService("MessageBusService")
local SafetyService = game:GetService("SafetyService")
local MessageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")

return {
	start = function() -- line: 8
		-- upvalues: SafetyService (copy), ExperienceStateCaptureService (copy)
		SafetyService.IsCaptureModeForReport = true
		ExperienceStateCaptureService:ToggleCaptureMode()
	end,
	subscribeOnceToExitReason = function(p1: ((...any) -> ...any)) -- line: 15
		-- upvalues: MessageBusService (copy), MessageId (copy)
		return MessageBusService:Subscribe(MessageId, p1, true, false)
	end
}
