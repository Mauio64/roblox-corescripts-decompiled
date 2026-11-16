local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/ecR")
local pointerOverlay = UIBlox.Core.VR.PointerOverlay
local vrControllerModel = require("@luauforge/bundled/hSx").VRControllerModel
local laserPointer = require("@luauforge/bundled/hSx").LaserPointer
local useIsFPSAtTarget = require("@luauforge/bundled/hSy").useIsFPSAtTarget

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
