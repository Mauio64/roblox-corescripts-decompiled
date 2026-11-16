local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local Constants = VoiceChat.Constants
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Analytics = require(RobloxGui.Modules.SelfView.Analytics)
local v = Analytics.new()

return function(p, p2, p3: string?)
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		if p == tostring(localPlayer.UserId) then
			if p2 == Constants.VOICE_STATE.ERROR then
				default:RejoinPreviousChannel()
				return
			end

			if p2 == Constants.VOICE_STATE.CONNECTING then
				default:ShowVoiceChatLoadingMessage()
				return
			end

			v:setLastCtx("bubbleChatToggle")
			default:ToggleMic(p3)
		else
			default:ToggleMutePlayer(tonumber(p), p3)
		end
	end
end
