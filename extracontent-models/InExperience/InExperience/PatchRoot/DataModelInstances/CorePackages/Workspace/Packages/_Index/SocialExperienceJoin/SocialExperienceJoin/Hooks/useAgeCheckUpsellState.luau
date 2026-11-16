local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local GameDetailRodux = require(parent.GameDetailRodux)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SignalsReact = require(parent.SignalsReact)

local NetworkingGames = require(SocialExperienceJoin.Networking.NetworkingGames)
local JoinCardCacheStore = require(SocialExperienceJoin.Stores.JoinCardCacheStore)

local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local FetchUserSettingsAndOptions = GameDetailRodux.FetchUserSettingsAndOptions
local ApiFetchAgeRecommendations = GameDetailRodux.AgeRecommendations.ApiFetchAgeRecommendations

local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = RobloxAppHooks.useRoactService
local useSignalState = SignalsReact.useSignalState

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = SharedFlags.FFlagLuaAppPlayButtonAmpAgeCheckFlow
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags2.FFlagLuaAppPlayButtonWizardCloseDelay
local SharedFlags3 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonWizardCloseDelayMs = SharedFlags3.FIntLuaAppPlayButtonWizardCloseDelayMs

local SharedFlags4 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags4.FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local SharedFlags5 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags5.FStringLuaAppPlayButtonAgeCheckAmpNameSpace

local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local GamePlayButton = require(parent.GamePlayButton)
local delayedAmpWizardCompletionCallbackOverride = GamePlayButton.delayedAmpWizardCompletionCallbackOverride

local v = {}

local function parseContentMaturityMapping(value: string)
	local contentMaturityMapping = {}

	if value == "" then
		return contentMaturityMapping
	end

	for _, v2 in string.split(value, ",") do
		local v3 = string.split(v2, "=")

		if #v3 == 2 and v3[1] ~= "" and v3[2] ~= "" then
			contentMaturityMapping[v3[1]] = v3[2]
		end
	end

	return contentMaturityMapping
end

local v2 = parseContentMaturityMapping(game:DefineFastString(
	"LuaAppUpsellMaturityRatingToSettingMapping",
	"mild=NinePlus,moderate=ThirteenPlus,restricted=SeventeenPlus,unrated=ThirteenPlus"
))

local function parentalControlsRequiresAgeCheck(p, p2: string?): boolean
	if not (p and p2) then
		return false
	end

	local contentAgeRestriction = p.contentAgeRestriction

	if not (contentAgeRestriction and contentAgeRestriction.options) then
		return false
	end

	local v3 = v2[p2]

	if not v3 then
		return false
	end

	for _, option in contentAgeRestriction.options do
		if option and option.option and option.option.optionValue == v3 then
			return option.requirement == "ContentAgeRestrictionVerification"
		end
	end

	return false
end

local _ = { Success = "Success", Cancelled = "Cancelled", Error = "Error" }

