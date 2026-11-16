local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
local Dash = require(parent.Dash)
local Signals = require(parent.Signals)

local HttpService = game:GetService("HttpService")
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local VotesStoreTypes = require(script.Parent.VotesStoreTypes)
local VotesUtils = require(script.Parent.VotesUtils)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchVotes = require(script.Parent.fetchVotes)
local fetchUserVote = require(script.Parent.fetchUserVote)
local requestUserVoteUpdate = require(script.Parent.requestUserVoteUpdate)
local SharedFlags = require(parent.SharedFlags)

local FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes = SharedFlags.FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes
local ReasonNotVoteable = VotesStoreTypes.ReasonNotVoteable

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppInExperienceDetailsPrompt = SharedFlags2.FFlagLuaAppInExperienceDetailsPrompt
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem

local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)

local defineFastInt = game:DefineFastInt("USER_VOTE_CACHE_TTL_SECONDS", 600)

local function createVotesStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(p)
			return fetchVotes((Dash.keys(p))):andThen(function(data)
				if not data then
					error("No response")
				end

				if not (data.responseBody and data.responseBody.data) then
					if FFlagLuaAppInExperienceDetailsPrompt then
						error(`Response Code: {data.responseCode}`)
					else
						error(`Response Code: {data.reponseCode}`)
					end
				end

				local v = {}
				local data2 = data.responseBody.data
				Dash.forEach(data2, function(data3)
					local upVotes = data3.upVotes
					local downVotes = data3.downVotes
					local rating

					if typeof(upVotes) == "number" and typeof(downVotes) == "number" then
						rating = VotesUtils.calculateRating(upVotes, downVotes)
					end

					v[tostring(data3.id)] = {
						upVotes = upVotes,
						downVotes = downVotes,
						rating = rating
					}
				end)

				return v
			end):catch(function(p2)
				error(`Error requesting votes: {p2}`)
			end)
		end
	})

	local dataCache2 = createDataCache(defineFastInt)

	local dataResolver2 = createDataResolver({
		cache = dataCache2,
		logError = function(p)
			logResponseError("v1/games/votes/user", p)
		end,
		fetchFn = function(universeId: string, _)
			return fetchUserVote(universeId):andThen(function(p)
				local responseBody = p.responseBody

				if not VotesStoreTypes.userVoteResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createVotesStore", "Invalid user vote response", {
						universeId = universeId,
						responseBody = responseBody
					})

					error({ StatusCode = p.responseCode })
				end

				return responseBody
			end)
		end,
		supportsMultiGet = false,
		supportsMutations = true
	})

	local function updateUserVote(universeId: string, userVote2: boolean?)
		local signal, v = Signals.createSignal(nil)

		local optimisticCachedItem, v2 = dataResolver2.getOptimisticCachedItem(universeId)
		local v3 = optimisticCachedItem and optimisticCachedItem.data(false)
		local userVote

		if v3 then
			userVote = v3.userVote
		end

		local item = dataCache.getItem(universeId)
		local v4 = item and item.data(false)

		if not v2 and v3 and not v3.canVote then
			v({ type = "error", reasonForNotVoteable = v3.reasonForNotVoteable })

			return signal
		end

		local userVote3

		if userVote2 == nil then
			userVote3 = Cryo.None
		else
			userVote3 = userVote2
		end

		dataResolver2.setMutation(universeId, { userVote = userVote3 })

		if v4 then
			local v5, v6

			if FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes then
				local v7 = userVote == true and 1 or 0
				local v8 = userVote == false and 1 or 0

				local v9 = userVote2 == true and 1 or 0
				local v10 = userVote2 == false and 1 or 0

				v5 = v9 - v7
				v6 = v10 - v8
			else
				v5 = userVote2 == true and 1 or 0
				v6 = if userVote2 == false then 1 else 0
			end

			local upVotes = v4.upVotes + v5
			local downVotes = v4.downVotes + v6

			if FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes then
				upVotes = math.max(0, upVotes)
				downVotes = math.max(0, downVotes)
			end

			local v7 = {
				upVotes = upVotes,
				downVotes = downVotes,
				rating = VotesUtils.calculateRating(upVotes, downVotes)
			}

			dataCache.updateItem(universeId, v7)
		end

		local v5 = getGameInfoStore(false).applyVoteChange(universeId, userVote, userVote2)

		requestUserVoteUpdate(universeId, userVote2):andThen(function(_)
			dataResolver2.commitMutation(universeId)
			v({ type = "success", userVote = userVote2 })
		end):catch(function(data)
			dataResolver2.clearMutation(universeId)

			if v4 then
				dataCache.updateItem(universeId, v4)
			end

			if v5 then
				getGameInfoStore(false).updateGameInfo(universeId, v5)
			end

			local statusCode

			if type(data) == "table" and data.StatusCode then
				statusCode = data.StatusCode
			end

			local reasonForNotVoteable = nil

			if statusCode then
				local success, result = pcall(function()
					return HttpService:JSONDecode(data.Body)
				end)

				if success and result and result.errors then
					for _, err in ipairs(result.errors) do
						if err.code == VotesStoreTypes.PLAY_GAME_ERROR_CODE then
							reasonForNotVoteable = ReasonNotVoteable.PlayGame
						end
					end
				end

				if statusCode == StatusCodes.TOO_MANY_REQUESTS then
					reasonForNotVoteable = ReasonNotVoteable.FloodCheckThresholdMet
				end
			end

			v({ type = "error", reasonForNotVoteable = reasonForNotVoteable })
			local statusMessage

			if type(data) == "table" and data.StatusMessage then
				statusMessage = data.StatusMessage
			end

			DiscoveryEventErrorLogger.reportError("updateUserVote", "Error updating user vote", {
				universeId = universeId,
				statusCode = statusCode,
				statusMessage = statusMessage
			})

			logResponseError("v1/games/votes/user-votes", { StatusCode = statusCode })
		end)
		return signal
	end

	local function updateVoteItems(items)
		local v = {}

		for k, item in items do
			v[k] = {
				upVotes = item.upVotes,
				downVotes = item.downVotes,
				rating = VotesUtils.calculateRating(item.upVotes, item.downVotes)
			}
		end

		dataCache.updateItems(v)
	end

	local votesStore = {
		fetchVote = dataResolver.fetchItem,
		fetchVotes = dataResolver.fetchItems,
		getVote = dataResolver.getCachedItem,
		getVotes = dataResolver.getCachedItems,
		getAndFetchVote = dataResolver.getAndFetchItem,
		getAndFetchVotes = dataResolver.getAndFetchItems,
		fetchUserVote = dataResolver2.fetchItem,
		fetchUserVotes = dataResolver2.fetchItems,
		getUserVote = dataResolver2.getOptimisticCachedItem,
		getUserVotes = dataResolver2.getOptimisticCachedItems,
		getAndFetchUserVote = dataResolver2.getOptimisticAndFetchItem,
		getAndFetchUserVotes = dataResolver2.getOptimisticAndFetchItems,
		updateUserVote = updateUserVote,
		updateVoteItem = FFlagLuaAppDataHydrationUpdateItem and function(p: string, downVotes: number, upVotes: number)
			dataCache.updateItem(p, {
				downVotes = downVotes,
				upVotes = upVotes,
				rating = VotesUtils.calculateRating(upVotes, downVotes)
			})
		end or nil,
		updateVoteItems = updateVoteItems,
		updateUserVoteItem = 0,
		updateUserVoteItems = 0,
		clear = 0,
		dispose = 0
	}
	local updateUserVoteItem

	if FFlagLuaAppDataHydrationUpdateItem then
		updateUserVoteItem = dataCache2.updateItem
	end

	votesStore.updateUserVoteItem = updateUserVoteItem
	votesStore.updateUserVoteItems = dataCache2.updateItems

	function votesStore.clear()
		dataCache.clear()
		dataResolver.clear()
		dataCache2.clear()
		dataResolver2.clear()
	end

	function votesStore.dispose()
		dataCache.dispose()
		dataResolver.dispose()
		dataResolver2.dispose()
	end
	return votesStore
end

return createVotesStore
