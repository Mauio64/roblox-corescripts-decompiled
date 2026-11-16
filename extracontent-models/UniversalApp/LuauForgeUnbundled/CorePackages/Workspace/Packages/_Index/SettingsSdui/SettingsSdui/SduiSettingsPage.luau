local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/RobloxAppEnums").AppPage
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/AppComposition").CompositionTags
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SduiSharedUtilities")
local fFlagSduiSettingsFocusRef = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SharedFlags").FFlagSduiSettingsFocusRef

local sduiPageWrapperEntryPoint = SduiSharedUtilities.SduiPageWrapperEntryPoint
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef

local SettingsSduiConstants = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SettingsSduiConstants")
local fetchSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/fetchSettingsPage")

local settings2 = appPage.Settings
local configKey = SettingsSduiConstants.ConfigKey
local surfaceLoadTimeEventName = SettingsSduiConstants.SurfaceLoadTimeEventName

local v5 = { layout = compositionTags.Layout.Detail }

local function SduiSettingsPage(props)
	usePageScopeRef(configKey)
	local v6 = React.useMemo(function()
		local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			configKey,
			{
				eventName = surfaceLoadTimeEventName,
				metadata = { page = "mount" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("mount")
		return loadTimerWithSurfaceLoadTime
	end, {})

	React.useEffect(function()
		fetchSettingsPage(v6)
	end, { v6 })

	local v7 = React.useCallback(function()
		local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			configKey,
			{
				eventName = surfaceLoadTimeEventName,
				metadata = { page = "refresh" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("refresh")
		fetchSettingsPage(loadTimerWithSurfaceLoadTime, true)
	end, {})

	local createElement = React.createElement
	local v9 = {
		appPage = settings2,
		configKey = configKey,
		pageTimer = v6,
		refresh = v7,
		composition = v5,
		pageTopPadding = props.pageTopPadding,
		defaultFocusRef = 0,
		backgroundStyle = 0
	}
	local v10 = if fFlagSduiSettingsFocusRef then props.defaultFocusRef else nil
	v9.defaultFocusRef = v10
	v9.backgroundStyle = props.backgroundStyle
	return createElement(sduiPageWrapperEntryPoint, v9)
end

return React.memo(SduiSettingsPage)
