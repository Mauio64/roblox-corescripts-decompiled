local LocalizationService = game:GetService("LocalizationService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Cryo")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local fitChildren = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon").Components.FitChildren
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/ArgCheck")
local timeUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Time").TimeUnit
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Time").DateTime
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/ReactFocusNavigation")

local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/FocusNavigationUtils").FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/InputHandlers")

local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/UIBlox").Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Localization").withLocalization

local scrollingPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon").Components.ScrollingPicker
local dateHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Time").DateHelper

local getFFlagSignUpBirthdayRefactorNestedDefinition = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags").GetFFlagSignUpBirthdayRefactorNestedDefinition

local getFFlagSignUpBirthdayPickerRequireManualSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags").GetFFlagSignUpBirthdayPickerRequireManualSelection

local v5 = { Default = "Default", Emphasized = "Emphasized", Muted = "Muted" }

local v6 = {}

for i = 1, 31 do
	table.insert(v6, i)
end

local confirms = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = focusNavigationEventNameEnum.Confirm
}

local reasonDateInvalid = dateHelper.ReasonDateInvalid
local monthsLocalizationKeys = dateHelper.MonthsLocalizationKeys
local dateTypeOrder = dateHelper.DateTypeOrder

local function renderWheelContainer(p2, shouldExpandTapTarget, focusNavigationRef)
	return Roact.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 200),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = not shouldExpandTapTarget,
		[Roact.Ref] = focusNavigationRef
	}, p2)
end

local function buildEntries(p2, p3, p4)
	if p3 then
		return Cryo.List.join({ p4 }, p2)
	end

	return p2
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

local function useFocusNavigationBindings(p2)
	local v7 = ReactFocusNavigation.useEventMap(confirms, p2)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() end)
			}
		}
	end, {})
	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

