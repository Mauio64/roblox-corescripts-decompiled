local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Promise = require(GenericAbuseReportingParent.Promise)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local appendReportAnythingTags = require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags).appendReportAnythingTags

local function tag(s1: string?) -- line: 46
	if not s1 then
		return nil
	end

	return {
		valueList = {{
			data = s1
		}}
	}
end
local function buildVoiceReport(p1, t1: {[any]: any}?) -- line: 53
	-- upvalues: Players (copy), HttpService (copy), tag (copy)
	local t2 = {}

	if t1 then
		for _, v in ipairs(t1.sortedPlayerListUserIds) do
			table.insert(t2, {
				data = tostring(v)
			})
		end
	end

	local LocalPlayer = Players.LocalPlayer

	return HttpService:JSONEncode({
		tags = {
			ENTRY_POINT = tag("in-experience"),
			SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
			REPORT_TARGET_USER_ID = tag(p1.data.targetIdStr),
			REPORTED_ABUSE_CATEGORY = tag(p1.data.category),
			REPORTER_COMMENT = tag(p1.data.comment or ""),
			IS_PLACE_VOICE_ENABLED = tag("true"),
			VOICE_USER_IDS_FROM_CLIENT = {
				valueList = t2
			},
			IN_EXP_MENU_OPENED_UNIX_MILLI = tag((tostring(t1 and t1.menuOpenedUnixMilli or 0))),
			VOICE_CHANNEL_ID = tag(t1 and t1.channelId or ""),
			VOICE_USER_COUNT = tag((tostring(t1 and t1.voiceUserCount or 0))),
			VOICE_IMPACTED_USER_COUNT = tag((tostring(t1 and t1.voiceImpactedUserCount or 0))),
			REPORTED_ABUSE_VECTOR = tag(p1.data.abuseVector)
		}
	})
end
local function buildChatReport(p2, t3: {[any]: any}) -- line: 82
	-- upvalues: Players (copy), tag (copy)
	local LocalPlayer = Players.LocalPlayer
	local v22 = t3.targetMessages and (not not t3.targetMessages[1] and t3.targetMessages[1].messageId) or ""
	local v23 = t3.targetMessages and (not not t3.targetMessages[1] and t3.targetMessages[1].presetId) or nil
	local v24 = t3.targetMessages and (not not t3.targetMessages[1] and t3.targetMessages[1].presetChatVersion) or nil

	return {
		tags = {
			ENTRY_POINT = tag("in-experience"),
			SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
			REPORT_TARGET_USER_ID = tag(p2.data.targetIdStr),
			REPORTED_ABUSE_CATEGORY = tag(p2.data.category),
			REPORTER_COMMENT = tag(p2.data.comment or ""),
			REPORTED_ABUSE_VECTOR = tag(p2.data.abuseVector),
			REPORT_TARGET_MESSAGE_ID = tag(v22),
			PRESET_ID = tag(v23),
			PRESET_CHAT_VERSION = tag(v24),
			VARIANT = tag("IGM_CLRv2")
		}
	}
end
local function buildAvatarReport(p3, p4) -- line: 112
	-- upvalues: Players (copy), tag (copy), appendReportAnythingTags (copy)
	local LocalPlayer = Players.LocalPlayer
	local t4 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
		REPORT_TARGET_USER_ID = tag(p3.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p3.data.category),
		REPORTER_COMMENT = tag(p3.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p3.data.abuseVector)
	}

	appendReportAnythingTags(t4, p4)

	return {
		tags = t4
	}
end
local function buildPlaceReport(p5, p6) -- line: 129
	-- upvalues: Players (copy), tag (copy), appendReportAnythingTags (copy), HttpService (copy)
	local LocalPlayer = Players.LocalPlayer
	local t5 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
		PLACE_ID = tag((tostring(game.PlaceId))),
		REPORTED_ABUSE_CATEGORY = tag(p5.data.category),
		REPORTER_COMMENT = tag(p5.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p5.data.abuseVector)
	}

	appendReportAnythingTags(t5, p6)

	return HttpService:JSONEncode({
		tags = t5
	})
end

return {
	submitVoiceReport = function(p7, t6: {[any]: any}?) -- line: 155
		-- upvalues: buildVoiceReport (copy), Promise (copy), Players (copy)
		local v35 = buildVoiceReport(p7, t6)

		return Promise.try(function() -- line: 157
			-- upvalues: Players (copy), v35 (copy)
			Players:ReportAbuseV3(Players.LocalPlayer, v35)

			return {
				responseBody = {}
			}
		end)
	end,
	submitChatReport = function(p8, t7: {[any]: any}) -- line: 163
		-- upvalues: buildChatReport (copy), Promise (copy), Players (copy)
		local v38 = buildChatReport(p8, t7)

		return Promise.try(function() -- line: 165
			-- upvalues: Players (copy), t7 (copy), v38 (copy)
			Players:ReportChatAbuse(t7.eligibleMessages, t7.targetMessages, v38)

			return {
				responseBody = {}
			}
		end)
	end,
	submitChatReportWithoutMessage = function(p9) -- line: 171
		-- upvalues: Promise (copy), Players (copy)
		return Promise.try(function() -- line: 172
			-- upvalues: p9 (copy), Players (copy)
			local num = tonumber(p9.data.targetIdStr)
			local v47 = num and Players:GetPlayerByUserId(num)

			Players:ReportAbuse(v47, p9.data.category, p9.data.comment or "")

			return {
				responseBody = {}
			}
		end)
	end,
	submitAvatarReport = function(p10, p11) -- line: 180
		-- upvalues: buildAvatarReport (copy), Promise (copy), Players (copy)
		local v42 = buildAvatarReport(p10, p11)

		return Promise.try(function() -- line: 182
			-- upvalues: Players (copy), p10 (copy), v42 (copy)
			Players:ReportAvatarAbuse(tonumber(p10.data.targetIdStr), v42)

			return {
				responseBody = {}
			}
		end)
	end,
	submitPlaceReport = function(p12, p13) -- line: 188
		-- upvalues: buildPlaceReport (copy), Promise (copy), Players (copy)
		local v45 = buildPlaceReport(p12, p13)

		return Promise.try(function() -- line: 190
			-- upvalues: Players (copy), v45 (copy)
			Players:ReportAbuseV3(Players.LocalPlayer, v45)

			return {
				responseBody = {}
			}
		end)
	end,
	buildVoiceReport = buildVoiceReport,
	buildChatReport = buildChatReport,
	buildAvatarReport = buildAvatarReport,
	buildPlaceReport = buildPlaceReport
}
