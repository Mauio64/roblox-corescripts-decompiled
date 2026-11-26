local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local module = require("@luauforge/bundled/hLR")
local module2 = require("@luauforge/bundled/hLT")

local dateHelper = require("@luauforge/bundled/geM").DateHelper
local timeUnit = require("@luauforge/bundled/geM").TimeUnit

local module3 = require("@luauforge/bundled/gxM")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local dateTypeOrder = dateHelper.DateTypeOrder

local vector2s = {
	[Enum.HorizontalAlignment.Left] = Vector2.new(0, 0),
	[Enum.HorizontalAlignment.Center] = Vector2.new(0.5, 0),
	[Enum.HorizontalAlignment.Right] = Vector2.new(1, 0)
}

local udims = {
	[Enum.HorizontalAlignment.Left] = UDim2.fromScale(0, 0),
	[Enum.HorizontalAlignment.Center] = UDim2.fromScale(0.5, 0),
	[Enum.HorizontalAlignment.Right] = UDim2.fromScale(1, 0)
}

return function(props)
	local v5 = useStyle()
	local v6 = module3({
		titleText = props.titleKey,
		subTitleText = props.subTitleKey,
		errorText = props.errorTextKey,
		yearText = "CommonUI.Controls.Label.Year",
		monthText = "CommonUI.Controls.Label.Month",
		dayText = "CommonUI.Controls.Label.Day"
	})

	local v7 = useSelector(function(p2)
		return p2.ScreenSize or Vector2.new(1920, 1080)
	end)

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)

	local v8 = React.useCallback(function(p2)
		local v9 = tonumber(p2)

		if v9 then
			setState(v9)
		end

		props.onDateSelected({
			[timeUnit.Years] = v9,
			[timeUnit.Months] = state2,
			[timeUnit.Days] = state3
		})
	end, { props.onDateSelected, state2, state3 })

	local v9 = React.useCallback(function(p2)
		local v10 = tonumber(p2)

		if v10 then
			setState2(v10)
		end

		props.onDateSelected({
			[timeUnit.Years] = state,
			[timeUnit.Months] = v10,
			[timeUnit.Days] = state3
		})
	end, { props.onDateSelected, state, state3 })

	local v10 = React.useCallback(function(p2)
		local v11 = tonumber(p2)

		if v11 then
			setState3(v11)
		end

		props.onDateSelected({
			[timeUnit.Years] = state,
			[timeUnit.Months] = state2,
			[timeUnit.Days] = v11
		})
	end, { props.onDateSelected, state, state2 })

	local v11 = React.useMemo(function()
		local currentDate = dateHelper:getCurrentDate()

		local maxYear = props.maxYear or currentDate[timeUnit.Years]
		local result = {}

		for i = maxYear, props.minYear or maxYear - 100, -1 do
			table.insert(result, { key = tostring(i), text = tostring(i) })
		end

		return result
	end, { props.minYear, props.maxYear })

	local v12 = React.useMemo(function()
		local result = {}

		for i = 1, 12 do
			table.insert(result, { key = tostring(i), text = tostring(i) })
		end

		return result
	end)

	local v13 = React.useMemo(function()
		local result = {}

		for i = 1, 31 do
			table.insert(result, { key = tostring(i), text = tostring(i) })
		end

		return result
	end)

	local v14 = dateTypeOrder[LocalizationService.RobloxLocaleId]
	local v15

	if props.designTokens then
		v15 = props.designTokens
	else
		v15 = {
			textCaptionHeaderSize = v5.Font.BaseSize * v5.Font.CaptionHeader.RelativeSize,
			textBodySize = v5.Font.BaseSize * v5.Font.Body.RelativeSize,
			dropdownHeight = 72,
			dropdownHorizontalPadding = 36,
			dropdownVerticalPadding = 24,
			dateDropdownWidth = 156
		}
	end

	local alignment = props.alignment or Enum.HorizontalAlignment.Left
	local v16

	if props.horizontalInnerPadding then
		v16 = props.horizontalInnerPadding
	else
		v16 = UDim.new(0, v15.dropdownHorizontalPadding)
	end

	local createElement = React.createElement
	local v18 = {
		Size = props.size,
		AnchorPoint = vector2s[alignment],
		Position = udims[alignment],
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder
	}
	local v19 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v15.dropdownVerticalPadding)
		}),
		Title = 0,
		BirthdayPicker = 0,
		OptionalTitle = 0,
		ErrorTitle = 0
	}

	local v20 = if props.titleKey then React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 0),
		Text = v6.titleText,
		TextColor3 = v5.Theme.TextEmphasis.Color,
		TextSize = v15.textCaptionHeaderSize,
		TextTransparency = v5.Theme.TextEmphasis.Transparency,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.XY
	}) else nil
	v19.Title = v20

	local createElement2 = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 0, v15.dropdownHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		ZIndex = 2
	}

	local children = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = v16
		}),
		YearPicker = 0,
		MonthPicker = 0,
		DayPicker = 0
	}

	local createElement3 = React.createElement
	local v24 = {
		Size = UDim2.new(0.25, 0, 0, v15.dropdownHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v14[timeUnit.Years],
		ZIndex = 2
	}

	local createElement4 = React.createElement
	local v27 = {
		height = UDim.new(0, v15.dropdownHeight),
		placeholder = v6.yearText,
		screenSize = v7,
		showDropShadow = true,
		fixedListHeight = props.fixedListHeight,
		onChange = v8,
		cellDatas = v11,
		analyticsContext = "YearDropdownMenu",
		selectionGroupName = "YearDropdownMenu",
		onMenuOpenChange = 0
	}

	local v28 = if module2 then props.onMenuOpenChange else nil
	v27.onMenuOpenChange = v28
	children.YearPicker = createElement3("Frame", v24, {
		YearDropdownMenu = createElement4(module, v27)
	})

	local createElement5 = React.createElement
	local v30 = {
		Size = UDim2.new(0.25, 0, 0, v15.dropdownHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v14[timeUnit.Months],
		ZIndex = 2
	}

	local createElement6 = React.createElement
	local v33 = {
		height = UDim.new(0, v15.dropdownHeight),
		placeholder = v6.monthText,
		screenSize = v7,
		showDropShadow = true,
		fixedListHeight = props.fixedListHeight,
		onChange = v9,
		cellDatas = v12,
		analyticsContext = "MonthDropdownMenu",
		selectionGroupName = "MonthDropdownMenu",
		onMenuOpenChange = 0
	}

	local v34 = if module2 then props.onMenuOpenChange else nil
	v33.onMenuOpenChange = v34
	children.MonthPicker = createElement5("Frame", v30, {
		MonthDropdownMenu = createElement6(module, v33)
	})

	local createElement7 = React.createElement
	local v36 = {
		Size = UDim2.new(0.25, 0, 0, v15.dropdownHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v14[timeUnit.Days],
		ZIndex = 2
	}

	local createElement8 = React.createElement
	local v39 = {
		height = UDim.new(0, v15.dropdownHeight),
		placeholder = v6.dayText,
		screenSize = v7,
		showDropShadow = true,
		fixedListHeight = props.fixedListHeight,
		onChange = v10,
		cellDatas = v13,
		analyticsContext = "DayDropdownMenu",
		selectionGroupName = "DayDropdownMenu",
		onMenuOpenChange = 0
	}

	local v40 = if module2 then props.onMenuOpenChange else nil
	v39.onMenuOpenChange = v40
	children.DayPicker = createElement7("Frame", v36, {
		DayDropdownMenu = createElement8(module, v39)
	})
	v19.BirthdayPicker = createElement2("Frame", v22, children)

	local v41 = if props.subTitleKey then React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
		LayoutOrder = 3,
		Size = UDim2.fromScale(1, 0),
		Text = v6.subTitleText,
		TextColor3 = v5.Theme.TextDefault.Color,
		TextSize = v15.textBodySize,
		TextTransparency = v5.Theme.TextDefault.Transparency,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.XY
	}) else nil
	v19.OptionalTitle = v41

	local v42 = if props.errorTextKey then React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
		LayoutOrder = 4,
		Size = UDim2.fromScale(1, 0),
		Text = v6.errorText,
		TextColor3 = v5.Theme.Alert.Color,
		TextSize = v15.textBodySize,
		TextTransparency = v5.Theme.Alert.Transparency,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.XY
	}) else nil
	v19.ErrorTitle = v42
	return createElement("Frame", v18, v19)
end
