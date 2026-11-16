local parent = script:FindFirstAncestor("FriendsMenu").Parent

local RoactAppExperiment = require(parent.RoactAppExperiment)

local useUserExperiment = RoactAppExperiment.useUserExperiment

local defineFastString = game:DefineFastString("SortInvitesByScoreExperimentLayer", "Social.Friends")

return {
	FFlagEnableSortInvitesByScoreExperiment = game:DefineFastFlag("EnableSortInvitesByScoreExperiment", false),
	FFlagSortInvitesByScoreEnabledForAll = game:DefineFastFlag("SortInvitesByScoreEnabledForAll", false),
	useSortInvitesByScoreExperiment = function()
		return (useUserExperiment({ defineFastString }, function(p)
			return (p[defineFastString] or {}).sortInvitesByScore
		end))
	end
}
