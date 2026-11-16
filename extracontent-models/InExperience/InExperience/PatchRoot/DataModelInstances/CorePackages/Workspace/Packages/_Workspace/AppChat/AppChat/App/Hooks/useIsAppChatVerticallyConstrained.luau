local parent = script:FindFirstAncestor("AppChat").Parent

local UIBlox = require(parent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local defineFastInt = game:DefineFastInt("AppChatVerticalConstraintThreshold", 300)

return function(): boolean
	return useLayerCollector().absoluteSize.Y <= defineFastInt
end
