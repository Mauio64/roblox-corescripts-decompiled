local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local GameVotesRoduxParent = GameVotesRodux.Parent
local Promise = require(GameVotesRoduxParent.Promise)
local PerformFetch = require(GameVotesRoduxParent.Http).PerformFetch
local Logging = require(GameVotesRoduxParent.AppCommonLib).Logging
local SetNetworkingErrorToast = require(GameVotesRoduxParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local GetUserGameVotes = require(GameVotesRodux.UserGameVotes.GetUserGameVotes)
local SetUserGameVotes = require(GameVotesRodux.UserGameVotes.SetUserGameVotes)
local VoteStatus = require(GameVotesRodux.Enums.VoteStatus)

local function getUserVoteStatus(p1) -- line: 11
	-- upvalues: VoteStatus (copy)
	if p1 == true then
		return VoteStatus.VotedUp
	end

	if p1 == false then
		return VoteStatus.VotedDown
	end

	if p1 == nil then
		return VoteStatus.NotVoted
	end

	return nil
end

local t1 = {}

local function fetchKeymapper(p2) -- line: 24
	return "luaapp.gamesapi.user-game-votes" .. p2
end

function t1.Fetch(p3, p4) -- line: 28
	-- upvalues: PerformFetch (copy), GetUserGameVotes (copy), VoteStatus (copy), SetUserGameVotes (copy), Logging (copy), Promise (copy), SetNetworkingErrorToast (copy)
	assert(type(p4) == "string", string.format("FetchUserGameVotes thunk expects universeId to be a string, was %s", (type(p4))))

	return PerformFetch.Single("luaapp.gamesapi.user-game-votes" .. p4, function(p5) -- line: 34
		-- upvalues: GetUserGameVotes (copy), p3 (copy), p4 (copy), VoteStatus (copy), SetUserGameVotes (copy), Logging (copy), Promise (copy), SetNetworkingErrorToast (copy)
		return GetUserGameVotes(p3, p4):andThen(function(p6) -- line: 35
			-- upvalues: VoteStatus (copy), p5 (copy), SetUserGameVotes (copy), p4 (copy), Logging (copy), Promise (copy)
			local responseBody = p6.responseBody

			if responseBody ~= nil and (responseBody.canVote ~= nil and responseBody.reasonForNotVoteable ~= nil) then
				local userVote = responseBody.userVote
				local v23 = if userVote ~= true then if userVote ~= false then if userVote ~= nil then nil else VoteStatus.NotVoted else VoteStatus.VotedDown else VoteStatus.VotedUp

				if v23 then
					p5:dispatch(SetUserGameVotes(p4, responseBody.canVote, v23, responseBody.reasonForNotVoteable))

					return Promise.resolve(p6)
				end

				Logging.warn("Response from GetUserGameVotes is malformed!")

				return Promise.reject({
					HttpError = Enum.HttpError.OK
				})
			end

			Logging.warn("Response from GetUserGameVotes is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p7) -- line: 53
			-- upvalues: p5 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p5:dispatch(SetNetworkingErrorToast(p7))

			return Promise.reject(p7)
		end)
	end)
end
function t1.GetFetchingStatus(p8, p9) -- line: 60
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p8, "luaapp.gamesapi.user-game-votes" .. p9)
end

return t1
