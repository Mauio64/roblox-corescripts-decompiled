local CoreGui = game:GetService("CoreGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local PlayerViewService = game:GetService("PlayerViewService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v5 = require(RobloxGui.Modules.Flags.GetFIntPlayerViewRemoteEventTimeout)()
local RequestDeviceCameraCFrame = RobloxReplicatedStorage:WaitForChild("RequestDeviceCameraCFrame", v5)
local ReplicateDeviceCameraCFrame = RobloxReplicatedStorage:WaitForChild("ReplicateDeviceCameraCFrame", v5)
local EngineFeature = game:GetEngineFeature("PlayerViewRemoteEventSupport")

if RequestDeviceCameraCFrame and ReplicateDeviceCameraCFrame then
	ReplicateDeviceCameraCFrame.OnClientEvent:Connect(function(p1, p2, p3) -- line: 19
		-- upvalues: EngineFeature (copy), PlayerViewService (copy)
		if EngineFeature then
			PlayerViewService:UpdateDeviceCFrame(p1, p2, p3)
		end
	end)
	RequestDeviceCameraCFrame.OnClientEvent:Connect(function() -- line: 24
		-- upvalues: EngineFeature (copy), PlayerViewService (copy)
		if EngineFeature then
			PlayerViewService:OnCameraCFrameReplicationRequest()
		end
	end)

	return
end

warn("PlayerViewService failed to initialize.")
