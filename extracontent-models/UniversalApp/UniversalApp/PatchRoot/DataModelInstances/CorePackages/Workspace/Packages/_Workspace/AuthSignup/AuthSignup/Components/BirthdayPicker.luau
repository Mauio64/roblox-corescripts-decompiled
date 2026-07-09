local Parent = script:FindFirstAncestor("AuthSignup").Parent
local LocalizationService = game:GetService("LocalizationService")
local Cryo = require(Parent.Cryo)
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local FitChildren = require(Parent.AuthCommon).Components.FitChildren
local ArgCheck = require(Parent.ArgCheck)
local TimeUnit = require(Parent.Time).TimeUnit
local DateTime = require(Parent.Time).DateTime
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(Parent.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(Parent.InputHandlers)
local withStyle = require(Parent.UIBlox).Style.withStyle
local withLocalization = require(Parent.Localization).withLocalization
local ScrollingPicker = require(Parent.AuthCommon).Components.ScrollingPicker
local DateHelper = require(Parent.Time).DateHelper
local GetFFlagSignUpBirthdayRefactorNestedDefinition = require(Parent.SharedFlags).GetFFlagSignUpBirthdayRefactorNestedDefinition
local GetFFlagSignUpBirthdayPickerRequireManualSelection = require(Parent.SharedFlags).GetFFlagSignUpBirthdayPickerRequireManualSelection
local _ = {
	Default = "Default",
	Emphasized = "Emphasized",
	Muted = "Muted"
}
local t1 = {}

for i = 1, 31 do
	table.insert(t1, i)
end

local t2 = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = FocusNavigationEventNameEnum.Confirm
}
local ReasonDateInvalid = DateHelper.ReasonDateInvalid
local MonthsLocalizationKeys = DateHelper.MonthsLocalizationKeys
local DateTypeOrder = DateHelper.DateTypeOrder

local function renderWheelContainer(p1, p2, p3) -- line: 71
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 200),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = not p2,
		[Roact.Ref] = p3
	}, p1)
end
local function buildEntries(t3: {[any]: any}, b1: boolean, s1: string) -- line: 83
	-- upvalues: Cryo (copy)
	if b1 then
		return Cryo.List.join({ s1 }, t3)
	end

	return t3
end

local v28 = Roact.PureComponent:extend("BirthdayPicker")

v28.defaultProps = {
	minAgeAllowed = 0,
	maxAgeAllowed = 99,
	NextSelectionUp = nil,
	NextSelectionDown = nil,
	skipUpdateOnMount = false,
	shouldExpandTapTarget = false,
	tapTargetExpansionSize = 0,
	requireManualSelection = false,
	placeholderTextMonth = "----",
	placeholderTextDay = "--",
	placeholderTextYear = "----"
}

local function useFocusNavigationBindings(p4) -- line: 106
	-- upvalues: ReactFocusNavigation (copy), t2 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v37 = ReactFocusNavigation.useEventMap(t2, p4)
	local v38 = React.useMemo(function() -- line: 108
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() -- line: 111
				end)
			}
		}
	end, {})

	return ReactFocusNavigation.useEventHandlerMap(v38, v37)
end

