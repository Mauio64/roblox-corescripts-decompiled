require("@luauforge/bundled/dKT")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local module = require("@luauforge/bundled/gJT")

local function isPortrait(p2): boolean
	if isVRAppBuild() then
		return true
	end

	if fFlagEnableSplitPane then
		return module(p2) == deviceOrientationMode.Portrait
	end

	return p2.DeviceOrientation == deviceOrientationMode.Portrait
end

return isPortrait
