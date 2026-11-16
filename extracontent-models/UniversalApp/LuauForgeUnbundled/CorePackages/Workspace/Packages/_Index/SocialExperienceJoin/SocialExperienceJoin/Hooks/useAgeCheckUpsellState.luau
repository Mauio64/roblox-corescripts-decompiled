local GameDetailRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/GameDetailRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppHooks")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SignalsReact")

local NetworkingGames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingGames")
local JoinCardCacheStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Stores/JoinCardCacheStore")

local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/DiscoveryTypes").PlayabilityStatusEnum

local fetchUserSettingsAndOptions = GameDetailRodux.FetchUserSettingsAndOptions
local apiFetchAgeRecommendations = GameDetailRodux.AgeRecommendations.ApiFetchAgeRecommendations

local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = RobloxAppHooks.useRoactService
local useSignalState = SignalsReact.useSignalState

local fFlagLuaAppPlayButtonAmpAgeCheckFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagLuaAppPlayButtonAmpAgeCheckFlow
local fFlagLuaAppPlayButtonWizardCloseDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagLuaAppPlayButtonWizardCloseDelay
local fIntLuaAppPlayButtonWizardCloseDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FIntLuaAppPlayButtonWizardCloseDelayMs

local fStringLuaAppPlayButtonAgeCheckAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local fStringLuaAppPlayButtonAgeCheckAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpNameSpace

local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/AmpUpsell")
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local delayedAmpWizardCompletionCallbackOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/GamePlayButton").delayedAmpWizardCompletionCallbackOverride

local v5 = {}

local function parseContentMaturityMapping(value)
	local contentMaturityMapping = {}

	if value == "" then
		return contentMaturityMapping
	end

	for k, v6 in string.split(value, ",") do
		local v7 = string.split(v6, "=")

		if #v7 == 2 and v7[1] ~= "" and v7[2] ~= "" then
			contentMaturityMapping[v7[1]] = v7[2]
		end
	end

	return contentMaturityMapping
end

local v6 = parseContentMaturityMapping(game:DefineFastString(
	"LuaAppUpsellMaturityRatingToSettingMapping",
	"mild=NinePlus,moderate=ThirteenPlus,restricted=SeventeenPlus,unrated=ThirteenPlus"
))

local function parentalControlsRequiresAgeCheck(p2, p3): boolean
	if not (p2 and p3) then
		return false
	end

	local contentAgeRestriction = p2.contentAgeRestriction

	if not (contentAgeRestriction and contentAgeRestriction.options) then
		return false
	end

	local v7 = v6[p3]

	if not v7 then
		return false
	end

	for k, option in contentAgeRestriction.options do
		if option and option.option and option.option.optionValue == v7 then
			return option.requirement == "ContentAgeRestrictionVerification"
		end
	end

	return false
end

local v7 = { Success = "Success", Cancelled = "Cancelled", Error = "Error" }

