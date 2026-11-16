local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local isSubjectTo10ftPolicies = dependencies.isSubjectTo10ftPolicies
local getFIntShowFriendRecommendationsLimit = require(parent.Flags.getFIntShowFriendRecommendationsLimit)

return function(p: number): boolean
	if isSubjectTo10ftPolicies() then
		return true
	end

	return p <= getFIntShowFriendRecommendationsLimit()
end
