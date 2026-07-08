local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local GameDetailRodux = require(SocialExperienceJoinParent.GameDetailRodux)
local React = require(SocialExperienceJoinParent.React)
local RoactServiceTags = require(SocialExperienceJoinParent.RoactServiceTags)
local RoactUtils = require(SocialExperienceJoinParent.RoactUtils)
local RobloxAppHooks = require(SocialExperienceJoinParent.RobloxAppHooks)
local SignalsReact = require(SocialExperienceJoinParent.SignalsReact)
local NetworkingGames = require(SocialExperienceJoin.Networking.NetworkingGames)
local JoinCardCacheStore = require(SocialExperienceJoin.Stores.JoinCardCacheStore)
local PlayabilityStatusEnum = require(SocialExperienceJoinParent.DiscoveryTypes).PlayabilityStatusEnum
local FetchUserSettingsAndOptions = GameDetailRodux.FetchUserSettingsAndOptions
local ApiFetchAgeRecommendations = GameDetailRodux.AgeRecommendations.ApiFetchAgeRecommendations
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = RobloxAppHooks.useRoactService
local useSignalState = SignalsReact.useSignalState
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = require(SocialExperienceJoinParent.SharedFlags).FFlagLuaAppPlayButtonAmpAgeCheckFlow
local FFlagLuaAppPlayButtonWizardCloseDelay = require(SocialExperienceJoinParent.SharedFlags).FFlagLuaAppPlayButtonWizardCloseDelay
local FIntLuaAppPlayButtonWizardCloseDelayMs = require(SocialExperienceJoinParent.SharedFlags).FIntLuaAppPlayButtonWizardCloseDelayMs
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = require(SocialExperienceJoinParent.SharedFlags).FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = require(SocialExperienceJoinParent.SharedFlags).FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local AmpUpsell = require(SocialExperienceJoinParent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local delayedAmpWizardCompletionCallbackOverride = require(SocialExperienceJoinParent.GamePlayButton).delayedAmpWizardCompletionCallbackOverride
local t1 = {}

local function parseContentMaturityMapping(s1: string) -- line: 55
	local t2 = {}

	if s1 == "" then
		return t2
	end

	for _, v37 in string.split(s1, ",") do
		local parts = string.split(v37, "=")

		if #parts == 2 and parts[1] ~= "" and parts[2] ~= "" then
			t2[parts[1]] = parts[2]
		end
	end

	return t2
end

local v30 = parseContentMaturityMapping((game:DefineFastString("LuaAppUpsellMaturityRatingToSettingMapping", "mild=NinePlus,moderate=ThirteenPlus,restricted=SeventeenPlus,unrated=ThirteenPlus")))

local function parentalControlsRequiresAgeCheck(p1, s2: string?) -- line: 71
	-- upvalues: v30 (copy)
	if not p1 or not s2 then
		return false
	end

	local contentAgeRestriction = p1.contentAgeRestriction

	if not contentAgeRestriction or not contentAgeRestriction.options then
		return false
	end

	local v42 = v30[s2]

	if not v42 then
		return false
	end

	for _, v44 in contentAgeRestriction.options do
		if v44 and v44.option and v42 == v44.option.optionValue then
			return v44.requirement == "ContentAgeRestrictionVerification"
		end
	end

	return false
end

local _ = {
	Success = "Success",
	Cancelled = "Cancelled",
	Error = "Error"
}

local function useAgeCheckUpsellState(s3: string, p2: ((...any) -> ...any)?) -- line: 110
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), JoinCardCacheStore (copy), useSignalState (copy), useSelector (copy), NetworkingGames (copy), PlayabilityStatusEnum (copy), ApiFetchAgeRecommendations (copy), FetchUserSettingsAndOptions (copy), t1 (copy), parentalControlsRequiresAgeCheck (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), AccessResponseEnum (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy)
	local v47 = useDispatch()
	local v48 = useRoactService(RoactNetworking)
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState(false)
	local v53 = JoinCardCacheStore.get()
	local v54 = useSignalState(v53.getPlayabilityEntries)
	local v55 = useSignalState(v53.getUserSettings)
	local v56 = if s3 == "" then nil else v54[s3]
	local v57 = React.useRef(v56 ~= nil)
	local v58 = useSelector(function(p3) -- line: 127
		-- upvalues: s3 (copy)
		local v66 = p3.AgeRecommendations and p3.AgeRecommendations[s3]

		if v66 and (v66.summary and v66.summary.ageRecommendation) then
			return v66.summary.ageRecommendation.contentMaturity
		end

		return nil
	end)

	React.useEffect(function() -- line: 135
		-- upvalues: s3 (copy), v50 (copy), v52 (copy), v53 (copy), v47 (copy), NetworkingGames (copy)
		if s3 == "" then
			v50(true)
			v52(false)

			return
		end

		if v53.getPlayabilityEntries(false)[s3] ~= nil then
			v50(true)
			v52(v53.getUserSettings(false) ~= nil)

			return
		end

		v52(false)
		v50(false)
		v47(NetworkingGames.GetExperiencesPlayabilityStatus.API({ s3 })):andThen(function(p4) -- line: 155
			-- upvalues: v53 (copy), s3 (copy)
			local v69 = p4.responseBody and p4.responseBody[1]

			if v69 then
				v53.setPlayabilityEntry(s3, v69)
			end
		end):catch(function() -- line: 161
		end):finally(function() -- line: 162
			-- upvalues: v50 (copy)
			v50(true)
		end)
	end, {
		v47,
		s3,
		v53
	})
	React.useEffect(function() -- line: 167
		-- upvalues: s3 (copy), v56 (copy), PlayabilityStatusEnum (copy), v47 (copy), ApiFetchAgeRecommendations (copy), v48 (copy), v52 (copy)
		if s3 == "" then
			return
		end

		if (v56 and v56.playabilityStatus) ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
			return
		end

		v47(ApiFetchAgeRecommendations.Fetch(v48, s3)):catch(function() -- line: 176
		end):finally(function() -- line: 176
			-- upvalues: v52 (copy)
			v52(true)
		end)
	end, {
		v47,
		v48,
		s3,
		v56
	})
	React.useEffect(function() -- line: 181
		-- upvalues: s3 (copy), v56 (copy), PlayabilityStatusEnum (copy), v53 (copy), FetchUserSettingsAndOptions (copy), v48 (copy), t1 (copy)
		if s3 == "" then
			return
		end

		if (v56 and v56.playabilityStatus) ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
			return
		end

		if v53.getUserSettings(false) ~= nil then
			return
		end

		FetchUserSettingsAndOptions(v48):andThen(function(p5) -- line: 192
			-- upvalues: v53 (copy)
			v53.setUserSettings(p5)
		end):catch(function() -- line: 194
			-- upvalues: v53 (copy), t1 (copy)
			v53.setUserSettings(t1)
		end)
	end, {
		v48,
		s3,
		v56,
		v53
	})

	local v59 = v56 ~= nil and (v56.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls and parentalControlsRequiresAgeCheck(v55, v58))
	local v60 = v56 ~= nil and (v56.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or (FFlagLuaAppPlayButtonAmpAgeCheckFlow and v56.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired or v59))
	local v61 = React.useCallback(function() -- line: 211
		-- upvalues: s3 (copy), v47 (copy), NetworkingGames (copy), v53 (copy), FetchUserSettingsAndOptions (copy), v48 (copy), t1 (copy)
		if s3 == "" then
			return
		end

		v47(NetworkingGames.GetExperiencesPlayabilityStatus.API({ s3 })):andThen(function(p6) -- line: 216
			-- upvalues: v53 (copy), s3 (copy)
			local v72 = p6.responseBody and p6.responseBody[1]

			if v72 then
				v53.setPlayabilityEntry(s3, v72)
			end
		end):catch(function() -- line: 222
			-- upvalues: v53 (copy), s3 (copy)
			v53.clearPlayabilityEntry(s3)
		end)
		FetchUserSettingsAndOptions(v48):andThen(function(p7) -- line: 225
			-- upvalues: v53 (copy)
			v53.setUserSettings(p7)
		end):catch(function() -- line: 227
			-- upvalues: v53 (copy), t1 (copy)
			v53.setUserSettings(t1)
		end)
	end, {
		v47,
		v48,
		s3,
		v53
	})
	local v62 = React.useCallback(function() -- line: 232
		-- upvalues: AccessResponseEnum (copy), v61 (copy), p2 (copy), v47 (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy)
		local function onAmpWizardCompletion(s4: string?, _) -- line: 233
			-- upvalues: AccessResponseEnum (copy), v61 (copy), p2 (copy)
			local v76 = if s4 ~= AccessResponseEnum.Granted then s4 ~= AccessResponseEnum.Error and "Cancelled" or "Error" else "Success"

			if v76 == "Success" then
				v61()
			end

			if p2 then
				p2(v76)
			end
		end

		v47(OpenAmpWizardContainer(FStringLuaAppPlayButtonAgeCheckAmpFeatureName, onAmpWizardCompletion, nil, "joinCardAgeCheckRequired", nil, FStringLuaAppPlayButtonAgeCheckAmpNameSpace, nil, nil, if not FFlagLuaAppPlayButtonWizardCloseDelay then nil else delayedAmpWizardCompletionCallbackOverride(onAmpWizardCompletion, FIntLuaAppPlayButtonWizardCloseDelayMs)))
	end, {
		v47,
		v61,
		p2
	})
	local v63 = v56 ~= nil and (v56.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls and (v55 == nil or v58 == nil and not v51))
	local v64 = if not v56 then nil else v56.playabilityStatus

	return React.useMemo(function() -- line: 275
		-- upvalues: v64 (copy), v49 (copy), v63 (copy), v60 (copy), v57 (copy), v62 (copy), v61 (copy)
		return {
			cachedPlayabilityStatus = v64,
			playabilityChecked = v49,
			pendingParentalControlsResolution = v63,
			ageCheckRequired = v60,
			playabilityFromCache = v57.current,
			joinAgeCheckUpsellFlow = v62,
			refetchPlayability = v61
		}
	end, {
		v64,
		v49,
		v63,
		v60,
		v62,
		v61
	})
end

return useAgeCheckUpsellState
