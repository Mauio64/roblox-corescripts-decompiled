local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingSquads/Cryo")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingSquads/Http").Url
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	return (p2.roduxNetworking.POST("SendSquadVoiceAbuseReport", function(callback, data)
		assert(data.voiceChannelId, "Missing voiceChannelId")

		local mapped = Cryo.List.map(data.voiceUserIds, function(p3)
			return { data = tostring(p3) }
		end)

		local v5 = {
			ENTRY_POINT = {
				valueList = {
					{ data = "party" }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = data.submitterUserId }
				}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {
					{ data = data.abuserUserId }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = data.abuseReason }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = data.abuseComment }
				}
			},
			IS_PLACE_VOICE_ENABLED = {
				valueList = {
					{ data = "true" }
				}
			},
			VOICE_USER_IDS_FROM_CLIENT = { valueList = mapped },
			IN_EXP_MENU_OPENED_UNIX_MILLI = {
				valueList = {
					{
						data = tostring((math.floor(data.reportBeginTimestampMs)))
					}
				}
			},
			VOICE_CHANNEL_ID = {
				valueList = {
					{ data = data.voiceChannelId }
				}
			},
			VOICE_USER_COUNT = {
				valueList = {
					{ data = tostring(data.voiceUserCount) }
				}
			},
			VOICE_IMPACTED_USER_COUNT = {
				valueList = {
					{ data = "0" }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = "voice" }
				}
			}
		}

		return callback(url.APIS_URL):path("abuse-reporting"):path("v2"):path("abuse-report"):body({
			tags = v5
		})
	end))
end
