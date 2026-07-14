local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local Responsive = require(VideoUtilsParent.Responsive)
local VideoPlaybackDetectionMethod = require(VideoUtils.VideoPlaybackDetectionMethod)

local function getPlaybackDetectionMethod(s1: string?, b1: boolean?) -- line: 10
	-- upvalues: VideoPlaybackDetectionMethod (copy), Responsive (copy)
	if b1 then
		return VideoPlaybackDetectionMethod.Hover
	end

	if s1 == Responsive.Input.Touch then
		return VideoPlaybackDetectionMethod.Viewport
	end

	if s1 == Responsive.Input.Directional then
		return VideoPlaybackDetectionMethod.Selection
	end

	return nil
end

return getPlaybackDetectionMethod
