local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local useSwipeLatency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/useSwipeLatency")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")

local mediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider

local function SwipeLatencyTracker(data): nil
	local pager = data.pager
	local v5 = mediaPreloadProvider.useMediaControllerProvider()

	local v6 = React.useMemo(function()
		return function(p2, p3)
			if v5 == nil or (p3 == nil or p3.kind ~= "moment") then
				return nil
			end

			local momentId = p3.moment.momentId
			return v5.getControllerMap(p2)[momentId]
		end
	end, { v5 })

	local v7 = React.useMemo(function()
		return function(p2, p3): boolean
			local v8 = v6(p2, p3)

			if v8 == nil then
				return false
			end

			local v9

			if p3 == nil or p3.kind ~= "moment" then
				v9 = false
			else
				v9 = p3.moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v9 then
				return v8.getPosition(p2) > 0
			end

			return v8.getState(p2).readiness == "Ready"
		end
	end, { v6 })

	local v8 = React.useMemo(function()
		return function(p2)
			return v7(p2, pager.getCurrentItem(p2))
		end
	end, { pager, v7 })

	local v9 = React.useCallback(function(p2)
		return v7(false, p2)
	end, { v7 })

	local v10 = React.useCallback(function(p2): string
		if p2 == nil or p2.kind ~= "moment" then
			return "unknown"
		end

		local captureType = p2.moment.metadata.captureType

		if captureType == Enum.CaptureType.Video then
			return "video"
		end

		if captureType == Enum.CaptureType.Screenshot then
			return "screenshot"
		end

		return "unknown"
	end, {})

	local v12 = useSwipeLatency({
		getIsSettled = React.useMemo(function()
			return function(p2): boolean
				local current = data.controllerRef.current

				if current == nil then
					return true
				end

				return current.getScrollState(p2) == "Idle"
			end
		end, { data.controllerRef }),
		getHasPresentedFrame = v8,
		getTargetHasPresentedFrame = v9,
		getCaptureType = v10
	})

	React.useEffect(function()
		data.onTargetCommittedRef.current = v12
		return function()
			if data.onTargetCommittedRef.current == v12 then
				data.onTargetCommittedRef.current = nil
			end
		end
	end, { data.onTargetCommittedRef, v12 })

	return nil
end

return SwipeLatencyTracker
