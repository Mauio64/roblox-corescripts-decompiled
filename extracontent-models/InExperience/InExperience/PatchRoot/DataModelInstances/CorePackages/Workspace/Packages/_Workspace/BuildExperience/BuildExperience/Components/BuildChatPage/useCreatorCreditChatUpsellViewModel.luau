local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local NumberLocalization = Localization.NumberLocalization

local CreatorCreditConfig = require(BuildExperience.CreatorCreditConfig)
local useOpenBuyRobuxWebView = require(BuildExperience.Components.CreatorCreditSheet.useOpenBuyRobuxWebView)

local useRefreshCreatorCreditOnUnhide = require(BuildExperience.Components.CreatorCreditSheet.useRefreshCreatorCreditOnUnhide)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildExperienceFreeLimitCard = require(BuildExperience.Flags.FFlagBuildExperienceFreeLimitCard)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local GetBuildCreatorCreditRefreshStore = require(BuildExperience.Stores.GetBuildCreatorCreditRefreshStore)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local function formatRobux(p: number) -- 1 equivalent call inferred from this helper
	return NumberLocalization.localize(string.format("%.0f", (math.floor(p))), LocalizationService.RobloxLocaleId)
end

local function getQuotaBlockReason(data)
	if data == nil then
		return nil
	end

	if FFlagBuildExperienceModelPicker then
		return if data.allowed == false then data.reason else nil
	elseif data.allowed == nil then
		if data.freeTrialRemaining > 0 then
			return nil
		end

		if not data.limitSettings.additionalUsageEnabled then
			return "FreeTrialExhausted"
		end

		if data.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance then
			return "InsufficientRobuxBalance"
		end

		if
			data.limitSettings.dailyLimitSet
			and data.limitRemaining < CreatorCreditConfig.FIntMinimumUsableRobuxBalance
		then
			return "DailyLimitReached"
		end

		return nil
	else
		return if not data.allowed then data.reason else nil
	end
end

