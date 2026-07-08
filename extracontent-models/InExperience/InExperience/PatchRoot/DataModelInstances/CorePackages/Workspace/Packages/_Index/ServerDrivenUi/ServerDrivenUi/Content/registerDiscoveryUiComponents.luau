local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local getSduiComponentRegistry = require(ServerDrivenUiParent.SduiCoreSystem).getSduiComponentRegistry
local SduiComponentDefinitions = require(ServerDrivenUi.System.SduiComponentDefinitions)

local function registerDiscoveryUiComponents() -- line: 15
	-- upvalues: SduiComponentDefinitions (copy), getSduiComponentRegistry (copy)
	local _registeredComponents = SduiComponentDefinitions.new()._registeredComponents

	getSduiComponentRegistry().registerComponentDefinitions(_registeredComponents)
end

return registerDiscoveryUiComponents
