local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local computeImpactedUserCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/computeImpactedUserCount")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/LoaderContext")
local reportHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/reportHelper")
local useVoiceSnapshot = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/Enrichment/useVoiceSnapshot").useVoiceSnapshot

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/appendReportAnythingTags")

local submitVoiceReport = reportHelper.submitVoiceReport
local submitChatReport = reportHelper.submitChatReport
local submitChatReportWithoutMessage = reportHelper.submitChatReportWithoutMessage
local submitAvatarReport = reportHelper.submitAvatarReport
local submitPlaceReport = reportHelper.submitPlaceReport

return {
	useInExpCustomSubmit = function(data)
		local v5 = useVoiceSnapshot(data.voiceChatServiceManager)

		return React.useCallback(function(p2)
			if not p2.endpoint then
				error("SubmissionConfig must have an endpoint")
			end

			if p2.endpoint == "voice" then
				local current = v5.current
				return submitVoiceReport(p2, {
					sortedPlayerListUserIds = current.sortedPlayerListUserIds,
					channelId = current.channelId,
					voiceUserCount = current.voiceUserCount,
					voiceImpactedUserCount = computeImpactedUserCount(data.voiceChatServiceManager, p2.data.targetIdStr),
					menuOpenedUnixMilli = data.menuOpenTimeRef.current
				})
			elseif p2.endpoint == "chat" then
				local inExpChatMessagesLoader = data.inExpChatMessagesLoader

				if not inExpChatMessagesLoader then
					return Promise.reject("inExpChatMessagesLoader is required for chat reports")
				end

				local textChatMessageId = p2.data.custom and p2.data.custom.textChatMessageId

				if textChatMessageId == "__MSG_NOT_SHOWN_ID" then
					return submitChatReportWithoutMessage(p2)
				end

				return inExpChatMessagesLoader.fetch({}):andThen(function(options)
					local v6 = {}
					local v7 = {}

					for i, v8 in ipairs(options or {}) do
						for j, v9 in ipairs(v8.items or {}) do
							table.insert(v6, {
								channel = v9.meta.textChannel,
								messageId = v9.id
							})

							if v9.id == textChatMessageId then
								table.insert(v7, {
									channel = v9.meta.textChannel,
									messageId = v9.id,
									presetId = v9.meta.presetId,
									presetChatVersion = v9.meta.presetChatVersion
								})
							end
						end
					end

					return submitChatReport(p2, {
						eligibleMessages = v6,
						targetMessages = v7
					})
				end)
			else
				if p2.endpoint == "avatar" then
					return submitAvatarReport(
						p2,
						data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current
					)
				end

				if p2.endpoint == "place" then
					return submitPlaceReport(
						p2,
						data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current
					)
				end

				return Promise.reject("Unknown in-experience submission endpoint: " .. tostring(p2.endpoint))
			end
		end, {
			data.voiceChatServiceManager,
			data.inExpChatMessagesLoader,
			data.menuOpenTimeRef,
			data.reportAnythingSnapshotRef
		})
	end,
	useInExpClientActionHandlers = function(data)
		local v5 = useVoiceSnapshot(data.voiceChatServiceManager)

		local v6 = React.useCallback(function(p2)
			local current = v5.current
			return submitVoiceReport(p2, {
				sortedPlayerListUserIds = current.sortedPlayerListUserIds,
				channelId = current.channelId,
				voiceUserCount = current.voiceUserCount,
				voiceImpactedUserCount = computeImpactedUserCount(data.voiceChatServiceManager, p2.data.targetIdStr),
				menuOpenedUnixMilli = data.menuOpenTimeRef.current
			})
		end, { data.voiceChatServiceManager, data.menuOpenTimeRef })

		local v7 = React.useCallback(function(p2)
			local inExpChatMessagesLoader = data.inExpChatMessagesLoader

			if not inExpChatMessagesLoader then
				return Promise.reject("inExpChatMessagesLoader is required for chat reports")
			end

			local textChatMessageId = p2.data.custom and p2.data.custom.textChatMessageId

			if textChatMessageId == "__MSG_NOT_SHOWN_ID" then
				return submitChatReportWithoutMessage(p2)
			end

			return inExpChatMessagesLoader.fetch({}):andThen(function(options)
				local v8 = {}
				local v9 = {}

				for i, v10 in ipairs(options or {}) do
					for j, v11 in ipairs(v10.items or {}) do
						table.insert(v8, {
							channel = v11.meta.textChannel,
							messageId = v11.id
						})

						if v11.id == textChatMessageId then
							table.insert(v9, {
								channel = v11.meta.textChannel,
								messageId = v11.id,
								presetId = v11.meta.presetId,
								presetChatVersion = v11.meta.presetChatVersion
							})
						end
					end
				end

				return submitChatReport(p2, {
					eligibleMessages = v8,
					targetMessages = v9
				})
			end)
		end, { data.inExpChatMessagesLoader })

		local v8 = React.useCallback(function(p2)
			return submitAvatarReport(
				p2,
				data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current
			)
		end, { data.reportAnythingSnapshotRef })

		local v9 = React.useCallback(function(p2)
			return submitPlaceReport(
				p2,
				data.reportAnythingSnapshotRef and data.reportAnythingSnapshotRef.current
			)
		end, { data.reportAnythingSnapshotRef })

		local v10 = React.useCallback(function(p2)
			return submitChatReportWithoutMessage(p2)
		end, {})

		return (React.useMemo(function()
			return {
				voice = v6,
				chat = v7,
				avatar = v8,
				place = v9,
				legacyChat = v10
			}
		end, { v6, v7, v8, v9, v10 }))
	end,
	REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = "__MSG_NOT_SHOWN_ID"
}
