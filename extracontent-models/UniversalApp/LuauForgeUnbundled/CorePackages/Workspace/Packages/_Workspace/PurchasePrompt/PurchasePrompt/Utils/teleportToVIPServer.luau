local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol").default

local VIPServerPostPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/VIPServerPostPurchaseTelemetry")

local function teleportToVIPServer(p2, callback)
	local function fail(p3)
		default:logRobloxTelemetryCounter(VIPServerPostPurchaseTelemetry.VIPServerTeleportFailedCounter, 1, {
			reason = p3
		})

		callback()
	end

	local teleportToPurchasedVIPServer = RobloxReplicatedStorage:FindFirstChild("TeleportToPurchasedVIPServer")

	if teleportToPurchasedVIPServer == nil or not teleportToPurchasedVIPServer:IsA("RemoteEvent") then
		default:logRobloxTelemetryCounter(VIPServerPostPurchaseTelemetry.VIPServerTeleportFailedCounter, 1, {
			reason = "no_remote"
		})

		callback()

		return function() end
	else
		local onClientEventConnection = nil
		local teleportInitFailedConnection = nil
		local function disconnect()
			onClientEventConnection:Disconnect()
			teleportInitFailedConnection:Disconnect()
		end

		onClientEventConnection = teleportToPurchasedVIPServer.OnClientEvent:Connect(function()
			onClientEventConnection:Disconnect()
			teleportInitFailedConnection:Disconnect()
			default:logRobloxTelemetryCounter(VIPServerPostPurchaseTelemetry.VIPServerTeleportFailedCounter, 1, {
				reason = "server"
			})

			callback()
		end)
		teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p3)
			if p3 == Players.LocalPlayer then
				onClientEventConnection:Disconnect()
				teleportInitFailedConnection:Disconnect()
				default:logRobloxTelemetryCounter(VIPServerPostPurchaseTelemetry.VIPServerTeleportFailedCounter, 1, {
					reason = "teleport_init"
				})

				callback()
			end
		end)
		teleportToPurchasedVIPServer:FireServer(p2)

		return disconnect
	end
end

return teleportToVIPServer
