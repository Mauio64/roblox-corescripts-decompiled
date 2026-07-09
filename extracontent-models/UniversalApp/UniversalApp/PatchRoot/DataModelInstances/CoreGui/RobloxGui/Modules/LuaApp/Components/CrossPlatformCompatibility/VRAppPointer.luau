local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(Modules.Common.Roact)
local PointerOverlay = UIBlox.Core.VR.PointerOverlay
local VRControllerModel = require(CorePackages.Workspace.Packages.VrCommon).VRControllerModel
local LaserPointer = require(CorePackages.Workspace.Packages.VrCommon).LaserPointer
local useIsFPSAtTarget = require(CorePackages.Workspace.Packages.SplashScreenManager).useIsFPSAtTarget

local function AppVRPointer() -- line: 14
	-- upvalues: useIsFPSAtTarget (copy), Roact (copy), PointerOverlay (copy), LaserPointer (copy), VRControllerModel (copy)
	if useIsFPSAtTarget() then
		return (Roact.createElement(PointerOverlay, {
			LaserPointer = LaserPointer,
			VRControllerModel = VRControllerModel
		}))
	end

	return nil
end

return AppVRPointer
