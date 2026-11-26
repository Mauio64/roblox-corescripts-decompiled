local PostRecordUserSeenModal = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/AgeVerificationOverlay/PostRecordUserSeenModal")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").PerformFetch

return {
	KeyMapper = "luaapp.recorduserseenmodalupsell",
	Fetch = function(p2)
		return performFetch.Single("luaapp.recorduserseenmodalupsell", function(p3)
			return PostRecordUserSeenModal(p2):andThen(function(p4)
				if p4.responseBody == nil or p4.responseCode ~= 200 then
					return (Promise.reject())
				end

				return (Promise.resolve())
			end)
		end)
	end,
	GetFetchingStatus = function(p2)
		return performFetch.GetStatus(p2, "luaapp.recorduserseenmodalupsell")
	end
}
