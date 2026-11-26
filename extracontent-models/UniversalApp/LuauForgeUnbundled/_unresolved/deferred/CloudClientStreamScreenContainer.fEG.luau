require("@luauforge/deferred/fEH")
local module = require("@luauforge/deferred/fEI")
local overlayScreen = require("@luauforge/deferred/fEJ").OverlayScreen
local useDeviceType = require("@luauforge/deferred/fEV").useDeviceType

local fFlagUseUIOverlayForCloudPlay = require("@luauforge/deferred/fEW").FFlagUseUIOverlayForCloudPlay
local module2 = require("@luauforge/deferred/fEX")
local module3 = require("@luauforge/deferred/fFa")

local function DeviceOverlayScreen()
	local v5 = useDeviceType()

	return module.createElement(overlayScreen, { device = v5 })
end

local function CloudClientStreamScreenContainer()
	local v5 = module3()
	local element = module.createElement(module2, v5)

	if fFlagUseUIOverlayForCloudPlay then
		return module.createElement(module.Fragment, {}, {
			CloudClientStreamScreen = element,
			OverlayScreen = module.createElement(DeviceOverlayScreen)
		})
	end

	return element
end

return CloudClientStreamScreenContainer