function extended:init()
	self.isMounted = false

	local values = dateTime.now():GetValues()

	self.currentDate = {
		[timeUnit.Months] = ArgCheck.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[timeUnit.Days] = ArgCheck.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[timeUnit.Years] = ArgCheck.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}

	local v8 = self.currentDate[timeUnit.Years]
	local minAgeAllowed = self.props.minAgeAllowed
	local v9 = v8 - self.props.maxAgeAllowed
	local v10 = v8 - minAgeAllowed

	local v11 = self.props.requireManualSelection and getFFlagSignUpBirthdayPickerRequireManualSelection()

	self.dummyYears = {}

	if v11 then
		for i = v10, v9, -1 do
			table.insert(self.dummyYears, i)
		end
	else
		for i = v9, v10 do
			table.insert(self.dummyYears, i)
		end
	end

	self.minYear = v9
	self.maxYear = v10

	self.placeholderOffset = v11 and 1 or 0

	local initialMonth = self.props.initialMonth
	local initialDay = self.props.initialDay
	local initialYear = self.props.initialYear
	local v12 = initialMonth ~= nil and initialDay ~= nil and initialYear ~= nil
	local v13 = not v11 or v12

	local v14 = v11 and 2 or #self.dummyYears + -1

	local v15 = not v13 and 1 or 1 + self.placeholderOffset
	local v16 = not v13 and 1 or 1 + self.placeholderOffset
	local v17 = not v13 and 1 or v14 + self.placeholderOffset

	local v18 = if initialMonth then initialMonth + self.placeholderOffset else nil
	local v19 = if initialDay then initialDay + self.placeholderOffset else nil
	local v20

	if initialYear then
		local v21 = math.clamp(initialYear, v9, v10)

		v20 = (if v11 then v10 - v21 + 1 else v21 - v9 + 1) + self.placeholderOffset
	end

	self.state = {
		selectedMonthIndex = v18 or v15,
		selectedDayIndex = v19 or v16,
		selectedYearIndex = v20 or v17,
		continueButtonEnabled = v13,
		hasUserPickedMonth = v13,
		hasUserPickedDay = v13,
		hasUserPickedYear = v13
	}
	self.datePickerRef = Roact.createRef()
	self.defaultRef = Roact.createRef()

	self.shouldExpandTapTarget = self.props.shouldExpandTapTarget
	self.tapTargetExpansionSize = self.props.tapTargetExpansionSize

	function self.renderEntryTextfunction(p2, p3)
		return withStyle(function(p4)
			local font = p4.Font.Body.Font
			local v21 = p4.Font.BaseSize * p4.Font.Body.RelativeSize
			local color = p4.Theme.TextDefault.Color
			local transparency = p4.Theme.TextDefault.Transparency

			if p3 == "Muted" then
				color = p4.Theme.TextMuted.Color
				transparency = p4.Theme.TextMuted.Transparency
			elseif p3 == "Emphasized" then
				font = p4.Font.Header1.Font
				v21 = p4.Font.BaseSize * p4.Font.Header1.RelativeSize
				color = p4.Theme.TextEmphasis.Color
				transparency = p4.Theme.TextEmphasis.Transparency
			end

			return Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = tostring(p2),
				Font = font,
				TextSize = v21,
				TextColor3 = color,
				TextTransparency = transparency
			})
		end)
	end

	function self.renderWheelContainerFunction(p2)
		return Roact.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 200),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = not self.shouldExpandTapTarget,
			[Roact.Ref] = self.props.focusNavigationRef
		}, p2)
	end

	if getFFlagSignUpBirthdayRefactorNestedDefinition() then
		function self.renderWheelContainerFunction(p2)
			return renderWheelContainer(p2, self.shouldExpandTapTarget, self.props.focusNavigationRef)
		end
	end

	local function makeChangeHandler(p2, p3)
		return function(p4, p5)
			local v21 = self.state[p2] ~= p4

			local v22 = p5 and not self.state[p3] and self.placeholderOffset < p4

			if v21 or v22 then
				spawn(function()
					if not self.isMounted then
						return
					end

					local v23 = {}

					if self.state[p2] ~= p4 then
						v23[p2] = p4
					end

					if p5 and not self.state[p3] and p4 > self.placeholderOffset then
						v23[p3] = true
					end

					if next(v23) ~= nil then
						self:setState(v23)
					end
				end)
			end
		end
	end
	local v21 = "selectedMonthIndex"
	local v22 = "hasUserPickedMonth"
	function self.onSelectedIndexChangedForMonth(p2, p3)
		local v23 = self.state[v21] ~= p2

		local v24 = p3 and not self.state[v22] and self.placeholderOffset < p2

		if v23 or v24 then
			spawn(function()
				if not self.isMounted then
					return
				end

				local v25 = {}

				if self.state[v21] ~= p2 then
					v25[v21] = p2
				end

				if p3 and not self.state[v22] and p2 > self.placeholderOffset then
					v25[v22] = true
				end

				if next(v25) ~= nil then
					self:setState(v25)
				end
			end)
		end
	end

	local v23 = "selectedDayIndex"
	local v24 = "hasUserPickedDay"
	function self.onSelectedIndexChangedForDay(p2, p3)
		local v25 = self.state[v23] ~= p2

		local v26 = p3 and not self.state[v24] and self.placeholderOffset < p2

		if v25 or v26 then
			spawn(function()
				if not self.isMounted then
					return
				end

				local v27 = {}

				if self.state[v23] ~= p2 then
					v27[v23] = p2
				end

				if p3 and not self.state[v24] and p2 > self.placeholderOffset then
					v27[v24] = true
				end

				if next(v27) ~= nil then
					self:setState(v27)
				end
			end)
		end
	end

	local v25 = "selectedYearIndex"
	local v26 = "hasUserPickedYear"
	function self.onSelectedIndexChangedForYear(p2, p3)
		local v27 = self.state[v25] ~= p2

		local v28 = p3 and not self.state[v26] and self.placeholderOffset < p2

		if v27 or v28 then
			spawn(function()
				if not self.isMounted then
					return
				end

				local v29 = {}

				if self.state[v25] ~= p2 then
					v29[v25] = p2
				end

				if p3 and not self.state[v26] and p2 > self.placeholderOffset then
					v29[v26] = true
				end

				if next(v29) ~= nil then
					self:setState(v29)
				end
			end)
		end
	end

	function self.onActivated(p2)
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

function extended:getActualIndex(p3, p4, p5)
	if not self.state[p3] then
		return nil
	end

	local v7 = self.state[p4] - self.placeholderOffset

	if v7 < 1 or p5 < v7 then
		return nil
	end

	return v7
end

