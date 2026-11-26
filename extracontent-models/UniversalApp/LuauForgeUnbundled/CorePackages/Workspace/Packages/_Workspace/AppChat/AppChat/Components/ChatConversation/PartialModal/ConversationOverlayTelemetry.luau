require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/AppTelemetryLayer")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p2, p3)
				return { modalVariant = p2.modalVariant }
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p2, p3)
				return { modalVariant = p2.modalVariant, action = p2.action }
			end
		}),
		ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(data, p2)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					actionResult = data.actionResult
				}
			end
		})
	}
}
