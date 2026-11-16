local parent = script:FindFirstAncestor("NetworkingSquads").Parent

local Cryo = require(parent.Cryo)
local Http = require(parent.Http)
local Url = Http.Url
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	return (p.roduxNetworking.POST("SendSquadVoiceAbuseReport", function(callback, data)
		assert(data.voiceChannelId, "Missing voiceChannelId")

		local mapped = Cryo.List.map(data.voiceUserIds, function(p2)
			return { data = tostring(p2) }
		end)

		local tags = {
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

		return callback(Url.APIS_URL):path("abuse-reporting"):path("v2"):path("abuse-report"):body({
			tags = tags
		})
	end))
end
