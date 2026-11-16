local useLayerCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Layout.LayerCollector.useLayerCollector

local defineFastInt = game:DefineFastInt("AppChatVerticalConstraintThreshold", 300)

return function(): boolean
	return useLayerCollector().absoluteSize.Y <= defineFastInt
end
