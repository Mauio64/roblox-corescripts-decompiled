local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local parent = GameVotesRodux.Parent
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local SetUserGameVotes = require(GameVotesRodux.UserGameVotes.SetUserGameVotes)
local ClearUserGameVotes = require(GameVotesRodux.UserGameVotes.ClearUserGameVotes)

return function(options, data)
	options = options or {}

	if data.type == SetUserGameVotes.name then
		local v = {
			canVote = data.canVote,
			userVote = data.userVote,
			reasonForNotVoteable = data.reasonForNotVoteable
		}

		return (Immutable.Set(options, data.universeId, v))
	end

	if data.type == ClearUserGameVotes.name then
		options = Immutable.Set(options, data.universeId, nil)
	end

	return options
end
