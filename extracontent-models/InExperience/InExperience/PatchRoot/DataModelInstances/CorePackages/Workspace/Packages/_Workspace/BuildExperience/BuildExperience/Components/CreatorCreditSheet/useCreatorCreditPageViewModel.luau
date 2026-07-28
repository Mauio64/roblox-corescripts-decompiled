local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local CreatorCredit = require(BuildExperienceParent.DataHydration.CreatorCredit)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local CreatorCreditConfig = require(BuildExperience.CreatorCreditConfig)

require(script.Parent.CreatorCreditPageView)
require(script.Parent.DailyLimitBottomSheet)

local getHoursUntilReset = require(script.Parent.getHoursUntilReset)
local useOpenBuyRobuxWebView = require(script.Parent.useOpenBuyRobuxWebView)
local useRefreshCreatorCreditOnUnhide = require(script.Parent.useRefreshCreatorCreditOnUnhide)
local DataStatus = DataHydration.DataStatus

local function useCreatorCreditPageViewModel() -- line: 25
	-- upvalues: CreatorCredit (copy), React (copy), SignalsReact (copy), DataStatus (copy), useOpenBuyRobuxWebView (copy), useRefreshCreatorCreditOnUnhide (copy), getHoursUntilReset (copy), CreatorCreditConfig (copy)
	local v13 = CreatorCredit.getCreatorCreditStore(false)
	local v14 = React.useMemo(function() -- line: 28
		-- upvalues: v13 (copy)
		return v13.getQuotaSummary()
	end, { v13 })
	local v15 = React.useMemo(function() -- line: 31
		-- upvalues: v13 (copy)
		return v13.getDailyLimit()
	end, { v13 })
	local v16 = SignalsReact.useSignalState(v14.data)
	local v17 = SignalsReact.useSignalState(v15.data)
	local v18 = SignalsReact.useSignalState(v15.status)
	local v19 = v17 or if not v16 then nil else v16.limitSettings
	local v20 = not v16 and 0 or v16.robuxBalance
	local v21 = not v16 and 0 or v16.robuxSpentToday
	local v22 = not not v19 and v19.additionalUsageEnabled
	local v23 = if not v19 or not v19.dailyLimitSet then nil else v19.dailyLimit
	local v24 = v19 ~= nil
	local v25 = v18 == DataStatus.Ready and v17 ~= nil
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(false)
	local v32 = React.useRef(0)
	local v33 = React.useCallback(function() -- line: 50
		-- upvalues: v32 (copy), v29 (copy), v31 (copy)
		local v41 = v32

		v41.current = v41.current + 1
		v29(true)
		v31(false)

		return v32.current
	end, {})
	local v34 = React.useCallback(function(n1: number, b1: boolean) -- line: 56
		-- upvalues: v32 (copy), v29 (copy), v31 (copy)
		if n1 ~= v32.current then
			return
		end

		v29(false)
		v31(b1)
	end, {})
	local v35 = React.useCallback(function(b2: boolean) -- line: 64
		-- upvalues: v25 (copy), v28 (copy), v19 (copy), v33 (copy), v13 (copy), v34 (copy)
		if not v25 or (v28 or v19 == nil) then
			return
		end

		local v45 = v33()

		v13.setDailyLimit({
			additionalUsageEnabled = b2,
			dailyLimitSet = v19.dailyLimitSet,
			dailyLimit = v19.dailyLimit
		}):andThen(function() -- line: 75
			-- upvalues: v34 (copy), v45 (copy)
			v34(v45, false)
		end):catch(function() -- line: 78
			-- upvalues: v34 (copy), v45 (copy)
			v34(v45, true)
		end)
	end, {
		v33,
		v13,
		v34,
		v28,
		v19,
		v25
	})
	local v36 = React.useCallback(function() -- line: 82
		-- upvalues: v25 (copy), v28 (copy), v31 (copy), v27 (copy)
		if v25 and not v28 then
			v31(false)
			v27(true)
		end
	end, {
		v28,
		v25
	})
	local v37 = React.useCallback(function(n2: number?) -- line: 88
		-- upvalues: v25 (copy), v28 (copy), v19 (copy), v33 (copy), v13 (copy), v32 (copy), v34 (copy), v27 (copy)
		if not v25 or (v28 or v19 == nil) then
			return
		end

		local v47 = v33()

		v13.setDailyLimit({
			additionalUsageEnabled = v19.additionalUsageEnabled,
			dailyLimitSet = n2 ~= nil,
			dailyLimit = n2 or 0
		}):andThen(function() -- line: 99
			-- upvalues: v32 (copy), v47 (copy), v34 (copy), v27 (copy)
			if v32.current == v47 then
				v34(v47, false)
				v27(false)
			end
		end):catch(function() -- line: 105
			-- upvalues: v34 (copy), v47 (copy)
			v34(v47, true)
		end)
	end, {
		v33,
		v13,
		v34,
		v28,
		v19,
		v25
	})
	local v38 = React.useCallback(function() -- line: 109
		-- upvalues: v27 (copy)
		v27(false)
	end, {})
	local v39 = React.useCallback(function() -- line: 112
		-- upvalues: v13 (copy)
		v13.refreshQuotaSummary():catch(function() -- line: 113
		end)
	end, { v13 })
	local v40 = useOpenBuyRobuxWebView(v39)

	useRefreshCreatorCreditOnUnhide(v39)

	return {
		pageProps = {
			dailyPctUsed = not v16 and 0 or v16.freeTrialPctUsed,
			resetHours = if not v16 then nil else getHoursUntilReset(v16.nextResetEligibleTime),
			additionalEnabled = v22,
			dailyLimit = v23,
			hasLimitConfigured = v24,
			additionalUsed = v21,
			robuxAvailable = v20,
			settingsDisabled = not v25 or v28,
			settingsError = v30 or v18 == DataStatus.Failed,
			showBuyRobux = v16 ~= nil and (v16.freeTrialRemaining <= 0 and v16.robuxBalance < CreatorCreditConfig.FIntMinimumUsableRobuxBalance),
			onToggleAdditional = v35,
			onOpenLimitSheet = v36,
			onOpenBuyRobux = v40
		},
		limitSheetProps = {
			isOpen = v26,
			initialValue = v23,
			initialIsNoLimit = v24 and v23 == nil,
			additionalUsed = v21,
			isSaving = v28,
			saveError = v30,
			onConfirm = v37,
			onCancel = v38
		}
	}
end

return useCreatorCreditPageViewModel
