local LocalizationService = game:GetService("LocalizationService")

local CreatorCredit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local useLocalization = Localization.Hooks.useLocalization
local numberLocalization = Localization.NumberLocalization

local CreatorCreditConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/CreatorCreditConfig")
local useOpenBuyRobuxWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useOpenBuyRobuxWebView")

local useRefreshCreatorCreditOnUnhide = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useRefreshCreatorCreditOnUnhide")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildExperienceFreeLimitCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFreeLimitCard")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local GetBuildCreatorCreditRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildCreatorCreditRefreshStore")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore

local function formatRobux(p2)
	return numberLocalization.localize(
		string.format("%.0f", (math.floor(p2))),
		LocalizationService.RobloxLocaleId
	)
end

local function getQuotaBlockReason(data)
	if data == nil then
		return nil
	end

	if FFlagBuildExperienceModelPicker then
		if data.allowed == false then
			return data.reason
		end

		return nil
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
	elseif data.allowed then
		return nil
	else
		return data.reason
	end
end

local function useCreatorCreditChatUpsellViewModel(data)
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)

	local v5 = if FFlagBuildExperienceModelPicker then SignalsReact.useSignalState(localUserIdStore.getCurrentUserId) else nil

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
	local v7 = if FFlagBuildExperienceModelPicker then data.namedTier else nil
	local v8 = useMemo(fn, { creatorCreditStore, v7, v5 })
	local v9 = SignalsReact.useSignalState(v8.data)
	local nextResetEligibleTime = if v9 ~= nil then v9.nextResetEligibleTime else nil

	local v10 = nil

	if FFlagBuildExperienceModelPicker and v9 ~= nil and v9.blockDetails ~= nil then
		local requiredRobux = v9.blockDetails.requiredRobux

		if requiredRobux ~= nil and requiredRobux > 0 then
			v10 = requiredRobux
		end
	end

	local v12 = {
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
	local v13 = if v10 ~= nil then LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON else nil
	v12.modelBuyRobux = v13

	local v14 = if v10 ~= nil then LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_TITLE else nil
	v12.insufficientTitle = v14
	local v15

	if v10 ~= nil then
		v15 = { [1] = nil, nil }
		v15[1] = if data.namedTier == "advanced" then LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_ADVANCED_AMOUNT_DESCRIPTION else LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_DEFAULT_AMOUNT_DESCRIPTION
		v15.ROBUX = numberLocalization.localize(
			string.format("%.0f", ((math.floor)(v10))),
			LocalizationService.RobloxLocaleId
		)
	end

	v12.insufficientDescription = v15

	v12.dailyLimitDescription = LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_DESCRIPTION
	v12.dailyLimitTitle = LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_TITLE

	local v16 = if FFlagBuildExperienceFreeLimitCard then LocalizationStrings.CREATOR_CREDIT_FREE_LIMIT_REACHED_DESCRIPTION else LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_DESCRIPTION
	v12.freeTrialDescription = v16

	local v17 = if FFlagBuildExperienceFreeLimitCard then LocalizationStrings.CREATOR_CREDIT_FREE_LIMIT_REACHED_TITLE else LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_TITLE
	v12.freeTrialTitle = v17

	local v18 = if FFlagBuildExperienceFreeLimitCard then LocalizationStrings.CREATOR_CREDIT_MANAGE_USAGE_BUTTON else LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON
	v12.freeTrialAction = v18

	v12.notNow = LocalizationStrings.CREATOR_CREDIT_NOT_NOW_BUTTON
	v12.viewUsage = LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON
	local v19 = useLocalization(v12)

	local state, setState = React.useState(false)
	local outOfCreditsPromptFailureCount = data.outOfCreditsPromptFailureCount or 0
	local ref = React.useRef(outOfCreditsPromptFailureCount)
	local ref2 = React.useRef(0)

	local state2, setState2 = React.useState(nil)
	local ref3 = if FFlagBuildExperienceModelPicker then React.useRef(v9) else nil
	local useCallback = React.useCallback
	local function fn2()
		local current = ref2.current

		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).refresh()
		else
			creatorCreditStore.refreshQuotaSummary():andThen(function(p2)
				if p2 ~= nil and current == ref2.current then
					setState2(getQuotaBlockReason(p2))
				end
			end):catch(function() end)
		end
	end
	local v21 = if FFlagBuildExperienceModelPicker then data.namedTier else nil
	local v22 = useCallback(fn2, { creatorCreditStore, v21 })

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			setState2(nil)
			return function()
				ref2.current += 1
			end
		end, { v5, data.namedTier })
	end

	local function fn3()
		if outOfCreditsPromptFailureCount > ref.current then
			ref2.current += 1

			if ref3 then
				ref3.current = v8.data(false)
			end

			setState2(data.outOfCreditsPromptFailureReason)
			setState(false)
			v22()
		end

		ref.current = outOfCreditsPromptFailureCount
	end

	React.useEffect(fn3, {
		outOfCreditsPromptFailureCount,
		data.outOfCreditsPromptFailureReason,
		v22,
		if FFlagBuildExperienceModelPicker then v8 else nil
	})

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			if ref3 and v9 ~= ref3.current and v8.status(false) == "Ready" then
				setState2(nil)
			end
		end, { v9, v8 })
	end

	local ref4 = React.useRef(data.isAssistantResponding)
	React.useEffect(function()
		if FFlagBuildExperienceModelPicker then
			return
		end

		local v25 = ref4.current and not data.isAssistantResponding
		ref4.current = data.isAssistantResponding

		if not v25 then
			return
		end

		local thread = task.delay(CreatorCreditConfig.FIntPostTurnRefreshDelaySeconds, v22)
		return function()
			task.cancel(thread)
		end
	end, { data.isAssistantResponding, v22 })

	React.useEffect(function()
		if FFlagBuildExperienceModelPicker or (nextResetEligibleTime == nil or nextResetEligibleTime == "") then
			return
		end

		local dateTime = DateTime.fromIsoDate(nextResetEligibleTime)

		if dateTime == nil then
			return
		end

		local v25 = math.max(
			1,
			dateTime.UnixTimestamp - DateTime.now().UnixTimestamp + CreatorCreditConfig.FIntResetRefreshBufferSeconds
		)

		local thread = task.delay(v25, v22)
		return function()
			task.cancel(thread)
		end
	end, { nextResetEligibleTime, v22 })

	local v26 = useOpenBuyRobuxWebView((React.useCallback(function()
		v22()
		setState(true)
	end, { v22 })))

	if not FFlagBuildExperienceModelPicker then
		useRefreshCreatorCreditOnUnhide(v22)
	end

	local v27 = React.useCallback(function()
		setState(true)

		if data.onOpenCreatorCreditPage then
			data.onOpenCreatorCreditPage()
		end
	end, { data.onOpenCreatorCreditPage })
	local v28 = React.useCallback(function()
		setState(true)
	end, {})

	local v29 = state2 or getQuotaBlockReason(v9)

	local v30 = v19.buyMoreTitle
	local v31 = v19.buyMoreDescription
	local v32 = v19.buyRobux
	local v33 = v19.viewUsage

	if v29 == "FreeTrialExhausted" then
		v30 = v19.freeTrialTitle
		v31 = v19.freeTrialDescription
		v32 = v19.freeTrialAction
		v33 = v19.notNow
	elseif v29 == "DailyLimitReached" then
		v30 = v19.dailyLimitTitle
		v31 = v19.dailyLimitDescription
		v32 = v19.adjustLimit
		v33 = v19.notNow
	else
		if v29 == "InsufficientRobuxBalance" and v10 ~= nil then
			v30 = v19.insufficientTitle
			v31 = v19.insufficientDescription
			v32 = v19.modelBuyRobux
			v33 = v19.notNow
		else
			v28 = v27
		end

		v27 = v26
	end

	return {
		showBuyMoreRobuxCard = v29 ~= nil and not state and data.onOpenCreatorCreditPage ~= nil,
		buyMoreRobuxCardTitle = v30,
		buyMoreRobuxCardDescription = v31,
		buyMoreRobuxCardPrimaryActionText = v32,
		onBuyMoreRobuxCardPrimaryAction = v27,
		buyMoreRobuxCardSecondaryActionText = v33,
		onBuyMoreRobuxCardSecondaryAction = v28
	}
end

return useCreatorCreditChatUpsellViewModel
