local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local GetHumanoidDescription = require(parent.GetHumanoidDescription)
local Promise = require(parent.Promise)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local appendReportAnythingTags = require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableChatReportingTextChannelTag = SharedFlags.FFlagEnableChatReportingTextChannelTag
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagGetHumanoidDescriptionUpdatesV2E = SharedFlags2.GetFFlagGetHumanoidDescriptionUpdatesV2E
local FFlagAbuseReportForwardCustomTagFields = require(GenericAbuseReporting.Flags.FFlagAbuseReportForwardCustomTagFields)

local FFlagGenericAbuseReportingAvatarHumanoidDescription = require(GenericAbuseReporting.Flags.FFlagGenericAbuseReportingAvatarHumanoidDescription)

local appendReportAnythingTags2 = appendReportAnythingTags.appendReportAnythingTags
local getHumanoidDescription = GetHumanoidDescription.getHumanoidDescription

local function tag(p: string?)
	if p then
		return {
			valueList = {
				{ data = p }
			}
		}
	end

	return nil
end

local function isAllCapsKey(value: string): boolean -- 1 equivalent call inferred from this helper
	return typeof(value) == "string" and string.match(value, "^[A-Z_][A-Z0-9_]*$") ~= nil
end

local function appendCustomTagFields(p, p2)
	local custom = p2.data.custom

	if not custom then
		return
	end

	for k, v in pairs(custom) do
		if not isAllCapsKey(k) then -- inferred equivalent call
			continue
		end

		local typeName = typeof(v)

		if typeName == "string" or typeName == "number" or typeName == "boolean" then
			p[k] = tag(tostring(v))
		end
	end
end

local function buildVoiceReport(p, data)
	local valueList = {}

	if data then
		for _, sortedPlayerListUserId in ipairs(data.sortedPlayerListUserIds) do
			table.insert(valueList, {
				data = tostring(sortedPlayerListUserId)
			})
		end
	end

	local localPlayer = Players.LocalPlayer
	local tags = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
		REPORT_TARGET_USER_ID = tag(p.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p.data.category),
		REPORTER_COMMENT = tag(p.data.comment or ""),
		IS_PLACE_VOICE_ENABLED = tag("true"),
		VOICE_USER_IDS_FROM_CLIENT = { valueList = valueList },
		IN_EXP_MENU_OPENED_UNIX_MILLI = tag(tostring(data and data.menuOpenedUnixMilli or 0)),
		VOICE_CHANNEL_ID = tag(data and data.channelId or ""),
		VOICE_USER_COUNT = tag(tostring(data and data.voiceUserCount or 0)),
		VOICE_IMPACTED_USER_COUNT = tag(tostring(data and data.voiceImpactedUserCount or 0)),
		REPORTED_ABUSE_VECTOR = tag(p.data.abuseVector)
	}

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(tags, p)
	end

	return HttpService:JSONEncode({ tags = tags })
end

local function buildChatReport(p, p2)
	local localPlayer = Players.LocalPlayer
	local messageId = p2.targetMessages and p2.targetMessages[1] and p2.targetMessages[1].messageId or ""
	local presetId

	if p2.targetMessages and p2.targetMessages[1] then
		presetId = p2.targetMessages[1].presetId or nil
	end

	local v

	if p2.targetMessages and p2.targetMessages[1] then
		v = p2.targetMessages[1].presetChatVersion or nil
	end

	local chatReport = {
		tags = {
			ENTRY_POINT = tag("in-experience"),
			SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
			REPORT_TARGET_USER_ID = tag(p.data.targetIdStr),
			REPORTED_ABUSE_CATEGORY = tag(p.data.category),
			REPORTER_COMMENT = tag(p.data.comment or ""),
			REPORTED_ABUSE_VECTOR = tag(p.data.abuseVector),
			REPORT_TARGET_MESSAGE_ID = tag(messageId),
			PRESET_ID = tag(presetId),
			PRESET_CHAT_VERSION = tag(v),
			VARIANT = tag("IGM_CLRv2")
		}
	}

	if FFlagEnableChatReportingTextChannelTag then
		local channel = p2.targetMessages and p2.targetMessages[1] and p2.targetMessages[1].channel

		local v2 = not channel and "RBXGlobal" or channel.Name
		chatReport.tags.IN_GAME_CHAT_TEXT_CHANNEL = tag(v2)
	end

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(chatReport.tags, p)
	end

	return chatReport
end

