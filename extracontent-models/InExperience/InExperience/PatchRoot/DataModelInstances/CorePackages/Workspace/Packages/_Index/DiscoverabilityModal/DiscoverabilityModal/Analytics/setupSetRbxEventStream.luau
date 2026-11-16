local parent = script:FindFirstAncestor("DiscoverabilityModal").Parent
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget

return function(object)
	return function(_, p: string, p2: string, p3)
		object:setRBXEventStream(getPlatformTarget(), p, p2, p3)
	end
end
