local Parent = script:FindFirstAncestor("NetworkingSquads").Parent
local Cryo = require(Parent.Cryo)
local Url = require(Parent.Http).Url

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 9
	-- upvalues: Cryo (copy), Url (copy)
	return (p1.roduxNetworking.POST({
		Name = "SendSquadVoiceAbuseReport"
	}, function(p2, p3) -- line: 14
		-- upvalues: Cryo (copy), Url (copy)
		assert(p3.voiceChannelId, "Missing voiceChannelId")

		local v7 = Cryo.List.map(p3.voiceUserIds, function(p4) -- line: 17
			return {
				data = tostring(p4)
			}
		end)
		local t1 = {
			ENTRY_POINT = {
				valueList = {{
					data = "party"
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = p3.submitterUserId
				}}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {{
					data = p3.abuserUserId
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = p3.abuseReason
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = p3.abuseComment
				}}
			},
			IS_PLACE_VOICE_ENABLED = {
				valueList = {{
					data = "true"
				}}
			},
			VOICE_USER_IDS_FROM_CLIENT = {
				valueList = v7
			},
			IN_EXP_MENU_OPENED_UNIX_MILLI = {
				valueList = {{
					data = tostring((math.floor(p3.reportBeginTimestampMs)))
				}}
			},
			VOICE_CHANNEL_ID = {
				valueList = {{
					data = p3.voiceChannelId
				}}
			},
			VOICE_USER_COUNT = {
				valueList = {{
					data = tostring(p3.voiceUserCount)
				}}
			},
			VOICE_IMPACTED_USER_COUNT = {
				valueList = {{
					data = "0"
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = "voice"
				}}
			}
		}

		return p2(Url.APIS_URL):path("abuse-reporting"):path("v2"):path("abuse-report"):body({
			tags = t1
		})
	end))
end
