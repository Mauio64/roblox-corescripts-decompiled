local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local Cryo = require(AuthSignupParent.Cryo)
local React = require(AuthSignupParent.React)
local Foundation = require(AuthSignupParent.Foundation)
local AuthAnalytics = require(AuthSignupParent.AuthAnalytics)
local AuthCommon = require(AuthSignupParent.AuthCommon)
local Time = require(AuthSignupParent.Time)
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local useLocalization = require(AuthSignupParent.Localization).Hooks.useLocalization
local validateBirthday = require(AuthSignup.Util.validateBirthday)
local Birthday = AuthCommon.Models.Birthday
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View
local useEffect = React.useEffect
local useState = React.useState
local TimeUnit = Time.TimeUnit
local DateHelper = Time.DateHelper
local DropdownWithPopover = AuthCommon.Components.DropdownWithPopover

local function v22(p1) -- line: 34
	local t1 = {}

	for i = 1, 12 do
		table.insert(t1, {
			text = p1[i],
			value = i
		})
	end

	return t1
end

local t2 = {
	minAgeAllowed = 0,
	maxAgeAllowed = 99
}

local function BirthdayDropdown(t3: {[any]: any}) -- line: 63
	-- upvalues: Cryo (copy), t2 (copy), useTokens (copy), useLocalization (copy), DateHelper (copy), useState (copy), TimeUnit (copy), React (copy), v22 (copy), useEffect (copy), Birthday (copy), validateBirthday (copy), EventStreamConstants (copy), authFormInteraction (copy), View (copy), DropdownWithPopover (copy), FoundationText (copy)
	local v29 = Cryo.Dictionary.join(t2, t3)
	local v30 = useTokens()
	local v31 = useLocalization({
		errorText = "Authentication.SignUp.Response.InvalidBirthday",
		monthLabel = "Authentication.SignUp.Label.Month",
		dayLabel = "Authentication.SignUp.Label.Day",
		yearLabel = "Authentication.SignUp.Label.Year"
	})
	local v32 = useLocalization(DateHelper.MonthsLocalizationKeys)
	local v33, v34 = useState(nil)
	local v35, v36 = useState(nil)
	local v37, v38 = useState(nil)
	local v39, v40 = useState(false)
	local v41 = DateHelper:getCurrentDate()[TimeUnit.Years]
	local minAgeAllowed = v29.minAgeAllowed
	local v43 = v41 - v29.maxAgeAllowed
	local v44 = v41 - minAgeAllowed
	local v45 = DateHelper.DateTypeOrder[v29.localeId]
	local v46 = v45[TimeUnit.Months]
	local v47 = v45[TimeUnit.Days]
	local v48 = v45[TimeUnit.Years]
	local v49 = React.useMemo(function() -- line: 91
		-- upvalues: DateHelper (copy), v43 (copy), v44 (copy)
		return DateHelper:generateYearCellDatas(v43, v44)
	end, {
		v43,
		v44
	})
	local v50 = React.useMemo(function() -- line: 94
		-- upvalues: v22 (copy), v32 (copy)
		return (v22(v32))
	end, { v32 })
	local v51 = React.useMemo(function() -- line: 97
		-- upvalues: DateHelper (copy)
		return DateHelper:generateDayCellDatas()
	end, {})
	local focusOnMount = v29.focusOnMount

	useEffect(function() -- line: 103
		-- upvalues: v35 (copy), v33 (copy), v37 (copy), Birthday (copy), validateBirthday (copy), minAgeAllowed (copy), v29 (copy), v40 (copy), EventStreamConstants (copy), authFormInteraction (copy)
		if v35 == nil or (v33 == nil or v37 == nil) then
			return
		end

		local v53 = Birthday.new({
			Month = v35,
			Day = v33,
			Year = v37
		})

		if validateBirthday(v35, v33, v37, minAgeAllowed) then
			v29.onBirthdaySelected(v53, v53:GetAgeInYears(), true)
			v40(false)

			local v54 = EventStreamConstants.State.BirthdayDropdownBirthdaySelected .. "," .. v53:ToString(",")

			authFormInteraction(v29.analyticsEventContext, EventStreamConstants.Field.BirthdayDropdown, v54)

			return
		end

		v29.onBirthdaySelected(v53, v53:GetAgeInYears(), false)
		v40(true)
		authFormInteraction(v29.analyticsEventContext, EventStreamConstants.Field.BirthdayDropdown, EventStreamConstants.State.BirthdayDropdownInvalidBirthdayError)
	end, {
		v35,
		v33,
		v37
	})

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-small align-x-start"
	}, {
		DropdownContainer = React.createElement(View, {
			tag = "row size-full-0 flex-x-fill auto-y gap-medium"
		}, {
			MonthDropdown = React.createElement(DropdownWithPopover, {
				dropdownHeight = 40,
				fixSizeToParent = true,
				placeholder = v31.monthLabel,
				value = v35,
				cellDatas = v50,
				layoutOrder = v46,
				onChange = v36,
				errorState = v39,
				focusOnMount = focusOnMount and v46 == 1,
				backgroundColorToken = v30.Color.Common.Shadow,
				onDropdownOpened = v29.onDropdownOpened
			}),
			DayDropdown = React.createElement(DropdownWithPopover, {
				dropdownHeight = 40,
				fixSizeToParent = true,
				placeholder = v31.dayLabel,
				value = v33,
				cellDatas = v51,
				layoutOrder = v47,
				onChange = v34,
				errorState = v39,
				focusOnMount = focusOnMount and v47 == 1,
				backgroundColorToken = v30.Color.Common.Shadow,
				onDropdownOpened = v29.onDropdownOpened
			}),
			YearDropdown = React.createElement(DropdownWithPopover, {
				dropdownHeight = 40,
				fixSizeToParent = true,
				placeholder = v31.yearLabel,
				value = v37,
				cellDatas = v49,
				layoutOrder = v48,
				onChange = v38,
				errorState = v39,
				focusOnMount = focusOnMount and v48 == 1,
				backgroundColorToken = v30.Color.Common.Shadow,
				onDropdownOpened = v29.onDropdownOpened
			})
		}),
		ErrorText = v39 and React.createElement(FoundationText, {
			tag = "auto-xy text-body-small",
			Text = v31.errorText,
			padding = {
				bottom = UDim.new(0, 0)
			},
			textStyle = v30.Color.System.Alert
		})
	})
end

return React.memo(BirthdayDropdown)
