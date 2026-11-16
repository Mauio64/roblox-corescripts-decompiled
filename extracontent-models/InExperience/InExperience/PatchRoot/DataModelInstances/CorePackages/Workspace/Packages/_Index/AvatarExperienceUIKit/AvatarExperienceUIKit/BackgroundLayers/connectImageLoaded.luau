local RunService = game:GetService("RunService")

local function connectImageLoaded(p, callback, p2)
	local connection = nil
	connection = (p2 or RunService.Heartbeat):Connect(function()
		if not p.Parent then
			connection:Disconnect()
		elseif p.IsLoaded then
			connection:Disconnect()
			callback()
		end
	end)
	return connection
end

return connectImageLoaded