local function getTargetHumanoidDescription(p: number, p2)
	if GetFFlagGetHumanoidDescriptionUpdatesV2E() and p2 then
		local identifiedAvatar = p2.identificationResults.identifiedAvatars[p]

		if
			identifiedAvatar
			and identifiedAvatar.humanoidDescription
			and identifiedAvatar.humanoidDescriptionStatus == "OK"
		then
			return identifiedAvatar.humanoidDescription, identifiedAvatar.humanoidDescriptionStatus
		end
	end

	return getHumanoidDescription(p)
end

local function buildAvatarReport(p, p2)
	local localPlayer = Players.LocalPlayer
	local tags = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
		REPORT_TARGET_USER_ID = tag(p.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p.data.category),
		REPORTER_COMMENT = tag(p.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p.data.abuseVector)
	}

	appendReportAnythingTags2(tags, p2)
	local targetIdStr = tonumber(p.data.targetIdStr)

	if FFlagGenericAbuseReportingAvatarHumanoidDescription and targetIdStr then
		local v, v2

		if GetFFlagGetHumanoidDescriptionUpdatesV2E() and p2 then
			local identifiedAvatar = p2.identificationResults.identifiedAvatars[targetIdStr]

			if
				identifiedAvatar
				and identifiedAvatar.humanoidDescription
				and identifiedAvatar.humanoidDescriptionStatus == "OK"
			then
				v = identifiedAvatar.humanoidDescription
				v2 = identifiedAvatar.humanoidDescriptionStatus
			else
				v, v2 = getHumanoidDescription(targetIdStr)
			end
		else
			v, v2 = getHumanoidDescription(targetIdStr)
		end

		tags.REPORT_TARGET_HUMANOID_DESCRIPTION = tag(HttpService:JSONEncode(v))
		tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = tag(v2)
	end

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(tags, p)
	end

	return { tags = tags }
end

local function buildPlaceReport(p, p2)
	local localPlayer = Players.LocalPlayer
	local tags = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag(tostring(localPlayer and localPlayer.UserId or 0)),
		PLACE_ID = tag(tostring(game.PlaceId)),
		REPORTED_ABUSE_CATEGORY = tag(p.data.category),
		REPORTER_COMMENT = tag(p.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p.data.abuseVector)
	}

	appendReportAnythingTags2(tags, p2)

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(tags, p)
	end

	return HttpService:JSONEncode({ tags = tags })
end

local ReportHelper = {}

function ReportHelper.submitVoiceReport(p, p2)
	local voiceReport = buildVoiceReport(p, p2)
	return Promise.try(function()
		Players:ReportAbuseV3(Players.LocalPlayer, voiceReport)
		return { responseBody = {} }
	end)
end

function ReportHelper.submitChatReport(p, p2)
	local chatReport = buildChatReport(p, p2)
	return Promise.try(function()
		Players:ReportChatAbuse(p2.eligibleMessages, p2.targetMessages, chatReport)
		return { responseBody = {} }
	end)
end

function ReportHelper.submitChatReportWithoutMessage(p)
	return Promise.try(function()
		local targetIdStr = tonumber(p.data.targetIdStr)
		local playerByUserId = targetIdStr and Players:GetPlayerByUserId(targetIdStr)
		Players:ReportAbuse(playerByUserId, p.data.category, p.data.comment or "")
		return { responseBody = {} }
	end)
end

function ReportHelper.submitAvatarReport(p, p2)
	if FFlagGenericAbuseReportingAvatarHumanoidDescription then
		return Promise.try(function()
			local avatarReport = buildAvatarReport(p, p2)
			Players:ReportAvatarAbuse(tonumber(p.data.targetIdStr), avatarReport)
			return { responseBody = {} }
		end)
	end

	local avatarReport = buildAvatarReport(p, p2)
	return Promise.try(function()
		Players:ReportAvatarAbuse(tonumber(p.data.targetIdStr), avatarReport)
		return { responseBody = {} }
	end)
end

function ReportHelper.submitPlaceReport(p, p2)
	local placeReport = buildPlaceReport(p, p2)
	return Promise.try(function()
		Players:ReportAbuseV3(Players.LocalPlayer, placeReport)
		return { responseBody = {} }
	end)
end

ReportHelper.buildVoiceReport = buildVoiceReport
ReportHelper.buildChatReport = buildChatReport
ReportHelper.buildAvatarReport = buildAvatarReport
ReportHelper.buildPlaceReport = buildPlaceReport
return ReportHelper
