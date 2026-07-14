local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Cryo = require(DataHydrationParent.Cryo)
local Dash = require(DataHydrationParent.Dash)
local Signals = require(DataHydrationParent.Signals)
local HttpService = game:GetService("HttpService")
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local VotesStoreTypes = require(script.Parent.VotesStoreTypes)
local VotesUtils = require(script.Parent.VotesUtils)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local StatusCodes = require(DataHydrationParent.Http).StatusCodes
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchVotes = require(script.Parent.fetchVotes)
local fetchUserVote = require(script.Parent.fetchUserVote)
local requestUserVoteUpdate = require(script.Parent.requestUserVoteUpdate)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes = SharedFlags.FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes
local FFlagLuaAppDataHydrationOptimisticMutationLayer = SharedFlags.FFlagLuaAppDataHydrationOptimisticMutationLayer
local ReasonNotVoteable = VotesStoreTypes.ReasonNotVoteable
local FFlagLuaAppInExperienceDetailsPrompt = require(DataHydrationParent.SharedFlags).FFlagLuaAppInExperienceDetailsPrompt
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem
local FFlagLuaAppVoteOptimisticUpdateRaceFix = SharedFlags.FFlagLuaAppVoteOptimisticUpdateRaceFix
local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local v27 = game:DefineFastInt("USER_VOTE_CACHE_TTL_SECONDS", 600)

