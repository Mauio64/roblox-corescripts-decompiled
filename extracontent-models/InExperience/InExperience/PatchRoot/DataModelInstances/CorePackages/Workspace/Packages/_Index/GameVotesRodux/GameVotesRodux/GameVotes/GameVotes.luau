local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local GameVotesRoduxParent = GameVotesRodux.Parent
local Immutable = require(GameVotesRoduxParent.AppCommonLib).Immutable
local SetGameVotes = require(GameVotesRodux.GameVotes.SetGameVotes)

return function(t1: {[any]: any}?, p1) -- line: 15
	-- upvalues: SetGameVotes (copy), Immutable (copy)
	local v7 = t1 or {}

	assert(v7, "")

	if p1.type == SetGameVotes.name then
		local t2 = {
			upVotes = p1.upVotes,
			downVotes = p1.downVotes
		}

		v7 = Immutable.Set(v7, p1.universeId, t2)
	end

	return v7
end
