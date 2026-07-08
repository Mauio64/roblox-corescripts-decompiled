local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

game:GetService("CorePackages")

local RobloxGui = CoreGui.RobloxGui
local FaceAnimatorService = game:GetService("FaceAnimatorService")

require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default.participantsUpdate.Event:Connect(function(p1) -- line: 14
	-- upvalues: Players (copy)
	for k, v in pairs(p1) do
		local PlayerByUserId = Players:GetPlayerByUserId(k)

		if PlayerByUserId then
			PlayerByUserId:SetAttribute("RBXAttentionVoiceIsActive", v.isSignalActive)
		end
	end
end)

local function setLocalPlayerVideoAnimationEnabled() -- line: 23
	-- upvalues: Players (copy), FaceAnimatorService (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		LocalPlayer:SetAttribute("RBXAttentionVideoAnimationEnabled", FaceAnimatorService.VideoAnimationEnabled)
	end
end

local LocalPlayer = Players.LocalPlayer

if LocalPlayer then
	LocalPlayer:SetAttribute("RBXAttentionVideoAnimationEnabled", FaceAnimatorService.VideoAnimationEnabled)
end

FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(setLocalPlayerVideoAnimationEnabled)
