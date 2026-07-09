local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local EventIngestService = game:GetService("EventIngestService")
local ChallengeDialogParent = ChallengeDialog.Parent
local v4 = require(ChallengeDialogParent.Analytics).AnalyticsReporters.EventIngest.new(EventIngestService)
local EventConstants = require(ChallengeDialog.Analytics.EventConstants)
local interactionEventName = EventConstants.interactionEventName

return {
	sendDialogOpenedEvent = function(p1, s1: string, b1: boolean) -- line: 11
		-- upvalues: v4 (copy), EventConstants (copy), interactionEventName (copy)
		local t1 = {
			dialog_opened_type = p1,
			dialog_opened_type_internal_id = s1,
			dialog_opened_is_expired = b1
		}

		v4:sendEventDeferred(EventConstants.context.dialogOpened, interactionEventName, t1)
	end,
	sendDialogActionSelectedEvent = function(p2, s2: string, p3) -- line: 20
		-- upvalues: v4 (copy), EventConstants (copy), interactionEventName (copy)
		local t2 = {
			dialog_action_selected_type = p2,
			dialog_action_selected_type_internal_id = s2,
			dialog_action_selected_action = p3
		}

		v4:sendEventDeferred(EventConstants.context.dialogActionSelected, interactionEventName, t2)
	end,
	sendDialogAbandonedEvent = function(p4, s3: string) -- line: 29
		-- upvalues: v4 (copy), EventConstants (copy), interactionEventName (copy)
		local t3 = {
			dialog_abandoned_type = p4,
			dialog_abandoned_type_internal_id = s3
		}

		v4:sendEventDeferred(EventConstants.context.dialogAbandoned, interactionEventName, t3)
	end
}
