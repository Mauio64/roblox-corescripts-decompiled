local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorCredit = require(BuildExperienceParent.DataHydration.CreatorCredit)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local CreatorCreditConfig = require(BuildExperience.CreatorCreditConfig)
local useOpenBuyRobuxWebView = require(BuildExperience.Components.CreatorCreditSheet.useOpenBuyRobuxWebView)
local useRefreshCreatorCreditOnUnhide = require(BuildExperience.Components.CreatorCreditSheet.useRefreshCreatorCreditOnUnhide)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local function getQuotaBlockReason(p1) -- line: 34
	-- upvalues: CreatorCreditConfig (copy)
	if p1 == nil then
		return nil
	end

	if p1.allowed ~= nil then
		if p1.allowed then
			return nil
		end

		return p1.reason
	end

	if p1.freeTrialRemaining > 0 then
		return nil
	end

	if not p1.limitSettings.additionalUsageEnabled then
		return "FreeTrialExhausted"
	end

	if p1.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance then
		return "InsufficientRobuxBalance"
	end

	if p1.limitSettings.dailyLimitSet and p1.limitRemaining < CreatorCreditConfig.FIntMinimumUsableRobuxBalance then
		return "DailyLimitReached"
	end

	return nil
end
local function useCreatorCreditChatUpsellViewModel(t1: {[any]: any}) -- line: 59
	-- upvalues: CreatorCredit (copy), React (copy), SignalsReact (copy), CreatorCreditConfig (copy), useOpenBuyRobuxWebView (copy), useRefreshCreatorCreditOnUnhide (copy), LocalizationStrings (copy)
	local v14 = CreatorCredit.getCreatorCreditStore(false)
	local v15 = React.useMemo(function() -- line: 61
		-- upvalues: v14 (copy)
		return v14.getQuotaSummary()
	end, { v14 })
	local v16 = SignalsReact.useSignalState(v15.data)
	local v17 = if v16 == nil then nil else v16.nextResetEligibleTime
	local v18, v19 = React.useState(false)
	local v20 = t1.outOfCreditsPromptFailureCount or 0
	local v21 = React.useRef(v20)
	local v22 = React.useRef(0)
	local v23, v24 = React.useState(nil)
	local v25 = React.useCallback(function() -- line: 73
		-- upvalues: v22 (copy), v14 (copy), v24 (copy), CreatorCreditConfig (copy)
		local current = v22.current

		v14.refreshQuotaSummary():andThen(function(p2) -- line: 77
			-- upvalues: current (copy), v22 (copy), v24 (copy), CreatorCreditConfig (copy)
			if p2 ~= nil and current == v22.current then
				v24(if p2 ~= nil then if p2.allowed == nil then if not (p2.freeTrialRemaining > 0) then if p2.limitSettings.additionalUsageEnabled then if not (p2.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance) then if not p2.limitSettings.dailyLimitSet or not (p2.limitRemaining < CreatorCreditConfig.FIntMinimumUsableRobuxBalance) then nil else "DailyLimitReached" else "InsufficientRobuxBalance" else "FreeTrialExhausted" else nil else if not p2.allowed then p2.reason else nil else nil)
			end
		end):catch(function() -- line: 82
		end)
	end, { v14 })

	React.useEffect(function() -- line: 84
		-- upvalues: v20 (copy), v21 (copy), v22 (copy), v24 (copy), t1 (copy), v19 (copy), v25 (copy)
		if v20 > v21.current then
			local v37 = v22

			v37.current = v37.current + 1
			v24(t1.outOfCreditsPromptFailureReason)
			v19(false)
			v25()
		end

		v21.current = v20
	end, {
		v20,
		t1.outOfCreditsPromptFailureReason,
		v25
	})

	local v26 = React.useRef(t1.isAssistantResponding)

	React.useEffect(function() -- line: 95
		-- upvalues: v26 (copy), t1 (copy), CreatorCreditConfig (copy), v25 (copy)
		local v38 = v26.current and not t1.isAssistantResponding

		v26.current = t1.isAssistantResponding

		if not v38 then
			return
		end

		local thread = task.delay(CreatorCreditConfig.FIntPostTurnRefreshDelaySeconds, v25)

		return function() -- line: 102
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		t1.isAssistantResponding,
		v25
	})
	React.useEffect(function() -- line: 107
		-- upvalues: v17 (copy), CreatorCreditConfig (copy), v25 (copy)
		if v17 == nil or v17 == "" then
			return
		end

		local dateTime = DateTime.fromIsoDate(v17)

		if dateTime == nil then
			return
		end

		local v41 = math.max(1, dateTime.UnixTimestamp - DateTime.now().UnixTimestamp + CreatorCreditConfig.FIntResetRefreshBufferSeconds)
		local thread = task.delay(v41, v25)

		return function() -- line: 122
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v17,
		v25
	})

	local v27 = React.useCallback(function() -- line: 127
		-- upvalues: v25 (copy), v19 (copy)
		v25()
		v19(true)
	end, { v25 })
	local v28 = useOpenBuyRobuxWebView(v27)

	useRefreshCreatorCreditOnUnhide(v25)

	local v29 = React.useCallback(function() -- line: 134
		-- upvalues: v19 (copy), t1 (copy)
		v19(true)

		if t1.onOpenCreatorCreditPage then
			t1.onOpenCreatorCreditPage()
		end
	end, { t1.onOpenCreatorCreditPage })
	local v30 = React.useCallback(function() -- line: 140
		-- upvalues: v19 (copy)
		v19(true)
	end, {})
	local v31 = v23 or if v16 ~= nil then if v16.allowed == nil then if not (v16.freeTrialRemaining > 0) then if v16.limitSettings.additionalUsageEnabled then if not (v16.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance) then if not v16.limitSettings.dailyLimitSet or not (v16.limitRemaining < CreatorCreditConfig.FIntMinimumUsableRobuxBalance) then nil else "DailyLimitReached" else "InsufficientRobuxBalance" else "FreeTrialExhausted" else nil else if not v16.allowed then v16.reason else nil else nil
	local CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE = LocalizationStrings.CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE
	local CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION = LocalizationStrings.CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION
	local CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM
	local CREATOR_CREDIT_VIEW_USAGE_BUTTON = LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON

	if v31 == "FreeTrialExhausted" then
		CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE = LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_TITLE
		CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION = LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_DESCRIPTION
		CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM = LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON
		v28 = v29
		CREATOR_CREDIT_VIEW_USAGE_BUTTON = LocalizationStrings.CREATOR_CREDIT_NOT_NOW_BUTTON
		v29 = v30
	elseif v31 == "DailyLimitReached" then
		CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE = LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_TITLE
		CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION = LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_DESCRIPTION
		CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM = LocalizationStrings.CREATOR_CREDIT_ADJUST_LIMIT_BUTTON
		v28 = v29
		CREATOR_CREDIT_VIEW_USAGE_BUTTON = LocalizationStrings.CREATOR_CREDIT_NOT_NOW_BUTTON
		v29 = v30
	end

	return {
		showBuyMoreRobuxCard = v31 ~= nil and (not v18 and t1.onOpenCreatorCreditPage ~= nil),
		buyMoreRobuxCardTitle = CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE,
		buyMoreRobuxCardDescription = CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION,
		buyMoreRobuxCardPrimaryActionText = CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM,
		onBuyMoreRobuxCardPrimaryAction = v28,
		buyMoreRobuxCardSecondaryActionText = CREATOR_CREDIT_VIEW_USAGE_BUTTON,
		onBuyMoreRobuxCardSecondaryAction = v29
	}
end

return useCreatorCreditChatUpsellViewModel
