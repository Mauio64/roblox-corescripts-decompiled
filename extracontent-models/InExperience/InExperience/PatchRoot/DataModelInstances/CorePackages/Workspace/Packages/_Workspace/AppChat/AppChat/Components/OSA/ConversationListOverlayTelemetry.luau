local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Telemetry.Layers.AppTelemetryLayer)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p, _)
				return { modalVariant = p.modalVariant }
			end,
			eventStreamFormat = function(data, _)
				return {
					modalVariant = data.modalVariant,
					conversationId = data.conversationId,
					impressionId = data.impressionId
				}
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p, _)
				return { modalVariant = p.modalVariant, action = p.action }
			end,
			eventStreamFormat = function(data, _)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					conversationId = data.conversationId,
					impressionId = data.impressionId
				}
			end
		}),
		ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(data, _)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					actionResult = data.actionResult
				}
			end,
			eventStreamFormat = function(data, _)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					actionResult = data.actionResult,
					conversationId = data.conversationId,
					impressionId = data.impressionId
				}
			end
		})
	}
}
