local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/NavigationRodux").Thunks.NavigateDown
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local deviceType = RobloxAppEnums.DeviceType
local getDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/AppCommonLib").getDeviceType
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RobloxAppNavigation").NavigationCommands else nil

local fFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/DeviceOrientationStore").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

return function(p2, p3)
	return function(object)
		local v5

		if fFlagUseSignalsForDeviceOrientation then
			v5 = getDeviceOrientationStore(false).getDeviceOrientation(false)
		else
			v5 = object:getState().DeviceOrientation
		end

		local deviceType2 = getDeviceType(v5)

		if deviceType2 ~= deviceType.Phone and deviceType2 ~= deviceType.Tablet then
			return
		end

		local v6 = {
			name = appPage.InfoPeekView,
			extraProps = { title = p2, body = p3 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			object:dispatch(navigateDown(v6))
		end
	end
end
