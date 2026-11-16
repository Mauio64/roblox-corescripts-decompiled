local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local DataHydration = require(parent.DataHydration)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView

local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)
local FFlagBuildAdsManagerUniverseUrl = require(BuildExperience.Flags.FFlagBuildAdsManagerUniverseUrl)
local getAdsManagerUrl = require(script.Parent.Parent.getAdsManagerUrl)
local adCampaignEligibilityUtils = require(script.Parent.Parent.adCampaignEligibilityUtils)
local adCampaignScheduleUtils = require(script.Parent.Parent.adCampaignScheduleUtils)
local CreateAdCampaignSheetConfig = require(script.Parent.CreateAdCampaignSheetConfig)
require(script.Parent.CreateAdCampaignSheetView)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useOpenBuyRobuxWebView = require(BuildExperience.Components.CreatorCreditSheet.useOpenBuyRobuxWebView)
local useOpenWebViewWithResumeRefresh = require(BuildExperience.utils.useOpenWebViewWithResumeRefresh)

local DataStatus = DataHydration.DataStatus
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local IconName = Foundation.Enums.IconName
local campaignEndMs = adCampaignScheduleUtils.campaignEndMs
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local _ = { Pending = "pending", Succeeded = "succeeded", Failed = "failed" }

local signal = Signals.createSignal({ status = "succeeded" })

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function formatNumber(p: number) -- 4 equivalent calls inferred from this helper
	return NumberLocalization.localize(string.format("%.0f", (math.floor(p))), LocalizationService.RobloxLocaleId)
end

local function requireCampaignValue(runStartTimeMs: number?, p: string) -- 1 equivalent call inferred from this helper
	if runStartTimeMs == nil then
		error(`{p} is required for the two-option ad campaign sheet`)
	end

	return runStartTimeMs
end

local function requireCampaignOffers(campaignOffers) -- 1 equivalent call inferred from this helper
	if campaignOffers == nil or campaignOffers.feedback == nil and campaignOffers.plays == nil then
		error("campaignOffers is required for the two-option ad campaign sheet")
	end

	return campaignOffers
end

local function getCampaignOffer(p, p2: string?) -- 2 equivalent calls inferred from this helper
	if p2 == "feedback" then
		return p.feedback
	elseif p2 == "plays" then
		return p.plays
	end

	return nil
end

local function toCampaignOption(data, title: string, runDates: string, description: string, free: string)
	local v = data.fundingType == "free"
	local campaignOption = {
		value = data.campaignOption,
		title = title,
		runDates = runDates,
		description = description,
		priceText = 0,
		originalPriceText = 0
	}

	if not v then
		free = formatNumber(data.priceRobux) -- inferred equivalent call
	end

	campaignOption.priceText = free
	local originalPriceText

	if v then
		originalPriceText = formatNumber(data.priceRobux) -- inferred equivalent call
	end

	campaignOption.originalPriceText = originalPriceText
	return campaignOption
end

