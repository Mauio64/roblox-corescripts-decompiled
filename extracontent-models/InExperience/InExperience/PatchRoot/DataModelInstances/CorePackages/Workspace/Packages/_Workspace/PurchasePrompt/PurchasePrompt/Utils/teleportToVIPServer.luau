local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local VIPServerPostPurchaseTelemetry = require(PurchasePrompt.Events.VIPServerPostPurchaseTelemetry)

local function teleportToVIPServer(p: string, callback)
	local function fail(reason: string) -- 3 equivalent calls inferred from this helper
		default:logRobloxTelemetryCounter(VIPServerPostPurchaseTelemetry.VIPServerTeleportFailedCounter, 1, {
			reason = reason
		})

		callback()
	end

	local teleportToPurchasedVIPServer = RobloxReplicatedStorage:FindFirstChild("TeleportToPurchasedVIPServer")

	if teleportToPurchasedVIPServer == nil or not teleportToPurchasedVIPServer:IsA("RemoteEvent") then
		fail("no_remote") -- inferred equivalent call
		return function() end
	else
		local onClientEventConnection = nil
		local teleportInitFailedConnection = nil
		local function disconnect() -- 2 equivalent calls inferred from this helper
			onClientEventConnection:Disconnect()
			teleportInitFailedConnection:Disconnect()
		end

		onClientEventConnection = teleportToPurchasedVIPServer.OnClientEvent:Connect(function()
			disconnect() -- inferred equivalent call
			fail("server") -- inferred equivalent call
		end)
		teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p2)
			if p2 == Players.LocalPlayer then
				disconnect() -- inferred equivalent call
				fail("teleport_init") -- inferred equivalent call
			end
		end)
		teleportToPurchasedVIPServer:FireServer(p)

		return disconnect
	end
end

return teleportToVIPServer
