local parent = script:FindFirstAncestor("AuthSignup").Parent
local LocalizationService = game:GetService("LocalizationService")

local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)
local React = require(parent.React)
local AuthCommon = require(parent.AuthCommon)
local FitChildren = AuthCommon.Components.FitChildren
local ArgCheck = require(parent.ArgCheck)
local Time = require(parent.Time)
local TimeUnit = Time.TimeUnit
local Time2 = require(parent.Time)
local DateTime = Time2.DateTime
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local AuthCommon2 = require(parent.AuthCommon)
local ScrollingPicker = AuthCommon2.Components.ScrollingPicker
local Time3 = require(parent.Time)
local DateHelper = Time3.DateHelper

local SharedFlags = require(parent.SharedFlags)
local GetFFlagSignUpBirthdayRefactorNestedDefinition = SharedFlags.GetFFlagSignUpBirthdayRefactorNestedDefinition

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagSignUpBirthdayPickerRequireManualSelection = SharedFlags2.GetFFlagSignUpBirthdayPickerRequireManualSelection

local _ = { Default = "Default", Emphasized = "Emphasized", Muted = "Muted" }

local v = {}

for i = 1, 31 do
	table.insert(v, i)
end

local confirms = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = FocusNavigationEventNameEnum.Confirm
}

local ReasonDateInvalid = DateHelper.ReasonDateInvalid
local MonthsLocalizationKeys = DateHelper.MonthsLocalizationKeys
local DateTypeOrder = DateHelper.DateTypeOrder

local function renderWheelContainer(p, shouldExpandTapTarget, focusNavigationRef)
	return Roact.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 200),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = not shouldExpandTapTarget,
		[Roact.Ref] = focusNavigationRef
	}, p)
end

local function buildEntries(p, flag: boolean, p2: string) -- 3 equivalent calls inferred from this helper
	if flag then
		return Cryo.List.join({ p2 }, p)
	end

	return p
end

local extended = Roact.PureComponent:extend("BirthdayPicker")

extended.defaultProps = {
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

local function useFocusNavigationBindings(p)
	local v2 = ReactFocusNavigation.useEventMap(confirms, p)
	local v3 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() end)
			}
		}
	end, {})
	return ReactFocusNavigation.useEventHandlerMap(v3, v2)
end

