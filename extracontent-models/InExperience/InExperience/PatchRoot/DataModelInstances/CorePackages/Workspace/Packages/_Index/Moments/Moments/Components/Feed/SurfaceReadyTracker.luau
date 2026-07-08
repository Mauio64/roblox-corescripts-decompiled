local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsCommon = require(Parent.MomentsCommon)
local SignalsReact = require(Parent.SignalsReact)
local useMomentMediaController = MomentsCommon.Media.useMomentMediaController
local useMomentsSurfaceReadyTracking = MomentsCommon.Performance.useMomentsSurfaceReadyTracking

require(script.Parent.FeedTypes)

local function SurfaceReadyTracker(t1: {[any]: any}) -- line: 19
	-- upvalues: SignalsReact (copy), useMomentMediaController (copy), useMomentsSurfaceReadyTracking (copy)
	local pager = t1.pager
	local v9 = SignalsReact.useSignalState(pager.getCurrentItem)
	local v10 = if v9 == nil or v9.kind ~= "moment" then nil else v9.moment.momentId
	local v11 = v9 ~= nil and (v9.kind == "moment" and v9.moment.metadata.captureType == Enum.CaptureType.Video)
	local v12 = useMomentMediaController(v10 or "")

	useMomentsSurfaceReadyTracking({
		controller = if not v10 then nil else v12,
		isVideo = v11,
		enabled = v10 ~= nil
	})

	return nil
end

return SurfaceReadyTracker
