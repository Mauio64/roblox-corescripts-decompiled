local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Telemetry.Layers.AppTelemetryLayer)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p, _)
				return { modalVariant = p.modalVariant }
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p, _)
				return { modalVariant = p.modalVariant, action = p.action }
			end
		}),
		ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(data, _)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					actionResult = data.actionResult
				}
			end
		})
	}
}
