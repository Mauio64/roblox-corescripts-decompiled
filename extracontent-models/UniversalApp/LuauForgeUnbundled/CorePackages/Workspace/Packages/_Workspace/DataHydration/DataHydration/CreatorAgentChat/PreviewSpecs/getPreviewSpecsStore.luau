local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPreviewSpecsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs/createPreviewSpecsStore")

return Signals.createComputed(function()
	return createPreviewSpecsStore()
end)
