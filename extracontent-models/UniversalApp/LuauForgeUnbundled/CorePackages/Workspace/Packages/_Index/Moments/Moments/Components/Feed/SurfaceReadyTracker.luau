local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local useMomentMediaController = MomentsCommon.Media.useMomentMediaController
local useMomentsSurfaceReadyTracking = MomentsCommon.Performance.useMomentsSurfaceReadyTracking

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local function SurfaceReadyTracker(p2): nil
	local pager = p2.pager

	local v5 = SignalsReact.useSignalState(pager.getCurrentItem)

	local momentId = if not (v5 == nil or v5.kind ~= "moment") then v5.moment.momentId else nil
	local v6

	if v5 == nil or v5.kind ~= "moment" then
		v6 = false
	else
		v6 = v5.moment.metadata.captureType == Enum.CaptureType.Video
	end

	local v7 = useMomentMediaController(momentId or "")

	if not momentId then
		v7 = nil
	end

	useMomentsSurfaceReadyTracking({
		controller = v7,
		isVideo = v6,
		enabled = momentId ~= nil
	})

	return nil
end

return SurfaceReadyTracker
