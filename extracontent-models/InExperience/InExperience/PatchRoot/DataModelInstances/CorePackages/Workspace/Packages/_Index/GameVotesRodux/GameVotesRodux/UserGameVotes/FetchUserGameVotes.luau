local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local parent = GameVotesRodux.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local GetUserGameVotes = require(GameVotesRodux.UserGameVotes.GetUserGameVotes)
local SetUserGameVotes = require(GameVotesRodux.UserGameVotes.SetUserGameVotes)
local VoteStatus = require(GameVotesRodux.Enums.VoteStatus)

local function getUserVoteStatus(userVote) -- 1 equivalent call inferred from this helper
	if userVote == true then
		return VoteStatus.VotedUp
	elseif userVote == false then
		return VoteStatus.VotedDown
	elseif userVote == nil then
		return VoteStatus.NotVoted
	end

	return nil
end

local function fetchKeymapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.gamesapi.user-game-votes" .. p
end

local FetchUserGameVotes = {}

function FetchUserGameVotes.Fetch(p, value)
	assert(
		type(value) == "string",
		string.format("FetchUserGameVotes thunk expects universeId to be a string, was %s", (type(value)))
	)

	return PerformFetch.Single(fetchKeymapper(value), function(object) -- inferred equivalent call
		return GetUserGameVotes(p, value):andThen(function(p2)
			local responseBody = p2.responseBody

			if responseBody == nil or responseBody.canVote == nil or responseBody.reasonForNotVoteable == nil then
				Logging.warn("Response from GetUserGameVotes is malformed!")
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end

			local userVoteStatus = getUserVoteStatus(responseBody.userVote) -- inferred equivalent call

			if userVoteStatus then
				object:dispatch(SetUserGameVotes(
					value,
					responseBody.canVote,
					userVoteStatus,
					responseBody.reasonForNotVoteable
				))

				return Promise.resolve(p2)
			end

			Logging.warn("Response from GetUserGameVotes is malformed!")
			return Promise.reject({ HttpError = Enum.HttpError.OK })
		end, function(p2)
			object:dispatch(SetNetworkingErrorToast(p2))
			return Promise.reject(p2)
		end)
	end)
end

function FetchUserGameVotes.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fetchKeymapper(p2)) -- inferred equivalent call
end

return FetchUserGameVotes
