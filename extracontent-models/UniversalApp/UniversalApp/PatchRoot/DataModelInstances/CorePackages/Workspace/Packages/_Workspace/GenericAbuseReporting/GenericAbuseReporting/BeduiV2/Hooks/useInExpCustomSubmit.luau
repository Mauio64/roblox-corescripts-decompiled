local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Promise = require(GenericAbuseReportingParent.Promise)
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local computeImpactedUserCount = require(GenericAbuseReporting.BeduiV2.Utils.computeImpactedUserCount)

require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)

local reportHelper = require(GenericAbuseReporting.BeduiV2.Utils.reportHelper)
local useVoiceSnapshot = require(GenericAbuseReporting.BeduiV2.Hooks.Enrichment.useVoiceSnapshot).useVoiceSnapshot

require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags)

local submitVoiceReport = reportHelper.submitVoiceReport
local submitChatReport = reportHelper.submitChatReport
local submitChatReportWithoutMessage = reportHelper.submitChatReportWithoutMessage
local submitAvatarReport = reportHelper.submitAvatarReport
local submitPlaceReport = reportHelper.submitPlaceReport

return {
	REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = "__MSG_NOT_SHOWN_ID",
	useInExpCustomSubmit = function(t1: {[any]: any}) -- line: 41
		-- upvalues: useVoiceSnapshot (copy), React (copy), computeImpactedUserCount (copy), submitVoiceReport (copy), Promise (copy), submitChatReportWithoutMessage (copy), submitChatReport (copy), submitAvatarReport (copy), submitPlaceReport (copy)
		local v14 = useVoiceSnapshot(t1.voiceChatServiceManager)

		return React.useCallback(function(p1) -- line: 45
			-- upvalues: v14 (copy), computeImpactedUserCount (copy), t1 (copy), submitVoiceReport (copy), Promise (copy), submitChatReportWithoutMessage (copy), submitChatReport (copy), submitAvatarReport (copy), submitPlaceReport (copy)
			if not p1.endpoint then
				error("SubmissionConfig must have an endpoint")
			end

			if p1.endpoint == "voice" then
				local current = v14.current
				local t2 = {
					sortedPlayerListUserIds = current.sortedPlayerListUserIds,
					channelId = current.channelId,
					voiceUserCount = current.voiceUserCount,
					voiceImpactedUserCount = computeImpactedUserCount(t1.voiceChatServiceManager, p1.data.targetIdStr),
					menuOpenedUnixMilli = t1.menuOpenTimeRef.current
				}

				return submitVoiceReport(p1, t2)
			end

			if p1.endpoint == "chat" then
				local inExpChatMessagesLoader = t1.inExpChatMessagesLoader

				if not inExpChatMessagesLoader then
					return Promise.reject("inExpChatMessagesLoader is required for chat reports")
				end

				local v19 = p1.data.custom and p1.data.custom.textChatMessageId

				if v19 == "__MSG_NOT_SHOWN_ID" then
					return submitChatReportWithoutMessage(p1)
				end

				return inExpChatMessagesLoader.fetch({}):andThen(function(p2) -- line: 91
					-- upvalues: v19 (copy), submitChatReport (copy), p1 (copy)
					local t3 = {}
					local t4 = {}

					for _, v in ipairs(p2 or {}) do
						for _, v2 in ipairs(v.items or {}) do
							table.insert(t3, {
								channel = v2.meta.textChannel,
								messageId = v2.id
							})

							if v2.id == v19 then
								table.insert(t4, {
									channel = v2.meta.textChannel,
									messageId = v2.id,
									presetId = v2.meta.presetId,
									presetChatVersion = v2.meta.presetChatVersion
								})
							end
						end
					end

					return submitChatReport(p1, {
						eligibleMessages = t3,
						targetMessages = t4
					})
				end)
			end

			if p1.endpoint == "avatar" then
				return submitAvatarReport(p1, t1.reportAnythingSnapshotRef and t1.reportAnythingSnapshotRef.current)
			end

			if p1.endpoint == "place" then
				return submitPlaceReport(p1, t1.reportAnythingSnapshotRef and t1.reportAnythingSnapshotRef.current)
			end

			return Promise.reject("Unknown in-experience submission endpoint: " .. tostring(p1.endpoint))
		end, {
			t1.voiceChatServiceManager,
			t1.inExpChatMessagesLoader,
			t1.menuOpenTimeRef,
			t1.reportAnythingSnapshotRef
		})
	end
}