local function useAgeCheckUpsellState(p2, callback)
	local v8 = useDispatch()
	local v9 = useRoactService(roactNetworking)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v10 = JoinCardCacheStore.get()
	local v11 = useSignalState(v10.getPlayabilityEntries)
	local v12 = useSignalState(v10.getUserSettings)
	local v13 = if p2 ~= "" then v11[p2] else nil

	local ref = React.useRef(v13 ~= nil)

	local v14 = useSelector(function(p3)
		local v15 = p3.AgeRecommendations and p3.AgeRecommendations[p2]

		if v15 and v15.summary and v15.summary.ageRecommendation then
			return v15.summary.ageRecommendation.contentMaturity
		end

		return nil
	end)

	React.useEffect(function()
		if p2 == "" then
			setState(true)
			setState2(false)
		elseif v10.getPlayabilityEntries(false)[p2] == nil then
			setState2(false)
			setState(false)

			v8(NetworkingGames.GetExperiencesPlayabilityStatus.API({ p2 })):andThen(function(p3)
				local v15 = p3.responseBody and p3.responseBody[1]

				if v15 then
					v10.setPlayabilityEntry(p2, v15)
				end
			end):catch(function() end):finally(function()
				setState(true)
			end)
		else
			setState(true)
			setState2(v10.getUserSettings(false) ~= nil)
		end
	end, { v8, p2, v10 })

	React.useEffect(function()
		if not (p2 ~= "" and (v13 and v13.playabilityStatus) == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls) then
			return
		end

		v8(apiFetchAgeRecommendations.Fetch(v9, p2)):catch(function() end):finally(function()
			setState2(true)
		end)
	end, { v8, v9, p2, v13 })

	React.useEffect(function()
		if not (p2 ~= "" and (v13 and v13.playabilityStatus) == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls and v10.getUserSettings(false) == nil) then
			return
		end

		fetchUserSettingsAndOptions(v9):andThen(function(p3)
			v10.setUserSettings(p3)
		end):catch(function()
			v10.setUserSettings(v5)
		end)
	end, { v9, p2, v13, v10 })
	local v15

	if
		v13 == nil
		or v13.playabilityStatus ~= playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
	then
		v15 = false
	else
		v15 = parentalControlsRequiresAgeCheck(v12, v14)
	end

	local v16

	if v13 == nil then
		v16 = false
	else
		v16 = (v13.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or fFlagLuaAppPlayButtonAmpAgeCheckFlow and v13.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityAgeCheckRequired)
			and true
			or v15
	end

	local v17 = React.useCallback(function()
		if p2 == "" then
			return
		end

		v8(NetworkingGames.GetExperiencesPlayabilityStatus.API({ p2 })):andThen(function(p3)
			local v18 = p3.responseBody and p3.responseBody[1]

			if v18 then
				v10.setPlayabilityEntry(p2, v18)
			end
		end):catch(function()
			v10.clearPlayabilityEntry(p2)
		end)
		fetchUserSettingsAndOptions(v9):andThen(function(p3)
			v10.setUserSettings(p3)
		end):catch(function()
			v10.setUserSettings(v5)
		end)
	end, { v8, v9, p2, v10 })

	local v18 = React.useCallback(function()
		local function onAmpWizardCompletion(p3, p4)
			local v19 = p3 == accessResponseEnum.Granted and "Success"
				or p3 == accessResponseEnum.Error and "Error"
				or "Cancelled"

			if v19 == "Success" then
				v17()
			end

			if callback then
				callback(v19)
			end
		end

		local v28 = if fFlagLuaAppPlayButtonWizardCloseDelay then delayedAmpWizardCompletionCallbackOverride(
			onAmpWizardCompletion,
			fIntLuaAppPlayButtonWizardCloseDelayMs
		) else nil
		v8(openAmpWizardContainer(
			fStringLuaAppPlayButtonAgeCheckAmpFeatureName,
			onAmpWizardCompletion,
			nil,
			"joinCardAgeCheckRequired",
			nil,
			fStringLuaAppPlayButtonAgeCheckAmpNameSpace,
			nil,
			nil,
			v28
		))
	end, { v8, v17, callback })
	local v19

	if
		v13 == nil
		or v13.playabilityStatus ~= playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls
	then
		v19 = false
	else
		v19 = v12 == nil or v14 == nil and not state2
	end

	local playabilityStatus = if v13 then v13.playabilityStatus else nil

	return React.useMemo(function()
		return {
			cachedPlayabilityStatus = playabilityStatus,
			playabilityChecked = state,
			pendingParentalControlsResolution = v19,
			ageCheckRequired = v16,
			playabilityFromCache = ref.current,
			joinAgeCheckUpsellFlow = v18,
			refetchPlayability = v17
		}
	end, { playabilityStatus, state, v19, v16, v18, v17 })
end

return useAgeCheckUpsellState
