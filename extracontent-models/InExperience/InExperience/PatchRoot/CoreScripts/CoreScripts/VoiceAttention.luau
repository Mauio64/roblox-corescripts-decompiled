local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
VoiceChatServiceManager.default.participantsUpdate.Event:Connect(function(items)
	for k, item in pairs(items) do
		local playerByUserId = Players:GetPlayerByUserId(k)

		if playerByUserId then
			playerByUserId:SetAttribute("RBXAttentionVoiceIsActive", item.isSignalActive)
		end
	end
end)

local function setLocalPlayerVideoAnimationEnabled() -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		localPlayer:SetAttribute("RBXAttentionVideoAnimationEnabled", FaceAnimatorService.VideoAnimationEnabled)
	end
end

setLocalPlayerVideoAnimationEnabled() -- inferred equivalent call
FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(setLocalPlayerVideoAnimationEnabled)
