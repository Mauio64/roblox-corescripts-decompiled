local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/RoactAppExperiment").useUserExperiment

local defineFastString = game:DefineFastString("SortInvitesByScoreExperimentLayer", "Social.Friends")

return {
	FFlagEnableSortInvitesByScoreExperiment = game:DefineFastFlag(
		"EnableSortInvitesByScoreExperiment",
		false
	),
	FFlagSortInvitesByScoreEnabledForAll = game:DefineFastFlag("SortInvitesByScoreEnabledForAll", false),
	useSortInvitesByScoreExperiment = function()
		return (useUserExperiment({ defineFastString }, function(p2)
			return (p2[defineFastString] or {}).sortInvitesByScore
		end))
	end
}
