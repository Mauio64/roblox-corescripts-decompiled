local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)

local ModalTelemetry = require(AppChat.Components.ModalTelemetry)

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationTopModal,
			counterFormat = function(p1, _) -- line: 12
				return {
					modalVariant = p1.modalVariant
				}
			end,
			eventStreamFormat = function(p3, _) -- line: 17
				return {
					modalVariant = p3.modalVariant,
					modalContext = p3.modalContext
				}
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationTopModal,
			counterFormat = function(p5, _) -- line: 26
				return {
					modalVariant = p5.modalVariant,
					action = p5.action
				}
			end,
			eventStreamFormat = function(p7, _) -- line: 35
				return {
					modalVariant = p7.modalVariant,
					action = p7.action,
					modalContext = p7.modalContext
				}
			end
		})
	}
}
