local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Promise")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Http").StatusCodes
local ReasonForNotVoteable = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/Enums/ReasonForNotVoteable")
local VoteStatus = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/Enums/VoteStatus")
local SetUserGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/UserGameVotes/SetUserGameVotes")
local GamesPatchUserVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/UserGameVotes/GamesPatchUserVotes")
local toastType = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/ToastRodux").Enums.ToastType
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/ToastRodux").Actions.SetCurrentToastMessage
local SetGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/GameVotes/SetGameVotes")
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Http").PerformFetch

local function getNewGameVotes(gameVote, value, value2)
	if value == value2 then
		return gameVote
	end

	local upVotes = gameVote and gameVote.upVotes
	local downVotes = gameVote and gameVote.downVotes

	if value2 == VoteStatus.VotedUp then
		upVotes += 1

		if value == VoteStatus.VotedDown then
			downVotes -= 1
		end
	elseif value2 == VoteStatus.VotedDown then
		downVotes += 1

		if value == VoteStatus.VotedUp then
			upVotes -= 1
		end
	elseif value2 == VoteStatus.NotVoted then
		if value == VoteStatus.VotedUp then
			upVotes -= 1
		elseif value == VoteStatus.VotedDown then
			downVotes -= 1
		end
	end

	return { upVotes = upVotes, downVotes = downVotes }
end

local function isTooManyRequestsError(p2)
	if p2 then
		p2 = p2.HttpError == Enum.HttpError.OK and p2.StatusCode == statusCodes.TOO_MANY_REQUESTS
	end

	return p2
end

local function isPlayGameError(data): boolean
	if not data or data.HttpError ~= Enum.HttpError.OK or data.StatusCode ~= statusCodes.FORBIDDEN then
		return false
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(data.Body)
	end)

	if success and result and result.errors then
		for i, err in ipairs(result.errors) do
			if err.code == 6 then
				return true
			end
		end
	end

	return false
end

local function fetchKeymapper(p2)
	return "luaapp.gamesapi.patch-user-votes" .. p2
end

return {
	["getNewGameVotes"] = getNewGameVotes,
	Patch = function(p2, value, value2, value3)
		assert(
			type(value) == "string",
			string.format("PatchUserVotes thunk expects universeId to be a string, was %s", (type(value)))
		)

		assert(
			type(value2) == "string",
			string.format("PatchUserVotes thunk expects vote to be a string, was %s", (type(value2)))
		)

		assert(
			type(value3) == "string",
			string.format("PatchUserVotes thunk expects curVote to be a string, was %s", (type(value3)))
		)

		if value2 == value3 then
			return Promise.resolve()
		end

		return performFetch.Single("luaapp.gamesapi.patch-user-votes" .. value, function(object)
			return GamesPatchUserVotes(p2, value, value2):andThen(function(p3)
				local newGameVotes = getNewGameVotes(object:getState().GameVotes[value], value3, value2)

				object:dispatch(SetGameVotes(value, newGameVotes.upVotes, newGameVotes.downVotes))
				object:dispatch(SetUserGameVotes(value, true, value2, ""))
				return Promise.resolve(p3)
			end, function(p3)
				local v5

				if p3 then
					v5 = p3.HttpError == Enum.HttpError.OK
						and p3.StatusCode == statusCodes.TOO_MANY_REQUESTS
				else
					v5 = p3
				end

				if v5 then
					object:dispatch(SetUserGameVotes(value, false, value3, ReasonForNotVoteable.FloodCheckThresholdMet))

					object:dispatch(setCurrentToastMessage({
						toastType = toastType.NetworkingError,
						toastMessage = "Feature.Toast.VoteError.FloodCheckThresholdMet"
					}))
				else
					if not isPlayGameError(p3) then
						object:dispatch(setNetworkingErrorToast(p3))
						return Promise.reject(p3)
					end

					object:dispatch(SetUserGameVotes(value, false, value3, ReasonForNotVoteable.PlayGame))
					object:dispatch(setCurrentToastMessage({
						toastType = toastType.NetworkingError,
						toastMessage = "Feature.Toast.VoteError.PlayGame"
					}))
				end

				return Promise.reject(p3)
			end)
		end)
	end,
	GetPatchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.patch-user-votes" .. p3)
	end
}
