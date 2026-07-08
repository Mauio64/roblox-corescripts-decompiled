local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui").RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local Constants = require(ShareGame.Constants)
local SetDeviceLayout = require(ShareGame.Actions.SetDeviceLayout)
local SetDeviceOrientation = require(CorePackages.Workspace.Packages.DeviceOrientationRodux).Actions.SetDeviceOrientation
local SetIsSmallTouchScreen = require(ShareGame.Actions.SetIsSmallTouchScreen)

return function(p1, p2) -- line: 14
	-- upvalues: Constants (copy), SetDeviceOrientation (copy), Immutable (copy), SetDeviceLayout (copy), SetIsSmallTouchScreen (copy)
	local v10 = p1 or {
		IsSmallTouchScreen = false,
		DeviceLayout = Constants.DeviceLayout.DESKTOP,
		DeviceOrientation = Constants.DeviceOrientation.INVALID
	}

	if p2.type == SetDeviceOrientation.name then
		return (Immutable.Set(v10, "DeviceOrientation", p2.deviceOrientation))
	end

	if p2.type == SetDeviceLayout.name then
		return (Immutable.Set(v10, "DeviceLayout", p2.deviceLayout))
	end

	if p2.type == SetIsSmallTouchScreen.name then
		v10 = Immutable.Set(v10, "IsSmallTouchScreen", p2.isSmallTouchScreen)
	end

	return v10
end
