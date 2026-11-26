require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function makeCommentCountFields(p2)
	if p2 == nil or p2.count == nil then
		return {}
	end

	return { totalCommentCount = tostring(p2.count) }
end

return makeCommentCountFields
