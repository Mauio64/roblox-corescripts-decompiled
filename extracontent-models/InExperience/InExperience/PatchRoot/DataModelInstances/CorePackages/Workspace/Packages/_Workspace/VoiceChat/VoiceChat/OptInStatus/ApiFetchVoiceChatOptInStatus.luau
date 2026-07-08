local VoiceChat = script:FindFirstAncestor("VoiceChat")
local GetVoiceChatOptInStatus = require(VoiceChat.OptInStatus.GetVoiceChatOptInStatus)
local SetVoiceChatOptInStatus = require(VoiceChat.OptInStatus.SetVoiceChatOptInStatus)
local VoiceChatParent = VoiceChat.Parent
local Promise = require(VoiceChatParent.Promise)
local PerformFetch = require(VoiceChatParent.Http).PerformFetch
local Logging = require(VoiceChatParent.AppCommonLib).Logging

return {
	KeyMapper = "luaapp.voicechatoptinstatus",
	Fetch = function(p1) -- line: 16
		-- upvalues: PerformFetch (copy), GetVoiceChatOptInStatus (copy), SetVoiceChatOptInStatus (copy), Promise (copy), Logging (copy)
		return PerformFetch.Single("luaapp.voicechatoptinstatus", function(p2) -- line: 17
			-- upvalues: GetVoiceChatOptInStatus (copy), p1 (copy), SetVoiceChatOptInStatus (copy), Promise (copy), Logging (copy)
			return GetVoiceChatOptInStatus(p1):andThen(function(p3) -- line: 18
				-- upvalues: p2 (copy), SetVoiceChatOptInStatus (copy), Promise (copy), Logging (copy)
				local responseBody = p3.responseBody

				if responseBody ~= nil and responseBody.isUserOptIn ~= nil then
					p2:dispatch(SetVoiceChatOptInStatus(responseBody.isUserOptIn))

					return Promise.resolve(p3)
				end

				Logging.warn("Response from GetVoiceChatOptInStatus is malformed!")

				return Promise.reject({
					HttpError = Enum.HttpError.OK
				})
			end)
		end)
	end,
	GetFetchingStatus = function(p4) -- line: 31
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p4, "luaapp.voicechatoptinstatus")
	end
}
