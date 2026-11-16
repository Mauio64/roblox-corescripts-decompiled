local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationTopModal,
			counterFormat = function(p, _)
				return { modalVariant = p.modalVariant }
			end,
			eventStreamFormat = function(p, _)
				return { modalVariant = p.modalVariant, modalContext = p.modalContext }
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationTopModal,
			counterFormat = function(p, _)
				return { modalVariant = p.modalVariant, action = p.action }
			end,
			eventStreamFormat = function(data, _)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					modalContext = data.modalContext
				}
			end
		})
	}
}
