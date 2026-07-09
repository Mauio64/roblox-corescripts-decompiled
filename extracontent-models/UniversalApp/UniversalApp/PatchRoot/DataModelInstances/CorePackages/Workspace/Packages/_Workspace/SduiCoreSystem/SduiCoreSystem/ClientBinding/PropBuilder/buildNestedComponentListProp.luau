local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local buildLazyNestedComponentListProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildLazyNestedComponentListProp)
local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory

local function buildNestedComponentListProp(...) -- line: 15
	-- upvalues: buildLazyNestedComponentListProp (copy), PropResultCategory (copy)
	return buildLazyNestedComponentListProp(...), PropResultCategory.NestedComponentConfigListPropSignal
end

return buildNestedComponentListProp
