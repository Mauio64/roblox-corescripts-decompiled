local parent = script.Parent.Parent.Parent

local MomentsCommon = require(parent.MomentsCommon)
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure

local function logCaptureEndLayerExposure()
	logMomentsLayerExposure("Moments.CaptureEnd")
end

return logCaptureEndLayerExposure
