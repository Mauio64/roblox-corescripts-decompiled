local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module = require("@luauforge/bundled/dPR")

game:DefineFastFlag("UniversalAppCameraEnabled5", false)

local enabledForAllFlag = require("@luauforge/bundled/fCl")

local defineFastString = game:DefineFastString("UniversalAppCameraIXPLayer", appUserLayers.CameraButton)

return module.defineIXPTest({
	name = "CameraButton",
	getDependentFlagsEnabled = function()
		return game:GetEngineFeature("FacialAnimationStreaming2")
			and game:GetEngineFeature("VideoCaptureService")
	end,
	layer = defineFastString,
	recordExposure = false,
	getEnabledFlag = function()
		return game:GetFastFlag("UniversalAppCameraEnabled5")
	end,
	getEnabledForAllFlag = function()
		return enabledForAllFlag
	end,
	variables = {
		EnabledForUser = function(p2, p3)
			local cameraButtonEnabled = p2.cameraButtonEnabled
			return p3 or cameraButtonEnabled
		end
	}
})
