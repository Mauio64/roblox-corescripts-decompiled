local ParentParent = script.Parent.Parent
local isSubjectTo10ftPolicies = require(ParentParent.dependencies).isSubjectTo10ftPolicies
local getFIntShowFriendRecommendationsLimit = require(ParentParent.Flags.getFIntShowFriendRecommendationsLimit)

return function(n1: number) -- line: 6
	-- upvalues: isSubjectTo10ftPolicies (copy), getFIntShowFriendRecommendationsLimit (copy)
	if isSubjectTo10ftPolicies() then
		return true
	end

	return n1 <= getFIntShowFriendRecommendationsLimit()
end
