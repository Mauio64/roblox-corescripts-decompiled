local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)

local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason

local function VideoSelectionPlaybackDetector(data): nil
	React.useEffect(function()
		if data.isSelected then
			data.requestVideoPlayback(false)
		else
			data.cancelVideoPlayback(VideoEndReason.Unselected)
		end
	end, { data.isSelected, data.requestVideoPlayback, data.cancelVideoPlayback })

	return nil
end

return VideoSelectionPlaybackDetector
