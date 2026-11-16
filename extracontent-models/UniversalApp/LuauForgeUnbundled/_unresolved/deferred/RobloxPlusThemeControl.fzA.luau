local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module = require("@luauforge/bundled/fzr")
local surfaceName = module.SurfaceName
local surfaceContext = module.SurfaceContext

local module2 = require("@luauforge/bundled/fup")
local module3 = require("@luauforge/bundled/fzB")
local module4 = require("@luauforge/bundled/fun")
local module5 = require("@luauforge/deferred/fzE")

local feedbackAlert = Foundation.FeedbackAlert

local alertSeverity = Foundation.Enums.AlertSeverity

local function handleSubscribe()
	module.initiateRobloxSubscriptionPurchase(
		nil,
		nil,
		nil,
		surfaceName.SettingsAppThemeUpsell,
		surfaceContext.InApp
	)
end

local function RobloxPlusThemeControl(props)
	local canChangeRobloxPlusTheme = props.canChangeRobloxPlusTheme
	local setRobloxPlusTheme = props.setRobloxPlusTheme
	local reportSubscribeClick = props.reportSubscribeClick
	local reportThemeSelected = props.reportThemeSelected

	local v5 = module4(false)
	local v6 = useSignalState(v5.getPreviewColorThemeKey)

	React.useEffect(function()
		return function()
			v5.setPreviewColorThemeKey(nil)
		end
	end, { v5 })

	local ref = React.useRef(canChangeRobloxPlusTheme)
	React.useEffect(function()
		local current = ref.current
		ref.current = canChangeRobloxPlusTheme

		if not current and canChangeRobloxPlusTheme then
			local previewColorThemeKey = v5.getPreviewColorThemeKey(false)

			if previewColorThemeKey ~= nil and previewColorThemeKey ~= module2.Default then
				setRobloxPlusTheme(previewColorThemeKey)
			end

			v5.setPreviewColorThemeKey(nil)
		end
	end, { canChangeRobloxPlusTheme, setRobloxPlusTheme, v5 })

	local v7 = props.showExclusiveThemes == false
	local function hasDeviceAccess(p2): boolean
		return not canChangeRobloxPlusTheme
			and module3.getThemeAccess(p2, false, v7) == module3.ThemeAccess.Device
	end

	local persistedThemeKey = props.persistedThemeKey
	local persistedThemeKey2

	if
		not canChangeRobloxPlusTheme
		and module3.getThemeAccess(persistedThemeKey, false, v7) == module3.ThemeAccess.Device
	then
		persistedThemeKey2 = props.persistedThemeKey
	else
		persistedThemeKey2 = nil
	end

	local v8

	if canChangeRobloxPlusTheme then
		v8 = props.persistedThemeKey
	else
		v8 = v6 or persistedThemeKey2 or module2.Default
	end

	local v9 = React.useCallback(function()
		if reportSubscribeClick then
			reportSubscribeClick()
		end

		module.initiateRobloxSubscriptionPurchase(
			nil,
			nil,
			nil,
			surfaceName.SettingsAppThemeUpsell,
			surfaceContext.InApp
		)
	end, { reportSubscribeClick })

	local v10 = React.useCallback(function(p2)
		if p2 == v8 then
			return
		end

		if reportThemeSelected then
			reportThemeSelected(p2)
		end

		if canChangeRobloxPlusTheme then
			setRobloxPlusTheme(p2)
		elseif
			module3.getThemeAccess(p2, false, v7) == module3.ThemeAccess.Device
			or p2 == module2.Default and persistedThemeKey2 ~= nil
		then
			v5.setPreviewColorThemeKey(nil)
			setRobloxPlusTheme(p2, true)
		else
			local setPreviewColorThemeKey = v5.setPreviewColorThemeKey

			if p2 == module2.Default then
				p2 = nil
			end

			setPreviewColorThemeKey(p2)
		end
	end, {
		canChangeRobloxPlusTheme,
		setRobloxPlusTheme,
		v5,
		v8,
		reportThemeSelected,
		v7,
		persistedThemeKey2
	})

	local v11 = if not canChangeRobloxPlusTheme then React.createElement(feedbackAlert, {
		LayoutOrder = 1,
		severity = alertSeverity.Info,
		title = props.bannerTitle,
		link = { text = props.subscribeText, onActivated = v9 },
		testId = "RobloxPlusThemeControl--banner"
	}) else nil

	return React.createElement(module5, {
		LayoutOrder = props.LayoutOrder,
		themeKeys = props.themeKeys,
		themeLabels = props.themeLabels,
		selectedThemeKey = v8,
		onSelect = v10,
		columns = props.columns,
		categoryLabels = props.categoryLabels,
		isUpdating = props.isUpdating,
		robloxThemeKeys = props.robloxThemeKeys,
		exclusiveThemesLabel = props.exclusiveThemesLabel,
		newBadgeText = props.newBadgeText,
		showExclusiveThemes = props.showExclusiveThemes,
		banner = v11
	})
end

return RobloxPlusThemeControl
