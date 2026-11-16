local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason

local function VideoSelectionPlaybackDetector(data): nil
	React.useEffect(function()
		if data.isSelected then
			data.requestVideoPlayback(false)
		else
			data.cancelVideoPlayback(videoEndReason.Unselected)
		end
	end, { data.isSelected, data.requestVideoPlayback, data.cancelVideoPlayback })

	return nil
end

return VideoSelectionPlaybackDetector