local function useTwoOptionsControls(isOpen: boolean, callback, callback2, campaignOffers, flag: boolean, flag2: boolean, callback3, attemptedOption, adsManager: string, p: number?)
	local v = Responsive.usePreferredInput()
	local adCampaignCheckFunds = CreatorAgentChat.getCreatorAgentChatStore(false).adCampaignCheckFunds
	local defaultOffer = adCampaignEligibilityUtils.getDefaultOffer(campaignOffers)
	local campaignOption

	if attemptedOption == nil then
		campaignOption = defaultOffer.campaignOption
	else
		campaignOption = attemptedOption.campaignOption
	end

	local state, setState = React.useState(campaignOption)
	local ref = React.useRef(nil)

	local state2, setState2 = React.useState(nil)

	local useSignalState = SignalsReact.useSignalState
	local v2 = if state2 == nil then signal else state2.state
	local v3 = useSignalState(v2)
	local v4 = React.useCallback(function(p2)
		if p2 == nil or p2.fundingType ~= "paid" then
			setState2(nil)
		else
			setState2(adCampaignCheckFunds({ campaignOption = p2.campaignOption }))
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
		if isOpen then
			setState(function(p2)
				if (flag or flag2) and getCampaignOffer(campaignOffers, p2) ~= nil then -- inferred equivalent call
					return p2
				end

				return campaignOption
			end)

			return
		end

		if not flag2 then
			setState(campaignOption)
		end

		setState2(nil)
	end, { isOpen, flag, flag2, campaignOption, campaignOffers })
	local campaignOffer = getCampaignOffer(campaignOffers, state) -- inferred equivalent call
	local isErrorForSelectedOption = flag2 and (ref.current == nil or ref.current == state)
	React.useEffect(function()
		if isOpen and not (isErrorForSelectedOption or flag) then
			v4(campaignOffer)
		end
	end, { isOpen, flag, isErrorForSelectedOption, campaignOffer, v4 })

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					callback()
					object:cancel()
				end)
			}
		}
	end, { callback })
	local defaultOptionRef, sheetRootRef = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = isOpen,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})))
	local onOptionChanged = React.useCallback(function(p2: string)
		setState(p2)
	end, {})
	local result = v3.result
	local v5

	if campaignOffer == nil then
		v5 = false
	else
		v5 = campaignOffer.fundingType == "paid"
	end

	local isFundingCheckPending = not flag
		and not isErrorForSelectedOption
		and v5
		and (state2 == nil or v3.status == "pending")

	local v6 = not flag and not isErrorForSelectedOption and v5 and v3.status == "failed"
	local v7

	if v5 then
		if v3.status == "succeeded" and result ~= nil then
			v7 = result.canFund
		else
			v7 = false
		end
	else
		v7 = v5
	end

	local shouldBuyRobux = not (flag or isErrorForSelectedOption)

	if shouldBuyRobux then
		if v5 then
			if v3.status == "succeeded" and result ~= nil then
				shouldBuyRobux = not result.canFund
			else
				shouldBuyRobux = false
			end
		else
			shouldBuyRobux = v5
		end
	end

	local v8 = React.useCallback(function()
		callback3()

		if isOpen and v5 then
			v4(campaignOffer)
		end
	end, { isOpen, v5, campaignOffer, v4, callback3 })
	local onOpenBuyRobux = useOpenBuyRobuxWebView(v8)
	local onOpenAdsManager

	if FFlagBuildAdsManagerUniverseUrl then
		onOpenAdsManager = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getAdsManagerUrl(p), adsManager, v8)
	else
		onOpenAdsManager = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getDefaultAdsManagerUrl(), adsManager, v8)
	end

	local onCreate = React.useCallback(function()
		if shouldBuyRobux then
			onOpenBuyRobux()
			return
		end

		if v6 then
			v4(campaignOffer)
			return
		end

		if v5 and not (isErrorForSelectedOption or v7) or campaignOffer == nil then
			return
		end

		ref.current = campaignOffer.campaignOption
		callback2({
			paymentType = campaignOffer.fundingType,
			campaignOption = campaignOffer.campaignOption
		})
	end, {
		callback2,
		campaignOffer,
		shouldBuyRobux,
		onOpenBuyRobux,
		v5,
		isErrorForSelectedOption,
		v7,
		v6,
		v4
	})

	return {
		sheetRootRef = sheetRootRef,
		defaultOptionRef = defaultOptionRef,
		selectedOption = state,
		showCloseButton = v ~= Responsive.Input.Directional,
		isFundingCheckPending = isFundingCheckPending,
		isPrimaryActionDisabled = campaignOffer == nil or not isErrorForSelectedOption and v5 and not v7 and not (shouldBuyRobux or v6),
		shouldBuyRobux = shouldBuyRobux,
		showAdCreditsCallout = not flag and v7 and result.fundingSource == "ad_credit",
		isErrorForSelectedOption = isErrorForSelectedOption,
		onOptionChanged = onOptionChanged,
		onOpenBuyRobux = onOpenBuyRobux,
		onOpenAdsManager = onOpenAdsManager,
		onCreate = onCreate
	}
end

