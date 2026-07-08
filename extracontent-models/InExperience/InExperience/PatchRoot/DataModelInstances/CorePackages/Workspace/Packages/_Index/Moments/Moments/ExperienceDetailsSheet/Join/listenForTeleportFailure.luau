local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local function listenForTeleportFailure(p1: ((...any) -> ...any)) -- line: 15
	-- upvalues: Players (copy), TeleportService (copy)
	local LocalPlayer = Players.LocalPlayer
	local u6 = nil

	local function disconnect() -- line: 18
		-- upvalues: u6 (ref)
		if u6 ~= nil then
			u6:Disconnect()
			u6 = nil
		end
	end

	u6 = TeleportService.TeleportInitFailed:Connect(function(p2) -- line: 27
		-- upvalues: LocalPlayer (copy), u6 (ref), p1 (copy)
		if p2 == LocalPlayer then
			if u6 ~= nil then
				u6:Disconnect()
				u6 = nil
			end

			p1()
		end
	end)

	return disconnect
end

return listenForTeleportFailure