function extended:init()
	self.isMounted = false

	local values = DateTime.now():GetValues()

	self.currentDate = {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}

	local v2 = self.currentDate[TimeUnit.Years]
	local minAgeAllowed = self.props.minAgeAllowed
	local minYear = v2 - self.props.maxAgeAllowed
	local maxYear = v2 - minAgeAllowed

	local v3 = self.props.requireManualSelection and GetFFlagSignUpBirthdayPickerRequireManualSelection()

	self.dummyYears = {}

	if v3 then
		for i = maxYear, minYear, -1 do
			table.insert(self.dummyYears, i)
		end
	else
		for i = minYear, maxYear do
			table.insert(self.dummyYears, i)
		end
	end

	self.minYear = minYear
	self.maxYear = maxYear

	self.placeholderOffset = v3 and 1 or 0

	local initialMonth = self.props.initialMonth
	local initialDay = self.props.initialDay
	local initialYear = self.props.initialYear
	local v4 = initialMonth ~= nil and initialDay ~= nil and initialYear ~= nil
	local v5 = not v3 or v4

	local v6 = v3 and 2 or #self.dummyYears + -1

	local v7 = not v5 and 1 or 1 + self.placeholderOffset
	local v8 = not v5 and 1 or 1 + self.placeholderOffset
	local v9 = not v5 and 1 or v6 + self.placeholderOffset
	local v10

	if initialMonth then
		v10 = initialMonth + self.placeholderOffset
	end

	local v11

	if initialDay then
		v11 = initialDay + self.placeholderOffset
	end

	local v12

	if initialYear then
		local v13 = math.clamp(initialYear, minYear, maxYear)
		local v14

		if v3 then
			v14 = maxYear - v13 + 1
		else
			v14 = v13 - minYear + 1
		end

		v12 = v14 + self.placeholderOffset
	end

	self.state = {
		selectedMonthIndex = v10 or v7,
		selectedDayIndex = v11 or v8,
		selectedYearIndex = v12 or v9,
		continueButtonEnabled = v5,
		hasUserPickedMonth = v5,
		hasUserPickedDay = v5,
		hasUserPickedYear = v5
	}
	self.datePickerRef = Roact.createRef()
	self.defaultRef = Roact.createRef()

	self.shouldExpandTapTarget = self.props.shouldExpandTapTarget
	self.tapTargetExpansionSize = self.props.tapTargetExpansionSize

	function self.renderEntryTextfunction(p, p2)
		return withStyle(function(p3)
			local font = p3.Font.Body.Font
			local textSize = p3.Font.BaseSize * p3.Font.Body.RelativeSize
			local color = p3.Theme.TextDefault.Color
			local transparency = p3.Theme.TextDefault.Transparency

			if p2 == "Muted" then
				color = p3.Theme.TextMuted.Color
				transparency = p3.Theme.TextMuted.Transparency
			elseif p2 == "Emphasized" then
				font = p3.Font.Header1.Font
				textSize = p3.Font.BaseSize * p3.Font.Header1.RelativeSize
				color = p3.Theme.TextEmphasis.Color
				transparency = p3.Theme.TextEmphasis.Transparency
			end

			return Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = tostring(p),
				Font = font,
				TextSize = textSize,
				TextColor3 = color,
				TextTransparency = transparency
			})
		end)
	end

	function self.renderWheelContainerFunction(p)
		return Roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 200),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = not self.shouldExpandTapTarget,
			[Roact.Ref] = self.props.focusNavigationRef
		}, p)
	end

	if GetFFlagSignUpBirthdayRefactorNestedDefinition() then
		function self.renderWheelContainerFunction(p)
			return renderWheelContainer(p, self.shouldExpandTapTarget, self.props.focusNavigationRef)
		end
	end

	local function makeChangeHandler(p: string, p2: string) -- 3 equivalent calls inferred from this helper
		return function(p3, p4)
			local v13 = self.state[p] ~= p3

			local v14 = p4 and not self.state[p2] and self.placeholderOffset < p3

			if v13 or v14 then
				spawn(function()
					if not self.isMounted then
						return
					end

					local v15 = {}

					if self.state[p] ~= p3 then
						v15[p] = p3
					end

					if p4 and not self.state[p2] and p3 > self.placeholderOffset then
						v15[p2] = true
					end

					if next(v15) ~= nil then
						self:setState(v15)
					end
				end)
			end
		end
	end

	self.onSelectedIndexChangedForMonth = makeChangeHandler("selectedMonthIndex", "hasUserPickedMonth") -- inferred equivalent call
	self.onSelectedIndexChangedForDay = makeChangeHandler("selectedDayIndex", "hasUserPickedDay") -- inferred equivalent call
	self.onSelectedIndexChangedForYear = makeChangeHandler("selectedYearIndex", "hasUserPickedYear") -- inferred equivalent call

	function self.onActivated(_)
		if self.props.focusedGuiObject and self.datePickerRef and self.defaultRef.current then
			self.props.focusGuiObject(self.defaultRef.current, true)
		end
	end

	function self.onEntryActivated()
		if self.props.focusedGuiObject and self.datePickerRef and self.datePickerRef.current then
			self.props.focusGuiObject(self.datePickerRef.current, true)
		end
	end
end

function extended:getActualIndex(p: string, p2: string, p3: number)
	if not self.state[p] then
		return nil
	end

	local v2 = self.state[p2] - self.placeholderOffset
	return if not (v2 < 1 or p3 < v2) then v2 else nil
end