function extended:getActualMonth()
	return self:getActualIndex("hasUserPickedMonth", "selectedMonthIndex", #monthsLocalizationKeys)
end

function extended:getActualDay()
	return self:getActualIndex("hasUserPickedDay", "selectedDayIndex", #v6)
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
	local v7 = not (actualMonth == nil or actualDay == nil) and actualYear ~= nil

	local v8 = false
	local v9 = nil
	local v10

	if v7 then
		local v11
		v10, v11 = dateHelper:isValidDate(actualMonth, actualDay, actualYear)

		if not v10 and v11 == reasonDateInvalid.IsInvalidDayOfMonth then
			v9 = dateHelper:getLastDayOfTheMonthInYear(actualMonth, actualYear) + self.placeholderOffset
			v8 = true
		end
	else
		v10 = false
	end

	spawn(function()
		if self.isMounted then
			self:setState({
				selectedDayIndex = v8 and v9 or nil,
				continueButtonEnabled = v7 and v10
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
	local v7 = not (actualMonth == nil or actualDay == nil) and actualYear ~= nil
	local v8, v9

	if v7 then
		v8, v9 = dateHelper:isValidDate(actualMonth, actualDay, actualYear)
	else
		v8 = false
	end

	local v10 = not v8 and v9 == reasonDateInvalid.IsInvalidDayOfMonth

	if v8 ~= continueButtonEnabled or v10 then
		self:updatePickerState()
	end

	if updateBirthday then
		updateBirthday(actualMonth, actualDay, actualYear)
	end
end

function extended:render()
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v7 = dateTypeOrder[robloxLocaleId]

	local v8 = not self.shouldExpandTapTarget or self.tapTargetExpansionSize <= 0

	local layoutOrder = self.props.layoutOrder

	local v9 = self.props.requireManualSelection and getFFlagSignUpBirthdayPickerRequireManualSelection()
	local placeholderTextMonth = self.props.placeholderTextMonth
	local placeholderTextDay = self.props.placeholderTextDay
	local placeholderTextYear = self.props.placeholderTextYear

	local joined = monthsLocalizationKeys

	if v9 then
		joined = Cryo.List.join({ placeholderTextMonth }, joined)
	end

	local joined2 = v6

	if v9 then
		joined2 = Cryo.List.join({ placeholderTextDay }, joined2)
	end

	local dummyYears = self.dummyYears

	if v9 then
		dummyYears = Cryo.List.join({ placeholderTextYear }, dummyYears)
	end

	local selectedMonthIndex = self.state.selectedMonthIndex
	local selectedDayIndex = self.state.selectedDayIndex
	local selectedYearIndex = self.state.selectedYearIndex

	local v10 = v9 and self.state.hasUserPickedMonth and 2 or 1
	local v11 = v9 and self.state.hasUserPickedDay and 2 or 1
	local v12 = v9 and self.state.hasUserPickedYear and 2 or 1

	local actualMonth = self:getActualMonth()
	local actualYear = self:getActualYear()
	local hasUserPickedMonth = self.state.hasUserPickedMonth
	local hasUserPickedDay = self.state.hasUserPickedDay
	local hasUserPickedYear = self.state.hasUserPickedYear

	return withStyle(function(p2)
		return withLocalization({
			continueText = "Authentication.SignUp.Label.Continue"
		})(function(p3)
			local createElement = Roact.createElement
			local fitFrame = fitChildren.FitFrame
			local v13 = {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = fitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}

			local v14 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 14)
				}),
				DatePickerWrap = 0
			}

			local createElement2 = Roact.createElement
			local fitFrame2 = fitChildren.FitFrame
			local v15 = {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = fitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}

			local v16 = {
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
			local fitTextButton = fitChildren.FitTextButton
			local v17 = {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = fitChildren.FitAxis.Height,
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
			local v18 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				WheelContainer = 0
			}

			local renderWheelContainerFunction = self.renderWheelContainerFunction
			local createElement4 = Roact.createElement
			local v20 = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = 0
			}

			local v21 = if v8 then Enum.VerticalAlignment.Center else nil
			v20.VerticalAlignment = v21
			v18.WheelContainer = renderWheelContainerFunction({
				ListLayout = createElement4("UIListLayout", v20),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingRight = UDim.new(0, 5),
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				MonthWheel = Roact.createElement(scrollingPicker, {
					layoutOrder = v7[timeUnit.Months],
					size = UDim2.new(0.45, 0, 0, 200),
					renderEntry = function(p4)
						if p4 ~= placeholderTextMonth then
							return withStyle(function(p5)
								return withLocalization({ monthText = p4 })(function(p6)
									local v23 = p4 == joined[selectedMonthIndex]
										and hasUserPickedMonth
										and "Emphasized"
										or "Default"

									return self.renderEntryTextfunction(p6.monthText, v23)
								end)
							end)
						end

						if hasUserPickedMonth then
							return self.renderEntryTextfunction("", "Default")
						end

						return self.renderEntryTextfunction(placeholderTextMonth, "Muted")
					end,
					getEntryWrapperProps = function(p4)
						local v22 = joined[selectedMonthIndex]

						local ref = Roact.Ref
						local v23 = if p4 == v22 then self.defaultRef else nil
						return { [ref] = v23 }
					end,
					entries = joined,
					entrySizeOnScrollingAxis = 50,
					onSelectedIndexChanged = self.onSelectedIndexChangedForMonth,
					parentSpecifiedTarget = selectedMonthIndex,
					minTargetIndex = v10,
					onEntryActivated = self.onEntryActivated,
					shouldExpandTapTarget = self.shouldExpandTapTarget,
					tapTargetExpansionSize = self.tapTargetExpansionSize
				}),
				DayWheel = Roact.createElement(scrollingPicker, {
					layoutOrder = v7[timeUnit.Days],
					size = UDim2.new(0.2, 0, 0, 200),
					renderEntry = function(value)
						if type(value) == "number" then
							return withLocalization({
								dayAffix = dateHelper.DayAffixLocalizationKey
							})(function(p4)
								local v23 = value == joined2[selectedDayIndex]

								local formattedDayString = dateHelper:GetFormattedDayString(
									value,
									p4.dayAffix,
									robloxLocaleId
								)

								local v24 = actualMonth
									and actualYear
									and dateHelper:isInvalidDayOfTheMonth(actualMonth, value, actualYear)
									and "Muted"
									or v23 and hasUserPickedDay and "Emphasized"
									or "Default"

								return self.renderEntryTextfunction(formattedDayString, v24)
							end)
						end

						if hasUserPickedDay then
							return self.renderEntryTextfunction("", "Default")
						end

						return self.renderEntryTextfunction(placeholderTextDay, "Muted")
					end,
					entries = joined2,
					entrySizeOnScrollingAxis = 50,
					onSelectedIndexChanged = self.onSelectedIndexChangedForDay,
					parentSpecifiedTarget = selectedDayIndex,
					minTargetIndex = v11,
					onEntryActivated = self.onEntryActivated,
					shouldExpandTapTarget = self.shouldExpandTapTarget,
					tapTargetExpansionSize = self.tapTargetExpansionSize
				}),
				YearWheel = Roact.createElement(scrollingPicker, {
					layoutOrder = v7[timeUnit.Years],
					size = UDim2.new(0.35, 0, 0, 200),
					renderEntry = function(value)
						if type(value) == "number" then
							return withLocalization({
								yearAffix = dateHelper.YearAffixLocalizationKey
							})(function(p4)
								local v22 = value == dummyYears[selectedYearIndex]

								local formattedYearString = dateHelper:GetFormattedYearString(
									value,
									p4.yearAffix,
									robloxLocaleId
								)

								return self.renderEntryTextfunction(
									formattedYearString,
									v22 and hasUserPickedYear and "Emphasized" or "Default"
								)
							end)
						end

						if hasUserPickedYear then
							return self.renderEntryTextfunction("", "Default")
						end

						return self.renderEntryTextfunction(placeholderTextYear, "Muted")
					end,
					entries = dummyYears,
					entrySizeOnScrollingAxis = 50,
					onSelectedIndexChanged = self.onSelectedIndexChangedForYear,
					parentSpecifiedTarget = selectedYearIndex,
					minTargetIndex = v12,
					onEntryActivated = self.onEntryActivated,
					shouldExpandTapTarget = self.shouldExpandTapTarget,
					tapTargetExpansionSize = self.tapTargetExpansionSize
				})
			})
			v16.DatePicker = createElement3(fitTextButton, v17, v18)
			v14.DatePickerWrap = createElement2(fitFrame2, v15, v16)
			return createElement(fitFrame, v13, v14)
		end)
	end)
end

return function(p2)
	local v7 = ReactFocusNavigation.useFocusedGuiObject()
	local v8 = ReactFocusNavigation.useFocusGuiObject()
	local v9 = useFocusNavigationBindings(nil)
	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p2, {
			focusedGuiObject = v7,
			focusGuiObject = v8,
			focusNavigationRef = v9
		})
	)
end
