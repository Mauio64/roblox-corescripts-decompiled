require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local buildNestedComponentProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildNestedComponentProp")

local function buildLazyNestedComponentProp(p2, p3, p4, p5, p6, p7)
	return buildNestedComponentProp(p2, p3, p4, p5, p6, p7, true)
end

return buildLazyNestedComponentProp
