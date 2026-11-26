local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local function listenForTeleportFailure(callback)
	local localPlayer = Players.LocalPlayer
	local teleportInitFailedConnection = nil
	local function disconnect()
		if teleportInitFailedConnection ~= nil then
			teleportInitFailedConnection:Disconnect()
			teleportInitFailedConnection = nil
		end
	end

	teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p2)
		if p2 == localPlayer then
			if teleportInitFailedConnection ~= nil then
				teleportInitFailedConnection:Disconnect()
				teleportInitFailedConnection = nil
			end

			callback()
		end
	end)

	return disconnect
end

return listenForTeleportFailure
