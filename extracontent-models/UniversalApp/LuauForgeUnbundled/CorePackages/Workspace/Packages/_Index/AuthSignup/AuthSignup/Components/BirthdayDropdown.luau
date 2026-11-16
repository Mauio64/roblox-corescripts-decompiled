local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthAnalytics")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local Time = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Time")

local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local eventStreamConstants = AuthAnalytics.EventStreamConstants

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Localization").Hooks.useLocalization
local validateBirthday = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Util/validateBirthday")
local birthday = AuthCommon.Models.Birthday
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local view = Foundation.View
local useEffect = React.useEffect
local useState = React.useState
local timeUnit = Time.TimeUnit
local dateHelper = Time.DateHelper

local dropdownWithPopover = AuthCommon.Components.DropdownWithPopover

local function fn(list)
	local result = {}

	for i = 1, 12 do
		table.insert(result, { text = list[i], value = i })
	end

	return result
end

local v5 = { minAgeAllowed = 0, maxAgeAllowed = 99 }

local function BirthdayDropdown(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useTokens()
	local v7 = useLocalization({
		errorText = "Authentication.SignUp.Response.InvalidBirthday",
		monthLabel = "Authentication.SignUp.Label.Month",
		dayLabel = "Authentication.SignUp.Label.Day",
		yearLabel = "Authentication.SignUp.Label.Year"
	})

	local v8 = useLocalization(dateHelper.MonthsLocalizationKeys)
	local state, setState = useState(nil)
	local state2, setState2 = useState(nil)
	local state3, setState3 = useState(nil)
	local state4, setState4 = useState(false)

	local v9 = dateHelper:getCurrentDate()[timeUnit.Years]
	local minAgeAllowed = joined.minAgeAllowed
	local v10 = v9 - joined.maxAgeAllowed
	local v11 = v9 - minAgeAllowed

	local v12 = dateHelper.DateTypeOrder[joined.localeId]
	local v13 = v12[timeUnit.Months]
	local v14 = v12[timeUnit.Days]
	local v15 = v12[timeUnit.Years]

	local v16 = React.useMemo(function()
		return dateHelper:generateYearCellDatas(v10, v11)
	end, { v10, v11 })
	local v17 = React.useMemo(function()
		return fn(v8)
	end, { v8 })
	local v18 = React.useMemo(function()
		return dateHelper:generateDayCellDatas()
	end, {})

	local focusOnMount = joined.focusOnMount

	useEffect(function()
		if state2 == nil or state == nil or state3 == nil then
			return
		end

		local v19 = birthday.new({ Month = state2, Day = state, Year = state3 })

		if validateBirthday(state2, state, state3, minAgeAllowed) then
			joined.onBirthdaySelected(v19, v19:GetAgeInYears(), true)
			setState4(false)

			local v20 = eventStreamConstants.State.BirthdayDropdownBirthdaySelected .. "," .. v19:ToString(",")
			authFormInteraction(
				joined.analyticsEventContext,
				eventStreamConstants.Field.BirthdayDropdown,
				v20
			)
		else
			joined.onBirthdaySelected(v19, v19:GetAgeInYears(), false)

			setState4(true)
			authFormInteraction(
				joined.analyticsEventContext,
				eventStreamConstants.Field.BirthdayDropdown,
				eventStreamConstants.State.BirthdayDropdownInvalidBirthdayError
			)
		end
	end, { state2, state, state3 })

	return React.createElement(view, {
		tag = "col size-full-0 auto-y gap-small align-x-start"
	}, {
		DropdownContainer = React.createElement(
			view,
			{ tag = "row size-full-0 flex-x-fill auto-y gap-medium" },
			{
				MonthDropdown = React.createElement(dropdownWithPopover, {
					placeholder = v7.monthLabel,
					value = state2,
					cellDatas = v17,
					layoutOrder = v13,
					onChange = setState2,
					errorState = state4,
					focusOnMount = focusOnMount and v13 == 1,
					backgroundColorToken = v6.Color.Common.Shadow,
					dropdownHeight = 40,
					onDropdownOpened = joined.onDropdownOpened,
					fixSizeToParent = true
				}),
				DayDropdown = React.createElement(dropdownWithPopover, {
					placeholder = v7.dayLabel,
					value = state,
					cellDatas = v18,
					layoutOrder = v14,
					onChange = setState,
					errorState = state4,
					focusOnMount = focusOnMount and v14 == 1,
					backgroundColorToken = v6.Color.Common.Shadow,
					dropdownHeight = 40,
					onDropdownOpened = joined.onDropdownOpened,
					fixSizeToParent = true
				}),
				YearDropdown = React.createElement(dropdownWithPopover, {
					placeholder = v7.yearLabel,
					value = state3,
					cellDatas = v16,
					layoutOrder = v15,
					onChange = setState3,
					errorState = state4,
					focusOnMount = focusOnMount and v15 == 1,
					backgroundColorToken = v6.Color.Common.Shadow,
					dropdownHeight = 40,
					onDropdownOpened = joined.onDropdownOpened,
					fixSizeToParent = true
				})
			}
		),
		ErrorText = state4 and React.createElement(text, {
			Text = v7.errorText,
			tag = "auto-xy text-body-small",
			padding = { bottom = UDim.new(0, 0) },
			textStyle = v6.Color.System.Alert
		})
	})
end

return React.memo(BirthdayDropdown)
