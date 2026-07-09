local Parent = script:FindFirstAncestor("Moments").Parent
local MomentStatus = require(Parent.MomentsTypes).Enums.MomentStatus

local function shouldShowMomentInFeed(p1) -- line: 11
	-- upvalues: MomentStatus (copy)
	if p1.status == MomentStatus.Deleted then
		return false
	end

	if p1.isModerated == true then
		return false
	end

	return true
end

return shouldShowMomentInFeed
