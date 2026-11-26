local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/bundled/fBQ")
local module2 = require("@luauforge/bundled/fHu")

local module3 = require("@luauforge/deferred/fHv")
local module4 = require("@luauforge/bundled/fHw")
local module5 = require("@luauforge/bundled/fAl")
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local view = Foundation.View
local text = Foundation.Text
local progress = Foundation.Progress
local colorMode = Foundation.Enums.ColorMode
local iconName = Foundation.Enums.IconName
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize
local getIconRichText = Foundation.Utility.getIconRichText

local dark = module2.Dark
local light = module2.Light

local halloweenSecondary = module2.HalloweenSecondary

local function ThemeRow(props)
	local isSelected = props.isDisabled and props.isSelected
	local v5 = props.isDisabled and not props.isSelected and 0.5 or 0

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row align-y-center fill gap-medium size-0-1500 padding-x-medium stroke-standard radius-medium"] = true,
			["stroke-system-contrast"] = props.isSelected,
			["stroke-emphasis"] = not props.isSelected
		},
		backgroundStyle = {
			Color3 = props.bgColor,
			Transparency = props.bgTransparency
		},
		onActivated = 0,
		testId = 0
	}

	local v8 = if not props.isDisabled then props.onActivated else nil
	v7.onActivated = v8
	v7.testId = `{props.testIdPrefix}--option-{props.themeKey}`
	local v9 = {
		Swatch = React.createElement(view, {
			LayoutOrder = 1,
			tag = "size-800-800 stroke-standard stroke-emphasis radius-circle",
			backgroundStyle = { Color3 = props.swatchColor, Transparency = v5 },
			testId = `{props.testIdPrefix}--swatch-{props.themeKey}`
		}, props.secondarySwatchColor and {
			Secondary = React.createElement(view, {
				tag = "size-full radius-circle",
				backgroundStyle = {
					Color3 = props.secondarySwatchColor,
					Transparency = v5
				},
				testId = `{props.testIdPrefix}--swatch-secondary-{props.themeKey}`
			}, {
				HalfMask = React.createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(0.501, 0),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		} or nil),
		Label = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.label,
			tag = "fill auto-y text-title-small text-wrap text-align-x-left",
			textStyle = { Color3 = props.labelColor, Transparency = v5 },
			testId = `{props.testIdPrefix}--label-{props.themeKey}`
		}),
		Progress = 0,
		PlusIcon = 0
	}

	local v10 = if isSelected then React.createElement(progress, {
		LayoutOrder = 3,
		shape = progressShape.Circle,
		size = progressSize.Small,
		testId = `{props.testIdPrefix}--progress-{props.themeKey}`
	}) else nil
	v9.Progress = v10

	local v11 = if props.showPlusIcon and not isSelected then React.createElement(text, {
		LayoutOrder = 3,
		Text = getIconRichText(iconName.RobloxPlus),
		RichText = true,
		tag = "auto-xy content-muted",
		testId = `{props.testIdPrefix}--plus-icon-{props.themeKey}`
	}) else nil
	v9.PlusIcon = v11
	return createElement(view, v7, v9)
end

local function RobloxPlusThemeOptionGrid(props)
	local v5 = Foundation.Hooks.useTokens()

	local v6 = math.max(1, props.columns)
	local testIdPrefix = props.testIdPrefix or "RobloxPlusThemeOptionGrid"
	local themeLabels = props.themeLabels
	local themeKeys = props.themeKeys

	local v7 = if v5.Config.ColorMode.Name == colorMode.Light then light else dark

	local color3 = v5.Color.Content.Emphasis.Color3

	local color3_2 = v5.Color.Surface.Surface_0.Color3
	local v8 = 0

	if module3 then
		local v9 = if module5 then useThemeBackground() ~= nil else React.useContext(module4) ~= nil

		if v9 then
			color3_2 = v5.Color.Shift.Shift_200.Color3
			v8 = v5.Color.Shift.Shift_200.Transparency
		end
	end

	local v9 = v7[module.Default]

	local isUpdating = props.isUpdating == true

	local showPlusIcons = props.showPlusIcons == true

	local children = {}

	for k, themeKey in themeKeys do
		local v10 = v7[themeKey]

		local createElement = React.createElement
		local v12 = {
			LayoutOrder = (k - 1) % v6 + 1,
			themeKey = themeKey,
			label = 0,
			swatchColor = 0,
			secondarySwatchColor = 0,
			bgColor = 0,
			bgTransparency = 0,
			isSelected = 0,
			showPlusIcon = 0,
			isDisabled = 0,
			labelColor = 0,
			testIdPrefix = 0,
			onActivated = 0
		}

		local v13 = if themeLabels then themeLabels[themeKey] or themeKey else themeKey
		v12.label = v13
		v12.swatchColor = v10 or v9
		local v14 = if themeKey == module.Halloween2026 then halloweenSecondary else nil
		v12.secondarySwatchColor = v14

		v12.bgColor = color3_2
		v12.bgTransparency = v8
		v12.isSelected = themeKey == props.selectedThemeKey
		v12.showPlusIcon = showPlusIcons and themeKey ~= module.Default
		v12.isDisabled = isUpdating
		v12.labelColor = color3
		v12.testIdPrefix = testIdPrefix
		function v12.onActivated()
			props.onActivated(themeKey)
		end

		children[k] = createElement(ThemeRow, v12)
	end

	local count = 0
	local children2 = {}

	for i = 1, #children, v6 do
		count += 1
		local count2 = 0
		local children3 = {}

		for j = 0, v6 - 1 do
			local child = children[i + j]

			if not child then
				continue
			end

			count2 += 1
			children3[`Column-{j + 1}`] = child
		end

		for j = count2 + 1, v6 do
			children3[`ColumnSpacer-{j}`] = React.createElement(view, {
				LayoutOrder = j,
				tag = "fill auto-y"
			})
		end

		children2[`Row-{count}`] = React.createElement(
			view,
			{ LayoutOrder = count, tag = "row gap-medium size-full-0 auto-y" },
			children3
		)
	end

	return React.createElement(
		view,
		{ LayoutOrder = props.LayoutOrder, tag = "col gap-medium size-full-0 auto-y" },
		children2
	)
end

return RobloxPlusThemeOptionGrid
