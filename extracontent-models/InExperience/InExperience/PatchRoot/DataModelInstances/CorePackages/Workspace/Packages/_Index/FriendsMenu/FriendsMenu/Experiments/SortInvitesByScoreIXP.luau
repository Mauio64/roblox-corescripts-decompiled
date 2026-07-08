local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment
local v3 = game:DefineFastString("SortInvitesByScoreExperimentLayer", "Social.Friends")
local v4 = game:DefineFastFlag("EnableSortInvitesByScoreExperiment", false)
local v5 = game:DefineFastFlag("SortInvitesByScoreEnabledForAll", false)

return {
	FFlagEnableSortInvitesByScoreExperiment = v4,
	FFlagSortInvitesByScoreEnabledForAll = v5,
	useSortInvitesByScoreExperiment = function() -- line: 16
		-- upvalues: useUserExperiment (copy), v3 (copy)
		return (useUserExperiment({ v3 }, function(p1) -- line: 19
			-- upvalues: v3 (copy)
			return (p1[v3] or {}).sortInvitesByScore
		end))
	end
}
