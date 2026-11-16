local parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget

return function(object)
	return function(_, p: string, p2: string, p3)
		if p3 then
			p = p3.context
		end

		object:setRBXEventStream(getPlatformTarget(), p, p2, p3)
	end
end
