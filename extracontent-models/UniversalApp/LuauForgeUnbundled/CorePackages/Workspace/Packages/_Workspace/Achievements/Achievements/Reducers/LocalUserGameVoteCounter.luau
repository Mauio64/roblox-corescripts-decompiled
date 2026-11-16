local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Cryo")
local reducer = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Rodux").createReducer(
	{ gameVoteStatus = {}, voteCountSinceAppStart = 0, lastUniverseId = -1 },
	{
		SetUserGameVotes = function(data, data2)
			local universeId = data2.universeId
			local userVote = data2.userVote
			local canVote = data2.canVote

			local gameVoteStatus = data.gameVoteStatus
			local voteCountSinceAppStart = data.voteCountSinceAppStart
			local v5 = data.lastUniverseId

			if
				canVote
				and gameVoteStatus[universeId]
				and gameVoteStatus[universeId] ~= userVote
				and userVote ~= "NotVoted"
			then
				voteCountSinceAppStart += 1
				v5 = universeId
			end

			local joined = Cryo.Dictionary.join(gameVoteStatus, {
				[universeId] = userVote
			})
			return Cryo.Dictionary.join(data, {
				gameVoteStatus = joined,
				voteCountSinceAppStart = voteCountSinceAppStart,
				lastUniverseId = v5
			})
		end
	}
)

return function(p2, p3)
	return reducer(p2, p3)
end
