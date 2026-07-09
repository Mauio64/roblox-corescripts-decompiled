local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Telemetry.Layers.AppTelemetryLayer)

local ModalTelemetry = require(AppChat.Components.ModalTelemetry)

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p1, _) -- line: 12
				return {
					modalVariant = p1.modalVariant
				}
			end,
			eventStreamFormat = function(p3, _) -- line: 17
				return {
					modalVariant = p3.modalVariant,
					conversationId = p3.conversationId,
					impressionId = p3.impressionId
				}
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p5, _) -- line: 27
				return {
					modalVariant = p5.modalVariant,
					action = p5.action
				}
			end,
			eventStreamFormat = function(p7, _) -- line: 36
				return {
					modalVariant = p7.modalVariant,
					action = p7.action,
					conversationId = p7.conversationId,
					impressionId = p7.impressionId
				}
			end
		}),
		ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p9, _) -- line: 52
				return {
					modalVariant = p9.modalVariant,
					action = p9.action,
					actionResult = p9.actionResult
				}
			end,
			eventStreamFormat = function(p11, _) -- line: 65
				return {
					modalVariant = p11.modalVariant,
					action = p11.action,
					actionResult = p11.actionResult,
					conversationId = p11.conversationId,
					impressionId = p11.impressionId
				}
			end
		})
	}
}