function v28.init(p5) -- line: 118
	-- upvalues: DateTime (copy), TimeUnit (copy), ArgCheck (copy), GetFFlagSignUpBirthdayPickerRequireManualSelection (copy), Roact (copy), withStyle (copy), GetFFlagSignUpBirthdayRefactorNestedDefinition (copy), renderWheelContainer (copy)
	p5.isMounted = false

	local Values = DateTime.now():GetValues()

	p5.currentDate = {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(Values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(Values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(Values.Year, "current year in BirthdayPicker")
	}

	local v41 = p5.currentDate[TimeUnit.Years]
	local minAgeAllowed = p5.props.minAgeAllowed
	local v43 = v41 - p5.props.maxAgeAllowed
	local v44 = v41 - minAgeAllowed
	local v45 = p5.props.requireManualSelection and GetFFlagSignUpBirthdayPickerRequireManualSelection()

	p5.dummyYears = {}

	if v45 then
		for i = v44, v43, -1 do
			table.insert(p5.dummyYears, i)
		end
	else
		for i = v43, v44 do
			table.insert(p5.dummyYears, i)
		end
	end

	p5.minYear = v43
	p5.maxYear = v44
	p5.placeholderOffset = not v45 and 0 or 1

	local initialMonth = p5.props.initialMonth
	local initialDay = p5.props.initialDay
	local initialYear = p5.props.initialYear
	local v51 = initialMonth ~= nil and (initialDay ~= nil and initialYear ~= nil)
	local v52 = not v45 or v51
	local v53 = if not v45 then #p5.dummyYears + -1 else 2
	local v54 = not v52 and 1 or 1 + p5.placeholderOffset
	local v55 = not v52 and 1 or 1 + p5.placeholderOffset
	local v56 = not v52 and 1 or v53 + p5.placeholderOffset
	local v57 = if not initialMonth then nil else initialMonth + p5.placeholderOffset
	local v58 = if not initialDay then nil else initialDay + p5.placeholderOffset
	local v59 = nil

	if initialYear then
		local v60 = math.clamp(initialYear, v43, v44)

		v59 = ((if not v45 then v60 - v43 + 1 else v44 - v60 + 1)) + p5.placeholderOffset
	end

	p5.state = {
		selectedMonthIndex = v57 or v54,
		selectedDayIndex = v58 or v55,
		selectedYearIndex = v59 or v56,
		continueButtonEnabled = v52,
		hasUserPickedMonth = v52,
		hasUserPickedDay = v52,
		hasUserPickedYear = v52
	}
	p5.datePickerRef = Roact.createRef()
	p5.defaultRef = Roact.createRef()
	p5.shouldExpandTapTarget = p5.props.shouldExpandTapTarget
	p5.tapTargetExpansionSize = p5.props.tapTargetExpansionSize

	function p5.renderEntryTextfunction(p6, p7) -- line: 205
		-- upvalues: withStyle (copy), Roact (copy)
		return withStyle(function(p8) -- line: 206
			-- upvalues: p7 (copy), Roact (copy), p6 (copy)
			local BodyFont = p8.Font.Body.Font
			local v151 = p8.Font.BaseSize * p8.Font.Body.RelativeSize
			local TextDefaultColor = p8.Theme.TextDefault.Color
			local TextDefaultTransparency = p8.Theme.TextDefault.Transparency

			if p7 == "Muted" then
				TextDefaultColor = p8.Theme.TextMuted.Color
				TextDefaultTransparency = p8.Theme.TextMuted.Transparency
			elseif p7 == "Emphasized" then
				BodyFont = p8.Font.Header1.Font
				v151 = p8.Font.BaseSize * p8.Font.Header1.RelativeSize
				TextDefaultColor = p8.Theme.TextEmphasis.Color
				TextDefaultTransparency = p8.Theme.TextEmphasis.Transparency
			end

			return Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = tostring(p6),
				Font = BodyFont,
				TextSize = v151,
				TextColor3 = TextDefaultColor,
				TextTransparency = TextDefaultTransparency
			})
		end)
	end
	function p5.renderWheelContainerFunction(p9) -- line: 236
		-- upvalues: Roact (copy), p5 (copy)
		return Roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 200),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = not p5.shouldExpandTapTarget,
			[Roact.Ref] = p5.props.focusNavigationRef
		}, p9)
	end

	if GetFFlagSignUpBirthdayRefactorNestedDefinition() then
		function p5.renderWheelContainerFunction(p10) -- line: 248
			-- upvalues: renderWheelContainer (copy), p5 (copy)
			return renderWheelContainer(p10, p5.shouldExpandTapTarget, p5.props.focusNavigationRef)
		end
	end

	local function makeChangeHandler(s2: string, s3: string) -- line: 255
		-- upvalues: p5 (copy)
		return function(p11, p12) -- line: 256
			-- upvalues: p5 (copy), s2 (copy), s3 (copy)
			local v156 = p11 ~= p5.state[s2]
			local v157 = p12 and (not p5.state[s3] and p11 > p5.placeholderOffset)

			if not v156 and not v157 then
				return
			end

			spawn(function() -- line: 266
				-- upvalues: p5 (copy), s2 (copy), p11 (copy), p12 (copy), s3 (copy)
				if not p5.isMounted then
					return
				end

				local t4 = {}

				if p5.state[s2] ~= p11 then
					t4[s2] = p11
				end

				if p12 and not p5.state[s3] and p11 > p5.placeholderOffset then
					t4[s3] = true
				end

				if next(t4) ~= nil then
					p5:setState(t4)
				end
			end)
		end
	end

	local s4 = "selectedMonthIndex"
	local s5 = "hasUserPickedMonth"

	function p5.onSelectedIndexChangedForMonth(p13, p14) -- line: 256
		-- upvalues: p5 (copy), s4 (copy), s5 (copy)
		local v137 = p13 ~= p5.state[s4]
		local v138 = p14 and (not p5.state[s5] and p13 > p5.placeholderOffset)

		if not v137 and not v138 then
			return
		end

		spawn(function() -- line: 266
			-- upvalues: p5 (copy), s4 (copy), p13 (copy), p14 (copy), s5 (copy)
			if not p5.isMounted then
				return
			end

			local t5 = {}

			if p5.state[s4] ~= p13 then
				t5[s4] = p13
			end

			if p14 and not p5.state[s5] and p13 > p5.placeholderOffset then
				t5[s5] = true
			end

			if next(t5) ~= nil then
				p5:setState(t5)
			end
		end)
	end

	local s6 = "selectedDayIndex"
	local s7 = "hasUserPickedDay"

	function p5.onSelectedIndexChangedForDay(p15, p16) -- line: 256
		-- upvalues: p5 (copy), s6 (copy), s7 (copy)
		local v141 = p15 ~= p5.state[s6]
		local v142 = p16 and (not p5.state[s7] and p15 > p5.placeholderOffset)

		if not v141 and not v142 then
			return
		end

		spawn(function() -- line: 266
			-- upvalues: p5 (copy), s6 (copy), p15 (copy), p16 (copy), s7 (copy)
			if not p5.isMounted then
				return
			end

			local t6 = {}

			if p5.state[s6] ~= p15 then
				t6[s6] = p15
			end

			if p16 and not p5.state[s7] and p15 > p5.placeholderOffset then
				t6[s7] = true
			end

			if next(t6) ~= nil then
				p5:setState(t6)
			end
		end)
	end

	local s8 = "selectedYearIndex"
	local s9 = "hasUserPickedYear"

	function p5.onSelectedIndexChangedForYear(p17, p18) -- line: 256
		-- upvalues: p5 (copy), s8 (copy), s9 (copy)
		local v145 = p17 ~= p5.state[s8]
		local v146 = p18 and (not p5.state[s9] and p17 > p5.placeholderOffset)

		if not v145 and not v146 then
			return
		end

		spawn(function() -- line: 266
			-- upvalues: p5 (copy), s8 (copy), p17 (copy), p18 (copy), s9 (copy)
			if not p5.isMounted then
				return
			end

			local t7 = {}

			if p5.state[s8] ~= p17 then
				t7[s8] = p17
			end

			if p18 and not p5.state[s9] and p17 > p5.placeholderOffset then
				t7[s9] = true
			end

			if next(t7) ~= nil then
				p5:setState(t7)
			end
		end)
	end
	function p5.onActivated(_) -- line: 288
		-- upvalues: p5 (copy)
		if p5.props.focusedGuiObject and (p5.datePickerRef and p5.defaultRef.current) then
			p5.props.focusGuiObject(p5.defaultRef.current, true)
		end
	end
	function p5.onEntryActivated() -- line: 294
		-- upvalues: p5 (copy)
		if p5.props.focusedGuiObject and (p5.datePickerRef and p5.datePickerRef.current) then
			p5.props.focusGuiObject(p5.datePickerRef.current, true)
		end
	end
