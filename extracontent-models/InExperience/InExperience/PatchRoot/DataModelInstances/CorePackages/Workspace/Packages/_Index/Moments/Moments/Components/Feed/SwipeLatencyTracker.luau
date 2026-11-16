local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local MomentsCommon = require(parent.MomentsCommon)

require(script.Parent.FeedTypes)
local useSwipeLatency = require(script.Parent.useSwipeLatency)
require(Moments.Components.VerticalPager)

local MediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider

local function SwipeLatencyTracker(data): nil
	local pager = data.pager
	local v = MediaPreloadProvider.useMediaControllerProvider()

	local v2 = React.useMemo(function()
		return function(p, p2)
			if v == nil or (p2 == nil or p2.kind ~= "moment") then
				return nil
			end

			local momentId = p2.moment.momentId
			return v.getControllerMap(p)[momentId]
		end
	end, { v })

	local v3 = React.useMemo(function()
		return function(p, p2): boolean
			local v3 = v2(p, p2)

			if v3 == nil then
				return false
			end

			local v4

			if p2 == nil or p2.kind ~= "moment" then
				v4 = false
			else
				v4 = p2.moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v4 then
				return v3.getPosition(p) > 0
			end

			return v3.getState(p).readiness == "Ready"
		end
	end, { v2 })

	local getHasPresentedFrame = React.useMemo(function()
		return function(p)
			return v3(p, pager.getCurrentItem(p))
		end
	end, { pager, v3 })

	local getTargetHasPresentedFrame = React.useCallback(function(p)
		return v3(false, p)
	end, { v3 })

	local getCaptureType = React.useCallback(function(p): string
		if p == nil or p.kind ~= "moment" then
			return "unknown"
		end

		local captureType = p.moment.metadata.captureType

		if captureType == Enum.CaptureType.Video then
			return "video"
		end

		if captureType == Enum.CaptureType.Screenshot then
			return "screenshot"
		end

		return "unknown"
	end, {})

	local current = useSwipeLatency({
		getIsSettled = React.useMemo(function()
			return function(p): boolean
				local current = data.controllerRef.current
				return current == nil or current.getScrollState(p) == "Idle"
			end
		end, { data.controllerRef }),
		getHasPresentedFrame = getHasPresentedFrame,
		getTargetHasPresentedFrame = getTargetHasPresentedFrame,
		getCaptureType = getCaptureType
	})

	React.useEffect(function()
		data.onTargetCommittedRef.current = current
		return function()
			if data.onTargetCommittedRef.current == current then
				data.onTargetCommittedRef.current = nil
			end
		end
	end, { data.onTargetCommittedRef, current })

	return nil
end

return SwipeLatencyTracker
