local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local MomentsCommon = require(parent.MomentsCommon)

require(script.Parent.FeedTypes)
local swipeLatencyMachine = require(script.Parent.swipeLatencyMachine)

local Analytics = MomentsCommon.Analytics

local v = { video = "video", screenshot = "screenshot", unknown = "unknown" }

local defineFastInt = game:DefineFastInt("MomentsSwipeLatencyCapMs", 15000)

local function fireSwipeLatency(p: number, p2: number, p3)
	Analytics.fireAnalyticsEvent(Analytics.EventNames.MomentsSwipeLatency, {
		mediaWaitMs = tostring(p),
		totalLatencyMs = tostring(p2),
		captureType = v[p3.captureType] or "unknown"
	})
end

local function useSwipeLatency(data)
	local getIsSettled = data.getIsSettled
	local getHasPresentedFrame = data.getHasPresentedFrame
	local getTargetHasPresentedFrame = data.getTargetHasPresentedFrame
	local getCaptureType = data.getCaptureType

	local ref = React.useRef(data.onMeasurement or fireSwipeLatency)
	ref.current = data.onMeasurement or fireSwipeLatency

	local v2 = React.useMemo(function()
		return swipeLatencyMachine({
			now = data.now or function()
				return os.clock() * 1000
			end,
			capMs = data.capMs or defineFastInt,
			onMeasurement = function(p, p2, p3)
				ref.current(p, p2, p3)
			end
		})
	end, {})

	local v3 = React.useCallback(function(_: number, _: number, p)
		v2.start(getIsSettled(false), getTargetHasPresentedFrame(p), {
			captureType = getCaptureType(p)
		})
	end, { v2, getIsSettled, getTargetHasPresentedFrame, getCaptureType })

	React.useEffect(function()
		return (Signals.createEffect(function(p)
			v2.update(getIsSettled(p), getHasPresentedFrame(p))
		end))
	end, { getIsSettled, getHasPresentedFrame, v2 })

	return v3
end

return useSwipeLatency
