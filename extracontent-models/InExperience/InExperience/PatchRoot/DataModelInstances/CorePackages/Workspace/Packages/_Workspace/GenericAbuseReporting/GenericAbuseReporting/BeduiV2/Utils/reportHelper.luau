local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Promise = require(GenericAbuseReportingParent.Promise)
local FFlagEnableChatReportingTextChannelTag = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableChatReportingTextChannelTag

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local appendReportAnythingTags = require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags)
local FFlagAbuseReportForwardCustomTagFields = require(GenericAbuseReporting.Flags.FFlagAbuseReportForwardCustomTagFields)
local appendReportAnythingTags2 = appendReportAnythingTags.appendReportAnythingTags

local function tag(s1: string?) -- line: 49
	if not s1 then
		return nil
	end

	return {
		valueList = {{
			data = s1
		}}
	}
end
local function isAllCapsKey(s2: string) -- line: 56
	return typeof(s2) == "string" and string.match(s2, "^[A-Z_][A-Z0-9_]*$") ~= nil
end
local function appendCustomTagFields(t1: {[any]: any}, p1) -- line: 60
	-- upvalues: tag (copy)
	local custom = p1.data.custom

	if not custom then
		return
	end

	for k, v in pairs(custom) do
		if typeof(k) == "string" and string.match(k, "^[A-Z_][A-Z0-9_]*$") ~= nil then
			local v24 = typeof(v)

			if v24 == "string" or v24 == "number" or v24 == "boolean" then
				t1[k] = tag((tostring(v)))
			end
		end
	end
end
local function buildVoiceReport(p2, t2: {[any]: any}?) -- line: 77
	-- upvalues: Players (copy), tag (copy), FFlagAbuseReportForwardCustomTagFields (copy), appendCustomTagFields (copy), HttpService (copy)
	local t3 = {}

	if t2 then
		for _, v in ipairs(t2.sortedPlayerListUserIds) do
			table.insert(t3, {
				data = tostring(v)
			})
		end
	end

	local LocalPlayer = Players.LocalPlayer
	local t4 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
		REPORT_TARGET_USER_ID = tag(p2.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p2.data.category),
		REPORTER_COMMENT = tag(p2.data.comment or ""),
		IS_PLACE_VOICE_ENABLED = tag("true"),
		VOICE_USER_IDS_FROM_CLIENT = {
			valueList = t3
		},
		IN_EXP_MENU_OPENED_UNIX_MILLI = tag((tostring(t2 and t2.menuOpenedUnixMilli or 0))),
		VOICE_CHANNEL_ID = tag(t2 and t2.channelId or ""),
		VOICE_USER_COUNT = tag((tostring(t2 and t2.voiceUserCount or 0))),
		VOICE_IMPACTED_USER_COUNT = tag((tostring(t2 and t2.voiceImpactedUserCount or 0))),
		REPORTED_ABUSE_VECTOR = tag(p2.data.abuseVector)
	}

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(t4, p2)
	end

	return HttpService:JSONEncode({
		tags = t4
	})
end
local function buildChatReport(p3, t5: {[any]: any}) -- line: 108
	-- upvalues: Players (copy), tag (copy), FFlagEnableChatReportingTextChannelTag (copy), FFlagAbuseReportForwardCustomTagFields (copy), appendCustomTagFields (copy)
	local LocalPlayer = Players.LocalPlayer
	local v35 = t5.targetMessages and (not not t5.targetMessages[1] and t5.targetMessages[1].messageId) or ""
	local v36 = t5.targetMessages and (not not t5.targetMessages[1] and t5.targetMessages[1].presetId) or nil
	local v37 = t5.targetMessages and (not not t5.targetMessages[1] and t5.targetMessages[1].presetChatVersion) or nil
	local t6 = {
		tags = {
			ENTRY_POINT = tag("in-experience"),
			SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
			REPORT_TARGET_USER_ID = tag(p3.data.targetIdStr),
			REPORTED_ABUSE_CATEGORY = tag(p3.data.category),
			REPORTER_COMMENT = tag(p3.data.comment or ""),
			REPORTED_ABUSE_VECTOR = tag(p3.data.abuseVector),
			REPORT_TARGET_MESSAGE_ID = tag(v35),
			PRESET_ID = tag(v36),
			PRESET_CHAT_VERSION = tag(v37),
			VARIANT = tag("IGM_CLRv2")
		}
	}

	if FFlagEnableChatReportingTextChannelTag then
		local v39 = t5.targetMessages and (t5.targetMessages[1] and t5.targetMessages[1].channel)
		local v40 = not v39 and "RBXGlobal" or v39.Name

		t6.tags.IN_GAME_CHAT_TEXT_CHANNEL = tag(v40)
	end

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(t6.tags, p3)
	end

	return t6
