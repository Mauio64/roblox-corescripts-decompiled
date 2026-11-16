local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local Constants = require(ShareGame.Constants)

local SetDeviceLayout = require(ShareGame.Actions.SetDeviceLayout)
local DeviceOrientationRodux = require(CorePackages.Workspace.Packages.DeviceOrientationRodux)
local SetDeviceOrientation = DeviceOrientationRodux.Actions.SetDeviceOrientation
local SetIsSmallTouchScreen = require(ShareGame.Actions.SetIsSmallTouchScreen)

return function(p, data)
	p = p
		or {
			DeviceLayout = Constants.DeviceLayout.DESKTOP,
			DeviceOrientation = Constants.DeviceOrientation.INVALID,
			IsSmallTouchScreen = false
		}

	if data.type == SetDeviceOrientation.name then
		return (Immutable.Set(p, "DeviceOrientation", data.deviceOrientation))
	end

	if data.type == SetDeviceLayout.name then
		return (Immutable.Set(p, "DeviceLayout", data.deviceLayout))
	end

	if data.type == SetIsSmallTouchScreen.name then
		p = Immutable.Set(p, "IsSmallTouchScreen", data.isSmallTouchScreen)
	end

	return p
end
