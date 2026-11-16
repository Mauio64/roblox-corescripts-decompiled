local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
local t = require(parent.t)
require(parent.Signals)

local interface = t.interface({ id = t.number, upVotes = t.number, downVotes = t.number })
return {
	votesResponseValidator = t.interface({ data = t.array(interface) }),
	userVoteResponseValidator = t.interface({
		userVote = t.optional(t.boolean),
		canVote = t.boolean,
		reasonForNotVoteable = t.optional(t.string)
	}),
	ReasonNotVoteable = {
		PlayGame = "PlayGame",
		FloodCheckThresholdMet = "FloodCheckThresholdMet",
		AssetNotVoteable = "AssetNotVoteable"
	},
	PLAY_GAME_ERROR_CODE = 6
}