local function useCreateAdCampaignSheetViewModel(data)
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
	local v = React.useMemo(function()
		return creatorCreditStore.getQuotaSummary()
	end, { creatorCreditStore })
	local v2 = SignalsReact.useSignalState(v.data)
	local v3 = SignalsReact.useSignalState(v.status)

	local v4 = useOpenWebView()
	local v5 = FFlagEnablePaidAds
	local campaignOffers

	if v5 then
		campaignOffers = data.campaignOffers
		requireCampaignOffers(campaignOffers) -- inferred equivalent call
	end

	local feedback

	if campaignOffers ~= nil then
		feedback = campaignOffers.feedback
	end

	local plays

	if campaignOffers ~= nil then
		plays = campaignOffers.plays
	end

	local durationDays

	if v5 and feedback ~= nil then
		durationDays = feedback.durationDays
	else
		durationDays = data.campaignDurationDays or CreateAdCampaignSheetConfig.DEFAULT_CAMPAIGN_DURATION_DAYS
	end

	local v6

	if v5 and feedback ~= nil then
		v6 = feedback.priceRobux
	else
		v6 = data.estimatedPriceRobux or CreateAdCampaignSheetConfig.DEFAULT_ESTIMATED_PRICE_ROBUX
	end

	local runStartTimeMs

	if v5 then
		runStartTimeMs = data.runStartTimeMs
		requireCampaignValue(runStartTimeMs, "runStartTimeMs") -- inferred equivalent call
	else
		runStartTimeMs = data.runStartTimeMs or CreateAdCampaignSheetConfig.DEFAULT_RUN_START_TIME_MS
	end

	local v7

	if v5 then
		v7 = campaignEndMs(runStartTimeMs, durationDays)
	elseif data.runEndTimeMs == nil then
		v7 = CreateAdCampaignSheetConfig.DEFAULT_RUN_END_TIME_MS
	else
		v7 = data.runEndTimeMs
	end

	local v8

	if data.useLocalRunDates == true then
		v8 = LocalizationStrings.formatAdCampaignSheetLocalDate
	else
		v8 = LocalizationStrings.formatAdCampaignSheetDate
	end

	local startDate = v8(runStartTimeMs)
	local endDate = v8(v7)
	local title

	if v5 then
		title = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_TITLE
	else
		title = LocalizationStrings.AD_CAMPAIGN_SHEET_TITLE
	end

	local moderationNotice

	if v5 then
		moderationNotice = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_MODERATION_NOTICE
	else
		moderationNotice = LocalizationStrings.AD_CAMPAIGN_SHEET_MODERATION_NOTICE
	end

	local v9 = {
		title = title,
		description = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_DESCRIPTION,
			durationDays = durationDays
		},
		campaignTitle = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_CAMPAIGN_TITLE,
			durationDays = durationDays
		},
		runDates = {
			LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES,
			startDate = startDate,
			endDate = endDate
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
		moderationNotice = moderationNotice,
		createError = LocalizationStrings.AD_CAMPAIGN_SHEET_CREATE_ERROR
	}

	if v5 then
		v9.forbiddenError = LocalizationStrings.AD_CAMPAIGN_SHEET_FORBIDDEN_ERROR
		v9.insufficientFundsError = LocalizationStrings.AD_CAMPAIGN_SHEET_INSUFFICIENT_FUNDS_ERROR
		v9.internalError = LocalizationStrings.AD_CAMPAIGN_SHEET_INTERNAL_ERROR
		v9.missingThumbnailError = LocalizationStrings.AD_CAMPAIGN_SHEET_MISSING_THUMBNAIL_ERROR
		v9.introduction = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_INTRODUCTION
		v9.startCampaignTitle = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_CAMPAIGN_PICKER_TITLE

		if feedback ~= nil then
			v9.feedbackOptionTitle = {
				LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_OPTION_TITLE,
				durationDays = feedback.durationDays
			}

			v9.feedbackRunDates = {
				LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES,
				startDate = startDate,
				endDate = v8(campaignEndMs(runStartTimeMs, feedback.durationDays))
			}

			v9.feedbackDescription = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_SHORT_DESCRIPTION
		end

		if plays ~= nil then
			v9.playsOptionTitle = {
				LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_OPTION_TITLE,
				durationDays = plays.durationDays
			}

			v9.playsRunDates = {
				LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES,
				startDate = startDate,
				endDate = v8(campaignEndMs(runStartTimeMs, plays.durationDays))
			}

			v9.playsDescription = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_LONG_DESCRIPTION
		end

		v9.buyRobux = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON
		v9.adCreditsTitle = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_AD_CREDITS_TITLE
		v9.adCreditsAction = LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_AD_CREDITS_ACTION
		v9.adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER
	end

	local v10 = useLocalization(v9)

	local waitForCreateResult = data.waitForCreateResult == true
	local isCreatePending = waitForCreateResult and data.isCreatePending == true
	local hasCreateError = waitForCreateResult and data.hasCreateError == true
	local createErrorText = v10.createError

	if v5 and hasCreateError then
		local createErrorKind = data.createErrorKind

		if createErrorKind == "payment_required" then
			createErrorText = v10.insufficientFundsError
		elseif createErrorKind == "ineligible" then
			createErrorText = v10.forbiddenError
		elseif createErrorKind == "missing_thumbnail" then
			createErrorText = v10.missingThumbnailError
		else
			createErrorText = v10.internalError
		end
	end

	local onClose = React.useCallback(function()
		if isCreatePending then
			return
		end

		data.onClose()
	end, { data.onClose, isCreatePending })

	local onCreate = React.useCallback(function(p)
		data.onCreate(p)

		if not waitForCreateResult then
			onClose()
		end
	end, { data.onCreate, onClose, waitForCreateResult })
	local onAdvertisingTerms = React.useCallback(function(p: string)
		v4(CreateAdCampaignSheetConfig.ADVERTISING_TERMS_URL, p)
	end, { v4 })
	local onAdvertisingStandards = React.useCallback(function(p: string)
		v4(CreateAdCampaignSheetConfig.ADVERTISING_STANDARDS_URL, p)
	end, { v4 })
	local v11

	if FFlagEnablePaidAds then
		local v12 = React.useCallback(function()
			creatorCreditStore.refreshQuotaSummary():catch(function() end)
		end, { creatorCreditStore })

		local isOpen = data.isOpen

		local attemptedOption = data.attemptedOption
		local adsManager = v10.adsManager
		local v13

		if FFlagBuildAdsManagerUniverseUrl then
			v13 = data.universeId
		end

		v11 = useTwoOptionsControls(
			isOpen,
			onClose,
			onCreate,
			campaignOffers,
			isCreatePending,
			hasCreateError,
			v12,
			attemptedOption,
			adsManager,
			v13
		)
	end

	local balanceText, balanceState

	if v2 == nil then
		if v3 == DataStatus.Failed then
			balanceText = CreateAdCampaignSheetConfig.BALANCE_UNAVAILABLE
			balanceState = "failed"
		else
			balanceText = CreateAdCampaignSheetConfig.BALANCE_LOADING
			balanceState = "loading"
		end
	else
		balanceText = formatNumber(v2.robuxBalance) -- inferred equivalent call
		balanceState = "ready"
	end

	if not v5 then
		return {
			variant = "freeOptionOnly",
			isOpen = data.isOpen,
			title = v10.title,
			description = v10.description,
			campaignTitle = v10.campaignTitle,
			estimatedPriceText = formatNumber(v6), -- inferred equivalent call
			freeText = v10.free,
			earnedRobuxDisclaimer = v10.earnedRobuxDisclaimer,
			includedTitle = v10.includedTitle,
			benefits = {
				{ icon = IconName.Calendar, text = v10.runDates },
				{ icon = IconName.CirclePlay, text = v10.maximizePlays },
				{ icon = IconName.ThreePeople, text = v10.targetPlayers },
				{ icon = IconName.ChartScatterPlot, text = v10.performanceReport }
			},
			legalText = v10.legal,
			createText = v10.create,
			moderationNotice = v10.moderationNotice,
			balanceState = balanceState,
			balanceText = balanceText,
			isCreatePending = isCreatePending,
			hasCreateError = hasCreateError,
			createErrorText = createErrorText,
			onClose = onClose,
			onCreate = onCreate,
			onAdvertisingTerms = onAdvertisingTerms,
			onAdvertisingStandards = onAdvertisingStandards
		}
	end

	local v12 = {
		variant = "twoOptions",
		isOpen = data.isOpen,
		sheetRootRef = v11.sheetRootRef,
		title = v10.title,
		description = v10.introduction,
		startCampaignTitle = v10.startCampaignTitle,
		selectedOption = v11.selectedOption,
		defaultOptionRef = v11.defaultOptionRef,
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
	local feedbackOption

	if feedback ~= nil then
		feedbackOption = toCampaignOption(
			feedback,
			v10.feedbackOptionTitle,
			v10.feedbackRunDates,
			v10.feedbackDescription,
			v10.free
		)
	end

	v12.feedbackOption = feedbackOption
	local playsOption

	if plays ~= nil then
		playsOption = toCampaignOption(plays, v10.playsOptionTitle, v10.playsRunDates, v10.playsDescription, v10.free)
	end

	v12.playsOption = playsOption

	v12.legalText = v10.legal
	local createText

	if v11.shouldBuyRobux then
		createText = v10.buyRobux
	else
		createText = v10.create
	end

	v12.createText = createText
	v12.moderationNotice = v10.moderationNotice
	v12.isCreatePending = isCreatePending
	v12.isFundingCheckPending = v11.isFundingCheckPending
	v12.isCreateDisabled = v11.isPrimaryActionDisabled
	v12.showAdCreditsCallout = v11.showAdCreditsCallout
	v12.adCreditsTitle = v10.adCreditsTitle
	v12.adCreditsAction = v10.adCreditsAction
	v12.hasCreateError = v11.isErrorForSelectedOption
	v12.createErrorText = createErrorText
	v12.balanceState = balanceState
	v12.balanceText = balanceText
	v12.showCloseButton = v11.showCloseButton
	v12.onOptionChanged = v11.onOptionChanged
	v12.onOpenBuyRobux = v11.onOpenBuyRobux
	v12.onOpenAdsManager = v11.onOpenAdsManager
	v12.onClose = onClose
	v12.onCreate = v11.onCreate
	v12.onAdvertisingTerms = onAdvertisingTerms
	v12.onAdvertisingStandards = onAdvertisingStandards
	return v12
end

return useCreateAdCampaignSheetViewModel
