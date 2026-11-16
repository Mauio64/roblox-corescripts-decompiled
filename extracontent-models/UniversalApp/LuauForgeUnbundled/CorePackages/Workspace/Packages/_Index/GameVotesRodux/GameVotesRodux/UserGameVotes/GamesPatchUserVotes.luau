local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Http").Url
local VoteStatus = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/Enums/VoteStatus")

local v5 = {
	[VoteStatus.VotedUp] = true,
	[VoteStatus.VotedDown] = false,
	[VoteStatus.NotVoted] = "null"
}

return function(callback, value, p2)
	assert(type(value) == "string", "GamesPatchUserVotes request expects universeId to be a string")

	local v6 = v5[p2]
	assert(v6 ~= nil, "GamesPatchUserVotes request expects a valid vote")

	return callback(string.format("%sv1/games/%s/user-votes", url.GAME_URL, value), "PATCH", {
		postBody = HttpService:JSONEncode({ vote = v6 })
	})
end
