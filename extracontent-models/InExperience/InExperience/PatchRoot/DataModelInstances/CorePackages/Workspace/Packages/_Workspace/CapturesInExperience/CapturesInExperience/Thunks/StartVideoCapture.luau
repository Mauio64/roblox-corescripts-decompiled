local CaptureService = game:GetService("CaptureService")

local engineFeature = game:GetEngineFeature("EnableVideoCaptureApiLua")

return function()
	return function(_)
		if engineFeature then
			CaptureService:StartVideoCaptureInternalAsync()
		end
	end
end
