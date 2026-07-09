local Parent = script:FindFirstAncestor("AppChat").Parent
local useLayerCollector = require(Parent.UIBlox).Core.Layout.LayerCollector.useLayerCollector
local v3 = game:DefineFastInt("AppChatVerticalConstraintThreshold", 300)

return function() -- line: 10
	-- upvalues: useLayerCollector (copy), v3 (copy)
	return useLayerCollector().absoluteSize.Y <= v3
end
