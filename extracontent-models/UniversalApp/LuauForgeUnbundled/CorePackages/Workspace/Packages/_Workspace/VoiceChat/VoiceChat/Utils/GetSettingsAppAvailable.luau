local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/dependencies")

local sharedFlags = dependencies.SharedFlags

local default = dependencies.LinkingProtocol.LinkingProtocol.default
local settingsRoute = dependencies.LinkingProtocol.Enums.SettingsRoute

local fFlagEnableRetryForLinkingProtocolFetch = sharedFlags.FFlagEnableRetryForLinkingProtocolFetch
local fIntLinkingProtocolFetchRetries = sharedFlags.FIntLinkingProtocolFetchRetries
local fIntLinkingProtocolFetchTimeoutMS = sharedFlags.FIntLinkingProtocolFetchTimeoutMS

return function()
	local v5 = false
	local v6 = false

	if fFlagEnableRetryForLinkingProtocolFetch then
		for i = 0, fIntLinkingProtocolFetchRetries do
			local thread = task.spawn(function()
				v5, v6 = default:supportsSwitchToSettingsApp(settingsRoute.Microphone):await()
			end)
			task.wait(fIntLinkingProtocolFetchTimeoutMS / 1000)
			task.cancel(thread)

			if v6 ~= nil then
				break
			end
		end
	else
		v5, v6 = default:supportsSwitchToSettingsApp(settingsRoute.Microphone):await()
	end

	return v5 and v6 == true
end
