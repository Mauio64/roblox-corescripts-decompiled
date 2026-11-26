local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/AppCommonLib").Immutable
local SetGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/GameVotes/SetGameVotes")

return function(options, data)
	local v5 = options or {}
	assert(v5, "")

	if data.type == SetGameVotes.name then
		local v6 = { upVotes = data.upVotes, downVotes = data.downVotes }

		v5 = immutable.Set(v5, data.universeId, v6)
	end

	return v5
end
