local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Dash")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local HttpService = game:GetService("HttpService")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local VotesStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/VotesStoreTypes")
local VotesUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/VotesUtils")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").StatusCodes
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/fetchVotes")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/fetchUserVote")
local requestUserVoteUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/requestUserVoteUpdate")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local reasonNotVoteable = VotesStoreTypes.ReasonNotVoteable

local fFlagLuaAppInExperienceDetailsPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppInExperienceDetailsPrompt
local fFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem

local getGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/getGameInfoStore")

local defineFastInt = game:DefineFastInt("USER_VOTE_CACHE_TTL_SECONDS", 600)

local function createVotesStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return module9((Dash.keys(p2))):andThen(function(data)
				if not data then
					error("No response")
				end

				if not (data.responseBody and data.responseBody.data) then
					if fFlagLuaAppInExperienceDetailsPrompt then
						error(`Response Code: {data.responseCode}`)
					else
						error(`Response Code: {data.reponseCode}`)
					end
				end

				local v7 = {}
				local data2 = data.responseBody.data
				Dash.forEach(data2, function(data3)
					local upVotes = data3.upVotes
					local downVotes = data3.downVotes
					local v8 = if typeof(upVotes) == "number" and typeof(downVotes) == "number" then VotesUtils.calculateRating(upVotes, downVotes) else nil

					v7[tostring(data3.id)] = {
						upVotes = upVotes,
						downVotes = downVotes,
						rating = v8
					}
				end)

				return v7
			end):catch(function(p3)
				error(`Error requesting votes: {p3}`)
			end)
		end
	})

	local v7 = createDataCache(defineFastInt)

	local v8 = createDataResolver({
		cache = v7,
		logError = function(p2)
			logResponseError("v1/games/votes/user", p2)
		end,
		fetchFn = function(p2, p3)
			return module10(p2):andThen(function(p4)
				local responseBody = p4.responseBody

				if not VotesStoreTypes.userVoteResponseValidator(responseBody) then
					discoveryEventErrorLogger.reportError(
						"createVotesStore",
						"Invalid user vote response",
						{ universeId = p2, responseBody = responseBody }
					)

					error({ StatusCode = p4.responseCode })
				end

				return responseBody
			end)
		end,
		supportsMultiGet = false,
		supportsMutations = true
	})

	local function updateUserVote(p2, p3)
		local signal, v9 = Signals.createSignal(nil)

		local optimisticCachedItem, v10 = v8.getOptimisticCachedItem(p2)
		local v11 = optimisticCachedItem and optimisticCachedItem.data(false)
		local userVote = if v11 then v11.userVote else nil

		local item = v5.getItem(p2)
		local v12 = item and item.data(false)

		if not v10 and v11 and not v11.canVote then
			v9({ type = "error", reasonForNotVoteable = v11.reasonForNotVoteable })

			return signal
		end

		local v14 = if p3 == nil then Cryo.None else p3
		v8.setMutation(p2, { userVote = v14 })

		if v12 then
			local v15 = userVote == true and 1 or 0
			local v16 = userVote == false and 1 or 0

			local v17 = p3 == true and 1 or 0
			local v18 = p3 == false and 1 or 0

			local v19 = v17 - v15
			local v20 = v18 - v16
			local v21 = v12.upVotes + v19
			local v22 = v12.downVotes + v20
			local v23 = math.max(0, v21)
			local v24 = math.max(0, v22)
			local v25 = {
				upVotes = v23,
				downVotes = v24,
				rating = VotesUtils.calculateRating(v23, v24)
			}

			v5.updateItem(p2, v25)
		end

		local v15 = getGameInfoStore(false).applyVoteChange(p2, userVote, p3)

		requestUserVoteUpdate(p2, p3):andThen(function(p4)
			v8.commitMutation(p2)
			v9({ type = "success", userVote = p3 })
		end):catch(function(data)
			v8.clearMutation(p2)

			if v12 then
				v5.updateItem(p2, v12)
			end

			if v15 then
				getGameInfoStore(false).updateGameInfo(p2, v15)
			end

			local statusCode = if type(data) == "table" and data.StatusCode then data.StatusCode else nil

			local v16 = nil

			if statusCode then
				local success, result = pcall(function()
					return HttpService:JSONDecode(data.Body)
				end)

				if success and result and result.errors then
					for i, err in ipairs(result.errors) do
						if err.code == VotesStoreTypes.PLAY_GAME_ERROR_CODE then
							v16 = reasonNotVoteable.PlayGame
						end
					end
				end

				if statusCode == statusCodes.TOO_MANY_REQUESTS then
					v16 = reasonNotVoteable.FloodCheckThresholdMet
				end
			end

			v9({ type = "error", reasonForNotVoteable = v16 })

			local v17 = if type(data) == "table" and data.StatusMessage then data.StatusMessage else nil
			discoveryEventErrorLogger.reportError("updateUserVote", "Error updating user vote", {
				universeId = p2,
				statusCode = statusCode,
				statusMessage = v17
			})

			logResponseError("v1/games/votes/user-votes", { StatusCode = statusCode })
		end)
		return signal
	end

	local function updateVoteItems(items)
		local v9 = {}

		for k, item in items do
			v9[k] = {
				upVotes = item.upVotes,
				downVotes = item.downVotes,
				rating = VotesUtils.calculateRating(item.upVotes, item.downVotes)
			}
		end

		v5.updateItems(v9)
	end

	local votesStore = {
		fetchVote = v6.fetchItem,
		fetchVotes = v6.fetchItems,
		getVote = v6.getCachedItem,
		getVotes = v6.getCachedItems,
		getAndFetchVote = v6.getAndFetchItem,
		getAndFetchVotes = v6.getAndFetchItems,
		fetchUserVote = v8.fetchItem,
		fetchUserVotes = v8.fetchItems,
		getUserVote = v8.getOptimisticCachedItem,
		getUserVotes = v8.getOptimisticCachedItems,
		getAndFetchUserVote = v8.getOptimisticAndFetchItem,
		getAndFetchUserVotes = v8.getOptimisticAndFetchItems,
		updateUserVote = updateUserVote,
		updateVoteItem = fFlagLuaAppDataHydrationUpdateItem and function(p2, p3, p4)
			v5.updateItem(p2, {
				downVotes = p3,
				upVotes = p4,
				rating = VotesUtils.calculateRating(p4, p3)
			})
		end or nil,
		updateVoteItems = updateVoteItems,
		updateUserVoteItem = 0,
		updateUserVoteItems = 0,
		clear = 0,
		dispose = 0
	}

	local v9 = if fFlagLuaAppDataHydrationUpdateItem then v7.updateItem else nil
	votesStore.updateUserVoteItem = v9
	votesStore.updateUserVoteItems = v7.updateItems

	function votesStore.clear()
		v5.clear()
		v6.clear()
		v7.clear()
		v8.clear()
	end

	function votesStore.dispose()
		v5.dispose()
		v6.dispose()
		v8.dispose()
	end
	return votesStore
end

return createVotesStore
