local SettingsSdui = script:FindFirstAncestor("SettingsSdui")
local parent = SettingsSdui.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags
local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSettingsFocusRef = SharedFlags.FFlagSduiSettingsFocusRef

local SduiPageWrapperEntryPoint = SduiSharedUtilities.SduiPageWrapperEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef

local SettingsSduiConstants = require(SettingsSdui.SettingsSduiConstants)
local fetchSettingsPage = require(SettingsSdui.fetchSettingsPage)

local Settings = AppPage.Settings
local ConfigKey = SettingsSduiConstants.ConfigKey
local SurfaceLoadTimeEventName = SettingsSduiConstants.SurfaceLoadTimeEventName

local composition = { layout = CompositionTags.Layout.Detail }

local function SduiSettingsPage(props)
	usePageScopeRef(ConfigKey)
	local pageTimer = React.useMemo(function()
		local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(ConfigKey, {
			eventName = SurfaceLoadTimeEventName,
			metadata = { page = "mount" }
		})

		loadTimerWithSurfaceLoadTime.start("mount")
		return loadTimerWithSurfaceLoadTime
	end, {})

	React.useEffect(function()
		fetchSettingsPage(pageTimer)
	end, { pageTimer })

	local refresh = React.useCallback(function()
		local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(ConfigKey, {
			eventName = SurfaceLoadTimeEventName,
			metadata = { page = "refresh" }
		})

		loadTimerWithSurfaceLoadTime.start("refresh")
		fetchSettingsPage(loadTimerWithSurfaceLoadTime, true)
	end, {})

	local createElement = React.createElement
	local v = {
		appPage = Settings,
		configKey = ConfigKey,
		pageTimer = pageTimer,
		refresh = refresh,
		composition = composition,
		pageTopPadding = props.pageTopPadding,
		defaultFocusRef = 0,
		backgroundStyle = 0
	}
	local defaultFocusRef

	if FFlagSduiSettingsFocusRef then
		defaultFocusRef = props.defaultFocusRef
	end

	v.defaultFocusRef = defaultFocusRef
	v.backgroundStyle = props.backgroundStyle
	return createElement(SduiPageWrapperEntryPoint, v)
end

return React.memo(SduiSettingsPage)
