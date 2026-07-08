local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Constants = require(CorePackages.Workspace.Packages.VoiceChat).Constants
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local v7 = require(RobloxGui.Modules.SelfView.Analytics).new()

return function(p1, p2, s1: string?) -- line: 11
	-- upvalues: Players (copy), Constants (copy), default (copy), v7 (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		if p1 == tostring(LocalPlayer.UserId) then
			if p2 == Constants.VOICE_STATE.ERROR then
				default:RejoinPreviousChannel()

				return
			end

			if p2 == Constants.VOICE_STATE.CONNECTING then
				default:ShowVoiceChatLoadingMessage()

				return
			end

			v7:setLastCtx("bubbleChatToggle")
			default:ToggleMic(s1)

			return
		end

		default:ToggleMutePlayer(tonumber(p1), s1)
	end
end
