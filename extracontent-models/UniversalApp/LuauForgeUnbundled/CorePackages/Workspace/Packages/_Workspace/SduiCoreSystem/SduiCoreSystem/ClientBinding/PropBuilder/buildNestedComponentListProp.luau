local buildLazyNestedComponentListProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildLazyNestedComponentListProp")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory

local function buildNestedComponentListProp(...)
	return buildLazyNestedComponentListProp(...), propResultCategory.NestedComponentConfigListPropSignal
end

return buildNestedComponentListProp