local function useAgeCheckUpsellState(p: string, callback)
	local v3 = useDispatch()
	local v4 = useRoactService(RoactNetworking)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v5 = JoinCardCacheStore.get()
	local v6 = useSignalState(v5.getPlayabilityEntries)
	local v7 = useSignalState(v5.getUserSettings)
	local v8

	if p == "" then
		v8 = nil
	else
		v8 = v6[p]
	end

	local ref = React.useRef(v8 ~= nil)

	local v9 = useSelector(function(p2)
		local v9 = p2.AgeRecommendations and p2.AgeRecommendations[p]

		if v9 and v9.summary and v9.summary.ageRecommendation then
			return v9.summary.ageRecommendation.contentMaturity
		end

		return nil
	end)

	React.useEffect(function()
		if p == "" then
			setState(true)
			setState2(false)
		elseif v5.getPlayabilityEntries(false)[p] == nil then
			setState2(false)
			setState(false)

			v3(NetworkingGames.GetExperiencesPlayabilityStatus.API({ p })):andThen(function(p2)
				local v10 = p2.responseBody and p2.responseBody[1]

				if v10 then
					v5.setPlayabilityEntry(p, v10)
				end
			end):catch(function() end):finally(function()
				setState(true)
			end)
		else
			setState(true)
			setState2(v5.getUserSettings(false) ~= nil)
		end
	end, { v3, p, v5 })

	React.useEffect(function()
		if not (p ~= "" and (v8 and v8.playabilityStatus) == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls) then
			return
		end

		v3(ApiFetchAgeRecommendations.Fetch(v4, p)):catch(function() end):finally(function()
			setState2(true)
		end)
	end, { v3, v4, p, v8 })

	React.useEffect(function()
		if not (p ~= "" and (v8 and v8.playabilityStatus) == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls and v5.getUserSettings(false) == nil) then
			return
		end

		FetchUserSettingsAndOptions(v4):andThen(function(p2)
			v5.setUserSettings(p2)
		end):catch(function()
			v5.setUserSettings(v)
		end)
	end, { v4, p, v8, v5 })
	local v10

	if
		v8 == nil
		or v8.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
	then
		v10 = false
	else
		v10 = parentalControlsRequiresAgeCheck(v7, v9)
	end

	local ageCheckRequired

	if v8 == nil then
		ageCheckRequired = false
	else
		ageCheckRequired = (v8.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or FFlagLuaAppPlayButtonAmpAgeCheckFlow and v8.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired)
			and true
			or v10
	end

	local refetchPlayability = React.useCallback(function()
		if p == "" then
			return
		end

		v3(NetworkingGames.GetExperiencesPlayabilityStatus.API({ p })):andThen(function(p2)
			local v11 = p2.responseBody and p2.responseBody[1]

			if v11 then
				v5.setPlayabilityEntry(p, v11)
			end
		end):catch(function()
			v5.clearPlayabilityEntry(p)
		end)
		FetchUserSettingsAndOptions(v4):andThen(function(p2)
			v5.setUserSettings(p2)
		end):catch(function()
			v5.setUserSettings(v)
		end)
	end, { v3, v4, p, v5 })

	local joinAgeCheckUpsellFlow = React.useCallback(function()
		local function onAmpWizardCompletion(p2: string?, _)
			local v11 = p2 == AccessResponseEnum.Granted and "Success"
				or p2 == AccessResponseEnum.Error and "Error"
				or "Cancelled"

			if v11 == "Success" then
				refetchPlayability()
			end

			if callback then
				callback(v11)
			end
		end

		local v11

		if FFlagLuaAppPlayButtonWizardCloseDelay then
			v11 = delayedAmpWizardCompletionCallbackOverride(
				onAmpWizardCompletion,
				FIntLuaAppPlayButtonWizardCloseDelayMs
			)
		end

		v3(OpenAmpWizardContainer(
			FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
			onAmpWizardCompletion,
			nil,
			"joinCardAgeCheckRequired",
			nil,
			FStringLuaAppPlayButtonAgeCheckAmpNameSpace,
			nil,
			nil,
			v11
		))
	end, { v3, refetchPlayability, callback })
	local pendingParentalControlsResolution

	if
		v8 == nil
		or v8.playabilityStatus ~= PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
	then
		pendingParentalControlsResolution = false
	elseif v7 == nil then
		pendingParentalControlsResolution = true
	elseif v9 == nil then
		pendingParentalControlsResolution = not state2
	else
		pendingParentalControlsResolution = false
	end

	local playabilityStatus

	if v8 then
		playabilityStatus = v8.playabilityStatus
	else
		playabilityStatus = nil
	end

	return React.useMemo(function()
		return {
			cachedPlayabilityStatus = playabilityStatus,
			playabilityChecked = state,
			pendingParentalControlsResolution = pendingParentalControlsResolution,
			ageCheckRequired = ageCheckRequired,
			playabilityFromCache = ref.current,
			joinAgeCheckUpsellFlow = joinAgeCheckUpsellFlow,
			refetchPlayability = refetchPlayability
		}
	end, {
		playabilityStatus,
		state,
		pendingParentalControlsResolution,
		ageCheckRequired,
		joinAgeCheckUpsellFlow,
		refetchPlayability
	})
end

return useAgeCheckUpsellState
