local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local function listenForTeleportFailure(callback)
	local localPlayer = Players.LocalPlayer
	local teleportInitFailedConnection = nil
	local function disconnect() -- 1 equivalent call inferred from this helper
		if teleportInitFailedConnection ~= nil then
			teleportInitFailedConnection:Disconnect()
			teleportInitFailedConnection = nil
		end
	end

	teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p)
		if p == localPlayer then
			disconnect() -- inferred equivalent call
			callback()
		end
	end)

	return disconnect
end

return listenForTeleportFailure
