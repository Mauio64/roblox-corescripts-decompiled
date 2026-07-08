local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local tutils = require(Parent.tutils)

return function() -- line: 6
	-- upvalues: tutils (copy)
	return tutils.deepEqual
end
