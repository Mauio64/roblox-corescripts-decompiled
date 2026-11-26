local module = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/VrCompatibility/VRReadyWrapper")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/VrCompatibility/RoundedCornersFrame")
return {
	VRReadyWrapper = module,
	VRConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/VrCompatibility/Constants"),
	RoundedCornersFrame = module2
}
