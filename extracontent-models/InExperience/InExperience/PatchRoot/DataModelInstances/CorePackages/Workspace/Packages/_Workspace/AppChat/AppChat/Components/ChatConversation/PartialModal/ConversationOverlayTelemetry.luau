local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Telemetry.Layers.AppTelemetryLayer)

local ModalTelemetry = require(AppChat.Components.ModalTelemetry)

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p1, _) -- line: 12
				return {
					modalVariant = p1.modalVariant
				}
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p3, _) -- line: 20
				return {
					modalVariant = p3.modalVariant,
					action = p3.action
				}
			end
		}),
		ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationOverlay,
			counterFormat = function(p5, _) -- line: 32
				return {
					modalVariant = p5.modalVariant,
					action = p5.action,
					actionResult = p5.actionResult
				}
			end
		})
	}
}
