local promiseUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AppCommonLib").Utils.PromiseUtilities
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Http").Enum.RetrievalStatus
local GameDetailRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux")
local apiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local fetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local apiFetchAgeRecommendations = GameDetailRodux.AgeRecommendations.ApiFetchAgeRecommendations
local fetchUserGameVotes = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameVotesRodux").UserGameVotes.FetchUserGameVotes
local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameInfosRodux").GameInfosReducer
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DataHydration")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagMigrateGameInfoToStore
local NextDataExpirationTimeRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NextDataExpirationTimeRodux")
local setNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local nextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local expirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum

local apiFetchShowAgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/VoiceChat").AgeVerificationOverlay.ApiFetchShowAgeVerificationOverlay
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Promise")

local fFlagLuaAppPlayButtonCoalescePlayabilityFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonCoalescePlayabilityFetch

local getFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds

local RunService = game:GetService("RunService")

local object = setmetatable({}, { __mode = "k" })

local function hasInFlightBatch(p2, p3): boolean
	local v6 = object[p2]
	return v6 ~= nil and v6[p3] ~= nil
end

local function startInFlightBatch(object2, p2)
	local v6 = object[object2]

	if v6 == nil then
		v6 = {}
		object[object2] = v6
	end

	local v7 = v6[p2]

	if v7 == nil then
		v7 = { count = 0, hadFailure = false }
		v6[p2] = v7
	end

	v7.count += 1
end

local function finishInFlightBatch(p2, p3, p4)
	local v6 = object[p2]
	local v7 = if v6 then v6[p3] else nil

	if v6 == nil or v7 == nil then
		return p4
	end

	v7.count -= 1

	if not p4 then
		v7.hadFailure = true
	end

	if v7.count > 0 then
		return false
	end

	v6[p3] = nil
	return not v7.hadFailure
end

local function hasContentMaturity(p2, p3)
	local v6 = p2.AgeRecommendations and p2.AgeRecommendations[p3]

	if
		v6
		and v6.summary
		and v6.summary.ageRecommendation
		and v6.summary.ageRecommendation.contentMaturity
	then
		return true
	end

	if not fFlagMigrateGameInfoToStore then
		local v7 = p2.Personalization
			and p2.Personalization[gameInfosReducer.key]
			and p2.Personalization[gameInfosReducer.key][p3]
		return v7 and v7.contentMaturity ~= nil
	end

	local data = DataHydration.Game.getGameInfoStore(false).getGameInfo(p3).data(false)
	return data ~= nil and data.contentMaturity ~= nil
end

local function shouldFetchAgeRecommendations(p2, p3, p4): boolean
	return p4 == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
		and not hasContentMaturity(p2, p3)
end

local function playButtonDataFetchPromises(p2, object2, p3, p4, p5)
	local v6 = {}

	if
		apiFetchGameDetails.GetFetchingStatus(object2:getState(), p3) ~= retrievalStatus.Fetching
		and (p4 or object2:getState().GameDetails[p3] == nil)
	then
		table.insert(v6, object2:dispatch(apiFetchGameDetails.Fetch(p2, { p3 })))
	end

	local fetchingStatus = fetchGamePlayabilityAndProductInfo.GetFetchingStatus(object2:getState(), p3)

	if
		p4
		or p5
		or fetchingStatus == retrievalStatus.NotStarted
		or fetchingStatus == retrievalStatus.Failed
	then
		table.insert(
			v6,
			(object2:dispatch(fetchGamePlayabilityAndProductInfo.Fetch(p2, p3)):andThen(function(p6)
				local state = object2:getState()
				local v7 = p3
				local v8

				if p6 == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
					v8 = not hasContentMaturity(state, v7)
				else
					v8 = false
				end

				if v8 then
					return object2:dispatch(apiFetchAgeRecommendations.Fetch(p2, p3))
				end

				return Promise.resolve(p6)
			end))
		)
	end

	if
		game:GetEngineFeature("VoiceChatSupported")
		and apiFetchShowAgeVerificationOverlay.GetFetchingStatus(object2:getState(), p3) ~= retrievalStatus.Fetching
		and (p4 or object2:getState().ShowAgeVerificationOverlay[p3] == nil)
	then
		table.insert(v6, object2:dispatch(apiFetchShowAgeVerificationOverlay.Fetch(p2, p3)))
	end

	if
		fetchUserGameVotes.GetFetchingStatus(object2:getState(), p3) ~= retrievalStatus.Fetching
		and (p4 or object2:getState().UserGameVotes[p3] == nil)
	then
		object2:dispatch(fetchUserGameVotes.Fetch(p2, p3))
	end

	return v6
