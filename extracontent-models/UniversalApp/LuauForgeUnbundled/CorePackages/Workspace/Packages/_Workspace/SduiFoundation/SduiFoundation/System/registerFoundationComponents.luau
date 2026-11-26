local getSduiComponentRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiFoundation/SduiCoreSystem").getSduiComponentRegistry
local getComponentDefinitions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiFoundation/SduiFoundation/Components/getComponentDefinitions")

local function registerFoundationComponents()
	getSduiComponentRegistry().registerComponentDefinitions(getComponentDefinitions())
end

return registerFoundationComponents
