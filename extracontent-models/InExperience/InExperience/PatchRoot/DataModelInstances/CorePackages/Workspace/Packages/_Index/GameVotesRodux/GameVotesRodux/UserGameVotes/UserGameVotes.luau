local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local GameVotesRoduxParent = GameVotesRodux.Parent
local Immutable = require(GameVotesRoduxParent.AppCommonLib).Immutable
local SetUserGameVotes = require(GameVotesRodux.UserGameVotes.SetUserGameVotes)
local ClearUserGameVotes = require(GameVotesRodux.UserGameVotes.ClearUserGameVotes)

return function(p1, p2) -- line: 7
	-- upvalues: SetUserGameVotes (copy), Immutable (copy), ClearUserGameVotes (copy)
	local v8 = p1 or {}

	if p2.type == SetUserGameVotes.name then
		local t1 = {
			canVote = p2.canVote,
			userVote = p2.userVote,
			reasonForNotVoteable = p2.reasonForNotVoteable
		}

		return (Immutable.Set(v8, p2.universeId, t1))
	end

	if p2.type == ClearUserGameVotes.name then
		v8 = Immutable.Set(v8, p2.universeId, nil)
	end

	return v8
end
