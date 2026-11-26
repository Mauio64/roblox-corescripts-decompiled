local getSduiComponentRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").getSduiComponentRegistry
local SduiComponentDefinitions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/SduiComponentDefinitions")

local function registerDiscoveryUiComponents()
	local registeredComponents = SduiComponentDefinitions.new()._registeredComponents
	getSduiComponentRegistry().registerComponentDefinitions(registeredComponents)
end

return registerDiscoveryUiComponents
