local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local PromiseUtilities = require(Parent.AppCommonLib).Utils.PromiseUtilities
local RetrievalStatus = require(Parent.Http).Enum.RetrievalStatus
local GameDetailRodux = require(Parent.GameDetailRodux)
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local ApiFetchAgeRecommendations = GameDetailRodux.AgeRecommendations.ApiFetchAgeRecommendations
local FetchUserGameVotes = require(Parent.GameVotesRodux).UserGameVotes.FetchUserGameVotes
local GameInfosReducer = require(Parent.GameInfosRodux).GameInfosReducer
local NextDataExpirationTimeRodux = require(Parent.NextDataExpirationTimeRodux)
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local PlayabilityStatusEnum = require(Parent.DiscoveryTypes).PlayabilityStatusEnum
local ApiFetchShowAgeVerificationOverlay = require(Parent.VoiceChat).AgeVerificationOverlay.ApiFetchShowAgeVerificationOverlay
local Promise = require(Parent.Promise)
local GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = require(Parent.SharedFlags).GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds
local v18 = game:DefineFastFlag("LuaAppFetchContentMaturityWithPlayability", false)
local RunService = game:GetService("RunService")
local t1 = {}

local function hasContentMaturity(p1, p2) -- line: 32
	-- upvalues: GameInfosReducer (copy)
	local v26 = p1.AgeRecommendations and p1.AgeRecommendations[p2]

	if v26 and (v26.summary and v26.summary.ageRecommendation and v26.summary.ageRecommendation.contentMaturity) then
		return true
	end

	local v27 = p1.Personalization and (p1.Personalization[GameInfosReducer.key] and p1.Personalization[GameInfosReducer.key][p2])

	return v27 and v27.contentMaturity ~= nil
end
local function shouldFetchAgeRecommendations(p3, p4, p5) -- line: 49
	-- upvalues: v18 (copy), PlayabilityStatusEnum (copy), GameInfosReducer (copy)
	local v31 = v18

	if v31 then
		v31 = false

		if p5 == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
			local v32 = p3.AgeRecommendations and p3.AgeRecommendations[p4]
			local v33

			if v32 and v32.summary and v32.summary.ageRecommendation and v32.summary.ageRecommendation.contentMaturity then
				v33 = true
			else
				local v34 = p3.Personalization and (p3.Personalization[GameInfosReducer.key] and p3.Personalization[GameInfosReducer.key][p4])

				v33 = v34 and v34.contentMaturity ~= nil
			end

			v31 = not v33
		end
	end

	return v31
end
local function playButtonDataFetchPromises(p6, p7, p8, p9, b1: boolean?) -- line: 55
	-- upvalues: ApiFetchGameDetails (copy), RetrievalStatus (copy), FetchGamePlayabilityAndProductInfo (copy), v18 (copy), PlayabilityStatusEnum (copy), GameInfosReducer (copy), ApiFetchAgeRecommendations (copy), Promise (copy), ApiFetchShowAgeVerificationOverlay (copy), FetchUserGameVotes (copy)
	local t2 = {}

	if ApiFetchGameDetails.GetFetchingStatus(p7:getState(), p8) ~= RetrievalStatus.Fetching and (p9 or p7:getState().GameDetails[p8] == nil) then
		table.insert(t2, p7:dispatch(ApiFetchGameDetails.Fetch(p6, { p8 })))
	end

	local v41 = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p7:getState(), p8)

	if p9 or b1 or v41 == RetrievalStatus.NotStarted or v41 == RetrievalStatus.Failed then
		local v42 = p7:dispatch(FetchGamePlayabilityAndProductInfo.Fetch(p6, p8))

		if v18 then
			v42 = v42:andThen(function(p10) -- line: 84
				-- upvalues: p7 (copy), p8 (copy), v18 (copy), PlayabilityStatusEnum (copy), GameInfosReducer (copy), ApiFetchAgeRecommendations (copy), p6 (copy), Promise (copy)
				local v59 = p7:getState()
				local v60 = p8
				local v61 = v18

				if v61 then
					v61 = false

					if p10 == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
						local v62 = v59.AgeRecommendations and v59.AgeRecommendations[v60]
						local v63

						if v62 and v62.summary and v62.summary.ageRecommendation and v62.summary.ageRecommendation.contentMaturity then
							v63 = true
						else
							local v64 = v59.Personalization and (v59.Personalization[GameInfosReducer.key] and v59.Personalization[GameInfosReducer.key][v60])

							v63 = v64 and v64.contentMaturity ~= nil
						end

						v61 = not v63
					end
				end

				if v61 then
					return p7:dispatch(ApiFetchAgeRecommendations.Fetch(p6, p8))
				end

				return Promise.resolve(p10)
			end)
		end

		table.insert(t2, v42)
	end

	if game:GetEngineFeature("VoiceChatSupported") and ApiFetchShowAgeVerificationOverlay.GetFetchingStatus(p7:getState(), p8) ~= RetrievalStatus.Fetching and (p9 or p7:getState().ShowAgeVerificationOverlay[p8] == nil) then
		table.insert(t2, p7:dispatch(ApiFetchShowAgeVerificationOverlay.Fetch(p6, p8)))
	end

	if FetchUserGameVotes.GetFetchingStatus(p7:getState(), p8) ~= RetrievalStatus.Fetching and (p9 or p7:getState().UserGameVotes[p8] == nil) then
		p7:dispatch(FetchUserGameVotes.Fetch(p6, p8))
	end

	return t2
