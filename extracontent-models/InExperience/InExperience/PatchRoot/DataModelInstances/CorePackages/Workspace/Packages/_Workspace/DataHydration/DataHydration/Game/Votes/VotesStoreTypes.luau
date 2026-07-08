local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)

local t = require(DataHydrationParent.t)

require(DataHydrationParent.Signals)

local t1 = {
	PlayGame = "PlayGame",
	FloodCheckThresholdMet = "FloodCheckThresholdMet",
	AssetNotVoteable = "AssetNotVoteable"
}
local v5 = t.interface({
	id = t.number,
	upVotes = t.number,
	downVotes = t.number
})
local v6 = t.interface({
	data = t.array(v5)
})
local v7 = t.interface({
	userVote = t.optional(t.boolean),
	canVote = t.boolean,
	reasonForNotVoteable = t.optional(t.string)
})

return {
	PLAY_GAME_ERROR_CODE = 6,
	votesResponseValidator = v6,
	userVoteResponseValidator = v7,
	ReasonNotVoteable = t1
}
