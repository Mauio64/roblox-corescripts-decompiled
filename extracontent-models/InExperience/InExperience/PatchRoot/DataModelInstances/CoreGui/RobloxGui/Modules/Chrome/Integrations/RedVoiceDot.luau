local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local ChromeShared = script.Parent.Parent.ChromeShared
local GetStyleTokens = require(ChromeShared.Utility.GetStyleTokens)
local useVoiceState = require(RobloxGui.Modules.VoiceChat.Hooks.useVoiceState)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local v10 = GetStyleTokens()
local color3 = Color3.new(0.918, 0.2, 0.137)
local uDim2 = UDim2.new(0, v10.Size.Size_100, 0, v10.Size.Size_100)

return function(p1) -- line: 17
	-- upvalues: useVoiceState (copy), Players (copy), Constants (copy), React (copy), uDim2 (copy), color3 (copy)
	local v14 = useVoiceState(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v15 = v14 == Constants.VOICE_STATE.INACTIVE or v14 == Constants.VOICE_STATE.TALKING

	return React.createElement("Frame", {
		Name = "RedVoiceDot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = p1.position,
		Size = uDim2,
		BackgroundColor3 = color3,
		Visible = v15
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end
