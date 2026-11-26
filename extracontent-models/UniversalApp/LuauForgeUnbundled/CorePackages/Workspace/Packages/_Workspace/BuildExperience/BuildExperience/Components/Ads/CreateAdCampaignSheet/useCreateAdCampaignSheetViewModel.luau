local LocalizationService = game:GetService("LocalizationService")

local CreatorCredit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InputHandlers")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactFocusNavigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Responsive")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView

local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")
local FFlagBuildAdsManagerUniverseUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsManagerUniverseUrl")
local getAdsManagerUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/getAdsManagerUrl")
local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")
local adCampaignScheduleUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignScheduleUtils")
local CreateAdCampaignSheetConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetConfig")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetView")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local useOpenBuyRobuxWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useOpenBuyRobuxWebView")
local useOpenWebViewWithResumeRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOpenWebViewWithResumeRefresh")

local dataStatus = DataHydration.DataStatus
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local iconName = Foundation.Enums.IconName
local campaignEndMs = adCampaignScheduleUtils.campaignEndMs
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local v5 = { Pending = "pending", Succeeded = "succeeded", Failed = "failed" }

local signal = Signals.createSignal({ status = "succeeded" })

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function formatNumber(p2)
	return numberLocalization.localize(
		string.format("%.0f", (math.floor(p2))),
		LocalizationService.RobloxLocaleId
	)
end

local function requireCampaignValue(p2, p3)
	if p2 == nil then
		error(`{p3} is required for the two-option ad campaign sheet`)
	end

	return p2
end

local function requireCampaignOffers(p2)
	if p2 == nil or p2.feedback == nil and p2.plays == nil then
		error("campaignOffers is required for the two-option ad campaign sheet")
	end

	return p2
end

local function getCampaignOffer(p2, p3)
	if p3 == "feedback" then
		return p2.feedback
	elseif p3 == "plays" then
		return p2.plays
	end

	return nil
end

local function toCampaignOption(data, p2, p3, p4, free)
	local v6 = data.fundingType == "free"
	local campaignOption = {
		value = data.campaignOption,
		title = p2,
		runDates = p3,
		description = p4,
		priceText = 0,
		originalPriceText = 0
	}

	if not v6 then
		local priceRobux = data.priceRobux
		free = numberLocalization.localize(
			string.format("%.0f", (math.floor(priceRobux))),
			LocalizationService.RobloxLocaleId
		)
	end

	campaignOption.priceText = free
	local v7

	if v6 then
		local priceRobux = data.priceRobux
		v7 = numberLocalization.localize(
			string.format("%.0f", (math.floor(priceRobux))),
			LocalizationService.RobloxLocaleId
		)
	end

	campaignOption.originalPriceText = v7
	return campaignOption
end

