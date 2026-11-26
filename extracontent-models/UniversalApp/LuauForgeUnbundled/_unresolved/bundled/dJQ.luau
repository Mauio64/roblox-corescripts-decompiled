local EventIngestService = game:GetService("EventIngestService")

local eventIngest = require("@luauforge/bundled/dJR").AnalyticsReporters.EventIngest.new(EventIngestService)

local module = require("@luauforge/bundled/dJS")

local interactionEventName = module.interactionEventName

return {
	sendDialogOpenedEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(module.context.dialogOpened, interactionEventName, {
			dialog_opened_type = p2,
			dialog_opened_type_internal_id = p3,
			dialog_opened_is_expired = p4
		})
	end,
	sendDialogActionSelectedEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(module.context.dialogActionSelected, interactionEventName, {
			dialog_action_selected_type = p2,
			dialog_action_selected_type_internal_id = p3,
			dialog_action_selected_action = p4
		})
	end,
	sendDialogAbandonedEvent = function(p2, p3)
		eventIngest:sendEventDeferred(module.context.dialogAbandoned, interactionEventName, {
			dialog_abandoned_type = p2,
			dialog_abandoned_type_internal_id = p3
		})
	end
}
