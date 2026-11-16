local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local tutils = require(parent.tutils)

return function()
	return tutils.deepEqual
end
