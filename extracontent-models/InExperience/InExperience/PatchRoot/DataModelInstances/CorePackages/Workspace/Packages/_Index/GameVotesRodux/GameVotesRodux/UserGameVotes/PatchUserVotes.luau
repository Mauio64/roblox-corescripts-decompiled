local HttpService = game:GetService("HttpService")
local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local parent = GameVotesRodux.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local ReasonForNotVoteable = require(GameVotesRodux.Enums.ReasonForNotVoteable)
local VoteStatus = require(GameVotesRodux.Enums.VoteStatus)
local SetUserGameVotes = require(GameVotesRodux.UserGameVotes.SetUserGameVotes)
local GamesPatchUserVotes = require(GameVotesRodux.UserGameVotes.GamesPatchUserVotes)
local ToastRodux = require(parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local ToastRodux2 = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux2.Actions.SetCurrentToastMessage
local SetGameVotes = require(GameVotesRodux.GameVotes.SetGameVotes)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local Http2 = require(parent.Http)
local PerformFetch = Http2.PerformFetch

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

local function isTooManyRequestsError(p)
	if p then
		if p.HttpError == Enum.HttpError.OK then
			p = p.StatusCode == StatusCodes.TOO_MANY_REQUESTS
		else
			p = false
		end
	end

	return p
end

local function isPlayGameError(data): boolean
	if not data or data.HttpError ~= Enum.HttpError.OK or data.StatusCode ~= StatusCodes.FORBIDDEN then
		return false
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(data.Body)
	end)

	if success and result and result.errors then
		for _, err in ipairs(result.errors) do
			if err.code == 6 then
				return true
			end
		end
	end

	return false
end

local function fetchKeymapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.gamesapi.patch-user-votes" .. p
end

local PatchUserVotes = {}
PatchUserVotes.getNewGameVotes = getNewGameVotes

function PatchUserVotes.Patch(p, value, value2, value3)
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

	return PerformFetch.Single(fetchKeymapper(value), function(object) -- inferred equivalent call
		return GamesPatchUserVotes(p, value, value2):andThen(function(p2)
			local newGameVotes = getNewGameVotes(object:getState().GameVotes[value], value3, value2)

			object:dispatch(SetGameVotes(value, newGameVotes.upVotes, newGameVotes.downVotes))
			object:dispatch(SetUserGameVotes(value, true, value2, ""))
			return Promise.resolve(p2)
		end, function(p2)
			local v

			if p2 then
				if p2.HttpError == Enum.HttpError.OK then
					v = p2.StatusCode == StatusCodes.TOO_MANY_REQUESTS
				else
					v = false
				end
			else
				v = p2
			end

			if v then
				object:dispatch(SetUserGameVotes(value, false, value3, ReasonForNotVoteable.FloodCheckThresholdMet))

				object:dispatch(SetCurrentToastMessage({
					toastType = ToastType.NetworkingError,
					toastMessage = "Feature.Toast.VoteError.FloodCheckThresholdMet"
				}))
			else
				if not isPlayGameError(p2) then
					object:dispatch(SetNetworkingErrorToast(p2))
					return Promise.reject(p2)
				end

				object:dispatch(SetUserGameVotes(value, false, value3, ReasonForNotVoteable.PlayGame))
				object:dispatch(SetCurrentToastMessage({
					toastType = ToastType.NetworkingError,
					toastMessage = "Feature.Toast.VoteError.PlayGame"
				}))
			end

			return Promise.reject(p2)
		end)
	end)
end

function PatchUserVotes.GetPatchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fetchKeymapper(p2)) -- inferred equivalent call
end

return PatchUserVotes
