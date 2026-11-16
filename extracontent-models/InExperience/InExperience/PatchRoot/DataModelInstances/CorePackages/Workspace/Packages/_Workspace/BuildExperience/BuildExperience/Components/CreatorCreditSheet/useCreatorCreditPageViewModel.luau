local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local CreatorCreditConfig = require(BuildExperience.CreatorCreditConfig)
require(script.Parent.CreatorCreditPageView)
require(script.Parent.DailyLimitBottomSheet)
local getHoursUntilReset = require(script.Parent.getHoursUntilReset)
local useOpenBuyRobuxWebView = require(script.Parent.useOpenBuyRobuxWebView)
local useRefreshCreatorCreditOnUnhide = require(script.Parent.useRefreshCreatorCreditOnUnhide)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local GetBuildCreatorCreditRefreshStore = require(BuildExperience.Stores.GetBuildCreatorCreditRefreshStore)

local DataStatus = DataHydration.DataStatus

local function useCreatorCreditPageViewModel()
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)

	local v = React.useMemo(function()
		return creatorCreditStore.getQuotaSummary()
	end, { creatorCreditStore })
	local v2 = React.useMemo(function()
		return creatorCreditStore.getDailyLimit()
	end, { creatorCreditStore })
	local v3 = SignalsReact.useSignalState(v.data)
	local v4 = SignalsReact.useSignalState(v2.data)
	local v5 = SignalsReact.useSignalState(v2.status)
	local v6

	if v4 then
		v6 = v4
	else
		v6 = if v3 then v3.limitSettings else nil
	end

	local robuxAvailable = not v3 and 0 or v3.robuxBalance
	local additionalUsed = not v3 and 0 or v3.robuxSpentToday
	local additionalEnabled

	if v6 then
		additionalEnabled = v6.additionalUsageEnabled
	else
		additionalEnabled = false
	end

	local dailyLimit

	if v6 and v6.dailyLimitSet then
		dailyLimit = v6.dailyLimit
	end

	local hasLimitConfigured = v6 ~= nil
	local v7

	if v5 == DataStatus.Ready then
		v7 = v4 ~= nil
	else
		v7 = false
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local ref = React.useRef(0)

	local v8 = React.useCallback(function()
		ref.current += 1
		setState2(true)
		setState3(false)
		return ref.current
	end, {})
	local v9 = React.useCallback(function(p: number, flag: boolean)
		if ref.current ~= p then
			return
		end

		setState2(false)
		setState3(flag)
	end, {})

	local onToggleAdditional = React.useCallback(function(additionalUsageEnabled: boolean)
		if not v7 or state2 or v6 == nil then
			return
		end

		local v10 = v8()

		creatorCreditStore.setDailyLimit({
			additionalUsageEnabled = additionalUsageEnabled,
			dailyLimitSet = v6.dailyLimitSet,
			dailyLimit = v6.dailyLimit
		}):andThen(function()
			v9(v10, false)
		end):catch(function()
			v9(v10, true)
		end)
	end, { v8, creatorCreditStore, v9, state2, v6, v7 })
	local onOpenLimitSheet = React.useCallback(function()
		if v7 and not state2 then
			setState3(false)
			setState(true)
		end
	end, { state2, v7 })
	local onConfirm = React.useCallback(function(value: number?)
		if not v7 or state2 or v6 == nil then
			return
		end

		local v10 = v8()

		creatorCreditStore.setDailyLimit({
			additionalUsageEnabled = v6.additionalUsageEnabled,
			dailyLimitSet = value ~= nil,
			dailyLimit = value or 0
		}):andThen(function()
			if ref.current == v10 then
				v9(v10, false)
				setState(false)
			end
		end):catch(function()
			v9(v10, true)
		end)
	end, { v8, creatorCreditStore, v9, state2, v6, v7 })
	local onCancel = React.useCallback(function()
		setState(false)
	end, {})
	local v10 = React.useCallback(function()
		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).refresh()
		else
			creatorCreditStore.refreshQuotaSummary():catch(function() end)
		end
	end, { creatorCreditStore })
	local onOpenBuyRobux = useOpenBuyRobuxWebView(v10)

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			return GetBuildCreatorCreditRefreshStore(false).acquire()
		end, {})
	else
		useRefreshCreatorCreditOnUnhide(v10)
	end

	local pageProps = {
		dailyPctUsed = not v3 and 0 or v3.freeTrialPctUsed,
		resetHours = 0,
		resetPeriod = 0,
		additionalEnabled = 0,
		dailyLimit = 0,
		hasLimitConfigured = 0,
		additionalUsed = 0,
		robuxAvailable = 0,
		settingsDisabled = 0,
		settingsError = 0,
		showBuyRobux = 0,
		onToggleAdditional = 0,
		onOpenLimitSheet = 0,
		onOpenBuyRobux = 0
	}
	local resetHours

	if v3 then
		resetHours = getHoursUntilReset(v3.nextResetEligibleTime)
	end

	pageProps.resetHours = resetHours
	local resetPeriod

	if v3 then
		resetPeriod = v3.freeTrialResetPeriod
	end

	pageProps.resetPeriod = resetPeriod
	pageProps.additionalEnabled = additionalEnabled
	pageProps.dailyLimit = dailyLimit
	pageProps.hasLimitConfigured = hasLimitConfigured
	pageProps.additionalUsed = additionalUsed
	pageProps.robuxAvailable = robuxAvailable
	pageProps.settingsDisabled = not v7 or state2
	pageProps.settingsError = state3 or v5 == DataStatus.Failed
	pageProps.showBuyRobux = v3 ~= nil
		and v3.freeTrialRemaining <= 0
		and v3.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance
	pageProps.onToggleAdditional = onToggleAdditional
	pageProps.onOpenLimitSheet = onOpenLimitSheet
	pageProps.onOpenBuyRobux = onOpenBuyRobux
	return {
		pageProps = pageProps,
		limitSheetProps = {
			isOpen = state,
			initialValue = dailyLimit,
			initialIsNoLimit = hasLimitConfigured and dailyLimit == nil,
			additionalUsed = additionalUsed,
			isSaving = state2,
			saveError = state3,
			onConfirm = onConfirm,
			onCancel = onCancel
		}
	}
end

return useCreatorCreditPageViewModel
