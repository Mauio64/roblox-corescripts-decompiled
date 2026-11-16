local SduiFoundation = script:FindFirstAncestor("SduiFoundation")
local parent = SduiFoundation.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local getComponentDefinitions = require(SduiFoundation.Components.getComponentDefinitions)

local function registerFoundationComponents()
	getSduiComponentRegistry().registerComponentDefinitions(getComponentDefinitions())
end

return registerFoundationComponents