function extended:getActualMonth()
	return self:getActualIndex("hasUserPickedMonth", "selectedMonthIndex", #MonthsLocalizationKeys)
end

function extended:getActualDay()
	return self:getActualIndex("hasUserPickedDay", "selectedDayIndex", #v)
end

function extended:getActualYear()
	local actualIndex = self:getActualIndex("hasUserPickedYear", "selectedYearIndex", #self.dummyYears)

	if actualIndex then
		return self.dummyYears[actualIndex]
	end

	return nil
end

function extended:didMount()
	local updateBirthday = self.props.updateBirthday

	if updateBirthday and not self.props.skipUpdateOnMount then
		updateBirthday(self:getActualMonth(), self:getActualDay(), self:getActualYear())
	end

	if self.props.focusedGuiObject and self.datePickerRef and self.datePickerRef.current then
		self.props.focusGuiObject(self.datePickerRef.current, true)
	end

	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:updatePickerState()
	local actualMonth = self:getActualMonth()
	local actualDay = self:getActualDay()
	local actualYear = self:getActualYear()
	local v2

	if actualMonth == nil or actualDay == nil then
		v2 = false
	else
		v2 = actualYear ~= nil
	end

	local v3 = false
	local v4 = nil
	local v5

	if v2 then
		local v6
		v5, v6 = DateHelper:isValidDate(actualMonth, actualDay, actualYear)

		if not v5 and v6 == ReasonDateInvalid.IsInvalidDayOfMonth then
			v4 = DateHelper:getLastDayOfTheMonthInYear(actualMonth, actualYear) + self.placeholderOffset
			v3 = true
		end
	else
		v5 = false
	end

	spawn(function()
		if self.isMounted then
			self:setState({
				selectedDayIndex = v3 and v4 or nil,
				continueButtonEnabled = v2 and v5
			})
		end
	end)
end

function extended:didUpdate()
	local updateBirthday = self.props.updateBirthday
	local actualMonth = self:getActualMonth()
	local actualDay = self:getActualDay()
	local actualYear = self:getActualYear()
	local continueButtonEnabled = self.state.continueButtonEnabled
	local v2

	if actualMonth == nil or actualDay == nil then
		v2 = false
	else
		v2 = actualYear ~= nil
	end

	local v3, v4

	if v2 then
		v3, v4 = DateHelper:isValidDate(actualMonth, actualDay, actualYear)
	else
		v3 = false
	end

	local v5 = not v3 and v4 == ReasonDateInvalid.IsInvalidDayOfMonth

	if v3 ~= continueButtonEnabled or v5 then
		self:updatePickerState()
	end

	if updateBirthday then
		updateBirthday(actualMonth, actualDay, actualYear)
	end
end

function extended:render()
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v2 = DateTypeOrder[robloxLocaleId]

	local v3 = not self.shouldExpandTapTarget or self.tapTargetExpansionSize <= 0

	local layoutOrder = self.props.layoutOrder

	local v4 = self.props.requireManualSelection and GetFFlagSignUpBirthdayPickerRequireManualSelection()
	local placeholderTextMonth = self.props.placeholderTextMonth
	local placeholderTextDay = self.props.placeholderTextDay
	local placeholderTextYear = self.props.placeholderTextYear
	local entries = buildEntries(MonthsLocalizationKeys, v4, placeholderTextMonth) -- inferred equivalent call
	local entries2 = buildEntries(v, v4, placeholderTextDay) -- inferred equivalent call
	local entries3 = buildEntries(self.dummyYears, v4, placeholderTextYear) -- inferred equivalent call

	local selectedMonthIndex = self.state.selectedMonthIndex
	local selectedDayIndex = self.state.selectedDayIndex
	local selectedYearIndex = self.state.selectedYearIndex

	local minTargetIndex = v4 and self.state.hasUserPickedMonth and 2 or 1
	local minTargetIndex2 = v4 and self.state.hasUserPickedDay and 2 or 1
	local minTargetIndex3 = v4 and self.state.hasUserPickedYear and 2 or 1

	local actualMonth = self:getActualMonth()
	local actualYear = self:getActualYear()
	local hasUserPickedMonth = self.state.hasUserPickedMonth
	local hasUserPickedDay = self.state.hasUserPickedDay
	local hasUserPickedYear = self.state.hasUserPickedYear

	return withStyle(function(_)
		return withLocalization({ continueText = "Authentication.SignUp.Label.Continue" })(function(_)
			local createElement = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v5 = {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}

			local v6 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 14)
				}),
				DatePickerWrap = 0
			}

			local createElement2 = Roact.createElement
			local fitFrame2 = FitChildren.FitFrame
			local v7 = {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}

			local v8 = {
				CenterFrame = Roact.createElement("ImageLabel", {
					Size = UDim2.new(1, 0, 0, 50),
					Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/DatePickerDivider.png",
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 4, 4),
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					ZIndex = 2
				}),
				DatePicker = 0
			}

			local createElement3 = Roact.createElement
			local fitTextButton = FitChildren.FitTextButton
			local v9 = {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Selectable = true,
				NextSelectionUp = self.props.NextSelectionUp,
				NextSelectionDown = self.props.NextSelectionDown,
				NextSelectionLeft = self.datePickerRef.current,
				NextSelectionRight = self.datePickerRef.current,
				Text = "",
				[Roact.Ref] = self.datePickerRef,
				[Roact.Event.Activated] = self.onActivated
			}
			local v10 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				WheelContainer = 0
			}

			local renderWheelContainerFunction = self.renderWheelContainerFunction
			local createElement4 = Roact.createElement
			local v11 = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = 0
			}
			local verticalAlignment

			if v3 then
				verticalAlignment = Enum.VerticalAlignment.Center
			end

			v11.VerticalAlignment = verticalAlignment
			v10.WheelContainer = renderWheelContainerFunction({
				ListLayout = createElement4("UIListLayout", v11),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingRight = UDim.new(0, 5),
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				MonthWheel = Roact.createElement(ScrollingPicker, {
					layoutOrder = v2[TimeUnit.Months],
					size = UDim2.new(0.45, 0, 0, 200),
					renderEntry = function(monthText)
						if monthText ~= placeholderTextMonth then
							return withStyle(function(_)
								return withLocalization({ monthText = monthText })(function(p)
									local v12 = monthText == entries[selectedMonthIndex]
										and hasUserPickedMonth
										and "Emphasized"
										or "Default"

									return self.renderEntryTextfunction(p.monthText, v12)
								end)
							end)
						end

						if hasUserPickedMonth then
							return self.renderEntryTextfunction("", "Default")
						end

						return self.renderEntryTextfunction(placeholderTextMonth, "Muted")
					end,
					getEntryWrapperProps = function(p)
						local entry = entries[selectedMonthIndex]

						local ref = Roact.Ref
						local v12

						if p == entry then
							v12 = self.defaultRef
						end

						return { [ref] = v12 }
					end,
					entries = entries,
					entrySizeOnScrollingAxis = 50,
					onSelectedIndexChanged = self.onSelectedIndexChangedForMonth,
					parentSpecifiedTarget = selectedMonthIndex,
					minTargetIndex = minTargetIndex,
					onEntryActivated = self.onEntryActivated,
					shouldExpandTapTarget = self.shouldExpandTapTarget,
					tapTargetExpansionSize = self.tapTargetExpansionSize
				}),
				DayWheel = Roact.createElement(ScrollingPicker, {
					layoutOrder = v2[TimeUnit.Days],
					size = UDim2.new(0.2, 0, 0, 200),
					renderEntry = function(value)
						if type(value) == "number" then
							return withLocalization({
								dayAffix = DateHelper.DayAffixLocalizationKey
							})(function(p)
								local v12 = value == entries2[selectedDayIndex]

								local formattedDayString = DateHelper:GetFormattedDayString(
									value,
									p.dayAffix,
									robloxLocaleId
								)

								local v13 = actualMonth
									and actualYear
									and DateHelper:isInvalidDayOfTheMonth(actualMonth, value, actualYear)
									and "Muted"
									or v12 and hasUserPickedDay and "Emphasized"
									or "Default"

								return self.renderEntryTextfunction(formattedDayString, v13)
							end)
						end

						if hasUserPickedDay then
							return self.renderEntryTextfunction("", "Default")
						end

						return self.renderEntryTextfunction(placeholderTextDay, "Muted")
					end,
					entries = entries2,
					entrySizeOnScrollingAxis = 50,
					onSelectedIndexChanged = self.onSelectedIndexChangedForDay,
					parentSpecifiedTarget = selectedDayIndex,
					minTargetIndex = minTargetIndex2,
					onEntryActivated = self.onEntryActivated,
					shouldExpandTapTarget = self.shouldExpandTapTarget,
					tapTargetExpansionSize = self.tapTargetExpansionSize
				}),
				YearWheel = Roact.createElement(ScrollingPicker, {
					layoutOrder = v2[TimeUnit.Years],
					size = UDim2.new(0.35, 0, 0, 200),
					renderEntry = function(value)
						if type(value) == "number" then
							return withLocalization({
								yearAffix = DateHelper.YearAffixLocalizationKey
							})(function(p)
								local v12 = value == entries3[selectedYearIndex]

								local formattedYearString = DateHelper:GetFormattedYearString(
									value,
									p.yearAffix,
									robloxLocaleId
								)

								return self.renderEntryTextfunction(
									formattedYearString,
									v12 and hasUserPickedYear and "Emphasized" or "Default"
								)
							end)
						end

						if hasUserPickedYear then
							return self.renderEntryTextfunction("", "Default")
						end

						return self.renderEntryTextfunction(placeholderTextYear, "Muted")
					end,
					entries = entries3,
					entrySizeOnScrollingAxis = 50,
					onSelectedIndexChanged = self.onSelectedIndexChangedForYear,
					parentSpecifiedTarget = selectedYearIndex,
					minTargetIndex = minTargetIndex3,
					onEntryActivated = self.onEntryActivated,
					shouldExpandTapTarget = self.shouldExpandTapTarget,
					tapTargetExpansionSize = self.tapTargetExpansionSize
				})
			})
			v8.DatePicker = createElement3(fitTextButton, v9, v10)
			v6.DatePickerWrap = createElement2(fitFrame2, v7, v8)
			return createElement(fitFrame, v5, v6)
		end)
	end)
end

return function(p)
	local focusedGuiObject = ReactFocusNavigation.useFocusedGuiObject()
	local focusGuiObject = ReactFocusNavigation.useFocusGuiObject()
	local focusNavigationRef = useFocusNavigationBindings(nil)
	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p, {
			focusedGuiObject = focusedGuiObject,
			focusGuiObject = focusGuiObject,
			focusNavigationRef = focusNavigationRef
		})
	)
end
