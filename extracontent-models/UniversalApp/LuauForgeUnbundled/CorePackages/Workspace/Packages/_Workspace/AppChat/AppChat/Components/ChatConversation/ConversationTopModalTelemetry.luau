require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")

return {
	Events = {
		ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationTopModal,
			counterFormat = function(p2, p3)
				return { modalVariant = p2.modalVariant }
			end,
			eventStreamFormat = function(p2, p3)
				return {
					modalVariant = p2.modalVariant,
					modalContext = p2.modalContext
				}
			end
		}),
		ModalAction = ModalTelemetry.Events.modalActionWithSequence({
			modalSequence = ModalTelemetry.Enums.ModalSequence.ConversationTopModal,
			counterFormat = function(p2, p3)
				return { modalVariant = p2.modalVariant, action = p2.action }
			end,
			eventStreamFormat = function(data, p2)
				return {
					modalVariant = data.modalVariant,
					action = data.action,
					modalContext = data.modalContext
				}
			end
		})
	}
}
