local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthAnalytics = require(parent.AuthAnalytics)
local AuthCommon = require(parent.AuthCommon)
local Time = require(parent.Time)

local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventStreamConstants = AuthAnalytics.EventStreamConstants

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local validateBirthday = require(AuthSignup.Util.validateBirthday)
local Birthday = AuthCommon.Models.Birthday
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local View = Foundation.View
local useEffect = React.useEffect
local useState = React.useState
local TimeUnit = Time.TimeUnit
local DateHelper = Time.DateHelper

local DropdownWithPopover = AuthCommon.Components.DropdownWithPopover

local function fn(list)
	local result = {}

	for i = 1, 12 do
		table.insert(result, { text = list[i], value = i })
	end

	return result
end

local v = { minAgeAllowed = 0, maxAgeAllowed = 99 }

local function BirthdayDropdown(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useTokens()
	local v3 = useLocalization({
		errorText = "Authentication.SignUp.Response.InvalidBirthday",
		monthLabel = "Authentication.SignUp.Label.Month",
		dayLabel = "Authentication.SignUp.Label.Day",
		yearLabel = "Authentication.SignUp.Label.Year"
	})

	local v4 = useLocalization(DateHelper.MonthsLocalizationKeys)
	local state, setState = useState(nil)
	local state2, setState2 = useState(nil)
	local state3, setState3 = useState(nil)
	local state4, setState4 = useState(false)

	local v5 = DateHelper:getCurrentDate()[TimeUnit.Years]
	local minAgeAllowed = joined.minAgeAllowed
	local v6 = v5 - joined.maxAgeAllowed
	local v7 = v5 - minAgeAllowed

	local v8 = DateHelper.DateTypeOrder[joined.localeId]
	local layoutOrder = v8[TimeUnit.Months]
	local layoutOrder2 = v8[TimeUnit.Days]
	local layoutOrder3 = v8[TimeUnit.Years]

	local cellDatas = React.useMemo(function()
		return DateHelper:generateYearCellDatas(v6, v7)
	end, { v6, v7 })
	local cellDatas2 = React.useMemo(function()
		return fn(v4)
	end, { v4 })
	local cellDatas3 = React.useMemo(function()
		return DateHelper:generateDayCellDatas()
	end, {})

	local focusOnMount = joined.focusOnMount

	useEffect(function()
		if state2 == nil or state == nil or state3 == nil then
			return
		end

		local v9 = Birthday.new({ Month = state2, Day = state, Year = state3 })

		if validateBirthday(state2, state, state3, minAgeAllowed) then
			joined.onBirthdaySelected(v9, v9:GetAgeInYears(), true)
			setState4(false)

			local v10 = EventStreamConstants.State.BirthdayDropdownBirthdaySelected .. "," .. v9:ToString(",")
			authFormInteraction(joined.analyticsEventContext, EventStreamConstants.Field.BirthdayDropdown, v10)
		else
			joined.onBirthdaySelected(v9, v9:GetAgeInYears(), false)

			setState4(true)
			authFormInteraction(
				joined.analyticsEventContext,
				EventStreamConstants.Field.BirthdayDropdown,
				EventStreamConstants.State.BirthdayDropdownInvalidBirthdayError
			)
		end
	end, { state2, state, state3 })

	return React.createElement(View, { tag = "col size-full-0 auto-y gap-small align-x-start" }, {
		DropdownContainer = React.createElement(View, {
			tag = "row size-full-0 flex-x-fill auto-y gap-medium"
		}, {
			MonthDropdown = React.createElement(DropdownWithPopover, {
				placeholder = v3.monthLabel,
				value = state2,
				cellDatas = cellDatas2,
				layoutOrder = layoutOrder,
				onChange = setState2,
				errorState = state4,
				focusOnMount = focusOnMount and layoutOrder == 1,
				backgroundColorToken = v2.Color.Common.Shadow,
				dropdownHeight = 40,
				onDropdownOpened = joined.onDropdownOpened,
				fixSizeToParent = true
			}),
			DayDropdown = React.createElement(DropdownWithPopover, {
				placeholder = v3.dayLabel,
				value = state,
				cellDatas = cellDatas3,
				layoutOrder = layoutOrder2,
				onChange = setState,
				errorState = state4,
				focusOnMount = focusOnMount and layoutOrder2 == 1,
				backgroundColorToken = v2.Color.Common.Shadow,
				dropdownHeight = 40,
				onDropdownOpened = joined.onDropdownOpened,
				fixSizeToParent = true
			}),
			YearDropdown = React.createElement(DropdownWithPopover, {
				placeholder = v3.yearLabel,
				value = state3,
				cellDatas = cellDatas,
				layoutOrder = layoutOrder3,
				onChange = setState3,
				errorState = state4,
				focusOnMount = focusOnMount and layoutOrder3 == 1,
				backgroundColorToken = v2.Color.Common.Shadow,
				dropdownHeight = 40,
				onDropdownOpened = joined.onDropdownOpened,
				fixSizeToParent = true
			})
		}),
		ErrorText = state4 and React.createElement(Text, {
			Text = v3.errorText,
			tag = "auto-xy text-body-small",
			padding = { bottom = UDim.new(0, 0) },
			textStyle = v2.Color.System.Alert
		})
	})
end

return React.memo(BirthdayDropdown)
