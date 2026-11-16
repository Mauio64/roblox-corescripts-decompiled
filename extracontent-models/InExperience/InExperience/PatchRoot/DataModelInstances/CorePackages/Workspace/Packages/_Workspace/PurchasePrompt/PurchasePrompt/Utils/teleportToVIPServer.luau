local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local function teleportToVIPServer(p: string, callback)
	local teleportToPurchasedVIPServer = RobloxReplicatedStorage:FindFirstChild("TeleportToPurchasedVIPServer")

	if teleportToPurchasedVIPServer == nil or not teleportToPurchasedVIPServer:IsA("RemoteEvent") then
		callback()
		return function() end
	end

	local onClientEventConnection = nil
	local teleportInitFailedConnection = nil
	local function disconnect() -- 1 equivalent call inferred from this helper
		onClientEventConnection:Disconnect()
		teleportInitFailedConnection:Disconnect()
	end
	local function fail() -- 1 equivalent call inferred from this helper
		disconnect() -- inferred equivalent call
		callback()
	end

	onClientEventConnection = teleportToPurchasedVIPServer.OnClientEvent:Connect(fail)
	teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p2)
		if p2 == Players.LocalPlayer then
			fail() -- inferred equivalent call
		end
	end)
	teleportToPurchasedVIPServer:FireServer(p)

	return disconnect
end

return teleportToVIPServer
