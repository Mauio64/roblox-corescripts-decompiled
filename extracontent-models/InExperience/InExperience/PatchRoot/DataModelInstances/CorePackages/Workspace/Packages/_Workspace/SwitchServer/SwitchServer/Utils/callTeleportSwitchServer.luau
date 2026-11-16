local TeleportService = game:GetService("TeleportService")

local function callTeleportSwitchServer(p)
	if p == nil then
		TeleportService:TeleportSwitchServer()
	else
		TeleportService:TeleportSwitchServer(p)
	end
end

return callTeleportSwitchServer
