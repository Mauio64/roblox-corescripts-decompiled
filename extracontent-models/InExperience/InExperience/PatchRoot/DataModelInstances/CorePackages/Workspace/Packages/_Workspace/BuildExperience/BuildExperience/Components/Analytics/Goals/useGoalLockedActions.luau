local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Navigation = require(parent.Navigation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
require(parent.DataHydration.CreatorAgentChat)

local GoalLockedActionId = require(BuildExperience.Analytics.Goals.GoalLockedActionId)
require(BuildExperience.Analytics.Goals.GoalTypes)
require(BuildExperience.Chat.chatTypes)
local FFlagBuildAdsManagerUniverseUrl = require(BuildExperience.Flags.FFlagBuildAdsManagerUniverseUrl)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)
local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)
local adCampaignScheduleUtils = require(BuildExperience.Components.Ads.adCampaignScheduleUtils)
local AdCampaignCreatedToast = require(BuildExperience.Components.Ads.AdCampaignCreatedToast)
local CreateAdCampaignSheetContainer = require(BuildExperience.Components.Ads.CreateAdCampaignSheet.CreateAdCampaignSheetContainer)
local getAdsManagerUrl = require(BuildExperience.Components.Ads.getAdsManagerUrl)
local getAdsManagerUrl2 = getAdsManagerUrl.getAdsManagerUrl
local useCreateAdCampaign = require(BuildExperience.Components.Ads.useCreateAdCampaign)
local useGetAdCampaignEligibility = require(BuildExperience.Components.Ads.useGetAdCampaignEligibility)
local useGetAdCampaigns = require(BuildExperience.Components.Ads.useGetAdCampaigns)
local ExperienceShareOverlays = require(BuildExperience.Components.ShareAudience.ExperienceShareOverlays)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)

local v = urlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/monetization/developer-products")

local function useCreateAdAction(p: number)
	local v2 = useLocalization({
		adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER,
		createSuccess = LocalizationStrings.ADS_STATS_CREATE_SUCCESS
	})

	local v3 = useOpenWebView()
	local adsManager = v2.adsManager
	local v4

	if FFlagEnablePaidAds then
		v4 = p
	end

	local current2, v5 = useGetAdCampaignEligibility(v4)
	local v6 = useCreateAdCampaign(p)
	local clearCreateError = v6.clearCreateError
	local createCampaign = v6.createCampaign
	local isCreatePending = v6.isCreatePending
	local hasCreateError = v6.hasCreateError

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(false)
	local ref = React.useRef(nil)

	local canCreateCampaign = adCampaignEligibilityUtils.canCreateCampaign(current2)

	local v7, v8 = useGetAdCampaigns()

	local isEligible = v8 ~= "Ready"
		or not adCampaignScheduleUtils.hasActiveCampaign(v7, p, DateTime.now().UnixTimestampMillis)

	local onActivate = React.useCallback(function()
		if state4 then
			return
		end

		if not (FFlagEnablePaidAds and canCreateCampaign) then
			v3(getAdsManagerUrl2(p), adsManager)
			return
		end

		setState2(false)

		setState3(function(p2)
			if hasCreateError and p2 ~= nil then
				return p2
			end

			return adCampaignEligibilityUtils.campaignSheetTerms(current2, DateTime.now().UnixTimestampMillis)
		end)

		setState(true)
	end, {
		state4,
		canCreateCampaign,
		v3,
		p,
		adsManager,
		clearCreateError,
		hasCreateError,
		current2
	})

	local onClose = React.useCallback(function()
		setState(false)
		clearCreateError()
	end, { clearCreateError })

	local onCreate = React.useCallback(function(p2)
		ref.current = current2
		createCampaign(p2)
	end, { current2, createCampaign })

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
		local v9

		if v5 == "Ready" and current2 ~= nil then
			v9 = current2 ~= ref.current
		else
			v9 = false
		end

		if state4 and (v9 or v5 == "Failed") then
			ref.current = nil
			setState4(false)
		end
	end, { state4, v5, current2 })

	React.useEffect(function()
		ref.current = nil
		setState4(false)
		setState3(nil)
	end, { p })

	local onClose2 = React.useCallback(function()
		setState2(false)
	end, {})
	local runStartMs

	if state3 ~= nil then
		runStartMs = state3.runStartMs
	end

	local durationDays

	if state3 ~= nil then
		durationDays = state3.durationDays
	end

	local overlay

	if FFlagEnablePaidAds then
		local createElement = React.createElement
		local fragment = React.Fragment
		local createElement2 = React.createElement
		local universeId

		if FFlagBuildAdsManagerUniverseUrl then
			universeId = p
		end

		local v9 = {
			universeId = universeId,
			isOpen = state,
			onClose = onClose,
			onCreate = onCreate,
			waitForCreateResult = true,
			isCreatePending = isCreatePending or state4,
			hasCreateError = hasCreateError,
			createErrorKind = v6.createErrorKind,
			useLocalRunDates = true,
			campaignDurationDays = durationDays,
			estimatedPriceRobux = 0,
			campaignOffers = 0,
			runStartTimeMs = 0,
			runEndTimeMs = 0
		}
		local estimatedPriceRobux

		if state3 ~= nil then
			estimatedPriceRobux = state3.estimatedPriceRobux
		end

		v9.estimatedPriceRobux = estimatedPriceRobux
		local campaignOffers

		if state3 ~= nil then
			campaignOffers = state3.campaignOffers
		end

		v9.campaignOffers = campaignOffers
		v9.runStartTimeMs = runStartMs
		local runEndTimeMs

		if not (runStartMs == nil or durationDays == nil) then
			runEndTimeMs = adCampaignScheduleUtils.campaignEndMs(runStartMs, durationDays)
		end

		v9.runEndTimeMs = runEndTimeMs
		local v10 = {
			Sheet = createElement2(CreateAdCampaignSheetContainer, v9),
			Toast = 0
		}
		local toast

		if state2 then
			toast = React.createElement(AdCampaignCreatedToast, {
				onClose = onClose2,
				testId = "GoalAdCampaignCreatedToast",
				title = v2.createSuccess
			})
		end

		v10.Toast = toast
		overlay = createElement(fragment, nil, v10)
	else
		overlay = nil
	end

	local isLoading = v8 == "NotReady"
	return React.useMemo(function()
		return {
			onActivate = onActivate,
			isEligible = isEligible,
			isLoading = isLoading,
			overlay = overlay
		}
	end, { onActivate, overlay, isEligible, isLoading })
