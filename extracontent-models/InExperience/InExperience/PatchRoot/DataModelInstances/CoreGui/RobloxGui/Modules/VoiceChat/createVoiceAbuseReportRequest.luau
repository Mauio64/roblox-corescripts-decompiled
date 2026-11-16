local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

require(script.Parent.VoiceChatServiceManager)
local VoiceUsersByProximity = require(script.Parent.VoiceUsersByProximity)
local getSortedPlayers = VoiceUsersByProximity.getSortedPlayers

return function(object, p, data)
	local playerByUserId = object:GetPlayerByUserId(data.abuserUserId)
	local position

	if playerByUserId and playerByUserId.Character and playerByUserId.Character.PrimaryPart then
		position = playerByUserId.Character.PrimaryPart.Position
	end

	local v = #Cryo.Dictionary.values(p.participants)

	local v2 = position and #getSortedPlayers(object, p, position, 160, nil, playerByUserId) or 0

	local mapped = Cryo.List.map(data.sortedPlayerListUserIds, function(p2)
		return { data = tostring(p2) }
	end)

	local tags = {
		ENTRY_POINT = {
			valueList = {
				{ data = "in-experience" }
			}
		},
		SUBMITTER_USER_ID = {
			valueList = {
				{ data = tostring(data.localUserId) }
			}
		},
		REPORT_TARGET_USER_ID = {
			valueList = {
				{ data = tostring(data.abuserUserId) }
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
					data = tostring(data.inExpMenuOpenedUnixMilli)
				}
			}
		},
		VOICE_CHANNEL_ID = 0,
		VOICE_USER_COUNT = 0,
		VOICE_IMPACTED_USER_COUNT = 0,
		REPORTED_ABUSE_VECTOR = 0
	}
	local v3

	if game:GetEngineFeature("VoiceChatServiceExposesChannelId") then
		v3 = p.service:GetChannelId()
	else
		v3 = p.service:GetGroupId()
	end

	tags.VOICE_CHANNEL_ID = {
		valueList = {
			{ data = tostring(v3) }
		}
	}

	tags.VOICE_USER_COUNT = {
		valueList = {
			{ data = tostring(v) }
		}
	}

	tags.VOICE_IMPACTED_USER_COUNT = {
		valueList = {
			{ data = tostring(v2) }
		}
	}

	tags.REPORTED_ABUSE_VECTOR = {
		valueList = {
			{ data = data.abuseVector }
		}
	}
	return HttpService:JSONEncode({ tags = tags })
end
