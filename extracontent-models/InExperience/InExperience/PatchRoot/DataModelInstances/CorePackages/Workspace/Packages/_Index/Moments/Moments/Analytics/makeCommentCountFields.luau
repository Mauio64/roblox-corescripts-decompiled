local parent = script:FindFirstAncestor("Moments").Parent

require(parent.MomentsTypes)

local function makeCommentCountFields(p)
	if p == nil or p.count == nil then
		return {}
	end

	return { totalCommentCount = tostring(p.count) }
end

return makeCommentCountFields
