local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
local SignalsReact = require(parent.SignalsReact)

local useMomentMediaController = MomentsCommon.Media.useMomentMediaController
local useMomentsSurfaceReadyTracking = MomentsCommon.Performance.useMomentsSurfaceReadyTracking

require(script.Parent.FeedTypes)

local function SurfaceReadyTracker(p): nil
	local pager = p.pager

	local v = SignalsReact.useSignalState(pager.getCurrentItem)
	local momentId

	if not (v == nil or v.kind ~= "moment") then
		momentId = v.moment.momentId
	end

	local isVideo

	if v == nil or v.kind ~= "moment" then
		isVideo = false
	else
		isVideo = v.moment.metadata.captureType == Enum.CaptureType.Video
	end

	local controller = useMomentMediaController(momentId or "")

	if not momentId then
		controller = nil
	end

	useMomentsSurfaceReadyTracking({
		controller = controller,
		isVideo = isVideo,
		enabled = momentId ~= nil
	})

	return nil
end

return SurfaceReadyTracker
