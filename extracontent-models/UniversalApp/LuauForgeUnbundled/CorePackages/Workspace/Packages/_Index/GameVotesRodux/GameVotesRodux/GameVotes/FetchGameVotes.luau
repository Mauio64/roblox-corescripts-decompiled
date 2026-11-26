local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/AppCommonLib").Logging
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast
local SetGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/GameVotes/SetGameVotes")
local GetGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameVotesRodux/GameVotesRodux/GameVotes/GetGameVotes")

local function fetchKeymapper(p2)
	return "luaapp.gamesapi.game-votes" .. p2
end

return {
	Fetch = function(p2, value)
		assert(
			type(value) == "string",
			string.format("FetchGameVotes thunk expects universeId to be a string, was %s", (type(value)))
		)
		return performFetch.Single("luaapp.gamesapi.game-votes" .. value, function(object)
			return GetGameVotes(p2, value):andThen(function(p3)
				local responseBody = p3.responseBody

				if responseBody == nil or responseBody.upVotes == nil or responseBody.downVotes == nil then
					logging.warn("Response from GetGameVotes is malformed!")
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				object:dispatch(SetGameVotes(
					value,
					responseBody.upVotes < 0 and 0 or responseBody.upVotes,
					responseBody.downVotes < 0 and 0 or responseBody.downVotes
				))

				return Promise.resolve(p3)
			end, function(p3)
				object:dispatch(setNetworkingErrorToast(p3))
				return Promise.reject(p3)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.game-votes" .. p3)
	end
}
