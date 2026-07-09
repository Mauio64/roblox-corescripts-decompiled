local VoiceChat = script:FindFirstAncestor("VoiceChat")
local PostRecordUserSeenModal = require(VoiceChat.AgeVerificationOverlay.PostRecordUserSeenModal)
local VoiceChatParent = VoiceChat.Parent
local Promise = require(VoiceChatParent.Promise)
local PerformFetch = require(VoiceChatParent.Http).PerformFetch

return {
	KeyMapper = "luaapp.recorduserseenmodalupsell",
	Fetch = function(p1) -- line: 13
		-- upvalues: PerformFetch (copy), PostRecordUserSeenModal (copy), Promise (copy)
		return PerformFetch.Single("luaapp.recorduserseenmodalupsell", function(_) -- line: 14
			-- upvalues: PostRecordUserSeenModal (copy), p1 (copy), Promise (copy)
			return PostRecordUserSeenModal(p1):andThen(function(p3) -- line: 15
				-- upvalues: Promise (copy)
				if p3.responseBody ~= nil and p3.responseCode == 200 then
					return (Promise.resolve())
				end

				return (Promise.reject())
			end)
		end)
	end,
	GetFetchingStatus = function(p4) -- line: 22
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p4, "luaapp.recorduserseenmodalupsell")
	end
}
