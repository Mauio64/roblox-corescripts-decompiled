local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local MessageBusService = game:GetService("MessageBusService")
local SafetyService = game:GetService("SafetyService")

local messageId = MessageBusService:GetMessageId("CaptureMode", "sceneSelectionExitReason")
local InExpSceneSelectionAdapter = {}

function InExpSceneSelectionAdapter.start()
	SafetyService.IsCaptureModeForReport = true
	ExperienceStateCaptureService:ToggleCaptureMode()
end

function InExpSceneSelectionAdapter.subscribeOnceToExitReason(callback)
	return MessageBusService:Subscribe(messageId, callback, true, false)
end

return InExpSceneSelectionAdapter
