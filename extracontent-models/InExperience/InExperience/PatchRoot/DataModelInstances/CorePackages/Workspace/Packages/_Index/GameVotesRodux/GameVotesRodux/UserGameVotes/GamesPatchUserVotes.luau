local HttpService = game:GetService("HttpService")
local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local parent = GameVotesRodux.Parent
local Http = require(parent.Http)
local Url = Http.Url
local VoteStatus = require(GameVotesRodux.Enums.VoteStatus)

local v = {
	[VoteStatus.VotedUp] = true,
	[VoteStatus.VotedDown] = false,
	[VoteStatus.NotVoted] = "null"
}

return function(callback, value, p)
	assert(type(value) == "string", "GamesPatchUserVotes request expects universeId to be a string")

	local vote = v[p]
	assert(vote ~= nil, "GamesPatchUserVotes request expects a valid vote")

	return callback(string.format("%sv1/games/%s/user-votes", Url.GAME_URL, value), "PATCH", {
		postBody = HttpService:JSONEncode({ vote = vote })
	})
end
