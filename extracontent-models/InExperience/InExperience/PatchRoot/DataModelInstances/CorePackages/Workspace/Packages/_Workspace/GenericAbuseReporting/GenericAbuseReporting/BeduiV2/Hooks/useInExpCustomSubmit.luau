local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Promise = require(parent.Promise)
local React = require(parent.React)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local computeImpactedUserCount = require(GenericAbuseReporting.BeduiV2.Utils.computeImpactedUserCount)
require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local reportHelper = require(GenericAbuseReporting.BeduiV2.Utils.reportHelper)
local useVoiceSnapshot = require(GenericAbuseReporting.BeduiV2.Hooks.Enrichment.useVoiceSnapshot)
local useVoiceSnapshot2 = useVoiceSnapshot.useVoiceSnapshot

require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags)

local submitVoiceReport = reportHelper.submitVoiceReport
local submitChatReport = reportHelper.submitChatReport
local submitChatReportWithoutMessage = reportHelper.submitChatReportWithoutMessage
local submitAvatarReport = reportHelper.submitAvatarReport
local submitPlaceReport = reportHelper.submitPlaceReport
local UseInExpCustomSubmit = {}

function UseInExpCustomSubmit.useInExpCustomSubmit(data)
	local v = useVoiceSnapshot2(data.voiceChatServiceManager)

	return React.useCallback(function(p)
		if not p.endpoint then
			error("SubmissionConfig must have an endpoint")
		end

		if p.endpoint == "voice" then
			local current = v.current
			return submitVoiceReport(p, {
				sortedPlayerListUserIds = current.sortedPlayerListUserIds,
				channelId = current.channelId,
				voiceUserCount = current.voiceUserCount,
				voiceImpactedUserCount = computeImpactedUserCount(data.voiceChatServiceManager, p.data.targetIdStr),
				menuOpenedUnixMilli = data.menuOpenTimeRef.current
			})
		elseif p.endpoint == "chat" then
			local inExpChatMessagesLoader = data.inExpChatMessagesLoader

			if not inExpChatMessagesLoader then
				return Promise.reject("inExpChatMessagesLoader is required for chat reports")
			end

			local textChatMessageId = p.data.custom and p.data.custom.textChatMessageId

			if textChatMessageId == "__MSG_NOT_SHOWN_ID" then
				return submitChatReportWithoutMessage(p)
			end

			return inExpChatMessagesLoader.fetch({}):andThen(function(options)
				local eligibleMessages = {}
				local targetMessages = {}

				for _, v2 in ipairs(options or {}) do
					for _, v3 in ipairs(v2.items or {}) do
						table.insert(eligibleMessages, {
							channel = v3.meta.textChannel,
							messageId = v3.id
						})

						if v3.id == textChatMessageId then
							table.insert(targetMessages, {
								channel = v3.meta.textChannel,
								messageId = v3.id,
								presetId = v3.meta.presetId,
								presetChatVersion = v3.meta.presetChatVersion
							})
						end
					end
				end

				return submitChatReport(p, {
					eligibleMessages = eligibleMessages,
					targetMessages = targetMessages
				})
			end)
		else
			if p.endpoint == "avatar" then
				return submitAvatarReport(p, data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current)
			end

			if p.endpoint == "place" then
				return submitPlaceReport(p, data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current)
			end

			return Promise.reject("Unknown in-experience submission endpoint: " .. tostring(p.endpoint))
		end
	end, {
		data.voiceChatServiceManager,
		data.inExpChatMessagesLoader,
		data.menuOpenTimeRef,
		data.reportAnythingSnapshotRef
	})
end

function UseInExpCustomSubmit.useInExpClientActionHandlers(data)
	local v = useVoiceSnapshot2(data.voiceChatServiceManager)

	local voice = React.useCallback(function(p)
		local current = v.current
		return submitVoiceReport(p, {
			sortedPlayerListUserIds = current.sortedPlayerListUserIds,
			channelId = current.channelId,
			voiceUserCount = current.voiceUserCount,
			voiceImpactedUserCount = computeImpactedUserCount(data.voiceChatServiceManager, p.data.targetIdStr),
			menuOpenedUnixMilli = data.menuOpenTimeRef.current
		})
	end, { data.voiceChatServiceManager, data.menuOpenTimeRef })

	local chat = React.useCallback(function(p)
		local inExpChatMessagesLoader = data.inExpChatMessagesLoader

		if not inExpChatMessagesLoader then
			return Promise.reject("inExpChatMessagesLoader is required for chat reports")
		end

		local textChatMessageId = p.data.custom and p.data.custom.textChatMessageId

		if textChatMessageId == "__MSG_NOT_SHOWN_ID" then
			return submitChatReportWithoutMessage(p)
		end

		return inExpChatMessagesLoader.fetch({}):andThen(function(options)
			local eligibleMessages = {}
			local targetMessages = {}

			for _, v2 in ipairs(options or {}) do
				for _, v3 in ipairs(v2.items or {}) do
					table.insert(eligibleMessages, {
						channel = v3.meta.textChannel,
						messageId = v3.id
					})

					if v3.id == textChatMessageId then
						table.insert(targetMessages, {
							channel = v3.meta.textChannel,
							messageId = v3.id,
							presetId = v3.meta.presetId,
							presetChatVersion = v3.meta.presetChatVersion
						})
					end
				end
			end

			return submitChatReport(p, {
				eligibleMessages = eligibleMessages,
				targetMessages = targetMessages
			})
		end)
	end, { data.inExpChatMessagesLoader })

	local avatar = React.useCallback(function(p)
		return submitAvatarReport(p, data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current)
	end, { data.reportAnythingSnapshotRef })

	local place = React.useCallback(function(p)
		return submitPlaceReport(p, data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current)
	end, { data.reportAnythingSnapshotRef })

	local legacyChat = React.useCallback(function(p)
		return submitChatReportWithoutMessage(p)
	end, {})

	return (React.useMemo(function()
		return {
			voice = voice,
			chat = chat,
			avatar = avatar,
			place = place,
			legacyChat = legacyChat
		}
	end, { voice, chat, avatar, place, legacyChat }))
end

UseInExpCustomSubmit.REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = "__MSG_NOT_SHOWN_ID"
return UseInExpCustomSubmit