local function createVotesStore() -- line: 42
	-- upvalues: createDataCache (copy), createDataResolver (copy), Dash (copy), fetchVotes (copy), FFlagLuaAppInExperienceDetailsPrompt (copy), VotesUtils (copy), v27 (copy), logResponseError (copy), fetchUserVote (copy), VotesStoreTypes (copy), DiscoveryEventErrorLogger (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), Signals (copy), FFlagLuaAppVoteOptimisticUpdateRaceFix (copy), Cryo (copy), FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes (copy), FFlagSduiExperienceDetailsSupport (copy), getGameInfoStore (copy), requestUserVoteUpdate (copy), HttpService (copy), ReasonNotVoteable (copy), StatusCodes (copy), FFlagLuaAppDataHydrationUpdateItem (copy)
	local v29 = createDataCache()
	local v30 = createDataResolver({
		cache = v29,
		fetchFn = function(t1: {[any]: any}) -- line: 46
			-- upvalues: Dash (copy), fetchVotes (copy), FFlagLuaAppInExperienceDetailsPrompt (copy), VotesUtils (copy)
			local v34 = Dash.keys(t1)

			return fetchVotes(v34):andThen(function(p1) -- line: 51
				-- upvalues: FFlagLuaAppInExperienceDetailsPrompt (copy), Dash (copy), VotesUtils (copy)
				if not p1 then
					error("No response")
				end

				if not p1.responseBody or not p1.responseBody.data then
					if FFlagLuaAppInExperienceDetailsPrompt then
						error(`Response Code: { p1.responseCode }`)
					else
						error(`Response Code: { p1.reponseCode }`)
					end
				end

				local t2 = {}
				local data = p1.responseBody.data

				Dash.forEach(data, function(p2) -- line: 65
					-- upvalues: VotesUtils (copy), t2 (copy)
					local v83 = nil
					local upVotes = p2.upVotes
					local downVotes = p2.downVotes

					if typeof(upVotes) == "number" and typeof(downVotes) == "number" then
						v83 = VotesUtils.calculateRating(upVotes, downVotes)
					end

					t2[tostring(p2.id)] = {
						upVotes = upVotes,
						downVotes = downVotes,
						rating = v83
					}
				end)

				return t2
			end):catch(function(p3) -- line: 81
				error(`Error requesting votes: { p3 }`)
			end)
		end
	})
	local v31 = createDataCache(v27)
	local v32 = createDataResolver({
		supportsMultiGet = false,
		cache = v31,
		logError = function(p4) -- line: 92
			-- upvalues: logResponseError (copy)
			logResponseError("v1/games/votes/user", p4)
		end,
		fetchFn = function(s1: string, _) -- line: 95
			-- upvalues: fetchUserVote (copy), VotesStoreTypes (copy), DiscoveryEventErrorLogger (copy)
			return fetchUserVote(s1):andThen(function(p6) -- line: 99
				-- upvalues: VotesStoreTypes (copy), DiscoveryEventErrorLogger (copy), s1 (copy)
				local responseBody = p6.responseBody

				if not VotesStoreTypes.userVoteResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createVotesStore", "Invalid user vote response", {
						universeId = s1,
						responseBody = responseBody
					})
					error({
						StatusCode = p6.responseCode
					})
				end

				return responseBody
			end)
		end,
		supportsMutations = FFlagLuaAppDataHydrationOptimisticMutationLayer
	})

	return {
		fetchVote = v30.fetchItem,
		fetchVotes = v30.fetchItems,
		getVote = v30.getCachedItem,
		getVotes = v30.getCachedItems,
		getAndFetchVote = v30.getAndFetchItem,
		getAndFetchVotes = v30.getAndFetchItems,
		fetchUserVote = v32.fetchItem,
		fetchUserVotes = v32.fetchItems,
		getUserVote = if not FFlagLuaAppDataHydrationOptimisticMutationLayer then v32.getCachedItem else v32.getOptimisticCachedItem,
		getUserVotes = if not FFlagLuaAppDataHydrationOptimisticMutationLayer then v32.getCachedItems else v32.getOptimisticCachedItems,
		getAndFetchUserVote = if not FFlagLuaAppDataHydrationOptimisticMutationLayer then v32.getAndFetchItem else v32.getOptimisticAndFetchItem,
		getAndFetchUserVotes = if not FFlagLuaAppDataHydrationOptimisticMutationLayer then v32.getAndFetchItems else v32.getOptimisticAndFetchItems,
		updateUserVote = function(s2: string, b1: boolean?) -- line: 116
			-- upvalues: Signals (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), v32 (copy), v31 (copy), v29 (copy), FFlagLuaAppVoteOptimisticUpdateRaceFix (copy), Cryo (copy), FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes (copy), VotesUtils (copy), FFlagSduiExperienceDetailsSupport (copy), getGameInfoStore (copy), requestUserVoteUpdate (copy), HttpService (copy), VotesStoreTypes (copy), ReasonNotVoteable (copy), StatusCodes (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy)
			local v40, v41 = Signals.createSignal(nil)
			local v42, v43

			if FFlagLuaAppDataHydrationOptimisticMutationLayer then
				v42, v43 = v32.getOptimisticCachedItem(s2)
			else
				v42, v43 = v31.getItem(s2)
			end

			local v44 = v42 and v42.data(false)
			local v45 = if not v44 then nil else v44.userVote
			local v46 = v29.getItem(s2)
			local v47 = v46 and v46.data(false)

			if FFlagLuaAppVoteOptimisticUpdateRaceFix then
				if not v43 and v44 and not v44.canVote then
					v41({
						type = "error",
						reasonForNotVoteable = v44.reasonForNotVoteable
					})

					return v40
				end
			elseif v43 then
				v32.fetchItem(s2)
			elseif v44 and not v44.canVote then
				v41({
					type = "error",
					reasonForNotVoteable = v44.reasonForNotVoteable
				})

				return v40
			end

			if FFlagLuaAppDataHydrationOptimisticMutationLayer then
				local t3 = {
					userVote = if b1 ~= nil then b1 else Cryo.None
				}

				v32.setMutation(s2, t3)
			else
				local v49 = v44 and v44.canVote or nil
				local v50 = v44 and v44.reasonForNotVoteable or nil

				v31.replaceItem(s2, {
					canVote = v49,
					reasonForNotVoteable = v50,
					userVote = b1
				})
			end

			if v47 then
				local v55, v56

				if FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes then
					local v51 = v45 ~= true and 0 or 1
					local v52 = v45 ~= false and 0 or 1
					local v53 = b1 ~= true and 0 or 1
					local v54 = b1 ~= false and 0 or 1

					v55 = v53 - v51
					v56 = v54 - v52
				else
					v55 = b1 ~= true and 0 or 1
					v56 = b1 ~= false and 0 or 1
				end

				local v57 = v47.upVotes + v55
				local v58 = v47.downVotes + v56

				if FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes then
					v57 = math.max(0, v57)
					v58 = math.max(0, v58)
				end

				local v59 = VotesUtils.calculateRating(v57, v58)
				local t4 = {
					upVotes = v57,
					downVotes = v58,
					rating = v59
				}

				v29.updateItem(s2, t4)
			end

			local u61 = nil

			if FFlagSduiExperienceDetailsSupport then
				u61 = getGameInfoStore(false).applyVoteChange(s2, v45, b1)
			end

			requestUserVoteUpdate(s2, b1):andThen(function(_) -- line: 219
				-- upvalues: FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), v32 (copy), s2 (copy), v41 (copy), b1 (copy)
				if FFlagLuaAppDataHydrationOptimisticMutationLayer then
					v32.commitMutation(s2)
				end

				v41({
					type = "success",
					userVote = b1
				})
			end):catch(function(p8) -- line: 228
				-- upvalues: FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), v32 (copy), s2 (copy), v44 (copy), v31 (copy), v45 (copy), v47 (copy), v29 (copy), FFlagSduiExperienceDetailsSupport (copy), u61 (ref), getGameInfoStore (copy), HttpService (copy), VotesStoreTypes (copy), ReasonNotVoteable (copy), StatusCodes (copy), v41 (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy)
				if FFlagLuaAppDataHydrationOptimisticMutationLayer then
					v32.clearMutation(s2)
				else
					local v73 = v44 and v44.canVote or nil
					local v74 = v44 and v44.reasonForNotVoteable or nil

					v31.replaceItem(s2, {
						canVote = v73,
						reasonForNotVoteable = v74,
						userVote = v45
					})
				end

				if v47 then
					v29.updateItem(s2, v47)
				end

				if FFlagSduiExperienceDetailsSupport and u61 then
					getGameInfoStore(false).updateGameInfo(s2, u61)
				end

				local v75 = if type(p8) ~= "table" or not p8.StatusCode then nil else p8.StatusCode
				local PlayGame = nil

				if v75 then
					local ok, result = pcall(function() -- line: 259
						-- upvalues: HttpService (copy), p8 (copy)
						return HttpService:JSONDecode(p8.Body)
					end)

					if ok and result and result.errors then
						for _, v in ipairs(result.errors) do
							if v.code == VotesStoreTypes.PLAY_GAME_ERROR_CODE then
								PlayGame = ReasonNotVoteable.PlayGame
							end
						end
					end

					if v75 == StatusCodes.TOO_MANY_REQUESTS then
						PlayGame = ReasonNotVoteable.FloodCheckThresholdMet
					end
				end

				v41({
					type = "error",
					reasonForNotVoteable = PlayGame
				})

				local v81 = if type(p8) ~= "table" or not p8.StatusMessage then nil else p8.StatusMessage

				DiscoveryEventErrorLogger.reportError("updateUserVote", "Error updating user vote", {
					universeId = s2,
					statusCode = v75,
					statusMessage = v81
				})
				logResponseError("v1/games/votes/user-votes", {
					StatusCode = v75
				})
			end)

			return v40
		end,
		updateVoteItem = if not FFlagLuaAppDataHydrationUpdateItem then nil else function(s3: string, n1: number, n2: number) -- line: 330
			-- upvalues: v29 (copy), VotesUtils (copy)
			v29.updateItem(s3, {
				downVotes = n1,
				upVotes = n2,
				rating = VotesUtils.calculateRating(n2, n1)
			})
		end,
		updateUserVoteItem = if not FFlagLuaAppDataHydrationUpdateItem then nil else v31.updateItem,
		updateUserVoteItems = v31.updateItems,
		clear = function() -- line: 292
			-- upvalues: v29 (copy), v30 (copy), v31 (copy), v32 (copy)
			v29.clear()
			v30.clear()
			v31.clear()
			v32.clear()
		end,
		dispose = function() -- line: 299
			-- upvalues: v29 (copy), v30 (copy), v32 (copy)
			v29.dispose()
			v30.dispose()
			v32.dispose()
		end
	}
end

return createVotesStore