end
local function buildAvatarReport(p4, p5) -- line: 151
	-- upvalues: Players (copy), tag (copy), appendReportAnythingTags2 (copy), FFlagAbuseReportForwardCustomTagFields (copy), appendCustomTagFields (copy)
	local LocalPlayer = Players.LocalPlayer
	local t7 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
		REPORT_TARGET_USER_ID = tag(p4.data.targetIdStr),
		REPORTED_ABUSE_CATEGORY = tag(p4.data.category),
		REPORTER_COMMENT = tag(p4.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p4.data.abuseVector)
	}

	appendReportAnythingTags2(t7, p5)

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(t7, p4)
	end

	return {
		tags = t7
	}
end
local function buildPlaceReport(p6, p7) -- line: 171
	-- upvalues: Players (copy), tag (copy), appendReportAnythingTags2 (copy), FFlagAbuseReportForwardCustomTagFields (copy), appendCustomTagFields (copy), HttpService (copy)
	local LocalPlayer = Players.LocalPlayer
	local t8 = {
		ENTRY_POINT = tag("in-experience"),
		SUBMITTER_USER_ID = tag((tostring(LocalPlayer and LocalPlayer.UserId or 0))),
		PLACE_ID = tag((tostring(game.PlaceId))),
		REPORTED_ABUSE_CATEGORY = tag(p6.data.category),
		REPORTER_COMMENT = tag(p6.data.comment or ""),
		REPORTED_ABUSE_VECTOR = tag(p6.data.abuseVector)
	}

	appendReportAnythingTags2(t8, p7)

	if FFlagAbuseReportForwardCustomTagFields then
		appendCustomTagFields(t8, p6)
	end

	return HttpService:JSONEncode({
		tags = t8
	})
end

return {
	submitVoiceReport = function(p8, t9: {[any]: any}?) -- line: 200
		-- upvalues: buildVoiceReport (copy), Promise (copy), Players (copy)
		local v51 = buildVoiceReport(p8, t9)

		return Promise.try(function() -- line: 202
			-- upvalues: Players (copy), v51 (copy)
			Players:ReportAbuseV3(Players.LocalPlayer, v51)

			return {
				responseBody = {}
			}
		end)
	end,
	submitChatReport = function(p9, t10: {[any]: any}) -- line: 208
		-- upvalues: buildChatReport (copy), Promise (copy), Players (copy)
		local v54 = buildChatReport(p9, t10)

		return Promise.try(function() -- line: 210
			-- upvalues: Players (copy), t10 (copy), v54 (copy)
			Players:ReportChatAbuse(t10.eligibleMessages, t10.targetMessages, v54)

			return {
				responseBody = {}
			}
		end)
	end,
	submitChatReportWithoutMessage = function(p10) -- line: 216
		-- upvalues: Promise (copy), Players (copy)
		return Promise.try(function() -- line: 217
			-- upvalues: p10 (copy), Players (copy)
			local num = tonumber(p10.data.targetIdStr)
			local v63 = num and Players:GetPlayerByUserId(num)

			Players:ReportAbuse(v63, p10.data.category, p10.data.comment or "")

			return {
				responseBody = {}
			}
		end)
	end,
	submitAvatarReport = function(p11, p12) -- line: 225
		-- upvalues: buildAvatarReport (copy), Promise (copy), Players (copy)
		local v58 = buildAvatarReport(p11, p12)

		return Promise.try(function() -- line: 227
			-- upvalues: Players (copy), p11 (copy), v58 (copy)
			Players:ReportAvatarAbuse(tonumber(p11.data.targetIdStr), v58)

			return {
				responseBody = {}
			}
		end)
	end,
	submitPlaceReport = function(p13, p14) -- line: 233
		-- upvalues: buildPlaceReport (copy), Promise (copy), Players (copy)
		local v61 = buildPlaceReport(p13, p14)

		return Promise.try(function() -- line: 235
			-- upvalues: Players (copy), v61 (copy)
			Players:ReportAbuseV3(Players.LocalPlayer, v61)

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
