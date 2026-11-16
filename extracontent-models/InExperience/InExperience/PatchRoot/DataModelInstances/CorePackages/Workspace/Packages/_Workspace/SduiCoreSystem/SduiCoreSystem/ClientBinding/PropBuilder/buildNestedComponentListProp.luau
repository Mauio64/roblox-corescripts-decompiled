local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local buildLazyNestedComponentListProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildLazyNestedComponentListProp)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory

local function buildNestedComponentListProp(...)
	return buildLazyNestedComponentListProp(...), PropResultCategory.NestedComponentConfigListPropSignal
end

return buildNestedComponentListProp
