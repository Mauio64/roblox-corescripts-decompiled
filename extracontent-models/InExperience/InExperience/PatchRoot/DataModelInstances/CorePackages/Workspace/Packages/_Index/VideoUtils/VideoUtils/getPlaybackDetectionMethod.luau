local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local Responsive = require(parent.Responsive)

local VideoPlaybackDetectionMethod = require(VideoUtils.VideoPlaybackDetectionMethod)

local function getPlaybackDetectionMethod(p: string?, flag: boolean?)
	if flag then
		return VideoPlaybackDetectionMethod.Hover
	end

	if p == Responsive.Input.Touch then
		return VideoPlaybackDetectionMethod.Viewport
	end

	if p == Responsive.Input.Directional then
		return VideoPlaybackDetectionMethod.Selection
	end

	return nil
end

return getPlaybackDetectionMethod
