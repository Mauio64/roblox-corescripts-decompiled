local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local React = require(CorePackages.Packages.React)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local ChromeShared = script.Parent.Parent.ChromeShared
local GetStyleTokens = require(ChromeShared.Utility.GetStyleTokens)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatContinuousListeningChatIconDot = SharedFlags.FFlagExpChatContinuousListeningChatIconDot
local RedDot

if FFlagExpChatContinuousListeningChatIconDot then
	RedDot = require(script.Parent.RedDot)
else
	RedDot = nil
end

local useVoiceState = require(RobloxGui.Modules.VoiceChat.Hooks.useVoiceState)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local styleTokens = GetStyleTokens()

local color = Color3.new(0.918, 0.2, 0.137)
local udim = UDim2.new(0, styleTokens.Size.Size_100, 0, styleTokens.Size.Size_100)

return function(p)
	local v = useVoiceState(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local visible = v == Constants.VOICE_STATE.INACTIVE or v == Constants.VOICE_STATE.TALKING

	if FFlagExpChatContinuousListeningChatIconDot then
		return React.createElement(RedDot, {
			name = "RedVoiceDot",
			position = p.position,
			visible = visible
		})
	end

	return React.createElement("Frame", {
		Name = "RedVoiceDot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = p.position,
		Size = udim,
		BackgroundColor3 = color,
		Visible = visible
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end
