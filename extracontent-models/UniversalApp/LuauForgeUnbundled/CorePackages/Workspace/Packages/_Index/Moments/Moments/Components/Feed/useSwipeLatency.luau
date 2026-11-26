local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local swipeLatencyMachine = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/swipeLatencyMachine")

local analytics = MomentsCommon.Analytics

local v5 = { video = "video", screenshot = "screenshot", unknown = "unknown" }

local defineFastInt = game:DefineFastInt("MomentsSwipeLatencyCapMs", 15000)

local function fireSwipeLatency(p2, p3, p4)
	analytics.fireAnalyticsEvent(analytics.EventNames.MomentsSwipeLatency, {
		mediaWaitMs = tostring(p2),
		totalLatencyMs = tostring(p3),
		captureType = v5[p4.captureType] or "unknown"
	})
end

local function useSwipeLatency(data)
	local getIsSettled = data.getIsSettled
	local getHasPresentedFrame = data.getHasPresentedFrame
	local getTargetHasPresentedFrame = data.getTargetHasPresentedFrame
	local getCaptureType = data.getCaptureType

	local ref = React.useRef(data.onMeasurement or fireSwipeLatency)
	ref.current = data.onMeasurement or fireSwipeLatency

	local v6 = React.useMemo(function()
		local now = data.now or function()
			return os.clock() * 1000
		end

		return swipeLatencyMachine({
			now = now,
			capMs = data.capMs or defineFastInt,
			onMeasurement = function(p2, p3, p4)
				ref.current(p2, p3, p4)
			end
		})
	end, {})

	local v7 = React.useCallback(function(p2, p3, p4)
		v6.start(getIsSettled(false), getTargetHasPresentedFrame(p4), {
			captureType = getCaptureType(p4)
		})
	end, { v6, getIsSettled, getTargetHasPresentedFrame, getCaptureType })

	React.useEffect(function()
		return (Signals.createEffect(function(p2)
			v6.update(getIsSettled(p2), getHasPresentedFrame(p2))
		end))
	end, { getIsSettled, getHasPresentedFrame, v6 })

	return v7
end

return useSwipeLatency