local function useCreatorCreditChatUpsellViewModel(data)
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
	local v

	if FFlagBuildExperienceModelPicker then
		v = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)
	end

	local useMemo = React.useMemo
	local function fn()
		if FFlagBuildExperienceModelPicker then
			return assert(creatorCreditStore.getTierQuotaSummary, "Model picker requires tier quotas")(
				"PRODUCT_BUILD",
				data.namedTier or "default"
			)
		end

		return creatorCreditStore.getQuotaSummary()
	end

	local v2

	if FFlagBuildExperienceModelPicker then
		v2 = data.namedTier
	end

	local v3 = useMemo(fn, { creatorCreditStore, v2, v })
	local v4 = SignalsReact.useSignalState(v3.data)
	local nextResetEligibleTime

	if v4 == nil then
		nextResetEligibleTime = nil
	else
		nextResetEligibleTime = v4.nextResetEligibleTime
	end

	local v5 = nil

	if FFlagBuildExperienceModelPicker and v4 ~= nil and v4.blockDetails ~= nil then
		local requiredRobux = v4.blockDetails.requiredRobux

		if requiredRobux ~= nil and requiredRobux > 0 then
			v5 = requiredRobux
		end
	end

	local v6 = {
		adjustLimit = LocalizationStrings.CREATOR_CREDIT_ADJUST_LIMIT_BUTTON,
		buyMoreDescription = LocalizationStrings.CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION,
		buyMoreTitle = LocalizationStrings.CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE,
		buyRobux = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM,
		modelBuyRobux = 0,
		insufficientTitle = 0,
		insufficientDescription = 0,
		dailyLimitDescription = 0,
		dailyLimitTitle = 0,
		freeTrialDescription = 0,
		freeTrialTitle = 0,
		freeTrialAction = 0,
		notNow = 0,
		viewUsage = 0
	}
	local modelBuyRobux

	if v5 ~= nil then
		modelBuyRobux = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON
	end

	v6.modelBuyRobux = modelBuyRobux
	local insufficientTitle

	if v5 ~= nil then
		insufficientTitle = LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_TITLE
	end

	v6.insufficientTitle = insufficientTitle
	local insufficientDescription

	if v5 ~= nil then
		insufficientDescription = { [1] = nil, nil }
		local v7

		if data.namedTier == "advanced" then
			v7 = LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_ADVANCED_AMOUNT_DESCRIPTION
		else
			v7 = LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_DEFAULT_AMOUNT_DESCRIPTION
		end

		insufficientDescription[1] = v7
		insufficientDescription.ROBUX = formatRobux(v5) -- inferred equivalent call
	end

	v6.insufficientDescription = insufficientDescription

	v6.dailyLimitDescription = LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_DESCRIPTION
	v6.dailyLimitTitle = LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_TITLE
	local freeTrialDescription

	if FFlagBuildExperienceFreeLimitCard then
		freeTrialDescription = LocalizationStrings.CREATOR_CREDIT_FREE_LIMIT_REACHED_DESCRIPTION
	else
		freeTrialDescription = LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_DESCRIPTION
	end

	v6.freeTrialDescription = freeTrialDescription
	local freeTrialTitle

	if FFlagBuildExperienceFreeLimitCard then
		freeTrialTitle = LocalizationStrings.CREATOR_CREDIT_FREE_LIMIT_REACHED_TITLE
	else
		freeTrialTitle = LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_TITLE
	end

	v6.freeTrialTitle = freeTrialTitle
	local freeTrialAction

	if FFlagBuildExperienceFreeLimitCard then
		freeTrialAction = LocalizationStrings.CREATOR_CREDIT_MANAGE_USAGE_BUTTON
	else
		freeTrialAction = LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON
	end

	v6.freeTrialAction = freeTrialAction

	v6.notNow = LocalizationStrings.CREATOR_CREDIT_NOT_NOW_BUTTON
	v6.viewUsage = LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON
	local v7 = useLocalization(v6)

	local state, setState = React.useState(false)
	local outOfCreditsPromptFailureCount = data.outOfCreditsPromptFailureCount or 0
	local ref = React.useRef(outOfCreditsPromptFailureCount)
	local ref2 = React.useRef(0)

	local state2, setState2 = React.useState(nil)
	local ref3

	if FFlagBuildExperienceModelPicker then
		ref3 = React.useRef(v4)
	else
		ref3 = nil
	end

	local useCallback = React.useCallback
	local function fn2()
		local current = ref2.current

		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).refresh()
		else
			creatorCreditStore.refreshQuotaSummary():andThen(function(p)
				if p ~= nil and current == ref2.current then
					setState2(getQuotaBlockReason(p))
				end
			end):catch(function() end)
		end
	end

	local v8

	if FFlagBuildExperienceModelPicker then
		v8 = data.namedTier
	end

	local v9 = useCallback(fn2, { creatorCreditStore, v8 })

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			setState2(nil)
			return function()
				ref2.current += 1
			end
		end, { v, data.namedTier })
	end

	local useEffect = React.useEffect
	local function fn3()
		if outOfCreditsPromptFailureCount > ref.current then
			ref2.current += 1

			if ref3 then
				ref3.current = v3.data(false)
			end

			setState2(data.outOfCreditsPromptFailureReason)
			setState(false)
			v9()
		end

		ref.current = outOfCreditsPromptFailureCount
	end

	local outOfCreditsPromptFailureReason = data.outOfCreditsPromptFailureReason
	local v10

	if FFlagBuildExperienceModelPicker then
		v10 = v3
	end

	useEffect(fn3, { outOfCreditsPromptFailureCount, outOfCreditsPromptFailureReason, v9, v10 })

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			if ref3 and v4 ~= ref3.current and v3.status(false) == "Ready" then
				setState2(nil)
			end
		end, { v4, v3 })
	end

	local ref4 = React.useRef(data.isAssistantResponding)
	React.useEffect(function()
		if FFlagBuildExperienceModelPicker then
			return
		end

		local v11 = ref4.current and not data.isAssistantResponding
		ref4.current = data.isAssistantResponding

		if not v11 then
			return
		end

		local thread = task.delay(CreatorCreditConfig.FIntPostTurnRefreshDelaySeconds, v9)
		return function()
			task.cancel(thread)
		end
	end, { data.isAssistantResponding, v9 })

	React.useEffect(function()
		if FFlagBuildExperienceModelPicker or (nextResetEligibleTime == nil or nextResetEligibleTime == "") then
			return
		end

		local dateTime = DateTime.fromIsoDate(nextResetEligibleTime)

		if dateTime == nil then
			return
		end

		local v11 = math.max(
			1,
			dateTime.UnixTimestamp - DateTime.now().UnixTimestamp + CreatorCreditConfig.FIntResetRefreshBufferSeconds
		)

		local thread = task.delay(v11, v9)
		return function()
			task.cancel(thread)
		end
	end, { nextResetEligibleTime, v9 })

	local v11 = useOpenBuyRobuxWebView((React.useCallback(function()
		v9()
		setState(true)
	end, { v9 })))

	if not FFlagBuildExperienceModelPicker then
		useRefreshCreatorCreditOnUnhide(v9)
	end

	local onBuyMoreRobuxCardPrimaryAction = React.useCallback(function()
		setState(true)

		if data.onOpenCreatorCreditPage then
			data.onOpenCreatorCreditPage()
		end
	end, { data.onOpenCreatorCreditPage })
	local onBuyMoreRobuxCardSecondaryAction = React.useCallback(function()
		setState(true)
	end, {})

	local v12 = state2 or getQuotaBlockReason(v4)

	local buyMoreRobuxCardTitle = v7.buyMoreTitle
	local buyMoreRobuxCardDescription = v7.buyMoreDescription
	local buyMoreRobuxCardPrimaryActionText = v7.buyRobux
	local buyMoreRobuxCardSecondaryActionText = v7.viewUsage

	if v12 == "FreeTrialExhausted" then
		buyMoreRobuxCardTitle = v7.freeTrialTitle
		buyMoreRobuxCardDescription = v7.freeTrialDescription
		buyMoreRobuxCardPrimaryActionText = v7.freeTrialAction
		buyMoreRobuxCardSecondaryActionText = v7.notNow
	elseif v12 == "DailyLimitReached" then
		buyMoreRobuxCardTitle = v7.dailyLimitTitle
		buyMoreRobuxCardDescription = v7.dailyLimitDescription
		buyMoreRobuxCardPrimaryActionText = v7.adjustLimit
		buyMoreRobuxCardSecondaryActionText = v7.notNow
	else
		if v12 == "InsufficientRobuxBalance" and v5 ~= nil then
			buyMoreRobuxCardTitle = v7.insufficientTitle
			buyMoreRobuxCardDescription = v7.insufficientDescription
			buyMoreRobuxCardPrimaryActionText = v7.modelBuyRobux
			buyMoreRobuxCardSecondaryActionText = v7.notNow
		else
			onBuyMoreRobuxCardSecondaryAction = onBuyMoreRobuxCardPrimaryAction
		end

		onBuyMoreRobuxCardPrimaryAction = v11
	end

	return {
		showBuyMoreRobuxCard = v12 ~= nil and not state and data.onOpenCreatorCreditPage ~= nil,
		buyMoreRobuxCardTitle = buyMoreRobuxCardTitle,
		buyMoreRobuxCardDescription = buyMoreRobuxCardDescription,
		buyMoreRobuxCardPrimaryActionText = buyMoreRobuxCardPrimaryActionText,
		onBuyMoreRobuxCardPrimaryAction = onBuyMoreRobuxCardPrimaryAction,
		buyMoreRobuxCardSecondaryActionText = buyMoreRobuxCardSecondaryActionText,
		onBuyMoreRobuxCardSecondaryAction = onBuyMoreRobuxCardSecondaryAction
	}
end

return useCreatorCreditChatUpsellViewModel