local function useTwoOptionsControls(p2, callback, callback2, p3, p4, p5, callback3, p6, p7, p8)
	local v6 = Responsive.usePreferredInput()
	local adCampaignCheckFunds = CreatorAgentChat.getCreatorAgentChatStore(false).adCampaignCheckFunds
	local defaultOffer = adCampaignEligibilityUtils.getDefaultOffer(p3)
	local campaignOption = if p6 == nil then defaultOffer.campaignOption else p6.campaignOption
	local state, setState = React.useState(campaignOption)
	local ref = React.useRef(nil)

	local state2, setState2 = React.useState(nil)

	local useSignalState = SignalsReact.useSignalState
	local v7 = if state2 == nil then signal else state2.state
	local v8 = useSignalState(v7)
	local v9 = React.useCallback(function(p9)
		if p9 == nil or p9.fundingType ~= "paid" then
			setState2(nil)
		else
			setState2(adCampaignCheckFunds({ campaignOption = p9.campaignOption }))
		end
	end, { adCampaignCheckFunds })
	React.useEffect(function()
		if state2 == nil then
			return
		end

		return function()
			state2.dispose()
		end
	end, { state2 or false })

	React.useEffect(function()
		if p2 then
			setState(function(p9)
				if not (p4 or p5) then
					return campaignOption
				end

				local v10 = p3
				local v11 = if p9 == "feedback" then v10.feedback elseif p9 == "plays" then v10.plays else nil

				if v11 ~= nil then
					return p9
				end

				return campaignOption
			end)

			return
		end

		if not p5 then
			setState(campaignOption)
		end

		setState2(nil)
	end, { p2, p4, p5, campaignOption, p3 })
	local v10 = if state == "feedback" then p3.feedback elseif state == "plays" then p3.plays else nil

	local v11 = p5 and (ref.current == nil or ref.current == state)
	React.useEffect(function()
		if p2 and not (v11 or p4) then
			v9(v10)
		end
	end, { p2, p4, v11, v10, v9 })

	local v12 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					callback()
					object:cancel()
				end)
			}
		}
	end, { callback })
	local v14, v15 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = p2,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = v12
	})))
	local v16 = React.useCallback(function(p9)
		setState(p9)
	end, {})
	local result = v8.result
	local v17 = not (v10 == nil) and v10.fundingType == "paid"

	local v18 = not p4 and not v11 and v17 and (state2 == nil or v8.status == "pending")

	local v19 = not p4 and not v11 and v17 and v8.status == "failed"

	local v20 = if v17 then v8.status == "succeeded" and result ~= nil and result.canFund else v17

	local v21 = not (p4 or v11)

	if v21 then
		v21 = if v17 then v8.status == "succeeded" and result ~= nil and not result.canFund else v17
	end

	local v22 = React.useCallback(function()
		callback3()

		if p2 and v17 then
			v9(v10)
		end
	end, { p2, v17, v10, v9, callback3 })
	local v23 = useOpenBuyRobuxWebView(v22)
	local v24

	if FFlagBuildAdsManagerUniverseUrl then
		v24 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getAdsManagerUrl(p8), p7, v22)
	else
		v24 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getDefaultAdsManagerUrl(), p7, v22)
	end

	local v25 = React.useCallback(function()
		if v21 then
			v23()
			return
		end

		if v19 then
			v9(v10)
			return
		end

		if v17 and not (v11 or v20) or v10 == nil then
			return
		end

		ref.current = v10.campaignOption
		callback2({ paymentType = v10.fundingType, campaignOption = v10.campaignOption })
	end, {
		callback2,
		v10,
		v21,
		v23,
		v17,
		v11,
		v20,
		v19,
		v9
	})

	return {
		sheetRootRef = v15,
		defaultOptionRef = v14,
		selectedOption = state,
		showCloseButton = v6 ~= Responsive.Input.Directional,
		isFundingCheckPending = v18,
		isPrimaryActionDisabled = v10 == nil or not v11 and v17 and not v20 and not (v21 or v19),
		shouldBuyRobux = v21,
		showAdCreditsCallout = not p4 and v20 and result.fundingSource == "ad_credit",
		isErrorForSelectedOption = v11,
		onOptionChanged = v16,
		onOpenBuyRobux = v23,
		onOpenAdsManager = v24,
		onCreate = v25
	}
end

