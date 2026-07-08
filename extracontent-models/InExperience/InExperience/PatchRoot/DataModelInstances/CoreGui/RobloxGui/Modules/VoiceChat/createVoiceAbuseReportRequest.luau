local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

require(script.Parent.VoiceChatServiceManager)

local getSortedPlayers = require(script.Parent.VoiceUsersByProximity).getSortedPlayers

return function(p1, p2, t1: {[any]: any}) -- line: 21
	-- upvalues: Cryo (copy), getSortedPlayers (copy), HttpService (copy)
	local PlayerByUserId = p1:GetPlayerByUserId(t1.abuserUserId)
	local PrimaryPartPosition = nil

	if PlayerByUserId and (PlayerByUserId.Character and PlayerByUserId.Character.PrimaryPart) then
		PrimaryPartPosition = PlayerByUserId.Character.PrimaryPart.Position
	end

	local v10 = #Cryo.Dictionary.values(p2.participants)
	local n1 = 0

	if PrimaryPartPosition then
		n1 = #getSortedPlayers(p1, p2, PrimaryPartPosition, 160, nil, PlayerByUserId)
	end

	local v12 = Cryo.List.map(t1.sortedPlayerListUserIds, function(p3) -- line: 47
		return {
			data = tostring(p3)
		}
	end)
	local t2 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = "in-experience"
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = tostring(t1.localUserId)
				}}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {{
					data = tostring(t1.abuserUserId)
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = t1.abuseReason
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = t1.abuseComment
				}}
			},
			IS_PLACE_VOICE_ENABLED = {
				valueList = {{
					data = "true"
				}}
			},
			VOICE_USER_IDS_FROM_CLIENT = {
				valueList = v12
			},
			IN_EXP_MENU_OPENED_UNIX_MILLI = {
				valueList = {{
					data = tostring(t1.inExpMenuOpenedUnixMilli)
				}}
			},
			VOICE_CHANNEL_ID = {
				valueList = {{
					data = tostring(if not game:GetEngineFeature("VoiceChatServiceExposesChannelId") then p2.service:GetGroupId() else p2.service:GetChannelId())
				}}
			},
			VOICE_USER_COUNT = {
				valueList = {{
					data = tostring(v10)
				}}
			},
			VOICE_IMPACTED_USER_COUNT = {
				valueList = {{
					data = tostring(n1)
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = t1.abuseVector
				}}
			}
		}
	}

	return HttpService:JSONEncode(t2)
end
