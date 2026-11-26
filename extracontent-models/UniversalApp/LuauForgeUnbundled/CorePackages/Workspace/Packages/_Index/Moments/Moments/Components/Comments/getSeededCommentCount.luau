require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function getSeededCommentCount(p2)
	if p2 == nil then
		return nil
	end

	return p2.count
end

return getSeededCommentCount
