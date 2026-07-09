local VoiceChat = script:FindFirstAncestor("VoiceChat")
local dependencies = require(VoiceChat.dependencies)
local SharedFlags = dependencies.SharedFlags
local default = dependencies.LinkingProtocol.LinkingProtocol.default
local SettingsRoute = dependencies.LinkingProtocol.Enums.SettingsRoute
local FFlagEnableRetryForLinkingProtocolFetch = SharedFlags.FFlagEnableRetryForLinkingProtocolFetch
local FIntLinkingProtocolFetchRetries = SharedFlags.FIntLinkingProtocolFetchRetries
local FIntLinkingProtocolFetchTimeoutMS = SharedFlags.FIntLinkingProtocolFetchTimeoutMS

return function() -- line: 20
	-- upvalues: FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default (copy), SettingsRoute (copy), FIntLinkingProtocolFetchTimeoutMS (copy)
	local u9 = false
	local u10 = false

	if FFlagEnableRetryForLinkingProtocolFetch then
		for _ = 0, FIntLinkingProtocolFetchRetries do
			local thread = task.spawn(function() -- line: 26
				-- upvalues: u9 (ref), u10 (ref), default (copy), SettingsRoute (copy)
				local v15, v16 = default:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

				u9 = v15
				u10 = v16
			end)

			task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
			task.cancel(thread)

			if u10 ~= nil then
				break
			end
		end
	else
		local v13, v14 = default:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

		u9 = v13
		u10 = v14
	end

	return u9 and u10 == true
end
