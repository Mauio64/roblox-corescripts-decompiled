local parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DeviceType = RobloxAppEnums.DeviceType
local AppCommonLib = require(parent.AppCommonLib)
local getDeviceType = AppCommonLib.getDeviceType
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local FFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if FFlagUseSignalsForDeviceOrientation then
	local DeviceOrientationStore = require(parent.DeviceOrientationStore)
	getDeviceOrientationStore = DeviceOrientationStore.GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

return function(title: string, body: string)
	return function(object)
		local v

		if FFlagUseSignalsForDeviceOrientation then
			v = getDeviceOrientationStore(false).getDeviceOrientation(false)
		else
			v = object:getState().DeviceOrientation
		end

		local deviceType = getDeviceType(v)

		if deviceType ~= DeviceType.Phone and deviceType ~= DeviceType.Tablet then
			return
		end

		local v2 = {
			name = AppPage.InfoPeekView,
			extraProps = { title = title, body = body }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			object:dispatch(NavigateDown(v2))
		end
	end
end
