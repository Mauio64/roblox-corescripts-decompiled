local VoiceChat = script:FindFirstAncestor("VoiceChat")

local dependencies = require(VoiceChat.dependencies)

local sharedFlags = dependencies.SharedFlags

local default = dependencies.LinkingProtocol.LinkingProtocol.default
local settingsRoute = dependencies.LinkingProtocol.Enums.SettingsRoute

local fFlagEnableRetryForLinkingProtocolFetch = sharedFlags.FFlagEnableRetryForLinkingProtocolFetch
local fIntLinkingProtocolFetchRetries = sharedFlags.FIntLinkingProtocolFetchRetries
local fIntLinkingProtocolFetchTimeoutMS = sharedFlags.FIntLinkingProtocolFetchTimeoutMS

return function()
	local v = false
	local v2 = false

	if fFlagEnableRetryForLinkingProtocolFetch then
		for _ = 0, fIntLinkingProtocolFetchRetries do
			local thread = task.spawn(function()
				v, v2 = default:supportsSwitchToSettingsApp(settingsRoute.Microphone):await()
			end)
			task.wait(fIntLinkingProtocolFetchTimeoutMS / 1000)
			task.cancel(thread)

			if v2 ~= nil then
				break
			end
		end
	else
		v, v2 = default:supportsSwitchToSettingsApp(settingsRoute.Microphone):await()
	end

	return v and v2 == true
end
