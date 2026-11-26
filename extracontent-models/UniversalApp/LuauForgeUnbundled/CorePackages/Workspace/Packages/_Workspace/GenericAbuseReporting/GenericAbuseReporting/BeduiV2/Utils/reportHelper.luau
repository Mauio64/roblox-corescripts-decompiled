local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local GetHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GetHumanoidDescription")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Promise")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/appendReportAnythingTags")

local fFlagEnableChatReportingTextChannelTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagEnableChatReportingTextChannelTag
local getFFlagGetHumanoidDescriptionUpdatesV2E = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").GetFFlagGetHumanoidDescriptionUpdatesV2E
local FFlagAbuseReportForwardCustomTagFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportForwardCustomTagFields")

local FFlagGenericAbuseReportingAvatarHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagGenericAbuseReportingAvatarHumanoidDescription")

local appendReportAnythingTags = module3.appendReportAnythingTags
local getHumanoidDescription = GetHumanoidDescription.getHumanoidDescription

local function tag(p2)
	if p2 then
		return {
			valueList = {
				{ data = p2 }
			}
		}
	end

	return nil
end

local function isAllCapsKey(value): boolean
	return typeof(value) == "string" and string.match(value, "^[A-Z_][A-Z0-9_]*$") ~= nil
end

local function appendCustomTagFields(p2, p3)
	local custom = p3.data.custom

	if not custom then
		return
	end

	for k, v5 in pairs(custom) do
		local v6 = typeof(k) == "string" and string.match(k, "^[A-Z_][A-Z0-9_]*$") ~= nil

		if not v6 then
			continue
		end

		local typeName = typeof(v5)

		if typeName == "string" or typeName == "number" or typeName == "boolean" then
			p2[k] = tag(tostring(v5))
		end
	end
end

local function buildVoiceReport(p2, data)
	local v5 = {}

	if data then
		for i, sortedPlayerListUserId in ipairs(data.sortedPlayerListUserIds) do
			table.insert(v5, {
				data = tostring(sortedPlayerListUserId)
			})
		end
	end

	local localPlayer = Players.LocalPlayer
	local v6 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
		REPORT_TARGET_USER_ID = tag(p2.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p2.data.category),
		REPORTER_COMMENT = tag(p2.data.comment or ""),
		IS_PLACE_VOICE_ENABLED = tag("true"),
		VOICE_USER_IDS_FROM_CLIENT = { valueList = v5 },
		IN_EXP_MENU_OPENED_UNIX_MILLI = tag(tostring(data and data.menuOpenedUnixMilli or 0)),
		VOICE_CHANNEL_ID = tag(data and data.channelId or ""),
		VOICE_USER_COUNT = tag(tostring(data and data.voiceUserCount or 0)),
		VOICE_IMPACTED_USER_COUNT = tag(tostring(data and data.voiceImpactedUserCount or 0)),
		REPORTED_ABUSE_VECTOR = tag(p2.data.abuseVector)
	}

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(v6, p2)
	end

	return HttpService:JSONEncode({ tags = v6 })
end

local function buildChatReport(p2, p3)
	local localPlayer = Players.LocalPlayer
	local messageId = p3.targetMessages and p3.targetMessages[1] and p3.targetMessages[1].messageId or ""
	local presetId

	if p3.targetMessages and p3.targetMessages[1] then
		presetId = p3.targetMessages[1].presetId or nil
	end

	local v5

	if p3.targetMessages and p3.targetMessages[1] then
		v5 = p3.targetMessages[1].presetChatVersion or nil
	end

	local chatReport = {
		tags = {
			ENTRY_POINT = tag("in-experience"),
			SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
			REPORT_TARGET_USER_ID = tag(p2.data.targetIdStr),
			REPORTED_ABUSE_CATEGORY = tag(p2.data.category),
			REPORTER_COMMENT = tag(p2.data.comment or ""),
			REPORTED_ABUSE_VECTOR = tag(p2.data.abuseVector),
			REPORT_TARGET_MESSAGE_ID = tag(messageId),
			PRESET_ID = tag(presetId),
			PRESET_CHAT_VERSION = tag(v5),
			VARIANT = tag("IGM_CLRv2")
		}
	}

	if fFlagEnableChatReportingTextChannelTag then
		local channel = p3.targetMessages and p3.targetMessages[1] and p3.targetMessages[1].channel

		local v6 = not channel and "RBXGlobal" or channel.Name
		chatReport.tags.IN_GAME_CHAT_TEXT_CHANNEL = tag(v6)
	end

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(chatReport.tags, p2)
	end

	return chatReport
