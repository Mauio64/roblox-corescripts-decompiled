local parent = script:FindFirstAncestor("GamePlayButton").Parent

local AppCommonLib = require(parent.AppCommonLib)
local PromiseUtilities = AppCommonLib.Utils.PromiseUtilities
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local GameDetailRodux = require(parent.GameDetailRodux)
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local ApiFetchAgeRecommendations = GameDetailRodux.AgeRecommendations.ApiFetchAgeRecommendations
local GameVotesRodux = require(parent.GameVotesRodux)
local FetchUserGameVotes = GameVotesRodux.UserGameVotes.FetchUserGameVotes
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer
local DataHydration = require(parent.DataHydration)
local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local NextDataExpirationTimeRodux = require(parent.NextDataExpirationTimeRodux)
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local VoiceChat = require(parent.VoiceChat)
local ApiFetchShowAgeVerificationOverlay = VoiceChat.AgeVerificationOverlay.ApiFetchShowAgeVerificationOverlay
local Promise = require(parent.Promise)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonCoalescePlayabilityFetch = SharedFlags2.FFlagLuaAppPlayButtonCoalescePlayabilityFetch

local SharedFlags3 = require(parent.SharedFlags)
local GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = SharedFlags3.GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds

local RunService = game:GetService("RunService")

local object = setmetatable({}, { __mode = "k" })

local function hasInFlightBatch(object2, p: string): boolean -- 1 equivalent call inferred from this helper
	local v = object[object2]
	return v ~= nil and v[p] ~= nil
end

local function startInFlightBatch(object2, p: string)
	local v = object[object2]

	if v == nil then
		v = {}
		object[object2] = v
	end

	local v2 = v[p]

	if v2 == nil then
		v2 = { count = 0, hadFailure = false }
		v[p] = v2
	end

	v2.count += 1
end

local function finishInFlightBatch(object2, p: string, flag: boolean) -- 1 equivalent call inferred from this helper
	local v = object[object2]
	local v2

	if v then
		v2 = v[p]
	end

	if v == nil or v2 == nil then
		return flag
	end

	v2.count -= 1

	if not flag then
		v2.hadFailure = true
	end

	if v2.count > 0 then
		return false
	end

	v[p] = nil
	return not v2.hadFailure
end

local function hasContentMaturity(p, p2)
	local v = p.AgeRecommendations and p.AgeRecommendations[p2]

	if v and v.summary and v.summary.ageRecommendation and v.summary.ageRecommendation.contentMaturity then
		return true
	end

	if not FFlagMigrateGameInfoToStore then
		local v2 = p.Personalization
			and p.Personalization[GameInfosReducer.key]
			and p.Personalization[GameInfosReducer.key][p2]
		return v2 and v2.contentMaturity ~= nil
	end

	local data = DataHydration.Game.getGameInfoStore(false).getGameInfo(p2).data(false)
	return data ~= nil and data.contentMaturity ~= nil
end

local function shouldFetchAgeRecommendations(p, p2, p3): boolean -- 2 equivalent calls inferred from this helper
	return p3 == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
		and not hasContentMaturity(p, p2)
end

