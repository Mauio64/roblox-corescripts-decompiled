local Parent = script:FindFirstAncestor("Achievements").Parent
local Cryo = require(Parent.Cryo)
local v3 = require(Parent.Rodux).createReducer({
	voteCountSinceAppStart = 0,
	lastUniverseId = -1,
	gameVoteStatus = {}
}, {
	SetUserGameVotes = function(t1: {[any]: any}, t2: {[any]: any}) -- line: 30
		-- upvalues: Cryo (copy)
		local universeId = t2.universeId
		local userVote = t2.userVote
		local canVote = t2.canVote
		local gameVoteStatus = t1.gameVoteStatus
		local voteCountSinceAppStart = t1.voteCountSinceAppStart
		local lastUniverseId = t1.lastUniverseId

		if canVote and (gameVoteStatus[universeId] and userVote ~= gameVoteStatus[universeId] and userVote ~= "NotVoted") then
			voteCountSinceAppStart += 1
			lastUniverseId = universeId
		end

		local v12 = Cryo.Dictionary.join(gameVoteStatus, {
			[universeId] = userVote
		})

		return Cryo.Dictionary.join(t1, {
			gameVoteStatus = v12,
			voteCountSinceAppStart = voteCountSinceAppStart,
			lastUniverseId = lastUniverseId
		})
	end
})

return function(p1, p2) -- line: 64
	-- upvalues: v3 (copy)
	return v3(p1, p2)
end
