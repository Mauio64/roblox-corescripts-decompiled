local parent = script:FindFirstAncestor("Moments").Parent
require(parent.MomentsTypes)

local function getSeededCommentCount(p)
	return if p ~= nil then p.count else nil
end

return getSeededCommentCount
