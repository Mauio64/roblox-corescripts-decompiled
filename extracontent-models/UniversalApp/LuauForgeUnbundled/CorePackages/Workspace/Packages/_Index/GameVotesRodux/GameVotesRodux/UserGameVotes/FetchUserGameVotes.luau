local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/AppCommonLib").Logging
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast
local GetUserGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/UserGameVotes/GetUserGameVotes")
local SetUserGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/UserGameVotes/SetUserGameVotes")
local VoteStatus = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/Enums/VoteStatus")

local function getUserVoteStatus(p2)
	if p2 == true then
		return VoteStatus.VotedUp
	elseif p2 == false then
		return VoteStatus.VotedDown
	elseif p2 == nil then
		return VoteStatus.NotVoted
	end

	return nil
end

local function fetchKeymapper(p2)
	return "luaapp.gamesapi.user-game-votes" .. p2
end

return {
	Fetch = function(p2, value)
		assert(
			type(value) == "string",
			string.format(
				"FetchUserGameVotes thunk expects universeId to be a string, was %s",
				(type(value))
			)
		)
		return performFetch.Single("luaapp.gamesapi.user-game-votes" .. value, function(object)
			return GetUserGameVotes(p2, value):andThen(function(p3)
				local responseBody = p3.responseBody

				if
					responseBody == nil
					or responseBody.canVote == nil
					or responseBody.reasonForNotVoteable == nil
				then
					logging.warn("Response from GetUserGameVotes is malformed!")
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local userVote = responseBody.userVote
				local v6

				if userVote == true then
					v6 = VoteStatus.VotedUp
				elseif userVote == false then
					v6 = VoteStatus.VotedDown
				elseif userVote == nil then
					v6 = VoteStatus.NotVoted
				end

				if v6 then
					object:dispatch(SetUserGameVotes(
						value,
						responseBody.canVote,
						v6,
						responseBody.reasonForNotVoteable
					))

					return Promise.resolve(p3)
				end

				logging.warn("Response from GetUserGameVotes is malformed!")
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end, function(p3)
				object:dispatch(setNetworkingErrorToast(p3))
				return Promise.reject(p3)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.user-game-votes" .. p3)
	end
}
