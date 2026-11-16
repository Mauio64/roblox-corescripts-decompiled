local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SduiComponentDefinitions = require(ServerDrivenUi.System.SduiComponentDefinitions)

local function registerDiscoveryUiComponents()
	local registeredComponents = SduiComponentDefinitions.new()._registeredComponents
	getSduiComponentRegistry().registerComponentDefinitions(registeredComponents)
end

return registerDiscoveryUiComponents
