local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Responsive")

local VideoPlaybackDetectionMethod = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackDetectionMethod")

local function getPlaybackDetectionMethod(p2, p3)
	if p3 then
		return VideoPlaybackDetectionMethod.Hover
	end

	if p2 == Responsive.Input.Touch then
		return VideoPlaybackDetectionMethod.Viewport
	end

	if p2 == Responsive.Input.Directional then
		return VideoPlaybackDetectionMethod.Selection
	end

	return nil
end

return getPlaybackDetectionMethod