end

return {
	IsLoading = function(p2, p3): boolean
		local fetchingStatus = apiFetchGameDetails.GetFetchingStatus(p2, p3)

		if fetchingStatus == retrievalStatus.NotStarted or fetchingStatus == retrievalStatus.Fetching then
			return true
		end

		local fetchingStatus2 = fetchGamePlayabilityAndProductInfo.GetFetchingStatus(p2, p3)

		if fetchingStatus2 == retrievalStatus.NotStarted or fetchingStatus2 == retrievalStatus.Fetching then
			return true
		end

		local v6 = p2.PlayabilityStatus and p2.PlayabilityStatus[p3]

		if v6 then
			local v7

			if v6.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
				v7 = not hasContentMaturity(p2, p3)
			else
				v7 = false
			end

			if v7 then
				local fetchingStatus3 = apiFetchAgeRecommendations.GetFetchingStatus(p2, p3)

				if
					fetchingStatus3 == retrievalStatus.NotStarted
					or fetchingStatus3 == retrievalStatus.Fetching
				then
					return true
				end
			end
		end

		if game:GetEngineFeature("VoiceChatSupported") then
			local fetchingStatus3 = apiFetchShowAgeVerificationOverlay.GetFetchingStatus(p2, p3)

			if
				fetchingStatus3 == retrievalStatus.NotStarted
				or fetchingStatus3 == retrievalStatus.Fetching
			then
				return true
			end
		end

		return false
	end,
	Fetch = function(p2, p3, p4)
		return function(object2)
			local now = tick()

			local v6 = object2:getState().Personalization[nextDataExpirationTimeReducer.key][expirationTimeNamespace.GameDetailPlayability]

			local v7 = if v6 then v6[p3] else nil

			local v8 = v7 == nil or v7 < now

			if fFlagLuaAppPlayButtonCoalescePlayabilityFetch then
				local v9 = p3
				local v10 = object[object2]
				local v11 = not (v10 == nil) and v10[v9] ~= nil

				if v11 and not p4 then
					v8 = false
				end
			end

			local v9 = playButtonDataFetchPromises(p2, object2, p3, v8, p4)

			if not (#v9 > 0) then
				return nil
			end

			local Warn = if _G.__TESTEZ_RUNNING_TEST__ or RunService:IsStudio() then warn else nil

			if fFlagLuaAppPlayButtonCoalescePlayabilityFetch then
				startInFlightBatch(object2, p3)
			end

			return (promiseUtilities.Batch(v9, Warn):andThen(function(p5)
				local failureCount = promiseUtilities.CountResults(p5).failureCount
				local v10 = failureCount == 0

				if fFlagLuaAppPlayButtonCoalescePlayabilityFetch then
					local v12 = p3
					v10 = failureCount == 0
					local v13 = object[object2]
					local v14 = if v13 then v13[v12] else nil

					if v13 ~= nil and v14 ~= nil then
						v14.count -= 1

						if not v10 then
							v14.hadFailure = true
						end

						if v14.count > 0 then
							v10 = false
						else
							v13[v12] = nil
							v10 = not v14.hadFailure
						end
					end
				end

				if v10 then
					now = tick()
					v7 = math.floor(now + getFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds())
					object2:dispatch(setNextDataExpirationTime(
						p3,
						v7,
						expirationTimeNamespace.GameDetailPlayability
					))
				end
			end))
		end
	end
}
