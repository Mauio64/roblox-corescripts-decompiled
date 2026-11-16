local parent = script:FindFirstAncestor("Moments").Parent

local MomentsTypes = require(parent.MomentsTypes)

local MomentStatus = MomentsTypes.Enums.MomentStatus

local function shouldShowMomentInFeed(p): boolean
	return p.status ~= MomentStatus.Deleted and p.isModerated ~= true
end

return shouldShowMomentInFeed