end

local function getTargetHumanoidDescription(p2, p3)
	if getFFlagGetHumanoidDescriptionUpdatesV2E() and p3 then
		local identifiedAvatar = p3.identificationResults.identifiedAvatars[p2]

		if
			identifiedAvatar
			and identifiedAvatar.humanoidDescription
			and identifiedAvatar.humanoidDescriptionStatus == "OK"
		then
			return identifiedAvatar.humanoidDescription, identifiedAvatar.humanoidDescriptionStatus
		end
	end

	return getHumanoidDescription(p2)
end

local function buildAvatarReport(p2, p3)
	local localPlayer = Players.LocalPlayer
	local v5 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
		REPORT_TARGET_USER_ID = tag(p2.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p2.data.category),
		REPORTER_COMMENT = tag(p2.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p2.data.abuseVector)
	}

	appendReportAnythingTags(v5, p3)
	local targetIdStr = tonumber(p2.data.targetIdStr)

	if FFlagGenericAbuseReportingAvatarHumanoidDescription and targetIdStr then
		local v6, v7

		if getFFlagGetHumanoidDescriptionUpdatesV2E() and p3 then
			local identifiedAvatar = p3.identificationResults.identifiedAvatars[targetIdStr]

			if
				identifiedAvatar
				and identifiedAvatar.humanoidDescription
				and identifiedAvatar.humanoidDescriptionStatus == "OK"
			then
				v6 = identifiedAvatar.humanoidDescription
				v7 = identifiedAvatar.humanoidDescriptionStatus
			else
				v6, v7 = getHumanoidDescription(targetIdStr)
			end
		else
			v6, v7 = getHumanoidDescription(targetIdStr)
		end

		v5.REPORT_TARGET_HUMANOID_DESCRIPTION = tag(HttpService:JSONEncode(v6))
		v5.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = tag(v7)
	end

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(v5, p2)
	end

	return { tags = v5 }
end

local function buildPlaceReport(p2, p3)
	local localPlayer = Players.LocalPlayer
	local v5 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
		PLACE_ID = tag(tostring(game.PlaceId)),
		REPORTED_ABUSE_CATEGORY = tag(p2.data.category),
		REPORTER_COMMENT = tag(p2.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p2.data.abuseVector)
	}

	appendReportAnythingTags(v5, p3)

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(v5, p2)
	end

	return HttpService:JSONEncode({ tags = v5 })
end

return {
	submitVoiceReport = function(p2, p3)
		local voiceReport = buildVoiceReport(p2, p3)
		return Promise.try(function()
			Players:ReportAbuseV3(Players.LocalPlayer, voiceReport)
			return { responseBody = {} }
		end)
	end,
	submitChatReport = function(p2, p3)
		local chatReport = buildChatReport(p2, p3)
		return Promise.try(function()
			Players:ReportChatAbuse(p3.eligibleMessages, p3.targetMessages, chatReport)
			return { responseBody = {} }
		end)
	end,
	submitChatReportWithoutMessage = function(p2)
		return Promise.try(function()
			local targetIdStr = tonumber(p2.data.targetIdStr)
			local playerByUserId = targetIdStr and Players:GetPlayerByUserId(targetIdStr)
			Players:ReportAbuse(playerByUserId, p2.data.category, p2.data.comment or "")
			return { responseBody = {} }
		end)
	end,
	submitAvatarReport = function(p2, p3)
		if FFlagGenericAbuseReportingAvatarHumanoidDescription then
			return Promise.try(function()
				local avatarReport = buildAvatarReport(p2, p3)
				Players:ReportAvatarAbuse(tonumber(p2.data.targetIdStr), avatarReport)
				return { responseBody = {} }
			end)
		end

		local avatarReport = buildAvatarReport(p2, p3)
		return Promise.try(function()
			Players:ReportAvatarAbuse(tonumber(p2.data.targetIdStr), avatarReport)
			return { responseBody = {} }
		end)
	end,
	submitPlaceReport = function(p2, p3)
		local placeReport = buildPlaceReport(p2, p3)
		return Promise.try(function()
			Players:ReportAbuseV3(Players.LocalPlayer, placeReport)
			return { responseBody = {} }
		end)
	end,
	buildVoiceReport = buildVoiceReport,
	buildChatReport = buildChatReport,
	buildAvatarReport = buildAvatarReport,
	buildPlaceReport = buildPlaceReport
}
