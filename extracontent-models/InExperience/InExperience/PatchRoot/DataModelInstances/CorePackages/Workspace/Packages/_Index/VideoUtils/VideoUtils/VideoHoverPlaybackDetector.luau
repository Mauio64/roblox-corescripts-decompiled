local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)

local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason

local function VideoHoverPlaybackDetector(data): nil
	React.useEffect(function()
		if data.isHovered then
			data.requestVideoPlayback(false)
		else
			data.cancelVideoPlayback(VideoEndReason.Unhovered)
		end
	end, { data.isHovered, data.requestVideoPlayback, data.cancelVideoPlayback })

	return nil
end

return VideoHoverPlaybackDetector
