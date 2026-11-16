local momentStatus = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes").Enums.MomentStatus

local function shouldShowMomentInFeed(p2): boolean
	if p2.status == momentStatus.Deleted then
		return false
	end

	return p2.isModerated ~= true
end

return shouldShowMomentInFeed
