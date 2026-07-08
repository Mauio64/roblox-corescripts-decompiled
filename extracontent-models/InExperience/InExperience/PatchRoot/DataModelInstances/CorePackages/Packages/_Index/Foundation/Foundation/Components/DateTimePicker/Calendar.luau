local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local CalendarDay = require(script.Parent.CalendarDay)
local DateTimeUtilities = require(script.Parent.DateTimeUtilities)
local Icon = BuilderIcons.Icon
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local Text = require(Foundation.Components.Text)
local TextInput = require(Foundation.Components.TextInput)
local TimeDropdown = require(script.Parent.TimeDropdown)
local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function Calendar(t1: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), useScaledValue (copy), React (copy), DateTimeUtilities (copy), Text (copy), CalendarDay (copy), View (copy), IconButton (copy), Icon (copy), InputSize (copy), ButtonVariant (copy), TimeDropdown (copy), TextInput (copy)
	local v19 = useTokens()
	local v20 = useScaledValue(272)
	local v21 = React.useRef(false)
	local v22 = if t1.defaultDates then t1.defaultDates else { DateTime.now() }

	React.useEffect(function() -- line: 60
		-- upvalues: t1 (copy), v22 (copy)
		t1.onSelectedDateChanged(v22)
	end, {
		v22,
		t1.defaultDates,
		t1.onSelectedDateChanged
	})

	local v23, v24 = React.useState(v22)
	local v25 = React.useRef(nil)
	local v26, v27 = React.useState(if not t1.showEndDateTimeCalendarInput then {
		startDateTimeInput = true,
		endDateTimeInput = false
	} else {
		startDateTimeInput = false,
		endDateTimeInput = true
	})

	React.useEffect(function() -- line: 73
		-- upvalues: t1 (copy), v26 (copy), v25 (copy)
		if t1.showEndDateTimeCalendarInput and (v26.endDateTimeInput and v25.current) then
			v25.current.focus()
		end
	end, { v26 })

	local v28, v29 = React.useState(DateTimeUtilities.formatLocalTime(v22[1]))
	local v30, v31 = React.useState(not v22[2] and "" or DateTimeUtilities.formatLocalTime(v22[2]))

	React.useEffect(function() -- line: 88
		-- upvalues: v21 (copy)
		v21.current = true
	end, {})

	local v32, v33 = React.useState({
		month = v22[1]:ToLocalTime().Month,
		year = v22[1]:ToLocalTime().Year
	})
	local t2 = {}

	for _, v36 in v23 do
		table.insert(t2, v36:ToLocalTime())
	end

	local v37 = React.useCallback(function() -- line: 140
		-- upvalues: DateTimeUtilities (copy), v32 (copy), v33 (copy)
		local v49, v50 = DateTimeUtilities.getNextMonthInfo(v32.month, v32.year)

		v33({
			month = v49,
			year = v50
		})
	end, { v32 })
	local v38 = React.useCallback(function() -- line: 145
		-- upvalues: DateTimeUtilities (copy), v32 (copy), v33 (copy)
		local v51, v52 = DateTimeUtilities.getPrevMonthInfo(v32.month, v32.year)

		v33({
			month = v51,
			year = v52
		})
	end, { v32 })
	local v39 = React.useCallback(function(n1: number, n2: number, n3: number) -- line: 151
		-- upvalues: v23 (copy), t1 (copy), v26 (copy), v29 (copy), DateTimeUtilities (copy), v27 (copy), v31 (copy), v33 (copy), v24 (copy)
		local dateTime = DateTime.fromLocalTime(n3, n2, n1, v23[1]:ToLocalTime().Hour, v23[1]:ToLocalTime().Minute)

		if t1.showStartDateTimeCalendarInput then
			if t1.showEndDateTimeCalendarInput then
				if v26.startDateTimeInput then
					v29(DateTimeUtilities.formatLocalTime(dateTime))
					v27({
						startDateTimeInput = false,
						endDateTimeInput = true
					})
				elseif v26.endDateTimeInput then
					v31(DateTimeUtilities.formatLocalTime(dateTime))
					v27({
						startDateTimeInput = false,
						endDateTimeInput = false
					})
				else
					v29(DateTimeUtilities.formatLocalTime(dateTime))
					v31("")
					v27({
						startDateTimeInput = false,
						endDateTimeInput = true
					})
				end
			else
				v29(DateTimeUtilities.formatLocalTime(dateTime))
			end

			v33({
				month = n2,
				year = n3
			})

			return
		end

		v33({
			month = n2,
			year = n3
		})
		v24({ dateTime })
		t1.onSelectedDateChanged({ dateTime })
	end, {
		t1.showStartDateTimeCalendarInput,
		t1.showEndDateTimeCalendarInput,
		v23,
		v26,
		v25
	})
	local v40 = React.useCallback(function(p1) -- line: 196
		-- upvalues: t2 (copy)
		local v58 = p1:ToLocalTime()

		for _, v60 in t2 do
			if v60.Day == v58.Day and v60.Month == v58.Month and v60.Year == v58.Year then
				return true
			end
		end

		return false
	end, { t2 })
	local v41 = React.useCallback(function(p2) -- line: 210
		-- upvalues: t1 (copy), v23 (copy), DateTimeUtilities (copy)
		return t1.showEndDateTimeCalendarInput and (v23[1] and (v23[2] and DateTimeUtilities.isDateWithinRange(p2, {
			startDate = v23[1],
			endDate = v23[2]
		})))
	end, {
		t1.showEndDateTimeCalendarInput,
		v23
	})
	local v42 = React.useCallback(function(p3) -- line: 221
		-- upvalues: t1 (copy), DateTimeUtilities (copy), v26 (copy), v23 (copy)
		if t1.selectableDateRange and not DateTimeUtilities.isDateWithinRange(p3, t1.selectableDateRange) then
			return false
		end

		if t1.showEndDateTimeCalendarInput then
			if v26.endDateTimeInput and DateTimeUtilities.roundToStartOfDay(p3) < DateTimeUtilities.roundToStartOfDay(v23[1]) then
				return false
			end

			if v26.startDateTimeInput and v23[2] and DateTimeUtilities.roundToStartOfDay(p3) > DateTimeUtilities.roundToStartOfDay(v23[2]) then
				return false
			end
		end

		return true
	end, {
		v23,
		t1.selectableDateRange,
		v26,
		t1.showEndDateTimeCalendarInput
	})
	local v43 = React.useCallback(function(s1: string) -- line: 255
		-- upvalues: v21 (copy), v29 (copy), DateTimeUtilities (copy), t1 (copy), v23 (copy), v33 (copy), v24 (copy)
		if not v21.current then
			return
		end

		v29(s1)

		local v64 = DateTimeUtilities.getDateTimeFromText(s1)

		if v64 then
			local v65 = if not t1.showEndDateTimeCalendarInput then { v64 } else {
				v64,
				v23[2]
			}
			local v66 = v64:ToLocalTime()

			v33({
				month = v66.Month,
				year = v66.Year
			})
			v24(v65)
			t1.onSelectedDateChanged(v65)
		end
	end, {
		t1.onSelectedDateChanged,
		t1.showEndDateTimeCalendarInput,
		v42,
		v23,
		v21
	})
	local v44 = React.useCallback(function(s2: string) -- line: 286
		-- upvalues: v21 (copy), v31 (copy), DateTimeUtilities (copy), v23 (copy), v33 (copy), v24 (copy), t1 (copy)
		if not v21.current then
			return
		end

		v31(s2)

		local v68 = DateTimeUtilities.getDateTimeFromText(s2)

		if v68 then
			if v23[1] and DateTimeUtilities.roundToStartOfDay(v68) < DateTimeUtilities.roundToStartOfDay(v23[1]) then
				return
			end

			local t3 = {
				v23[1],
				v68
			}
			local v70 = v68:ToLocalTime()

			v33({
				month = v70.Month,
				year = v70.Year
			})
			v24(t3)
			t1.onSelectedDateChanged(t3)

			return
		end

		if s2 == "" then
			v24(function(p4) -- line: 312
				-- upvalues: t1 (copy)
				t1.onSelectedDateChanged({ p4[1] })

				return { p4[1] }
			end)

			return
		end
	end, {
		t1.onSelectedDateChanged,
		v23,
		v42,
		v21
	})
	local v45 = React.useMemo(function() -- line: 321
		-- upvalues: React (copy), v19 (copy), v20 (copy), DateTimeUtilities (copy), Text (copy), v32 (copy), CalendarDay (copy), v41 (copy), v42 (copy), v40 (copy), v39 (copy), t1 (copy)
		local t4 = {}

		table.insert(t4, React.createElement("UIGridLayout", {
			FillDirectionMaxCells = 7,
			key = "layout",
			CellPadding = UDim2.fromOffset(v19.Padding.None, v19.Padding.None),
			CellSize = UDim2.fromOffset(v20 / 7, v20 / 7),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}))

		local n4 = 1

		for _, v74 in DateTimeUtilities.weekdays do
			table.insert(t4, React.createElement(Text, {
				tag = "text-body-small text-align-x-center text-align-y-center",
				key = v74,
				LayoutOrder = n4,
				Text = v74
			}))
			n4 += 1
		end

		local v75 = DateTimeUtilities.getFirstDayOfWeek(v32.month, v32.year)
		local v76, v77 = DateTimeUtilities.getPrevMonthInfo(v32.month, v32.year)
		local v78 = DateTimeUtilities.getDaysInMonth(DateTimeUtilities.getPrevMonthInfo(v32.month, v32.year))
		local v79 = if v75 ~= 0 then v75 else 7

		for i = 1, v79 do
			local v81 = v78 - v79 + i
			local dateTime = DateTime.fromLocalTime(v77, v76, v81)

			table.insert(t4, React.createElement(CalendarDay, {
				highlight = v41(dateTime),
				isSelectable = v42(dateTime),
				isSelected = v40(dateTime),
				key = "prev-month-day-" .. v81,
				LayoutOrder = n4,
				onActivated = function() -- line: 380
					-- upvalues: v39 (copy), v81 (copy), v76 (copy), v77 (copy)
					v39(v81, v76, v77)
				end,
				Text = tostring(v81),
				testId = `{ t1.testId }--prev-month-calendar-day-{ v81 }`
			}))
			n4 += 1
		end

		for i = 1, DateTimeUtilities.getDaysInMonth(v32.month, v32.year) do
			local v84 = v42(DateTime.fromLocalTime(v32.year, v32.month, i))
			local v85 = v40(DateTime.fromLocalTime(v32.year, v32.month, i))

			table.insert(t4, React.createElement(CalendarDay, {
				emphasizeText = v84 and not v85,
				highlight = v41(DateTime.fromLocalTime(v32.year, v32.month, i)),
				isSelectable = v84,
				isSelected = v85,
				key = "current-month-day-" .. i,
				LayoutOrder = n4,
				onActivated = function() -- line: 411
					-- upvalues: v39 (copy), i (copy), v32 (copy)
					v39(i, v32.month, v32.year)
				end,
				Text = tostring(i),
				testId = `{ t1.testId }--current-month-calendar-day-{ i }`
			}))
			n4 += 1
		end

		local v86 = DateTimeUtilities.getLastDayOfWeek(v32.month, v32.year)
		local v87, v88 = DateTimeUtilities.getNextMonthInfo(v32.month, v32.year)
		local v89 = 7 - (v86 + 1)

		if v89 == 0 then
			v89 = 7
		end

		if v89 + #t4 < 50 then
			v89 += 50 - #t4 - v89
		end

		for i = 1, v89 do
			local dateTime = DateTime.fromLocalTime(v88, v87, i)

			table.insert(t4, React.createElement(CalendarDay, {
				highlight = v41(dateTime),
				isSelectable = v42(dateTime),
				isSelected = v40(dateTime),
				key = "next-month-day-" .. i,
				LayoutOrder = n4,
				onActivated = function() -- line: 449
					-- upvalues: v39 (copy), i (copy), v87 (copy), v88 (copy)
					v39(i, v87, v88)
				end,
				Text = tostring(i),
				testId = `{ t1.testId }--next-month-calendar-day-{ i }`
			}))
			n4 += 1
		end

		return t4
	end, {
		v40,
		v41,
		v42,
		v32,
		v23,
		v39,
		t1.selectableDateRange,
		t1.showEndDateTimeCalendarInput
	})
	local v46 = React.useCallback(function(p5) -- line: 474
		-- upvalues: v24 (copy), t1 (copy)
		local dateTime = DateTime.fromUnixTimestamp(p5)

		if os.date("*t", p5).isdst then
			local UnixTimestamp = dateTime.UnixTimestamp

			dateTime = DateTime.fromUnixTimestamp(UnixTimestamp - 3600)
		end

		v24({ dateTime })
		t1.onSelectedDateChanged({ dateTime })
	end, {
		v23,
		t1.onSelectedDateChanged
	})

	return React.createElement(View, {
		tag = "col auto-y",
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.fromOffset(v20, 0),
		testId = t1.testId
	}, {
		CalendarHeader = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-y-small"
		}, {
			PreviousMonthButton = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = Icon.ChevronSmallLeft,
				onActivated = v38,
				size = InputSize.Small,
				variant = ButtonVariant.Utility,
				testId = `{ t1.testId }--previous-month-button`
			}),
			MonthText = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "grow auto-xy text-align-x-right",
				Text = DateTimeUtilities.monthMap[v32.month],
				testId = `{ t1.testId }--month-text`
			}),
			YearText = React.createElement(Text, {
				LayoutOrder = 3,
				tag = "grow auto-xy text-align-x-left",
				Text = tostring(v32.year),
				testId = `{ t1.testId }--year-text`
			}),
			NextMonthButton = React.createElement(IconButton, {
				LayoutOrder = 4,
				isCircular = true,
				icon = Icon.ChevronSmallRight,
				onActivated = v37,
				size = InputSize.Small,
				variant = ButtonVariant.Utility,
				testId = `{ t1.testId }--next-month-button`
			})
		}),
		TimeDropdown = if not t1.showTimeDropdown then nil else React.createElement(TimeDropdown, {
			layoutOrder = 2,
			dateTime = v23[1],
			onItemChanged = v46,
			width = UDim.new(1, 0),
			testId = `{ t1.testId }--time-dropdown`
		}),
		CalendarInputContainer = if not t1.showStartDateTimeCalendarInput then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = "row flex-x-fill align-y-center gap-small size-full-0 auto-y",
			testId = `{ t1.testId }--input`
		}, {
			StartDateTime = React.createElement(TextInput, {
				label = "",
				LayoutOrder = 1,
				placeholder = "MM/DD/YYYY",
				hasError = v28 ~= "" and DateTimeUtilities.getDateTimeFromText(v28) == nil,
				onChanged = v43,
				onFocusLost = function() -- line: 106
					-- upvalues: DateTimeUtilities (copy), v28 (copy), v23 (copy), v29 (copy), v22 (copy)
					local v47 = DateTimeUtilities.getDateTimeFromText(v28)

					if not v47 and v23[1] or v47 and v23[2] and DateTimeUtilities.roundToStartOfDay(v47) > DateTimeUtilities.roundToStartOfDay(v23[2]) then
						v29(DateTimeUtilities.formatLocalTime(v22[1]))
					end
				end,
				size = InputSize.Medium,
				text = v28,
				onFocusGained = function() -- line: 557
					-- upvalues: v27 (copy)
					v27({
						startDateTimeInput = true,
						endDateTimeInput = false
					})
				end,
				testId = `{ t1.testId }--start-datetime-input`
			}),
			InputSeparator = if not t1.showEndDateTimeCalendarInput then nil else React.createElement(Text, {
				LayoutOrder = 2,
				tag = "auto-xy",
				Text = "-"
			}),
			EndDateTime = if not t1.showEndDateTimeCalendarInput then nil else React.createElement(TextInput, {
				label = "",
				LayoutOrder = 3,
				placeholder = "MM/DD/YYYY",
				hasError = v30 ~= "" and DateTimeUtilities.getDateTimeFromText(v30) == nil,
				isDisabled = not v23[1],
				onChanged = v44,
				onFocusGained = function() -- line: 577
					-- upvalues: v27 (copy)
					v27({
						startDateTimeInput = false,
						endDateTimeInput = true
					})
				end,
				onFocusLost = function() -- line: 125
					-- upvalues: DateTimeUtilities (copy), v30 (copy), v23 (copy), v31 (copy), v22 (copy)
					local v48 = DateTimeUtilities.getDateTimeFromText(v30)

					if not v48 and v23[2] or v48 and v23[1] and DateTimeUtilities.roundToStartOfDay(v48) < DateTimeUtilities.roundToStartOfDay(v23[1]) then
						v31(DateTimeUtilities.formatLocalTime(v22[2]))
					end
				end,
				size = InputSize.Medium,
				text = v30,
				textBoxRef = v25,
				testId = `{ t1.testId }--end-datetime-input`
			})
		}),
		WeekAndDates = React.createElement(View, {
			LayoutOrder = 4,
			tag = "size-full-0 auto-y",
			testId = `{ t1.testId }--weekAndDates`
		}, v45)
	})
end

return Calendar
