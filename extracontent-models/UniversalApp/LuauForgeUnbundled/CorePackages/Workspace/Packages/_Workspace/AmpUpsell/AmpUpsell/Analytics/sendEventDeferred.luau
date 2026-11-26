local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Analytics").getPlatformTarget

return function(object)
	return function(p2, p3, p4)
		object:SendEventDeferred(getPlatformTarget(), p2, p3, p4)
	end
end
