local HttpService = game:GetService("HttpService")
local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local GameVotesRoduxParent = GameVotesRodux.Parent
local Url = require(GameVotesRoduxParent.Http).Url
local VoteStatus = require(GameVotesRodux.Enums.VoteStatus)
local t1 = {
	[VoteStatus.VotedUp] = true,
	[VoteStatus.VotedDown] = false,
	[VoteStatus.NotVoted] = "null"
}

return function(p1, p2, p3) -- line: 22
	-- upvalues: t1 (copy), Url (copy), HttpService (copy)
	assert(type(p2) == "string", "GamesPatchUserVotes request expects universeId to be a string")

	local v10 = t1[p3]

	assert(v10 ~= nil, "GamesPatchUserVotes request expects a valid vote")

	return p1(string.format("%sv1/games/%s/user-votes", Url.GAME_URL, p2), "PATCH", {
		postBody = HttpService:JSONEncode({
			vote = v10
		})
	})
end