local function playButtonDataFetchPromises(p, object2, p2, p3, flag: boolean?)
	local v = {}

	if
		ApiFetchGameDetails.GetFetchingStatus(object2:getState(), p2) ~= RetrievalStatus.Fetching
		and (p3 or object2:getState().GameDetails[p2] == nil)
	then
		table.insert(v, object2:dispatch(ApiFetchGameDetails.Fetch(p, { p2 })))
	end

	local fetchingStatus = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(object2:getState(), p2)

	if p3 or flag or fetchingStatus == RetrievalStatus.NotStarted or fetchingStatus == RetrievalStatus.Failed then
		table.insert(v, (object2:dispatch(FetchGamePlayabilityAndProductInfo.Fetch(p, p2)):andThen(function(p4)
			if shouldFetchAgeRecommendations(object2:getState(), p2, p4) then -- inferred equivalent call
				return object2:dispatch(ApiFetchAgeRecommendations.Fetch(p, p2))
			end

			return Promise.resolve(p4)
		end)))
	end

	if
		game:GetEngineFeature("VoiceChatSupported")
		and ApiFetchShowAgeVerificationOverlay.GetFetchingStatus(object2:getState(), p2) ~= RetrievalStatus.Fetching
		and (p3 or object2:getState().ShowAgeVerificationOverlay[p2] == nil)
	then
		table.insert(v, object2:dispatch(ApiFetchShowAgeVerificationOverlay.Fetch(p, p2)))
	end

	if
		FetchUserGameVotes.GetFetchingStatus(object2:getState(), p2) ~= RetrievalStatus.Fetching
		and (p3 or object2:getState().UserGameVotes[p2] == nil)
	then
		object2:dispatch(FetchUserGameVotes.Fetch(p, p2))
	end

	return v
end

local FetchGamePlayButtonData = {}

function FetchGamePlayButtonData.IsLoading(p, p2): boolean
	local fetchingStatus = ApiFetchGameDetails.GetFetchingStatus(p, p2)

	if fetchingStatus == RetrievalStatus.NotStarted or fetchingStatus == RetrievalStatus.Fetching then
		return true
	end

	local fetchingStatus2 = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p, p2)

	if fetchingStatus2 == RetrievalStatus.NotStarted or fetchingStatus2 == RetrievalStatus.Fetching then
		return true
	end

	local v = p.PlayabilityStatus and p.PlayabilityStatus[p2]

	if v and shouldFetchAgeRecommendations(p, p2, v.playabilityStatus) then -- inferred equivalent call
		local fetchingStatus3 = ApiFetchAgeRecommendations.GetFetchingStatus(p, p2)

		if fetchingStatus3 == RetrievalStatus.NotStarted or fetchingStatus3 == RetrievalStatus.Fetching then
			return true
		end
	end

	if game:GetEngineFeature("VoiceChatSupported") then
		local fetchingStatus3 = ApiFetchShowAgeVerificationOverlay.GetFetchingStatus(p, p2)

		if fetchingStatus3 == RetrievalStatus.NotStarted or fetchingStatus3 == RetrievalStatus.Fetching then
			return true
		end
	end

	return false
end

function FetchGamePlayButtonData.Fetch(p, p2: string, flag: boolean?)
	return function(object2)
		local now = tick()

		local v = object2:getState().Personalization[NextDataExpirationTimeReducer.key][ExpirationTimeNamespace.GameDetailPlayability]
		local v2

		if v then
			v2 = v[p2]
		else
			v2 = nil
		end

		local v3 = v2 == nil or v2 < now

		if FFlagLuaAppPlayButtonCoalescePlayabilityFetch and hasInFlightBatch(object2, p2) and not flag then -- inferred equivalent call
			v3 = false
		end

		local v4 = playButtonDataFetchPromises(p, object2, p2, v3, flag)

		if not (#v4 > 0) then
			return nil
		end

		local Warn

		if _G.__TESTEZ_RUNNING_TEST__ or RunService:IsStudio() then
			Warn = warn
		end

		if FFlagLuaAppPlayButtonCoalescePlayabilityFetch then
			startInFlightBatch(object2, p2)
		end

		return (PromiseUtilities.Batch(v4, Warn):andThen(function(p3)
			local failureCount = PromiseUtilities.CountResults(p3).failureCount
			local v5 = failureCount == 0

			if FFlagLuaAppPlayButtonCoalescePlayabilityFetch then
				v5 = failureCount == 0
				v5 = finishInFlightBatch(object2, p2, v5) -- inferred equivalent call
			end

			if v5 then
				now = tick()
				v2 = math.floor(now + GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds())
				object2:dispatch(SetNextDataExpirationTime(p2, v2, ExpirationTimeNamespace.GameDetailPlayability))
			end
		end))
	end
end

return FetchGamePlayButtonData
