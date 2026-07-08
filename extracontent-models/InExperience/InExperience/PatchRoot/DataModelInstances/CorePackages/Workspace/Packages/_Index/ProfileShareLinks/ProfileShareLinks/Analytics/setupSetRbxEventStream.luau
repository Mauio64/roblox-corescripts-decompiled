local Parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local getPlatformTarget = require(Parent.Analytics).getPlatformTarget

return function(p1) -- line: 5
	-- upvalues: getPlatformTarget (copy)
	return function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 6
		-- upvalues: p1 (copy), getPlatformTarget (copy)
		local v8 = if not t1 then s1 else t1.context

		p1:setRBXEventStream(getPlatformTarget(), v8, s2, t1)
	end
end