end

local function useSellItemsAction(universeId: number, p, target)
	local v2 = useLocalization({ creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB })
	local v3 = useOpenWebView()
	local creatorHub = v2.creatorHub

	local onActivate = React.useCallback(function()
		if FFlagBuildExperienceMonetizationNativeUI and p ~= nil and target ~= nil then
			p.navigate("BuildMonetization", { target = target })
		else
			v3(v({ universeId = universeId }), creatorHub)
		end
	end, { universeId, p, target, v3, creatorHub })

	return React.useMemo(function()
		return { onActivate = onActivate, isEligible = true }
	end, { onActivate })
end

local function useShareWithFriendsAction(p: number, p2: number?)
	local v2 = useExperienceShareFlow(p, p2)
	local onShare = v2.onShare

	local element = React.createElement(ExperienceShareOverlays, {
		activeDialog = v2.activeDialog,
		hasShareError = v2.hasShareError,
		onCancel = v2.onCancelDialog,
		onConfirmFriends = v2.onConfirmFriends,
		onConfirmPlaytesters = v2.onConfirmPlaytesters
	})

	return React.useMemo(function()
		return { onActivate = onShare, isEligible = true, overlay = element }
	end, { onShare, element })
end

local function useGoalLockedActions(universeId: number)
	local v2 = Navigation.useNavigation()
	local v3

	if v2 ~= nil then
		v3 = BuildNavigationParams.getTarget(v2)
	end

	local v4 = useCreateAdAction(universeId)
	local v5 = useSellItemsAction(universeId, v2, v3)
	local v6

	if v3 ~= nil then
		v6 = v3.placeId
	end

	local v7 = useShareWithFriendsAction(universeId, v6)

	return {
		actions = React.useMemo(function()
			return {
				[GoalLockedActionId.CreateAd] = v4,
				[GoalLockedActionId.SellItems] = v5,
				[GoalLockedActionId.ShareWithFriends] = v7
			}
		end, { v4, v5, v7 })
	}
end

return useGoalLockedActions
