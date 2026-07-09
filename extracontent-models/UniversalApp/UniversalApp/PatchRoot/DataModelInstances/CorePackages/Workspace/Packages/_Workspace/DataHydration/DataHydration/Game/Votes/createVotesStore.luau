local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
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
local ReasonNotVoteable = VotesStoreTypes.ReasonNotVoteable
local FFlagLuaAppInExperienceDetailsPrompt = require(DataHydrationParent.SharedFlags).FFlagLuaAppInExperienceDetailsPrompt
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem
local FFlagLuaAppVoteOptimisticUpdateRaceFix = SharedFlags.FFlagLuaAppVoteOptimisticUpdateRaceFix
local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local v25 = game:DefineFastInt("USER_VOTE_CACHE_TTL_SECONDS", 600)

local function createVotesStore() -- line: 40
	-- upvalues: createDataCache (copy), createDataResolver (copy), Dash (copy), fetchVotes (copy), FFlagLuaAppInExperienceDetailsPrompt (copy), VotesUtils (copy), v25 (copy), logResponseError (copy), fetchUserVote (copy), VotesStoreTypes (copy), DiscoveryEventErrorLogger (copy), Signals (copy), FFlagLuaAppVoteOptimisticUpdateRaceFix (copy), FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes (copy), FFlagSduiExperienceDetailsSupport (copy), getGameInfoStore (copy), requestUserVoteUpdate (copy), HttpService (copy), ReasonNotVoteable (copy), StatusCodes (copy), FFlagLuaAppDataHydrationUpdateItem (copy)
	local v27 = createDataCache()
	local v28 = createDataResolver({
		cache = v27,
		fetchFn = function(t1: {[any]: any}) -- line: 44
			-- upvalues: Dash (copy), fetchVotes (copy), FFlagLuaAppInExperienceDetailsPrompt (copy), VotesUtils (copy)
			local v32 = Dash.keys(t1)

			return fetchVotes(v32):andThen(function(p1) -- line: 49
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

				Dash.forEach(data, function(p2) -- line: 63
					-- upvalues: VotesUtils (copy), t2 (copy)
					local v78 = nil
					local upVotes = p2.upVotes
					local downVotes = p2.downVotes

					if typeof(upVotes) == "number" and typeof(downVotes) == "number" then
						v78 = VotesUtils.calculateRating(upVotes, downVotes)
					end

					t2[tostring(p2.id)] = {
						upVotes = upVotes,
						downVotes = downVotes,
						rating = v78
					}
				end)

				return t2
			end):catch(function(p3) -- line: 79
				error(`Error requesting votes: { p3 }`)
			end)
		end
	})
	local v29 = createDataCache(v25)
	local v30 = createDataResolver({
		supportsMultiGet = false,
		cache = v29,
		logError = function(p4) -- line: 89
			-- upvalues: logResponseError (copy)
			logResponseError("v1/games/votes/user", p4)
		end,
		fetchFn = function(s1: string, _) -- line: 92
			-- upvalues: fetchUserVote (copy), VotesStoreTypes (copy), DiscoveryEventErrorLogger (copy)
			return fetchUserVote(s1):andThen(function(p6) -- line: 96
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
		end
	})

	return {
		fetchVote = v28.fetchItem,
		fetchVotes = v28.fetchItems,
		getVote = v28.getCachedItem,
		getVotes = v28.getCachedItems,
		getAndFetchVote = v28.getAndFetchItem,
		getAndFetchVotes = v28.getAndFetchItems,
		fetchUserVote = v30.fetchItem,
		fetchUserVotes = v30.fetchItems,
		getUserVote = v30.getCachedItem,
		getUserVotes = v30.getCachedItems,
		getAndFetchUserVote = v30.getAndFetchItem,
		getAndFetchUserVotes = v30.getAndFetchItems,
		updateUserVote = function(s2: string, b1: boolean?) -- line: 112
			-- upvalues: Signals (copy), v29 (copy), v27 (copy), FFlagLuaAppVoteOptimisticUpdateRaceFix (copy), v30 (copy), FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes (copy), VotesUtils (copy), FFlagSduiExperienceDetailsSupport (copy), getGameInfoStore (copy), requestUserVoteUpdate (copy), HttpService (copy), VotesStoreTypes (copy), ReasonNotVoteable (copy), StatusCodes (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy)
			local v38, v39 = Signals.createSignal(nil)
			local v40, v41 = v29.getItem(s2)
			local v42 = v40 and v40.data(false)
			local v43 = if not v42 then nil else v42.userVote
			local v44 = v27.getItem(s2)
			local v45 = v44 and v44.data(false)

			if FFlagLuaAppVoteOptimisticUpdateRaceFix then
				if not v41 and v42 and not v42.canVote then
					v39({
						type = "error",
						reasonForNotVoteable = v42.reasonForNotVoteable
					})

					return v38
				end
			elseif v41 then
				v30.fetchItem(s2)
			elseif v42 and not v42.canVote then
				v39({
					type = "error",
					reasonForNotVoteable = v42.reasonForNotVoteable
				})

				return v38
			end

			local v46 = v42 and v42.canVote or nil
			local v47 = v42 and v42.reasonForNotVoteable or nil

			v29.replaceItem(s2, {
				canVote = v46,
				reasonForNotVoteable = v47,
				userVote = b1
			})

			if v45 then
				local v52, v53

				if FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes then
					local v48 = v43 ~= true and 0 or 1
					local v49 = v43 ~= false and 0 or 1
					local v50 = b1 ~= true and 0 or 1
					local v51 = b1 ~= false and 0 or 1

					v52 = v50 - v48
					v53 = v51 - v49
				else
					v52 = b1 ~= true and 0 or 1
					v53 = b1 ~= false and 0 or 1
				end

				local v54 = v45.upVotes + v52
				local v55 = v45.downVotes + v53

				if FFlagLuaAppDataHydrationVotesStoreTrackOptimisticVotes then
					v54 = math.max(0, v54)
					v55 = math.max(0, v55)
				end

				local v56 = VotesUtils.calculateRating(v54, v55)
				local t3 = {
					upVotes = v54,
					downVotes = v55,
					rating = v56
				}

				v27.updateItem(s2, t3)
			end

			local u58 = nil

			if FFlagSduiExperienceDetailsSupport then
				u58 = getGameInfoStore(false).applyVoteChange(s2, v43, b1)
			end

			requestUserVoteUpdate(s2, b1):andThen(function(_) -- line: 205
				-- upvalues: v39 (copy), b1 (copy)
				v39({
					type = "success",
					userVote = b1
				})
			end):catch(function(p8) -- line: 211
				-- upvalues: v29 (copy), s2 (copy), v46 (copy), v47 (copy), v43 (copy), v45 (copy), v27 (copy), FFlagSduiExperienceDetailsSupport (copy), u58 (ref), getGameInfoStore (copy), HttpService (copy), VotesStoreTypes (copy), ReasonNotVoteable (copy), StatusCodes (copy), v39 (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy)
				v29.replaceItem(s2, {
					canVote = v46,
					reasonForNotVoteable = v47,
					userVote = v43
				})

				if v45 then
					v27.updateItem(s2, v45)
				end

				if FFlagSduiExperienceDetailsSupport and u58 then
					getGameInfoStore(false).updateGameInfo(s2, u58)
				end

				local v70 = if type(p8) ~= "table" or not p8.StatusCode then nil else p8.StatusCode
				local PlayGame = nil

				if v70 then
					local ok, result = pcall(function() -- line: 236
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

					if v70 == StatusCodes.TOO_MANY_REQUESTS then
						PlayGame = ReasonNotVoteable.FloodCheckThresholdMet
					end
				end

				v39({
					type = "error",
					reasonForNotVoteable = PlayGame
				})

				local v76 = if type(p8) ~= "table" or not p8.StatusMessage then nil else p8.StatusMessage

				DiscoveryEventErrorLogger.reportError("updateUserVote", "Error updating user vote", {
					universeId = s2,
					statusCode = v70,
					statusMessage = v76
				})
				logResponseError("v1/games/votes/user-votes", {
					StatusCode = v70
				})
			end)

			return v38
		end,
		updateVoteItem = if not FFlagLuaAppDataHydrationUpdateItem then nil else function(s3: string, n1: number, n2: number) -- line: 299
			-- upvalues: v27 (copy), VotesUtils (copy)
			v27.updateItem(s3, {
				downVotes = n1,
				upVotes = n2,
				rating = VotesUtils.calculateRating(n2, n1)
			})
		end,
		updateUserVoteItem = if not FFlagLuaAppDataHydrationUpdateItem then nil else v29.updateItem,
		updateUserVoteItems = v29.updateItems,
		clear = function() -- line: 269
			-- upvalues: v27 (copy), v28 (copy), v29 (copy), v30 (copy)
			v27.clear()
			v28.clear()
			v29.clear()
			v30.clear()
		end,
		dispose = function() -- line: 276
			-- upvalues: v27 (copy), v28 (copy), v30 (copy)
			v27.dispose()
			v28.dispose()
			v30.dispose()
		end
	}
end

return createVotesStore
