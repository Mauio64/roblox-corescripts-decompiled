local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local getPlatformTarget = require(Parent.Analytics).getPlatformTarget

return function(p1) -- line: 5
	-- upvalues: getPlatformTarget (copy)
	return function(s1: string, s2: string, t1: {[any]: any}?) -- line: 6
		-- upvalues: p1 (copy), getPlatformTarget (copy)
		p1:SendEventDeferred(getPlatformTarget(), s1, s2, t1)
	end
end
