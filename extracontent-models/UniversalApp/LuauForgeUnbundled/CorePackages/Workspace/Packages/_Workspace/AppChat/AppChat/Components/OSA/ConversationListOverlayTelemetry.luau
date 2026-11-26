require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/AppTelemetryLayer")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p2, p3)
				return { modalVariant = p2.modalVariant }
			end,
			eventStreamFormat = function(data, p2)
				return {
					modalVariant = data.modalVariant,
					conversationId = data.conversationId,
					impressionId = data.impressionId
				}
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationListOverlay,
			counterFormat = function(p2, p3)
				return { modalVariant = p2.modalVariant, action = p2.action }
			end,
			eventStreamFormat = function(data, p2)
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
			counterFormat = function(data, p2)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					actionResult = data.actionResult
				}
			end,
			eventStreamFormat = function(data, p2)
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
