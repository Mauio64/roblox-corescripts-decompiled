local Chrome = script:FindFirstAncestor("Chrome")
local Service = require(Chrome.Service)
local registerConnectIntegration = require(script.Parent.registerConnectIntegration)
local v4 = nil

if require(script.Parent.isConnectDropdownEnabled)() then
	v4 = registerConnectIntegration("connect_dropdown", Service.AvailabilitySignal.Available)
end

return v4
