local VoiceChat = script:FindFirstAncestor("VoiceChat")
local GetVoiceChatOptInStatus = require(VoiceChat.OptInStatus.GetVoiceChatOptInStatus)
local SetVoiceChatOptInStatus = require(VoiceChat.OptInStatus.SetVoiceChatOptInStatus)
local parent = VoiceChat.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch

local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
local ApiFetchVoiceChatOptInStatus = {}
ApiFetchVoiceChatOptInStatus.KeyMapper = "luaapp.voicechatoptinstatus"

function ApiFetchVoiceChatOptInStatus.Fetch(p)
	return PerformFetch.Single("luaapp.voicechatoptinstatus", function(object)
		return GetVoiceChatOptInStatus(p):andThen(function(p2)
			local responseBody = p2.responseBody

			if responseBody == nil or responseBody.isUserOptIn == nil then
				Logging.warn("Response from GetVoiceChatOptInStatus is malformed!")
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end

			object:dispatch(SetVoiceChatOptInStatus(responseBody.isUserOptIn))
			return Promise.resolve(p2)
		end)
	end)
end

function ApiFetchVoiceChatOptInStatus.GetFetchingStatus(p)
	return PerformFetch.GetStatus(p, "luaapp.voicechatoptinstatus")
end

return ApiFetchVoiceChatOptInStatus
