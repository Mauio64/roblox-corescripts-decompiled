local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local AppDropdownMenu = require(Modules.LuaApp.Components.Common.AppDropdownMenu)
local DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
local TimeUnit = require(CorePackages.Workspace.Packages.Time).TimeUnit
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local DateTypeOrder = DateHelper.DateTypeOrder
local t1 = {
	[Enum.HorizontalAlignment.Left] = Vector2.new(0, 0),
	[Enum.HorizontalAlignment.Center] = Vector2.new(0.5, 0),
	[Enum.HorizontalAlignment.Right] = Vector2.new(1, 0)
}
local t2 = {
	[Enum.HorizontalAlignment.Left] = UDim2.fromScale(0, 0),
	[Enum.HorizontalAlignment.Center] = UDim2.fromScale(0.5, 0),
	[Enum.HorizontalAlignment.Right] = UDim2.fromScale(1, 0)
}

return function(t3: {[any]: any}) -- line: 56
	-- upvalues: useStyle (copy), useLocalization (copy), useSelector (copy), React (copy), TimeUnit (copy), DateHelper (copy), LocalizationService (copy), DateTypeOrder (copy), t1 (copy), t2 (copy), AppDropdownMenu (copy)
	local v15 = useStyle()
	local v16 = useLocalization({
		yearText = "CommonUI.Controls.Label.Year",
		monthText = "CommonUI.Controls.Label.Month",
		dayText = "CommonUI.Controls.Label.Day",
		titleText = t3.titleKey,
		subTitleText = t3.subTitleKey,
		errorText = t3.errorTextKey
	})
	local v17 = useSelector(function(p1) -- line: 66
		return p1.ScreenSize or Vector2.new(1920, 1080)
	end)
	local v18, v19 = React.useState(0)
	local v20, v21 = React.useState(0)
	local v22, v23 = React.useState(0)
	local v24 = React.useCallback(function(p2) -- line: 74
		-- upvalues: v19 (copy), t3 (copy), TimeUnit (copy), v20 (copy), v22 (copy)
		local num = tonumber(p2)

		if num then
			v19(num)
		end

		t3.onDateSelected({
			[TimeUnit.Years] = num,
			[TimeUnit.Months] = v20,
			[TimeUnit.Days] = v22
		})
	end, {
		t3.onDateSelected,
		v20,
		v22
	})
	local v25 = React.useCallback(function(p3) -- line: 87
		-- upvalues: v21 (copy), t3 (copy), TimeUnit (copy), v18 (copy), v22 (copy)
		local num = tonumber(p3)

		if num then
			v21(num)
		end

		t3.onDateSelected({
			[TimeUnit.Years] = v18,
			[TimeUnit.Months] = num,
			[TimeUnit.Days] = v22
		})
	end, {
		t3.onDateSelected,
		v18,
		v22
	})
	local v26 = React.useCallback(function(p4) -- line: 100
		-- upvalues: v23 (copy), t3 (copy), TimeUnit (copy), v18 (copy), v20 (copy)
		local num = tonumber(p4)

		if num then
			v23(num)
		end

		t3.onDateSelected({
			[TimeUnit.Years] = v18,
			[TimeUnit.Months] = v20,
			[TimeUnit.Days] = num
		})
	end, {
		t3.onDateSelected,
		v18,
		v20
	})
	local v27 = React.useMemo(function() -- line: 113
		-- upvalues: DateHelper (copy), t3 (copy), TimeUnit (copy)
		local v41 = DateHelper:getCurrentDate()
		local t4 = {}
		local v43 = t3.maxYear or v41[TimeUnit.Years]

		for i = v43, t3.minYear or v43 - 100, -1 do
			table.insert(t4, {
				key = tostring(i),
				text = tostring(i)
			})
		end

		return t4
	end, {
		t3.minYear,
		t3.maxYear
	})
	local v28 = React.useMemo(function() -- line: 128
		local t5 = {}

		for i = 1, 12 do
			table.insert(t5, {
				key = tostring(i),
				text = tostring(i)
			})
		end

		return t5
	end)
	local v29 = React.useMemo(function() -- line: 139
		local t6 = {}

		for i = 1, 31 do
			table.insert(t6, {
				key = tostring(i),
				text = tostring(i)
			})
		end

		return t6
	end)
	local v30 = DateTypeOrder[LocalizationService.RobloxLocaleId]
	local v31 = if not t3.designTokens then {
		dropdownHeight = 72,
		dropdownHorizontalPadding = 36,
		dropdownVerticalPadding = 24,
		dateDropdownWidth = 156,
		textCaptionHeaderSize = v15.Font.BaseSize * v15.Font.CaptionHeader.RelativeSize,
		textBodySize = v15.Font.BaseSize * v15.Font.Body.RelativeSize
	} else t3.designTokens
	local v32 = t3.alignment or Enum.HorizontalAlignment.Left
	local v33 = if not t3.horizontalInnerPadding then UDim.new(0, v31.dropdownHorizontalPadding) else t3.horizontalInnerPadding

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t3.size,
		AnchorPoint = t1[v32],
		Position = t2[v32],
		LayoutOrder = t3.layoutOrder
	}, {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v31.dropdownVerticalPadding)
		}),
		Title = if not t3.titleKey then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			TextWrapped = true,
			Font = v15.Font.CaptionHeader.Font,
			Size = UDim2.fromScale(1, 0),
			Text = v16.titleText,
			TextColor3 = v15.Theme.TextEmphasis.Color,
			TextSize = v31.textCaptionHeaderSize,
			TextTransparency = v15.Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		}),
		BirthdayPicker = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, v31.dropdownHeight)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = v33
			}),
			YearPicker = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.new(0.25, 0, 0, v31.dropdownHeight),
				LayoutOrder = v30[TimeUnit.Years]
			}, {
				YearDropdownMenu = React.createElement(AppDropdownMenu, {
					showDropShadow = true,
					analyticsContext = "YearDropdownMenu",
					selectionGroupName = "YearDropdownMenu",
					height = UDim.new(0, v31.dropdownHeight),
					placeholder = v16.yearText,
					screenSize = v17,
					fixedListHeight = t3.fixedListHeight,
					onChange = v24,
					cellDatas = v27
				})
			}),
			MonthPicker = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.new(0.25, 0, 0, v31.dropdownHeight),
				LayoutOrder = v30[TimeUnit.Months]
			}, {
				MonthDropdownMenu = React.createElement(AppDropdownMenu, {
					showDropShadow = true,
					analyticsContext = "MonthDropdownMenu",
					selectionGroupName = "MonthDropdownMenu",
					height = UDim.new(0, v31.dropdownHeight),
					placeholder = v16.monthText,
					screenSize = v17,
					fixedListHeight = t3.fixedListHeight,
					onChange = v25,
					cellDatas = v28
				})
			}),
			DayPicker = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.new(0.25, 0, 0, v31.dropdownHeight),
				LayoutOrder = v30[TimeUnit.Days]
			}, {
				DayDropdownMenu = React.createElement(AppDropdownMenu, {
					showDropShadow = true,
					analyticsContext = "DayDropdownMenu",
					selectionGroupName = "DayDropdownMenu",
					height = UDim.new(0, v31.dropdownHeight),
					placeholder = v16.dayText,
					screenSize = v17,
					fixedListHeight = t3.fixedListHeight,
					onChange = v26,
					cellDatas = v29
				})
			})
		}),
		OptionalTitle = if not t3.subTitleKey then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			TextWrapped = true,
			Font = v15.Font.CaptionHeader.Font,
			Size = UDim2.fromScale(1, 0),
			Text = v16.subTitleText,
			TextColor3 = v15.Theme.TextDefault.Color,
			TextSize = v31.textBodySize,
			TextTransparency = v15.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		}),
		ErrorTitle = if not t3.errorTextKey then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			TextWrapped = true,
			Font = v15.Font.CaptionHeader.Font,
			Size = UDim2.fromScale(1, 0),
			Text = v16.errorText,
			TextColor3 = v15.Theme.Alert.Color,
			TextSize = v31.textBodySize,
			TextTransparency = v15.Theme.Alert.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		})
	})
end
