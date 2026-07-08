local CaptureService = game:GetService("CaptureService")
local EngineFeature = game:GetEngineFeature("EnableVideoCaptureApiLua")

return function() -- line: 5
	-- upvalues: EngineFeature (copy), CaptureService (copy)
	return function(_) -- line: 6
		-- upvalues: EngineFeature (copy), CaptureService (copy)
		if EngineFeature then
			CaptureService:StopVideoCaptureInternal()
		end
	end
end
