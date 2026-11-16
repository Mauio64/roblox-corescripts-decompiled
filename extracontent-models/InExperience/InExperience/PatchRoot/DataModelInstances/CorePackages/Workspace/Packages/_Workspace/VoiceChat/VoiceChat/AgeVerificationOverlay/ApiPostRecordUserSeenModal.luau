local VoiceChat = script:FindFirstAncestor("VoiceChat")
local PostRecordUserSeenModal = require(VoiceChat.AgeVerificationOverlay.PostRecordUserSeenModal)
local parent = VoiceChat.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local ApiPostRecordUserSeenModal = {}
ApiPostRecordUserSeenModal.KeyMapper = "luaapp.recorduserseenmodalupsell"

function ApiPostRecordUserSeenModal.Fetch(p)
	return PerformFetch.Single("luaapp.recorduserseenmodalupsell", function(_)
		return PostRecordUserSeenModal(p):andThen(function(p2)
			if p2.responseBody == nil or p2.responseCode ~= 200 then
				return (Promise.reject())
			end

			return (Promise.resolve())
		end)
	end)
end

function ApiPostRecordUserSeenModal.GetFetchingStatus(p)
	return PerformFetch.GetStatus(p, "luaapp.recorduserseenmodalupsell")
end

return ApiPostRecordUserSeenModal
