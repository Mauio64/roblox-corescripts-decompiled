local parent = script:FindFirstAncestor("Achievements").Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

local reducer = Rodux.createReducer({
	gameVoteStatus = {},
	voteCountSinceAppStart = 0,
	lastUniverseId = -1
}, {
	SetUserGameVotes = function(data, data2)
		local universeId = data2.universeId
		local userVote = data2.userVote
		local canVote = data2.canVote

		local gameVoteStatus = data.gameVoteStatus
		local voteCountSinceAppStart = data.voteCountSinceAppStart
		local lastUniverseId = data.lastUniverseId

		if
			canVote
			and gameVoteStatus[universeId]
			and gameVoteStatus[universeId] ~= userVote
			and userVote ~= "NotVoted"
		then
			voteCountSinceAppStart += 1
			lastUniverseId = universeId
		end

		local joined = Cryo.Dictionary.join(gameVoteStatus, { [universeId] = userVote })
		return Cryo.Dictionary.join(data, {
			gameVoteStatus = joined,
			voteCountSinceAppStart = voteCountSinceAppStart,
			lastUniverseId = lastUniverseId
		})
	end
})

return function(p, p2)
	return reducer(p, p2)
end
