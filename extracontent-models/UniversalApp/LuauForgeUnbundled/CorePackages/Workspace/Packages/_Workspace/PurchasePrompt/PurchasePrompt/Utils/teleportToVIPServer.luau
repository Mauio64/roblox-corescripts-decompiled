local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local function teleportToVIPServer(p2, callback)
	local teleportToPurchasedVIPServer = RobloxReplicatedStorage:FindFirstChild("TeleportToPurchasedVIPServer")

	if teleportToPurchasedVIPServer == nil or not teleportToPurchasedVIPServer:IsA("RemoteEvent") then
		callback()
		return function() end
	end

	local onClientEventConnection = nil
	local teleportInitFailedConnection = nil
	local function disconnect()
		onClientEventConnection:Disconnect()
		teleportInitFailedConnection:Disconnect()
	end
	local function fail()
		onClientEventConnection:Disconnect()
		teleportInitFailedConnection:Disconnect()

		callback()
	end

	onClientEventConnection = teleportToPurchasedVIPServer.OnClientEvent:Connect(fail)
	teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p3)
		if p3 == Players.LocalPlayer then
			onClientEventConnection:Disconnect()
			teleportInitFailedConnection:Disconnect()

			callback()
		end
	end)
	teleportToPurchasedVIPServer:FireServer(p2)

	return disconnect
end

return teleportToVIPServer
