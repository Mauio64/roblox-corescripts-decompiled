local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("UniversalAppCameraEnabled5", false)

local FFlagUniversalAppCameraEnabledForAll = require(Modules.AvatarExperience.Flags.FFlagUniversalAppCameraEnabledForAll)
local v7 = game:DefineFastString("UniversalAppCameraIXPLayer", AppUserLayers.CameraButton)

return IxpUtils.defineIXPTest({
	name = "CameraButton",
	recordExposure = false,
	getDependentFlagsEnabled = function() -- line: 23
		return game:GetEngineFeature("FacialAnimationStreaming2") and game:GetEngineFeature("VideoCaptureService")
	end,
	layer = v7,
	getEnabledFlag = function() -- line: 33
		return game:GetFastFlag("UniversalAppCameraEnabled5")
	end,
	getEnabledForAllFlag = function() -- line: 37
		-- upvalues: FFlagUniversalAppCameraEnabledForAll (copy)
		return FFlagUniversalAppCameraEnabledForAll
	end,
	variables = {
		EnabledForUser = function(p1, p2) -- line: 42
			local cameraButtonEnabled = p1.cameraButtonEnabled

			return p2 or cameraButtonEnabled
		end
	}
})
