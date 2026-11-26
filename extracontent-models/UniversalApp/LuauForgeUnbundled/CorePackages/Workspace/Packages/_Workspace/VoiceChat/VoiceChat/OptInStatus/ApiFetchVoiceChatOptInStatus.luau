local GetVoiceChatOptInStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/OptInStatus/GetVoiceChatOptInStatus")
local SetVoiceChatOptInStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/OptInStatus/SetVoiceChatOptInStatus")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").PerformFetch

local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/AppCommonLib").Logging

return {
	KeyMapper = "luaapp.voicechatoptinstatus",
	Fetch = function(p2)
		return performFetch.Single("luaapp.voicechatoptinstatus", function(object)
			return GetVoiceChatOptInStatus(p2):andThen(function(p3)
				local responseBody = p3.responseBody

				if responseBody == nil or responseBody.isUserOptIn == nil then
					logging.warn("Response from GetVoiceChatOptInStatus is malformed!")
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				object:dispatch(SetVoiceChatOptInStatus(responseBody.isUserOptIn))
				return Promise.resolve(p3)
			end)
		end)
	end,
	GetFetchingStatus = function(p2)
		return performFetch.GetStatus(p2, "luaapp.voicechatoptinstatus")
	end
}
