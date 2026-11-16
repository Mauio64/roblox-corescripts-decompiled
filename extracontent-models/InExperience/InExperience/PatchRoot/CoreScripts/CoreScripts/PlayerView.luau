local CoreGui = game:GetService("CoreGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local PlayerViewService = game:GetService("PlayerViewService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetFIntPlayerViewRemoteEventTimeout = require(RobloxGui.Modules.Flags.GetFIntPlayerViewRemoteEventTimeout)

local fIntPlayerViewRemoteEventTimeout = GetFIntPlayerViewRemoteEventTimeout()

local RequestDeviceCameraCFrame = RobloxReplicatedStorage:WaitForChild(
	"RequestDeviceCameraCFrame",
	fIntPlayerViewRemoteEventTimeout
)

local ReplicateDeviceCameraCFrame = RobloxReplicatedStorage:WaitForChild(
	"ReplicateDeviceCameraCFrame",
	fIntPlayerViewRemoteEventTimeout
)

local engineFeature = game:GetEngineFeature("PlayerViewRemoteEventSupport")

if RequestDeviceCameraCFrame and ReplicateDeviceCameraCFrame then
	ReplicateDeviceCameraCFrame.OnClientEvent:Connect(function(p, p2, p3)
		if engineFeature then
			PlayerViewService:UpdateDeviceCFrame(p, p2, p3)
		end
	end)
	RequestDeviceCameraCFrame.OnClientEvent:Connect(function()
		if engineFeature then
			PlayerViewService:OnCameraCFrameReplicationRequest()
		end
	end)
else
	warn("PlayerViewService failed to initialize.")
end
