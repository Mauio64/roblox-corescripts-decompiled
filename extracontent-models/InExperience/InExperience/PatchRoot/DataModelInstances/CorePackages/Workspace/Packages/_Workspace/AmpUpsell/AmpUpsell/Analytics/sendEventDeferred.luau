local parent = script:FindFirstAncestor("AmpUpsell").Parent
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget

return function(object)
	return function(p: string, p2: string, p3)
		object:SendEventDeferred(getPlatformTarget(), p, p2, p3)
	end
end
