local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBuilder
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local GoalLockedActionId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalLockedActionId")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildAdsManagerUniverseUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsManagerUniverseUrl")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")
local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")
local adCampaignScheduleUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignScheduleUtils")
local AdCampaignCreatedToast = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdCampaignCreatedToast")
local CreateAdCampaignSheetContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetContainer")
local getAdsManagerUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/getAdsManagerUrl").getAdsManagerUrl
local useCreateAdCampaign = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useCreateAdCampaign")
local useGetAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaignEligibility")
local useGetAdCampaigns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaigns")
local ExperienceShareOverlays = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/ExperienceShareOverlays")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local BuildNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/BuildNavigationParams")
local useExperienceShareFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useExperienceShareFlow")

local v5 = urlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/monetization/developer-products")

local function useCreateAdAction(p2)
	local v6 = useLocalization({
		adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER,
		createSuccess = LocalizationStrings.ADS_STATS_CREATE_SUCCESS
	})

	local v7 = useOpenWebView()
	local adsManager = v6.adsManager
	local v9 = if FFlagEnablePaidAds then p2 else nil
	local v10, v11 = useGetAdCampaignEligibility(v9)
	local v12 = useCreateAdCampaign(p2)
	local clearCreateError = v12.clearCreateError
	local createCampaign = v12.createCampaign
	local isCreatePending = v12.isCreatePending
	local hasCreateError = v12.hasCreateError

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(false)
	local ref = React.useRef(nil)

	local canCreateCampaign = adCampaignEligibilityUtils.canCreateCampaign(v10)

	local v13, v14 = useGetAdCampaigns()

	local v16 = v14 ~= "Ready" or not adCampaignScheduleUtils.hasActiveCampaign(v13, p2, DateTime.now().UnixTimestampMillis)

	local v17 = React.useCallback(function()
		if state4 then
			return
		end

		if not (FFlagEnablePaidAds and canCreateCampaign) then
			v7(getAdsManagerUrl(p2), adsManager)
			return
		end

		setState2(false)

		setState3(function(p3)
			if hasCreateError and p3 ~= nil then
				return p3
			end

			return adCampaignEligibilityUtils.campaignSheetTerms(v10, DateTime.now().UnixTimestampMillis)
		end)

		setState(true)
	end, {
		state4,
		canCreateCampaign,
		v7,
		p2,
		adsManager,
		clearCreateError,
		hasCreateError,
		v10
	})

	local v18 = React.useCallback(function()
		setState(false)
		clearCreateError()
	end, { clearCreateError })

	local v19 = React.useCallback(function(p3)
		ref.current = v10
		createCampaign(p3)
	end, { v10, createCampaign })

	local ref2 = React.useRef(false)
	React.useEffect(function()
		local current = ref2.current
		ref2.current = isCreatePending

		if current and not (isCreatePending or hasCreateError) then
			setState(false)
			setState2(true)
			setState4(ref.current ~= nil)
		end
	end, { isCreatePending, hasCreateError })

	React.useEffect(function()
		local v20 = v11 == "Ready" and v10 ~= nil and v10 ~= ref.current

		if state4 and (v20 or v11 == "Failed") then
			ref.current = nil
			setState4(false)
		end
	end, { state4, v11, v10 })

	React.useEffect(function()
		ref.current = nil
		setState4(false)
		setState3(nil)
	end, { p2 })

	local v20 = React.useCallback(function()
		setState2(false)
	end, {})

	local runStartMs = if state3 ~= nil then state3.runStartMs else nil
	local durationDays = if state3 ~= nil then state3.durationDays else nil
	local v21

	if FFlagEnablePaidAds then
		local createElement = React.createElement
		local fragment = React.Fragment
		local createElement2 = React.createElement
		local v25 = {
			universeId = if FFlagBuildAdsManagerUniverseUrl then p2 else nil,
			isOpen = state,
			onClose = v18,
			onCreate = v19,
			waitForCreateResult = true,
			isCreatePending = isCreatePending or state4,
			hasCreateError = hasCreateError,
			createErrorKind = v12.createErrorKind,
			useLocalRunDates = true,
			campaignDurationDays = durationDays,
			estimatedPriceRobux = 0,
			campaignOffers = 0,
			runStartTimeMs = 0,
			runEndTimeMs = 0
		}

		local v27 = if state3 ~= nil then state3.estimatedPriceRobux else nil
		v25.estimatedPriceRobux = v27
		local v28 = if state3 ~= nil then state3.campaignOffers else nil
		v25.campaignOffers = v28
		v25.runStartTimeMs = runStartMs

		local v29 = if runStartMs ~= nil and durationDays ~= nil then adCampaignScheduleUtils.campaignEndMs(runStartMs, durationDays) else nil
		v25.runEndTimeMs = v29
		local v23 = { Sheet = createElement2(CreateAdCampaignSheetContainer, v25), Toast = 0 }

		local v30 = if state2 then React.createElement(AdCampaignCreatedToast, {
			onClose = v20,
			testId = "GoalAdCampaignCreatedToast",
			title = v6.createSuccess
		}) else nil
		v23.Toast = v30
		v21 = createElement(fragment, nil, v23)
	else
		v21 = nil
	end

	local v22 = v14 == "NotReady"
	return React.useMemo(function()
		return { onActivate = v17, isEligible = v16, isLoading = v22, overlay = v21 }
	end, { v17, v21, v16, v22 })
end

local function useSellItemsAction(p2, p3, p4)
	local v6 = useLocalization({ creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB })
	local v7 = useOpenWebView()
	local creatorHub = v6.creatorHub

	local v8 = React.useCallback(function()
		if FFlagBuildExperienceMonetizationNativeUI and p3 ~= nil and p4 ~= nil then
			p3.navigate("BuildMonetization", { target = p4 })
		else
			v7(v5({ universeId = p2 }), creatorHub)
		end
	end, { p2, p3, p4, v7, creatorHub })

	return React.useMemo(function()
		return { onActivate = v8, isEligible = true }
	end, { v8 })
end

local function useShareWithFriendsAction(p2, p3)
	local v6 = useExperienceShareFlow(p2, p3)
	local onShare = v6.onShare

	local element = React.createElement(ExperienceShareOverlays, {
		activeDialog = v6.activeDialog,
		hasShareError = v6.hasShareError,
		onCancel = v6.onCancelDialog,
		onConfirmFriends = v6.onConfirmFriends,
		onConfirmPlaytesters = v6.onConfirmPlaytesters
	})

	return React.useMemo(function()
		return { onActivate = onShare, isEligible = true, overlay = element }
	end, { onShare, element })
end

local function useGoalLockedActions(p2)
	local v6 = Navigation.useNavigation()
	local v7 = if v6 ~= nil then BuildNavigationParams.getTarget(v6) else nil

	local v8 = useCreateAdAction(p2)
	local v9 = useSellItemsAction(p2, v6, v7)
	local v11 = if v7 ~= nil then v7.placeId else nil
	local v12 = useShareWithFriendsAction(p2, v11)

	return {
		actions = React.useMemo(function()
			return {
				[GoalLockedActionId.CreateAd] = v8,
				[GoalLockedActionId.SellItems] = v9,
				[GoalLockedActionId.ShareWithFriends] = v12
			}
		end, { v8, v9, v12 })
	}
end

return useGoalLockedActions