end
function v28.getActualIndex(t8: {[any]: any}, s10: string, s11: string, n1: number) -- line: 303
	if not t8.state[s10] then
		return nil
	end

	local v72 = t8.state[s11] - t8.placeholderOffset

	if v72 < 1 or n1 < v72 then
		return nil
	end

	return v72
end
function v28.getActualMonth(p20) -- line: 314
	-- upvalues: MonthsLocalizationKeys (copy)
	return p20:getActualIndex("hasUserPickedMonth", "selectedMonthIndex", #MonthsLocalizationKeys)
end
function v28.getActualDay(p21) -- line: 318
	-- upvalues: t1 (copy)
	return p21:getActualIndex("hasUserPickedDay", "selectedDayIndex", #t1)
end
function v28.getActualYear(p22) -- line: 322
	local v76 = p22:getActualIndex("hasUserPickedYear", "selectedYearIndex", #p22.dummyYears)

	if v76 then
		return p22.dummyYears[v76]
	end

	return nil
end
function v28.didMount(p23) -- line: 327
	local updateBirthday = p23.props.updateBirthday

	if updateBirthday and not p23.props.skipUpdateOnMount then
		updateBirthday(p23:getActualMonth(), p23:getActualDay(), p23:getActualYear())
	end

	if p23.props.focusedGuiObject and p23.datePickerRef and p23.datePickerRef.current then
		p23.props.focusGuiObject(p23.datePickerRef.current, true)
	end

	p23.isMounted = true
end
function v28.willUnmount(p24) -- line: 341
	p24.isMounted = false
end
function v28.updatePickerState(p25) -- line: 345
	-- upvalues: DateHelper (copy), ReasonDateInvalid (copy)
	local v81 = p25:getActualMonth()
	local v82 = p25:getActualDay()
	local v83 = p25:getActualYear()
	local v84 = v81 ~= nil and (v82 ~= nil and v83 ~= nil)
	local u85 = false
	local u86 = nil
	local u87 = false

	if v84 then
		local v88, v89 = DateHelper:isValidDate(v81, v82, v83)

		u87 = v88

		if not u87 and v89 == ReasonDateInvalid.IsInvalidDayOfMonth then
			u85 = true
			u86 = DateHelper:getLastDayOfTheMonthInYear(v81, v83) + p25.placeholderOffset
		end
	end

	spawn(function() -- line: 365
		-- upvalues: p25 (copy), u85 (ref), u86 (ref), v84 (copy), u87 (ref)
		if p25.isMounted then
			p25:setState({
				selectedDayIndex = u85 and u86 or nil,
				continueButtonEnabled = v84 and u87
			})
		end
	end)
end
function v28.didUpdate(p26) -- line: 375
	-- upvalues: DateHelper (copy), ReasonDateInvalid (copy)
	local updateBirthday = p26.props.updateBirthday
	local v92 = p26:getActualMonth()
	local v93 = p26:getActualDay()
	local v94 = p26:getActualYear()
	local continueButtonEnabled = p26.state.continueButtonEnabled
	local v96 = false
	local v97 = nil

	if v92 ~= nil and (v93 ~= nil and v94 ~= nil) then
		v96, v97 = DateHelper:isValidDate(v92, v93, v94)
	end

	local v98 = not v96 and v97 == ReasonDateInvalid.IsInvalidDayOfMonth

	if v96 ~= continueButtonEnabled or v98 then
		p26:updatePickerState()
	end

	if updateBirthday then
		updateBirthday(v92, v93, v94)
	end
end
function v28.render(p27) -- line: 402
	-- upvalues: LocalizationService (copy), DateTypeOrder (copy), GetFFlagSignUpBirthdayPickerRequireManualSelection (copy), MonthsLocalizationKeys (copy), Cryo (copy), t1 (copy), withStyle (copy), withLocalization (copy), Roact (copy), FitChildren (copy), ScrollingPicker (copy), TimeUnit (copy), DateHelper (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v101 = DateTypeOrder[RobloxLocaleId]
	local v102 = not p27.shouldExpandTapTarget or p27.tapTargetExpansionSize <= 0
	local layoutOrder = p27.props.layoutOrder
	local v104 = p27.props.requireManualSelection and GetFFlagSignUpBirthdayPickerRequireManualSelection()
	local placeholderTextMonth = p27.props.placeholderTextMonth
	local placeholderTextDay = p27.props.placeholderTextDay
	local placeholderTextYear = p27.props.placeholderTextYear
	local v108 = MonthsLocalizationKeys
	local v109 = if not v104 then v108 else Cryo.List.join({ placeholderTextMonth }, v108)
	local v110 = t1
	local v111 = if not v104 then v110 else Cryo.List.join({ placeholderTextDay }, v110)
	local dummyYears = p27.dummyYears
	local v113 = if not v104 then dummyYears else Cryo.List.join({ placeholderTextYear }, dummyYears)
	local selectedMonthIndex = p27.state.selectedMonthIndex
	local selectedDayIndex = p27.state.selectedDayIndex
	local selectedYearIndex = p27.state.selectedYearIndex
	local v117 = (not v104 or not p27.state.hasUserPickedMonth) and 1 or 2
	local v118 = (not v104 or not p27.state.hasUserPickedDay) and 1 or 2
	local v119 = (not v104 or not p27.state.hasUserPickedYear) and 1 or 2
	local v120 = p27:getActualMonth()
	local v121 = p27:getActualYear()
	local hasUserPickedMonth = p27.state.hasUserPickedMonth
	local hasUserPickedDay = p27.state.hasUserPickedDay
	local hasUserPickedYear = p27.state.hasUserPickedYear

	return withStyle(function(_) -- line: 435
		-- upvalues: withLocalization (copy), Roact (copy), FitChildren (copy), layoutOrder (copy), p27 (copy), v102 (copy), ScrollingPicker (copy), v101 (copy), TimeUnit (copy), placeholderTextMonth (copy), hasUserPickedMonth (copy), withStyle (copy), v109 (copy), selectedMonthIndex (copy), v117 (copy), hasUserPickedDay (copy), placeholderTextDay (copy), DateHelper (copy), v111 (copy), selectedDayIndex (copy), RobloxLocaleId (copy), v120 (copy), v121 (copy), v118 (copy), hasUserPickedYear (copy), placeholderTextYear (copy), v113 (copy), selectedYearIndex (copy), v119 (copy)
		return withLocalization({
			continueText = "Authentication.SignUp.Label.Continue"
		})(function(_) -- line: 438
			-- upvalues: Roact (copy), FitChildren (copy), layoutOrder (copy), p27 (copy), v102 (copy), ScrollingPicker (copy), v101 (copy), TimeUnit (copy), placeholderTextMonth (copy), hasUserPickedMonth (copy), withStyle (copy), withLocalization (copy), v109 (copy), selectedMonthIndex (copy), v117 (copy), hasUserPickedDay (copy), placeholderTextDay (copy), DateHelper (copy), v111 (copy), selectedDayIndex (copy), RobloxLocaleId (copy), v120 (copy), v121 (copy), v118 (copy), hasUserPickedYear (copy), placeholderTextYear (copy), v113 (copy), selectedYearIndex (copy), v119 (copy)
			return Roact.createElement(FitChildren.FitFrame, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 14)
				}),
				DatePickerWrap = Roact.createElement(FitChildren.FitFrame, {
					LayoutOrder = 1,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				}, {
					CenterFrame = Roact.createElement("ImageLabel", {
						Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/DatePickerDivider.png",
						BackgroundTransparency = 1,
						ZIndex = 2,
						Size = UDim2.new(1, 0, 0, 50),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 4, 4),
						Position = UDim2.new(0, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5)
					}),
					DatePicker = Roact.createElement(FitChildren.FitTextButton, {
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Selectable = true,
						NextSelectionUp = p27.props.NextSelectionUp,
						NextSelectionDown = p27.props.NextSelectionDown,
						NextSelectionLeft = p27.datePickerRef.current,
						NextSelectionRight = p27.datePickerRef.current,
						Text = "",
						[Roact.Ref] = p27.datePickerRef,
						[Roact.Event.Activated] = p27.onActivated
					}, {
						ListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						WheelContainer = p27.renderWheelContainerFunction({
							ListLayout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = if not v102 then nil else Enum.VerticalAlignment.Center
							}),
							Padding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 5),
								PaddingRight = UDim.new(0, 5),
								PaddingTop = UDim.new(0, 5),
								PaddingBottom = UDim.new(0, 5)
							}),
							MonthWheel = Roact.createElement(ScrollingPicker, {
								entrySizeOnScrollingAxis = 50,
								layoutOrder = v101[TimeUnit.Months],
								size = UDim2.new(0.45, 0, 0, 200),
								renderEntry = function(p30) -- line: 503
									-- upvalues: placeholderTextMonth (copy), hasUserPickedMonth (copy), p27 (copy), withStyle (copy), withLocalization (copy), v109 (copy), selectedMonthIndex (copy)
									if p30 == placeholderTextMonth then
										if hasUserPickedMonth then
											return p27.renderEntryTextfunction("", "Default")
										end

										return p27.renderEntryTextfunction(placeholderTextMonth, "Muted")
									end

									return withStyle(function(_) -- line: 512
										-- upvalues: withLocalization (copy), p30 (copy), v109 (copy), selectedMonthIndex (copy), hasUserPickedMonth (copy), p27 (copy)
										return withLocalization({
											monthText = p30
										})(function(p32) -- line: 515
											-- upvalues: v109 (copy), selectedMonthIndex (copy), p30 (copy), hasUserPickedMonth (copy), p27 (copy)
											local s12 = "Default"

											if v109[selectedMonthIndex] == p30 and hasUserPickedMonth then
												s12 = "Emphasized"
											end

											return p27.renderEntryTextfunction(p32.monthText, s12)
										end)
									end)
								end,
								getEntryWrapperProps = function(p33) -- line: 531
									-- upvalues: v109 (copy), selectedMonthIndex (copy), Roact (copy), p27 (copy)
									local v165 = v109[selectedMonthIndex]

									return {
										[Roact.Ref] = if p33 ~= v165 then nil else p27.defaultRef
									}
								end,
								entries = v109,
								onSelectedIndexChanged = p27.onSelectedIndexChangedForMonth,
								parentSpecifiedTarget = selectedMonthIndex,
								minTargetIndex = v117,
								onEntryActivated = p27.onEntryActivated,
								shouldExpandTapTarget = p27.shouldExpandTapTarget,
								tapTargetExpansionSize = p27.tapTargetExpansionSize
							}),
							DayWheel = Roact.createElement(ScrollingPicker, {
								entrySizeOnScrollingAxis = 50,
								layoutOrder = v101[TimeUnit.Days],
								size = UDim2.new(0.2, 0, 0, 200),
								renderEntry = function(p34) -- line: 549
									-- upvalues: hasUserPickedDay (copy), p27 (copy), placeholderTextDay (copy), withLocalization (copy), DateHelper (copy), v111 (copy), selectedDayIndex (copy), RobloxLocaleId (copy), v120 (copy), v121 (copy)
									if type(p34) ~= "number" then
										if hasUserPickedDay then
											return p27.renderEntryTextfunction("", "Default")
										end

										return p27.renderEntryTextfunction(placeholderTextDay, "Muted")
									end

									return withLocalization({
										dayAffix = DateHelper.DayAffixLocalizationKey
									})(function(p35) -- line: 558
										-- upvalues: v111 (copy), selectedDayIndex (copy), p34 (copy), DateHelper (copy), RobloxLocaleId (copy), v120 (copy), v121 (copy), hasUserPickedDay (copy), p27 (copy)
										local v170 = v111[selectedDayIndex] == p34
										local FormattedDayString = DateHelper:GetFormattedDayString(p34, p35.dayAffix, RobloxLocaleId)
										local s13 = "Default"

										if v120 and (v121 and DateHelper:isInvalidDayOfTheMonth(v120, p34, v121)) then
											s13 = "Muted"
										elseif v170 and hasUserPickedDay then
											s13 = "Emphasized"
										end

										return p27.renderEntryTextfunction(FormattedDayString, s13)
									end)
								end,
								entries = v111,
								onSelectedIndexChanged = p27.onSelectedIndexChangedForDay,
								parentSpecifiedTarget = selectedDayIndex,
								minTargetIndex = v118,
								onEntryActivated = p27.onEntryActivated,
								shouldExpandTapTarget = p27.shouldExpandTapTarget,
								tapTargetExpansionSize = p27.tapTargetExpansionSize
							}),
							YearWheel = Roact.createElement(ScrollingPicker, {
								entrySizeOnScrollingAxis = 50,
								layoutOrder = v101[TimeUnit.Years],
								size = UDim2.new(0.35, 0, 0, 200),
								renderEntry = function(p36) -- line: 593
									-- upvalues: hasUserPickedYear (copy), p27 (copy), placeholderTextYear (copy), withLocalization (copy), DateHelper (copy), v113 (copy), selectedYearIndex (copy), RobloxLocaleId (copy)
									if type(p36) ~= "number" then
										if hasUserPickedYear then
											return p27.renderEntryTextfunction("", "Default")
										end

										return p27.renderEntryTextfunction(placeholderTextYear, "Muted")
									end

									return withLocalization({
										yearAffix = DateHelper.YearAffixLocalizationKey
									})(function(p37) -- line: 602
										-- upvalues: v113 (copy), selectedYearIndex (copy), p36 (copy), DateHelper (copy), RobloxLocaleId (copy), hasUserPickedYear (copy), p27 (copy)
										local v174 = v113[selectedYearIndex] == p36
										local FormattedYearString = DateHelper:GetFormattedYearString(p36, p37.yearAffix, RobloxLocaleId)
										local s14 = "Default"

										if v174 and hasUserPickedYear then
											s14 = "Emphasized"
										end

										return p27.renderEntryTextfunction(FormattedYearString, s14)
									end)
								end,
								entries = v113,
								onSelectedIndexChanged = p27.onSelectedIndexChangedForYear,
								parentSpecifiedTarget = selectedYearIndex,
								minTargetIndex = v119,
								onEntryActivated = p27.onEntryActivated,
								shouldExpandTapTarget = p27.shouldExpandTapTarget,
								tapTargetExpansionSize = p27.tapTargetExpansionSize
							})
						})
					})
				})
			})
		end)
	end)
end

return function(p38) -- line: 635
	-- upvalues: ReactFocusNavigation (copy), useFocusNavigationBindings (copy), Roact (copy), v28 (copy), Cryo (copy)
	local v126 = ReactFocusNavigation.useFocusedGuiObject()
	local v127 = ReactFocusNavigation.useFocusGuiObject()
	local v128 = useFocusNavigationBindings(nil)

	return Roact.createElement(v28, Cryo.Dictionary.join(p38, {
		focusedGuiObject = v126,
		focusGuiObject = v127,
		focusNavigationRef = v128
	}))
end
