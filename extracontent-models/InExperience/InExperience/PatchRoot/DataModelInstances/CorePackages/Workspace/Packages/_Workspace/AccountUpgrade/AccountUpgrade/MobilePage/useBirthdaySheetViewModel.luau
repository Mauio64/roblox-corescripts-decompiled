local LocalizationService = game:GetService("LocalizationService")

local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Otter = require(parent.Otter)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AuthSignup = require(parent.AuthSignup)
local SharedFlags = require(parent.SharedFlags)

local useRequireManualSelection = require(AccountUpgrade.Hooks.useRequireManualSelection)
require(script.Parent.BirthdaySheetView)

local Time = require(parent.Time)
local DateHelper = Time.DateHelper

local useValidatedBirthday = AuthSignup.Hooks.useValidatedBirthday

local FIntSinglePageSignupMinimumAge = SharedFlags.FIntSinglePageSignupMinimumAge

local v = { frequency = 3 }

local function useSlide(onClose)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local v2, v3 = React.useBinding(reducedMotion and 1 or 0)
	local v4 = React.useMemo(function()
		return Otter.createSingleMotor(reducedMotion and 1 or 0)
	end, { reducedMotion })
	local ref = React.useRef(false)
	local ref2 = React.useRef(onClose)
	ref2.current = onClose

	React.useEffect(function()
		local v5 = v4:onStep(function(p: number)
			v3(p)

			if ref.current and p <= 0.1 then
				ref.current = false
				v4:stop()
				ref2.current()
			end
		end)

		if not reducedMotion then
			v4:setGoal(Otter.spring(1, v))
		end

		return function()
			v5()
			v4:destroy()
		end
	end, { v4, reducedMotion })

	return v2, (React.useCallback(function()
		if reducedMotion then
			ref2.current()
			return
		end

		if ref.current then
			return
		end

		ref.current = true
		v4:setGoal(Otter.spring(0, v))
	end, { v4, reducedMotion }))
end

local function useBirthdaySheetViewModel(data)
	local slideProgress, onDismiss = useSlide(data.onClose)

	local v2, v3 = useValidatedBirthday(FIntSinglePageSignupMinimumAge)

	local requireManualSelection = useRequireManualSelection()

	local onConfirm = data.onConfirm
	local onConfirmActivated = React.useCallback(function()
		if v2 ~= nil then
			onConfirm(v2)
		end
	end, { v2, onConfirm })

	local onAllPicked = data.onAllPicked
	local ref = React.useRef(false)
	local updateBirthday = React.useCallback(function(p: number?, p2: number?, p3: number?)
		v3(p, p2, p3)

		if onAllPicked and not ref.current and p and p2 and p3 then
			ref.current = true
			onAllPicked()
		end
	end, { v3, onAllPicked })
	local v4

	if data.showsAgeSummary then
		v4 = v2
	end

	local ageInYears

	if v4 then
		ageInYears = v4:GetAgeInYears()
	else
		ageInYears = nil
	end

	local onAgeSummaryShown = data.onAgeSummaryShown
	local ref2 = React.useRef(false)
	React.useEffect(function()
		if ageInYears ~= nil and onAgeSummaryShown and not ref2.current then
			ref2.current = true
			onAgeSummaryShown(ageInYears)
		end
	end, { ageInYears, onAgeSummaryShown })
	local monthText

	if v4 then
		monthText = DateHelper.MonthsLocalizationKeys[v4.Month]
	end

	local v5 = useLocalization({
		titleText = "Authentication.SignUp.Label.SelectBirthdaySentenceCase",
		confirmText = "Authentication.SignUp.Button.OKCaptialized",
		monthText = monthText,
		dayAffix = DateHelper.DayAffixLocalizationKey,
		yearAffix = DateHelper.YearAffixLocalizationKey
	})
	local formattedFullString

	if v4 and v5.monthText then
		formattedFullString = DateHelper:GetFormattedFullString(
			v5.monthText,
			v4.Day,
			v5.dayAffix,
			v4.Year,
			v5.yearAffix,
			" ",
			LocalizationService.RobloxLocaleId
		)
	end

	local v6 = useLocalization({
		ageSummaryText = formattedFullString and {
			"Authentication.SignUp.Label.BirthdayPickerWithDateAndAge",
			date = formattedFullString,
			yearsOld = tostring(ageInYears)
		} or nil
	})

	local birthday = data.birthday

	local v7 = {
		titleText = v5.titleText,
		confirmText = v5.confirmText,
		ageSummaryText = v6.ageSummaryText,
		isCentered = data.isCentered == true,
		slideProgress = slideProgress,
		minAgeAllowed = FIntSinglePageSignupMinimumAge,
		requireManualSelection = requireManualSelection,
		updateBirthday = updateBirthday,
		initialMonth = 0,
		initialDay = 0,
		initialYear = 0,
		isConfirmEnabled = 0,
		onDismiss = 0,
		onConfirmActivated = 0
	}
	local initialMonth

	if birthday then
		initialMonth = birthday.Month
	end

	v7.initialMonth = initialMonth
	local initialDay

	if birthday then
		initialDay = birthday.Day
	end

	v7.initialDay = initialDay
	local initialYear

	if birthday then
		initialYear = birthday.Year
	end

	v7.initialYear = initialYear
	v7.isConfirmEnabled = v2 ~= nil
	v7.onDismiss = onDismiss
	v7.onConfirmActivated = onConfirmActivated
	return v7
end

return useBirthdaySheetViewModel
