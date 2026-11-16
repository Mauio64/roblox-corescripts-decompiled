local Chrome = script:FindFirstAncestor("Chrome")

local Service = require(Chrome.Service)
local registerConnectIntegration = require(script.Parent.registerConnectIntegration)
local isConnectDropdownEnabled = require(script.Parent.isConnectDropdownEnabled)
local v

if isConnectDropdownEnabled() then
	return (registerConnectIntegration("connect_dropdown", Service.AvailabilitySignal.Available))
end

return v
