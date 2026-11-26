local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/ego")
local pointerOverlay = UIBlox.Core.VR.PointerOverlay
local vrControllerModel = require("@luauforge/bundled/ibW").VRControllerModel
local laserPointer = require("@luauforge/bundled/ibW").LaserPointer
local useIsFPSAtTarget = require("@luauforge/bundled/ibX").useIsFPSAtTarget

local function AppVRPointer()
	if useIsFPSAtTarget() then
		return (module.createElement(pointerOverlay, {
			LaserPointer = laserPointer,
			VRControllerModel = vrControllerModel
		}))
	end

	return nil
end

return AppVRPointer
