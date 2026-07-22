local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local React = require(VideoUtilsParent.React)
local Signals = require(VideoUtilsParent.Signals)
local SignalsReact = require(VideoUtilsParent.SignalsReact)
local useSelector = require(VideoUtilsParent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigationFocus = require(VideoUtilsParent.Navigation).useNavigationFocus
local VideoEndReason = require(VideoUtils.Analytics.Enums).VideoEndReason

require(VideoUtils.VideoPlaybackCoordinator)
require(VideoUtils.ViewportVideoAutoplayController)

local FFlagLuaAppEdpMediaGalleryFullScreen = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagVideoPlaybackDetectorCancelPendingScanTask = require(VideoUtilsParent.SharedFlags).FFlagVideoPlaybackDetectorCancelPendingScanTask
local FIntVideoPlaybackDetectorScanDebounceInMilliseconds = require(VideoUtilsParent.SharedFlags).FIntVideoPlaybackDetectorScanDebounceInMilliseconds
local t1 = {
	instance = nil,
	shouldUseDwell = true
}
local v15 = Signals.createSignal(t1)
local v16 = not FFlagVideoPlaybackDetectorCancelPendingScanTask and 0.5 or FIntVideoPlaybackDetectorScanDebounceInMilliseconds / 1000

local function VideoViewportPlaybackDetector(t2: {[any]: any}) -- line: 56
	-- upvalues: useNavigationFocus (copy), useSelector (copy), React (copy), SignalsReact (copy), v15 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), VideoEndReason (copy), AppLifecycleObserverService (copy), ExperienceService (copy), v16 (copy), FFlagVideoPlaybackDetectorCancelPendingScanTask (copy)
	local v19 = useNavigationFocus()
	local v20 = useSelector(function(p1) -- line: 59
		return p1.ScreenSize
	end)
	local v21 = useSelector(function(p2) -- line: 63
		return p2.TopBar.topBarHeight
	end)
	local v22 = useSelector(function(p3) -- line: 67
		return p3.GlobalGuiInset
	end)
	local v23 = React.useMemo(function() -- line: 71
		-- upvalues: v21 (copy), v20 (copy), v22 (copy)
		return {
			min = Vector2.new(0, v21),
			max = Vector2.new(v20.X, v20.Y - v22.bottom)
		}
	end, {
		v21,
		v20,
		v22
	})
	local v24 = SignalsReact.useSignalState(if not t2.viewportVideoAutoplayController then v15 else t2.viewportVideoAutoplayController.getWinnerState)

	React.useEffect(function() -- line: 85
		-- upvalues: t2 (copy), v24 (copy), v19 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), VideoEndReason (copy)
		if not t2.viewportVideoAutoplayController then
			return
		end

		if t2.itemFrameRef.current ~= nil and v24.instance == t2.itemFrameRef.current then
			if t2.videoPlaybackCoordinator:isPlaybackAllowed(v19, if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded) then
				t2.requestVideoPlayback(v24.shouldUseDwell)

				return
			end

			t2.cancelVideoPlayback(VideoEndReason.ExitViewport)
		end
	end, {
		t2.viewportVideoAutoplayController,
		t2.itemFrameRef,
		t2.requestVideoPlayback,
		t2.cancelVideoPlayback,
		t2.videoPlaybackCoordinator,
		v19,
		v24,
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded
	})
	React.useEffect(function() -- line: 118
		-- upvalues: t2 (copy), AppLifecycleObserverService (copy), ExperienceService (copy)
		local viewportVideoAutoplayController = t2.viewportVideoAutoplayController

		if not viewportVideoAutoplayController then
			return
		end

		local connection = AppLifecycleObserverService.OnUnhide:Connect(function() -- line: 124
			-- upvalues: viewportVideoAutoplayController (copy)
			viewportVideoAutoplayController:scheduleUpdateWinner("Y", nil, true)
		end)
		local v30 = ExperienceService:RegisterForExperienceLeave(function() -- line: 129
			-- upvalues: viewportVideoAutoplayController (copy)
			viewportVideoAutoplayController:scheduleUpdateWinner("Y", nil, true)
		end)

		return function() -- line: 134
			-- upvalues: connection (copy), v30 (copy)
			connection:Disconnect()
			v30:Disconnect()
		end
	end, { t2.viewportVideoAutoplayController })
	React.useEffect(function() -- line: 143
		-- upvalues: t2 (copy), v19 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), v23 (copy), VideoEndReason (copy), v16 (copy), FFlagVideoPlaybackDetectorCancelPendingScanTask (copy), AppLifecycleObserverService (copy), ExperienceService (copy)
		if t2.viewportVideoAutoplayController ~= nil then
			return
		end

		local t3 = {}
		local u32 = nil

		if t2.itemFrameRef.current ~= nil then
			local current = t2.itemFrameRef.current
			local timestamp = nil
			local u35 = nil

			local function requestPlaybackIfEligible() -- line: 156
				-- upvalues: timestamp (ref), t2 (copy), v19 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), v23 (copy), VideoEndReason (copy)
				timestamp = tick()

				if t2.videoPlaybackCoordinator:isPlaybackCandidate(v19, if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded, t2.itemFrameRef, v23, t2.videoVisiblePercent) then
					t2.requestVideoPlayback(true)

					return
				end

				t2.cancelVideoPlayback(VideoEndReason.ExitViewport)
			end
			local function onItemFrameLayoutChange() -- line: 174
				-- upvalues: u35 (ref), timestamp (ref), v16 (copy), requestPlaybackIfEligible (copy), FFlagVideoPlaybackDetectorCancelPendingScanTask (copy), u32 (ref)
				if u35 ~= nil then
					return
				end

				local n1 = 0

				if timestamp ~= nil then
					u35 = timestamp + v16
					n1 = u35 - tick()
				end

				if n1 > 0 then
					local thread = task.delay(n1, function() -- line: 187
						-- upvalues: u35 (ref), requestPlaybackIfEligible (copy)
						u35 = nil
						requestPlaybackIfEligible()
					end)

					if FFlagVideoPlaybackDetectorCancelPendingScanTask then
						u32 = thread

						return
					end
				else
					u35 = nil
					requestPlaybackIfEligible()
				end
			end

			requestPlaybackIfEligible()

			local connection = AppLifecycleObserverService.OnUnhide:Connect(function() -- line: 204
				-- upvalues: requestPlaybackIfEligible (copy)
				requestPlaybackIfEligible()
			end)
			local v39 = ExperienceService:RegisterForExperienceLeave(function() -- line: 210
				-- upvalues: requestPlaybackIfEligible (copy)
				requestPlaybackIfEligible()
			end)

			t3 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onItemFrameLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onItemFrameLayoutChange)
			}
			table.insert(t3, connection)
			table.insert(t3, v39)
		end

		return function() -- line: 223
			-- upvalues: FFlagVideoPlaybackDetectorCancelPendingScanTask (copy), u32 (ref), t3 (ref)
			if FFlagVideoPlaybackDetectorCancelPendingScanTask and u32 then
				task.cancel(u32)
				u32 = nil
			end

			for _, v43 in t3 do
				v43:Disconnect()
			end
		end
	end, {
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded,
		t2.itemFrameRef,
		t2.videoVisiblePercent,
		v19,
		v23,
		t2.videoPlaybackCoordinator,
		t2.requestVideoPlayback,
		t2.cancelVideoPlayback,
		t2.viewportVideoAutoplayController
	})

	return nil
end

return VideoViewportPlaybackDetector
