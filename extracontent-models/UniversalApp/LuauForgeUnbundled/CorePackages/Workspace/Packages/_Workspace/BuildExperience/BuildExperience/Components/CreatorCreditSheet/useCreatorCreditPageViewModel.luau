local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local CreatorCredit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local CreatorCreditConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/CreatorCreditConfig")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditPageView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/DailyLimitBottomSheet")
local getHoursUntilReset = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/getHoursUntilReset")
local useOpenBuyRobuxWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useOpenBuyRobuxWebView")
local useRefreshCreatorCreditOnUnhide = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useRefreshCreatorCreditOnUnhide")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local GetBuildCreatorCreditRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildCreatorCreditRefreshStore")

local dataStatus = DataHydration.DataStatus

local function useCreatorCreditPageViewModel()
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)

	local v5 = React.useMemo(function()
		return creatorCreditStore.getQuotaSummary()
	end, { creatorCreditStore })
	local v6 = React.useMemo(function()
		return creatorCreditStore.getDailyLimit()
	end, { creatorCreditStore })
	local v7 = SignalsReact.useSignalState(v5.data)
	local v8 = SignalsReact.useSignalState(v6.data)
	local v9 = SignalsReact.useSignalState(v6.status)
	local v10 = if v8 then v8 elseif v7 then v7.limitSettings else nil
	local v11 = not v7 and 0 or v7.robuxBalance
	local v12 = not v7 and 0 or v7.robuxSpentToday
	local v13 = if v10 then v10.additionalUsageEnabled else false
	local dailyLimit = if v10 and v10.dailyLimitSet then v10.dailyLimit else nil
	local v14 = v10 ~= nil
	local v15 = v9 == dataStatus.Ready and v8 ~= nil

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local ref = React.useRef(0)

	local v16 = React.useCallback(function()
		ref.current += 1
		setState2(true)
		setState3(false)
		return ref.current
	end, {})
	local v17 = React.useCallback(function(p2, p3)
		if ref.current ~= p2 then
			return
		end

		setState2(false)
		setState3(p3)
	end, {})

	local v18 = React.useCallback(function(p2)
		if not v15 or state2 or v10 == nil then
			return
		end

		local v19 = v16()

		creatorCreditStore.setDailyLimit({
			additionalUsageEnabled = p2,
			dailyLimitSet = v10.dailyLimitSet,
			dailyLimit = v10.dailyLimit
		}):andThen(function()
			v17(v19, false)
		end):catch(function()
			v17(v19, true)
		end)
	end, { v16, creatorCreditStore, v17, state2, v10, v15 })
	local v19 = React.useCallback(function()
		if v15 and not state2 then
			setState3(false)
			setState(true)
		end
	end, { state2, v15 })
	local v20 = React.useCallback(function(value)
		if not v15 or state2 or v10 == nil then
			return
		end

		local v21 = v16()

		creatorCreditStore.setDailyLimit({
			additionalUsageEnabled = v10.additionalUsageEnabled,
			dailyLimitSet = value ~= nil,
			dailyLimit = value or 0
		}):andThen(function()
			if ref.current == v21 then
				v17(v21, false)
				setState(false)
			end
		end):catch(function()
			v17(v21, true)
		end)
	end, { v16, creatorCreditStore, v17, state2, v10, v15 })
	local v21 = React.useCallback(function()
		setState(false)
	end, {})
	local v22 = React.useCallback(function()
		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).refresh()
		else
			creatorCreditStore.refreshQuotaSummary():catch(function() end)
		end
	end, { creatorCreditStore })
	local v23 = useOpenBuyRobuxWebView(v22)

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			return GetBuildCreatorCreditRefreshStore(false).acquire()
		end, {})
	else
		useRefreshCreatorCreditOnUnhide(v22)
	end

	local v25 = {
		dailyPctUsed = not v7 and 0 or v7.freeTrialPctUsed,
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
	local v26 = if v7 then getHoursUntilReset(v7.nextResetEligibleTime) else nil
	v25.resetHours = v26
	local v27 = if v7 then v7.freeTrialResetPeriod else nil
	v25.resetPeriod = v27
	v25.additionalEnabled = v13
	v25.dailyLimit = dailyLimit
	v25.hasLimitConfigured = v14
	v25.additionalUsed = v12
	v25.robuxAvailable = v11
	v25.settingsDisabled = not v15 or state2
	v25.settingsError = state3 or v9 == dataStatus.Failed
	v25.showBuyRobux = v7 ~= nil
		and v7.freeTrialRemaining <= 0
		and v7.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance
	v25.onToggleAdditional = v18
	v25.onOpenLimitSheet = v19
	v25.onOpenBuyRobux = v23
	return {
		pageProps = v25,
		limitSheetProps = {
			isOpen = state,
			initialValue = dailyLimit,
			initialIsNoLimit = v14 and dailyLimit == nil,
			additionalUsed = v12,
			isSaving = state2,
			saveError = state3,
			onConfirm = v20,
			onCancel = v21
		}
	}
end

return useCreatorCreditPageViewModel
