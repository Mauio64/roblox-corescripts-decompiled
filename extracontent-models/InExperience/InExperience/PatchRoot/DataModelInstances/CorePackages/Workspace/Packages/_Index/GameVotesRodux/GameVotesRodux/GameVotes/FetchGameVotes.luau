local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local parent = GameVotesRodux.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local SetGameVotes = require(GameVotesRodux.GameVotes.SetGameVotes)
local GetGameVotes = require(GameVotesRodux.GameVotes.GetGameVotes)

local function fetchKeymapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.gamesapi.game-votes" .. p
end

local FetchGameVotes = {}

function FetchGameVotes.Fetch(p, value)
	assert(
		type(value) == "string",
		string.format("FetchGameVotes thunk expects universeId to be a string, was %s", (type(value)))
	)

	return PerformFetch.Single(fetchKeymapper(value), function(object) -- inferred equivalent call
		return GetGameVotes(p, value):andThen(function(p2)
			local responseBody = p2.responseBody

			if responseBody == nil or responseBody.upVotes == nil or responseBody.downVotes == nil then
				Logging.warn("Response from GetGameVotes is malformed!")
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end

			object:dispatch(SetGameVotes(
				value,
				responseBody.upVotes < 0 and 0 or responseBody.upVotes,
				responseBody.downVotes < 0 and 0 or responseBody.downVotes
			))

			return Promise.resolve(p2)
		end, function(p2)
			object:dispatch(SetNetworkingErrorToast(p2))
			return Promise.reject(p2)
		end)
	end)
end

function FetchGameVotes.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fetchKeymapper(p2)) -- inferred equivalent call
end

return FetchGameVotes
