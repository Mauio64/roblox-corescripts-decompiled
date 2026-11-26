local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/Analytics").getPlatformTarget

return function(object)
	return function(p2, p3, p4, p5)
		if p5 then
			p3 = p5.context
		end

		object:sendEventDeferred(getPlatformTarget(), p3, p4, p5)
	end
end