end

function t1.IsLoading(p11, p12) -- line: 119
	-- upvalues: ApiFetchGameDetails (copy), RetrievalStatus (copy), FetchGamePlayabilityAndProductInfo (copy), v18 (copy), PlayabilityStatusEnum (copy), GameInfosReducer (copy), ApiFetchAgeRecommendations (copy), ApiFetchShowAgeVerificationOverlay (copy)
	local v45 = ApiFetchGameDetails.GetFetchingStatus(p11, p12)

	if v45 == RetrievalStatus.NotStarted or v45 == RetrievalStatus.Fetching then
		return true
	end

	local v46 = FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p11, p12)

	if v46 == RetrievalStatus.NotStarted or v46 == RetrievalStatus.Fetching then
		return true
	end

	if v18 then
		local v47 = p11.PlayabilityStatus and p11.PlayabilityStatus[p12]

		if v47 then
			local playabilityStatus = v47.playabilityStatus
			local v49 = v18

			if v49 then
				v49 = false

				if playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
					local v50 = p11.AgeRecommendations and p11.AgeRecommendations[p12]
					local v51

					if v50 and v50.summary and v50.summary.ageRecommendation and v50.summary.ageRecommendation.contentMaturity then
						v51 = true
					else
						local v52 = p11.Personalization and (p11.Personalization[GameInfosReducer.key] and p11.Personalization[GameInfosReducer.key][p12])

						v51 = v52 and v52.contentMaturity ~= nil
					end

					v49 = not v51
				end
			end

			if v49 then
				local v53 = ApiFetchAgeRecommendations.GetFetchingStatus(p11, p12)

				if v53 == RetrievalStatus.NotStarted or v53 == RetrievalStatus.Fetching then
					return true
				end
			end
		end
	end

	if game:GetEngineFeature("VoiceChatSupported") then
		local v54 = ApiFetchShowAgeVerificationOverlay.GetFetchingStatus(p11, p12)

		if v54 == RetrievalStatus.NotStarted or v54 == RetrievalStatus.Fetching then
			return true
		end
	end

	return false
end
function t1.Fetch(p13, s1: string, b2: boolean?) -- line: 170
	-- upvalues: NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), playButtonDataFetchPromises (copy), RunService (copy), PromiseUtilities (copy), GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds (copy), SetNextDataExpirationTime (copy)
	return function(p14) -- line: 171
		-- upvalues: NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), s1 (copy), playButtonDataFetchPromises (copy), p13 (copy), b2 (copy), RunService (copy), PromiseUtilities (copy), GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds (copy), SetNextDataExpirationTime (copy)
		local timestamp = tick()
		local u67 = nil
		local v68 = p14:getState().Personalization[NextDataExpirationTimeReducer.key][ExpirationTimeNamespace.GameDetailPlayability]

		if v68 then
			u67 = v68[s1]
		end

		local v69 = false

		if u67 == nil or u67 < timestamp then
			v69 = true
		end

		local v70 = playButtonDataFetchPromises(p13, p14, s1, v69, b2)

		if #v70 > 0 then
			local _warn = nil

			if _G.__TESTEZ_RUNNING_TEST__ or RunService:IsStudio() then
				_warn = warn
			end

			return PromiseUtilities.Batch(v70, _warn):andThen(function(p15) -- line: 194
				-- upvalues: PromiseUtilities (copy), timestamp (ref), u67 (ref), GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds (copy), p14 (copy), SetNextDataExpirationTime (copy), s1 (copy), ExpirationTimeNamespace (copy)
				if PromiseUtilities.CountResults(p15).failureCount == 0 then
					timestamp = tick()
					u67 = math.floor(timestamp + GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds())
					p14:dispatch(SetNextDataExpirationTime(s1, u67, ExpirationTimeNamespace.GameDetailPlayability))
				end
			end)
		end
	end
end

return t1
