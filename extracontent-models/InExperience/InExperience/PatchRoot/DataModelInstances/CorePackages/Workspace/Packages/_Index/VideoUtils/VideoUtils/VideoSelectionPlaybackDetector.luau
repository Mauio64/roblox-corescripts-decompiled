local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local React = require(VideoUtilsParent.React)
local VideoEndReason = require(VideoUtils.Analytics.Enums).VideoEndReason

local function VideoSelectionPlaybackDetector(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), VideoEndReason (copy)
	React.useEffect(function() -- line: 16
		-- upvalues: t1 (copy), VideoEndReason (copy)
		if t1.isSelected then
			t1.requestVideoPlayback(false)

			return
		end

		t1.cancelVideoPlayback(VideoEndReason.Unselected)
	end, {
		t1.isSelected,
		t1.requestVideoPlayback,
		t1.cancelVideoPlayback
	})

	return nil
end

return VideoSelectionPlaybackDetector
