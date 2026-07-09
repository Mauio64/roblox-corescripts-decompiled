local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local GameVotesRoduxParent = GameVotesRodux.Parent
local Promise = require(GameVotesRoduxParent.Promise)
local PerformFetch = require(GameVotesRoduxParent.Http).PerformFetch
local Logging = require(GameVotesRoduxParent.AppCommonLib).Logging
local SetNetworkingErrorToast = require(GameVotesRoduxParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local SetGameVotes = require(GameVotesRodux.GameVotes.SetGameVotes)
local GetGameVotes = require(GameVotesRodux.GameVotes.GetGameVotes)
local t1 = {}

local function fetchKeymapper(p1) -- line: 12
	return "luaapp.gamesapi.game-votes" .. p1
end

function t1.Fetch(p2, p3) -- line: 16
	-- upvalues: PerformFetch (copy), GetGameVotes (copy), SetGameVotes (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
	assert(type(p3) == "string", string.format("FetchGameVotes thunk expects universeId to be a string, was %s", (type(p3))))

	return PerformFetch.Single("luaapp.gamesapi.game-votes" .. p3, function(p4) -- line: 22
		-- upvalues: GetGameVotes (copy), p2 (copy), p3 (copy), SetGameVotes (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
		return GetGameVotes(p2, p3):andThen(function(p5) -- line: 23
			-- upvalues: p4 (copy), SetGameVotes (copy), p3 (copy), Promise (copy), Logging (copy)
			local responseBody = p5.responseBody

			if responseBody ~= nil and (responseBody.upVotes ~= nil and responseBody.downVotes ~= nil) then
				p4:dispatch(SetGameVotes(p3, if not (responseBody.upVotes < 0) then responseBody.upVotes else 0, if not (responseBody.downVotes < 0) then responseBody.downVotes else 0))

				return Promise.resolve(p5)
			end

			Logging.warn("Response from GetGameVotes is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p6) -- line: 39
			-- upvalues: p4 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p4:dispatch(SetNetworkingErrorToast(p6))

			return Promise.reject(p6)
		end)
	end)
end
function t1.GetFetchingStatus(p7, p8) -- line: 46
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p7, "luaapp.gamesapi.game-votes" .. p8)
end

return t1
