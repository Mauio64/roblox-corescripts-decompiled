local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Otter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Localization").Hooks.useLocalization
local AuthSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/SharedFlags")

local useRequireManualSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Hooks/useRequireManualSelection")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/BirthdaySheetView")

local dateHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Time").DateHelper

local useValidatedBirthday = AuthSignup.Hooks.useValidatedBirthday

local fIntSinglePageSignupMinimumAge = SharedFlags.FIntSinglePageSignupMinimumAge

local v5 = { frequency = 3 }

local function useSlide(onClose)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local v6, v7 = React.useBinding(reducedMotion and 1 or 0)
	local v8 = React.useMemo(function()
		return Otter.createSingleMotor(reducedMotion and 1 or 0)
	end, { reducedMotion })
	local ref = React.useRef(false)
	local ref2 = React.useRef(onClose)
	ref2.current = onClose

	React.useEffect(function()
		local v9 = v8:onStep(function(p2)
			v7(p2)

			if ref.current and p2 <= 0.1 then
				ref.current = false
				v8:stop()
				ref2.current()
			end
		end)

		if not reducedMotion then
			v8:setGoal(Otter.spring(1, v5))
		end

		return function()
			v9()
			v8:destroy()
		end
	end, { v8, reducedMotion })

	return v6, (React.useCallback(function()
		if reducedMotion then
			ref2.current()
			return
		end

		if ref.current then
			return
		end

		ref.current = true
		v8:setGoal(Otter.spring(0, v5))
	end, { v8, reducedMotion }))
end

local function useBirthdaySheetViewModel(data)
	local v6, v7 = useSlide(data.onClose)

	local v8, v9 = useValidatedBirthday(fIntSinglePageSignupMinimumAge)

	local v10 = useRequireManualSelection()

	local onConfirm = data.onConfirm
	local v11 = React.useCallback(function()
		if v8 ~= nil then
			onConfirm(v8)
		end
	end, { v8, onConfirm })

	local onAllPicked = data.onAllPicked
	local ref = React.useRef(false)
	local v12 = React.useCallback(function(p2, p3, p4)
		v9(p2, p3, p4)

		if onAllPicked and not ref.current and p2 and p3 and p4 then
			ref.current = true
			onAllPicked()
		end
	end, { v9, onAllPicked })

	local v13 = if data.showsAgeSummary then v8 else nil
	local ageInYears = if v13 then v13:GetAgeInYears() else nil

	local onAgeSummaryShown = data.onAgeSummaryShown
	local ref2 = React.useRef(false)
	React.useEffect(function()
		if ageInYears ~= nil and onAgeSummaryShown and not ref2.current then
			ref2.current = true
			onAgeSummaryShown(ageInYears)
		end
	end, { ageInYears, onAgeSummaryShown })

	local v16 = if v13 then dateHelper.MonthsLocalizationKeys[v13.Month] else nil
	local v17 = useLocalization({
		titleText = "Authentication.SignUp.Label.SelectBirthdaySentenceCase",
		confirmText = "Authentication.SignUp.Button.OKCaptialized",
		monthText = v16,
		dayAffix = dateHelper.DayAffixLocalizationKey,
		yearAffix = dateHelper.YearAffixLocalizationKey
	})
	local formattedFullString

	if v13 and v17.monthText then
		formattedFullString = dateHelper:GetFormattedFullString(
			v17.monthText,
			v13.Day,
			v17.dayAffix,
			v13.Year,
			v17.yearAffix,
			" ",
			LocalizationService.RobloxLocaleId
		)
	end

	local v18 = useLocalization({
		ageSummaryText = formattedFullString and {
			"Authentication.SignUp.Label.BirthdayPickerWithDateAndAge",
			date = formattedFullString,
			yearsOld = tostring(ageInYears)
		} or nil
	})

	local birthday = data.birthday

	local v19 = {
		titleText = v17.titleText,
		confirmText = v17.confirmText,
		ageSummaryText = v18.ageSummaryText,
		isCentered = data.isCentered == true,
		slideProgress = v6,
		minAgeAllowed = fIntSinglePageSignupMinimumAge,
		requireManualSelection = v10,
		updateBirthday = v12,
		initialMonth = 0,
		initialDay = 0,
		initialYear = 0,
		isConfirmEnabled = 0,
		onDismiss = 0,
		onConfirmActivated = 0
	}

	local v20 = if birthday then birthday.Month else nil
	v19.initialMonth = v20
	local v21 = if birthday then birthday.Day else nil
	v19.initialDay = v21
	local v22 = if birthday then birthday.Year else nil
	v19.initialYear = v22
	v19.isConfirmEnabled = v8 ~= nil
	v19.onDismiss = v7
	v19.onConfirmActivated = v11
	return v19
end

return useBirthdaySheetViewModel
