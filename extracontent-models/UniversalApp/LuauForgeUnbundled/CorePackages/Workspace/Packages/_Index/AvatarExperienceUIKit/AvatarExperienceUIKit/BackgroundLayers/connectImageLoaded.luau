local RunService = game:GetService("RunService")

local function connectImageLoaded(p2, callback, p3)
	local connection = nil
	connection = (p3 or RunService.Heartbeat):Connect(function()
		if not p2.Parent then
			connection:Disconnect()
		elseif p2.IsLoaded then
			connection:Disconnect()
			callback()
		end
	end)
	return connection
end

return connectImageLoaded
