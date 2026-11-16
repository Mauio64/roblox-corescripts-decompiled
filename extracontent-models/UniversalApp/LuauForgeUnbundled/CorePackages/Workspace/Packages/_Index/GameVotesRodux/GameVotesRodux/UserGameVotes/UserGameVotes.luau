local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/AppCommonLib").Immutable
local SetUserGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/UserGameVotes/SetUserGameVotes")
local ClearUserGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/UserGameVotes/ClearUserGameVotes")

return function(options, data)
	local v5 = options or {}

	if data.type == SetUserGameVotes.name then
		local v6 = {
			canVote = data.canVote,
			userVote = data.userVote,
			reasonForNotVoteable = data.reasonForNotVoteable
		}

		return (immutable.Set(v5, data.universeId, v6))
	end

	if data.type == ClearUserGameVotes.name then
		v5 = immutable.Set(v5, data.universeId, nil)
	end

	return v5
end
