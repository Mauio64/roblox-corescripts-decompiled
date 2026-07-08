local HttpService = game:GetService("HttpService")
local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local GameVotesRoduxParent = GameVotesRodux.Parent
local Promise = require(GameVotesRoduxParent.Promise)
local StatusCodes = require(GameVotesRoduxParent.Http).StatusCodes
local ReasonForNotVoteable = require(GameVotesRodux.Enums.ReasonForNotVoteable)
local VoteStatus = require(GameVotesRodux.Enums.VoteStatus)
local SetUserGameVotes = require(GameVotesRodux.UserGameVotes.SetUserGameVotes)
local GamesPatchUserVotes = require(GameVotesRodux.UserGameVotes.GamesPatchUserVotes)
local ToastType = require(GameVotesRoduxParent.ToastRodux).Enums.ToastType
local SetCurrentToastMessage = require(GameVotesRoduxParent.ToastRodux).Actions.SetCurrentToastMessage
local SetGameVotes = require(GameVotesRodux.GameVotes.SetGameVotes)
local SetNetworkingErrorToast = require(GameVotesRoduxParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local PerformFetch = require(GameVotesRoduxParent.Http).PerformFetch

local function getNewGameVotes(p1, p2, p3) -- line: 19
	-- upvalues: VoteStatus (copy)
	if p2 == p3 then
		return p1
	end

	local v22 = p1 and p1.upVotes
	local v23 = p1 and p1.downVotes

	if p3 == VoteStatus.VotedUp then
		v22 += 1

		if p2 == VoteStatus.VotedDown then
			v23 -= 1
		end
	elseif p3 == VoteStatus.VotedDown then
		v23 += 1

		if p2 == VoteStatus.VotedUp then
			v22 -= 1
		end
	elseif p3 == VoteStatus.NotVoted then
		if p2 == VoteStatus.VotedUp then
			v22 -= 1
		elseif p2 == VoteStatus.VotedDown then
			v23 -= 1
		end
	end

	return {
		upVotes = v22,
		downVotes = v23
	}
end
local function isTooManyRequestsError(p4) -- line: 50
	-- upvalues: StatusCodes (copy)
	return p4 and (p4.HttpError == Enum.HttpError.OK and p4.StatusCode == StatusCodes.TOO_MANY_REQUESTS)
end
local function isPlayGameError(p5) -- line: 54
	-- upvalues: StatusCodes (copy), HttpService (copy)
	if p5 and (p5.HttpError == Enum.HttpError.OK and p5.StatusCode == StatusCodes.FORBIDDEN) then
		local ok, result = pcall(function() -- line: 56
			-- upvalues: HttpService (copy), p5 (copy)
			return HttpService:JSONDecode(p5.Body)
		end)

		if ok and result and result.errors then
			for _, v in ipairs(result.errors) do
				if v.code == 6 then
					return true
				end
			end
		end
	end

	return false
end
local function fetchKeymapper(p6) -- line: 70
	return "luaapp.gamesapi.patch-user-votes" .. p6
end

return {
	getNewGameVotes = getNewGameVotes,
	Patch = function(p7, p8, p9, p10) -- line: 78
		-- upvalues: Promise (copy), PerformFetch (copy), GamesPatchUserVotes (copy), getNewGameVotes (copy), SetGameVotes (copy), SetUserGameVotes (copy), StatusCodes (copy), ReasonForNotVoteable (copy), SetCurrentToastMessage (copy), ToastType (copy), isPlayGameError (copy), SetNetworkingErrorToast (copy)
		assert(type(p8) == "string", string.format("PatchUserVotes thunk expects universeId to be a string, was %s", (type(p8))))
		assert(type(p9) == "string", string.format("PatchUserVotes thunk expects vote to be a string, was %s", (type(p9))))
		assert(type(p10) == "string", string.format("PatchUserVotes thunk expects curVote to be a string, was %s", (type(p10))))

		if p9 == p10 then
			return Promise.resolve()
		end

		return PerformFetch.Single("luaapp.gamesapi.patch-user-votes" .. p8, function(p11) -- line: 97
			-- upvalues: GamesPatchUserVotes (copy), p7 (copy), p8 (copy), p9 (copy), getNewGameVotes (copy), p10 (copy), SetGameVotes (copy), SetUserGameVotes (copy), Promise (copy), StatusCodes (copy), ReasonForNotVoteable (copy), SetCurrentToastMessage (copy), ToastType (copy), isPlayGameError (copy), SetNetworkingErrorToast (copy)
			return GamesPatchUserVotes(p7, p8, p9):andThen(function(p12) -- line: 98
				-- upvalues: p11 (copy), p8 (copy), getNewGameVotes (copy), p10 (copy), p9 (copy), SetGameVotes (copy), SetUserGameVotes (copy), Promise (copy)
				local v39 = p11:getState().GameVotes[p8]
				local v40 = getNewGameVotes(v39, p10, p9)

				p11:dispatch(SetGameVotes(p8, v40.upVotes, v40.downVotes))
				p11:dispatch(SetUserGameVotes(p8, true, p9, ""))

				return Promise.resolve(p12)
			end, function(p13) -- line: 105
				-- upvalues: StatusCodes (copy), p11 (copy), SetUserGameVotes (copy), p8 (copy), p10 (copy), ReasonForNotVoteable (copy), SetCurrentToastMessage (copy), ToastType (copy), Promise (copy), isPlayGameError (copy), SetNetworkingErrorToast (copy)
				if p13 and (p13.HttpError == Enum.HttpError.OK and p13.StatusCode == StatusCodes.TOO_MANY_REQUESTS) then
					p11:dispatch(SetUserGameVotes(p8, false, p10, ReasonForNotVoteable.FloodCheckThresholdMet))
					p11:dispatch(SetCurrentToastMessage({
						toastMessage = "Feature.Toast.VoteError.FloodCheckThresholdMet",
						toastType = ToastType.NetworkingError
					}))

					return Promise.reject(p13)
				end

				if isPlayGameError(p13) then
					p11:dispatch(SetUserGameVotes(p8, false, p10, ReasonForNotVoteable.PlayGame))
					p11:dispatch(SetCurrentToastMessage({
						toastMessage = "Feature.Toast.VoteError.PlayGame",
						toastType = ToastType.NetworkingError
					}))

					return Promise.reject(p13)
				end

				p11:dispatch(SetNetworkingErrorToast(p13))

				return Promise.reject(p13)
			end)
		end)
	end,
	GetPatchingStatus = function(p14, p15) -- line: 129
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p14, "luaapp.gamesapi.patch-user-votes" .. p15)
	end
}
