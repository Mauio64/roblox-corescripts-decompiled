local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason

local function VideoHoverPlaybackDetector(data): nil
	React.useEffect(function()
		if data.isHovered then
			data.requestVideoPlayback(false)
		else
			data.cancelVideoPlayback(videoEndReason.Unhovered)
		end
	end, { data.isHovered, data.requestVideoPlayback, data.cancelVideoPlayback })

	return nil
end

return VideoHoverPlaybackDetector