local function useCreateAdCampaignSheetViewModel(data)
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
	local v6 = React.useMemo(function()
		return creatorCreditStore.getQuotaSummary()
	end, { creatorCreditStore })
	local v7 = SignalsReact.useSignalState(v6.data)
	local v8 = SignalsReact.useSignalState(v6.status)

	local v9 = useOpenWebView()
	local v10 = FFlagEnablePaidAds
	local campaignOffers

	if v10 then
		campaignOffers = data.campaignOffers

		if campaignOffers == nil or campaignOffers.feedback == nil and campaignOffers.plays == nil then
			error("campaignOffers is required for the two-option ad campaign sheet")
		end
	end

	local feedback = if campaignOffers ~= nil then campaignOffers.feedback else nil
	local plays = if campaignOffers ~= nil then campaignOffers.plays else nil
	local v11

	if v10 and feedback ~= nil then
		v11 = feedback.durationDays
	else
		v11 = data.campaignDurationDays or CreateAdCampaignSheetConfig.DEFAULT_CAMPAIGN_DURATION_DAYS
	end

	local v12

	if v10 and feedback ~= nil then
		v12 = feedback.priceRobux
	else
		v12 = data.estimatedPriceRobux or CreateAdCampaignSheetConfig.DEFAULT_ESTIMATED_PRICE_ROBUX
	end

	local runStartTimeMs

	if v10 then
		runStartTimeMs = data.runStartTimeMs

		if runStartTimeMs == nil then
			error("runStartTimeMs is required for the two-option ad campaign sheet")
		end
	else
		runStartTimeMs = data.runStartTimeMs or CreateAdCampaignSheetConfig.DEFAULT_RUN_START_TIME_MS
	end

	local v13

	if v10 then
		v13 = campaignEndMs(runStartTimeMs, v11)
	else
		v13 = if data.runEndTimeMs == nil then CreateAdCampaignSheetConfig.DEFAULT_RUN_END_TIME_MS else data.runEndTimeMs
	end

	local v14

	if data.useLocalRunDates == true then
		v14 = LocalizationStrings.formatAdCampaignSheetLocalDate
	else
		v14 = LocalizationStrings.formatAdCampaignSheetDate
	end

	local v15 = v14(runStartTimeMs)
	local v16 = v14(v13)
	local v17

	if v10 then
		v17 = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_TITLE
	else
		v17 = LocalizationStrings.AD_CAMPAIGN_SHEET_TITLE
	end

	local v18 = if v10 then LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_MODERATION_NOTICE else LocalizationStrings.AD_CAMPAIGN_SHEET_MODERATION_NOTICE
	local v19 = {
		title = v17,
		description = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_DESCRIPTION,
			durationDays = v11
		},
		campaignTitle = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_CAMPAIGN_TITLE,
			durationDays = v11
		},
		runDates = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES,
			startDate = v15,
			endDate = v16
		},
		free = LocalizationStrings.AD_CAMPAIGN_SHEET_FREE,
		earnedRobuxDisclaimer = LocalizationStrings.AD_CAMPAIGN_SHEET_EARNED_ROBUX_DISCLAIMER,
		includedTitle = LocalizationStrings.AD_CAMPAIGN_SHEET_INCLUDED_TITLE,
		maximizePlays = LocalizationStrings.AD_CAMPAIGN_SHEET_MAXIMIZE_PLAYS,
		targetPlayers = LocalizationStrings.AD_CAMPAIGN_SHEET_TARGET_PLAYERS,
		performanceReport = LocalizationStrings.AD_CAMPAIGN_SHEET_PERFORMANCE_REPORT,
		legal = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_LEGAL,
			advertisingTermsStart = CreateAdCampaignSheetConfig.ADVERTISING_TERMS_START_MARKER,
			advertisingTermsEnd = CreateAdCampaignSheetConfig.ADVERTISING_TERMS_END_MARKER,
			advertisingStandardsStart = CreateAdCampaignSheetConfig.ADVERTISING_STANDARDS_START_MARKER,
			advertisingStandardsEnd = CreateAdCampaignSheetConfig.ADVERTISING_STANDARDS_END_MARKER
		},
		create = LocalizationStrings.AD_CAMPAIGN_SHEET_CREATE,
		moderationNotice = v18,
		createError = LocalizationStrings.AD_CAMPAIGN_SHEET_CREATE_ERROR
	}

	if v10 then
		v19.forbiddenError = LocalizationStrings.AD_CAMPAIGN_SHEET_FORBIDDEN_ERROR
		v19.insufficientFundsError = LocalizationStrings.AD_CAMPAIGN_SHEET_INSUFFICIENT_FUNDS_ERROR
		v19.internalError = LocalizationStrings.AD_CAMPAIGN_SHEET_INTERNAL_ERROR
		v19.missingThumbnailError = LocalizationStrings.AD_CAMPAIGN_SHEET_MISSING_THUMBNAIL_ERROR
		v19.introduction = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_INTRODUCTION
		v19.startCampaignTitle = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_CAMPAIGN_PICKER_TITLE

		if feedback ~= nil then
			v19.feedbackOptionTitle = {
				LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_OPTION_TITLE,
				durationDays = feedback.durationDays
			}

			v19.feedbackRunDates = {
				LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES,
				startDate = v15,
				endDate = v14(campaignEndMs(runStartTimeMs, feedback.durationDays))
			}

			v19.feedbackDescription = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_SHORT_DESCRIPTION
		end

		if plays ~= nil then
			v19.playsOptionTitle = {
				LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_OPTION_TITLE,
				durationDays = plays.durationDays
			}

			v19.playsRunDates = {
				LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES,
				startDate = v15,
				endDate = v14(campaignEndMs(runStartTimeMs, plays.durationDays))
			}

			v19.playsDescription = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_LONG_DESCRIPTION
		end

		v19.buyRobux = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON
		v19.adCreditsTitle = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_AD_CREDITS_TITLE
		v19.adCreditsAction = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_AD_CREDITS_ACTION
		v19.adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER
	end

	local v20 = useLocalization(v19)

	local waitForCreateResult = data.waitForCreateResult == true
	local v21 = waitForCreateResult and data.isCreatePending == true
	local v22 = waitForCreateResult and data.hasCreateError == true
	local v23 = v20.createError

	if v10 and v22 then
		local createErrorKind = data.createErrorKind

		if createErrorKind == "payment_required" then
			v23 = v20.insufficientFundsError
		elseif createErrorKind == "ineligible" then
			v23 = v20.forbiddenError
		elseif createErrorKind == "missing_thumbnail" then
			v23 = v20.missingThumbnailError
		else
			v23 = v20.internalError
		end
	end

	local v24 = React.useCallback(function()
		if v21 then
			return
		end

		data.onClose()
	end, { data.onClose, v21 })

	local v25 = React.useCallback(function(p2)
		data.onCreate(p2)

		if not waitForCreateResult then
			v24()
		end
	end, { data.onCreate, v24, waitForCreateResult })
	local v26 = React.useCallback(function(p2)
		v9(CreateAdCampaignSheetConfig.ADVERTISING_TERMS_URL, p2)
	end, { v9 })
	local v27 = React.useCallback(function(p2)
		v9(CreateAdCampaignSheetConfig.ADVERTISING_STANDARDS_URL, p2)
	end, { v9 })
	local v28

	if FFlagEnablePaidAds then
		local v29 = React.useCallback(function()
			creatorCreditStore.refreshQuotaSummary():catch(function() end)
		end, { creatorCreditStore })

		local isOpen = data.isOpen

		local attemptedOption = data.attemptedOption
		local adsManager = v20.adsManager
		local v31 = if FFlagBuildAdsManagerUniverseUrl then data.universeId else nil
		v28 = useTwoOptionsControls(
			isOpen,
			v24,
			v25,
			campaignOffers,
			v21,
			v22,
			v29,
			attemptedOption,
			adsManager,
			v31
		)
	end

	local v29, v30

	if v7 == nil then
		if v8 == dataStatus.Failed then
			v29 = CreateAdCampaignSheetConfig.BALANCE_UNAVAILABLE
			v30 = "failed"
		else
			v29 = CreateAdCampaignSheetConfig.BALANCE_LOADING
			v30 = "loading"
		end
	else
		local robuxBalance = v7.robuxBalance
		v29 = numberLocalization.localize(
			string.format("%.0f", (math.floor(robuxBalance))),
			LocalizationService.RobloxLocaleId
		)
		v30 = "ready"
	end

	if not v10 then
		return {
			variant = "freeOptionOnly",
			isOpen = data.isOpen,
			title = v20.title,
			description = v20.description,
			campaignTitle = v20.campaignTitle,
			estimatedPriceText = numberLocalization.localize(
				string.format("%.0f", (math.floor(v12))),
				LocalizationService.RobloxLocaleId
			),
			freeText = v20.free,
			earnedRobuxDisclaimer = v20.earnedRobuxDisclaimer,
			includedTitle = v20.includedTitle,
			benefits = {
				{ icon = iconName.Calendar, text = v20.runDates },
				{ icon = iconName.CirclePlay, text = v20.maximizePlays },
				{ icon = iconName.ThreePeople, text = v20.targetPlayers },
				{ icon = iconName.ChartScatterPlot, text = v20.performanceReport }
			},
			legalText = v20.legal,
			createText = v20.create,
			moderationNotice = v20.moderationNotice,
			balanceState = v30,
			balanceText = v29,
			isCreatePending = v21,
			hasCreateError = v22,
			createErrorText = v23,
			onClose = v24,
			onCreate = v25,
			onAdvertisingTerms = v26,
			onAdvertisingStandards = v27
		}
	end

	local v31 = {
		variant = "twoOptions",
		isOpen = data.isOpen,
		sheetRootRef = v28.sheetRootRef,
		title = v20.title,
		description = v20.introduction,
		startCampaignTitle = v20.startCampaignTitle,
		selectedOption = v28.selectedOption,
		defaultOptionRef = v28.defaultOptionRef,
		feedbackOption = 0,
		playsOption = 0,
		legalText = 0,
		createText = 0,
		moderationNotice = 0,
		isCreatePending = 0,
		isFundingCheckPending = 0,
		isCreateDisabled = 0,
		showAdCreditsCallout = 0,
		adCreditsTitle = 0,
		adCreditsAction = 0,
		hasCreateError = 0,
		createErrorText = 0,
		balanceState = 0,
		balanceText = 0,
		showCloseButton = 0,
		onOptionChanged = 0,
		onOpenBuyRobux = 0,
		onOpenAdsManager = 0,
		onClose = 0,
		onCreate = 0,
		onAdvertisingTerms = 0,
		onAdvertisingStandards = 0
	}

	local v32 = if feedback ~= nil then toCampaignOption(
		feedback,
		v20.feedbackOptionTitle,
		v20.feedbackRunDates,
		v20.feedbackDescription,
		v20.free
	) else nil
	v31.feedbackOption = v32

	local v33 = if plays ~= nil then toCampaignOption(
		plays,
		v20.playsOptionTitle,
		v20.playsRunDates,
		v20.playsDescription,
		v20.free
	) else nil
	v31.playsOption = v33

	v31.legalText = v20.legal
	local v34 = if v28.shouldBuyRobux then v20.buyRobux else v20.create
	v31.createText = v34
	v31.moderationNotice = v20.moderationNotice
	v31.isCreatePending = v21
	v31.isFundingCheckPending = v28.isFundingCheckPending
	v31.isCreateDisabled = v28.isPrimaryActionDisabled
	v31.showAdCreditsCallout = v28.showAdCreditsCallout
	v31.adCreditsTitle = v20.adCreditsTitle
	v31.adCreditsAction = v20.adCreditsAction
	v31.hasCreateError = v28.isErrorForSelectedOption
	v31.createErrorText = v23
	v31.balanceState = v30
	v31.balanceText = v29
	v31.showCloseButton = v28.showCloseButton
	v31.onOptionChanged = v28.onOptionChanged
	v31.onOpenBuyRobux = v28.onOpenBuyRobux
	v31.onOpenAdsManager = v28.onOpenAdsManager
	v31.onClose = v24
	v31.onCreate = v28.onCreate
	v31.onAdvertisingTerms = v26
	v31.onAdvertisingStandards = v27
	return v31
end

return useCreateAdCampaignSheetViewModel
