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
local FFlagLuaAppHomeTouchAutoplay = require(VideoUtilsParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local t1 = {
	instance = nil,
	shouldUseDwell = true
}
local v16 = Signals.createSignal(t1)
local v17 = not FFlagVideoPlaybackDetectorCancelPendingScanTask and 0.5 or FIntVideoPlaybackDetectorScanDebounceInMilliseconds / 1000

local function VideoViewportPlaybackDetector(t2: {[any]: any}) -- line: 57
	-- upvalues: useNavigationFocus (copy), useSelector (copy), React (copy), FFlagLuaAppHomeTouchAutoplay (copy), SignalsReact (copy), v16 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), VideoEndReason (copy), AppLifecycleObserverService (copy), ExperienceService (copy), v17 (copy), FFlagVideoPlaybackDetectorCancelPendingScanTask (copy)
	local v20 = useNavigationFocus()
	local v21 = useSelector(function(p1) -- line: 60
		return p1.ScreenSize
	end)
	local v22 = useSelector(function(p2) -- line: 64
		return p2.TopBar.topBarHeight
	end)
	local v23 = useSelector(function(p3) -- line: 68
		return p3.GlobalGuiInset
	end)
	local v24 = React.useMemo(function() -- line: 72
		-- upvalues: v22 (copy), v21 (copy), v23 (copy)
		return {
			min = Vector2.new(0, v22),
			max = Vector2.new(v21.X, v21.Y - v23.bottom)
		}
	end, {
		v22,
		v21,
		v23
	})

	if FFlagLuaAppHomeTouchAutoplay then
		local v25 = SignalsReact.useSignalState(if not t2.viewportVideoAutoplayController then v16 else t2.viewportVideoAutoplayController.getWinnerState)

		React.useEffect(function() -- line: 87
			-- upvalues: t2 (copy), v25 (copy), v20 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), VideoEndReason (copy)
			if not t2.viewportVideoAutoplayController then
				return
			end

			if t2.itemFrameRef.current ~= nil and v25.instance == t2.itemFrameRef.current then
				if t2.videoPlaybackCoordinator:isPlaybackAllowed(v20, if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded) then
					t2.requestVideoPlayback(v25.shouldUseDwell)

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
			v20,
			v25,
			if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded
		})
		React.useEffect(function() -- line: 120
			-- upvalues: t2 (copy), AppLifecycleObserverService (copy), ExperienceService (copy)
			local viewportVideoAutoplayController = t2.viewportVideoAutoplayController

			if not viewportVideoAutoplayController then
				return
			end

			local connection = AppLifecycleObserverService.OnUnhide:Connect(function() -- line: 126
				-- upvalues: viewportVideoAutoplayController (copy)
				viewportVideoAutoplayController:scheduleUpdateWinner("Y", nil, true)
			end)
			local v31 = ExperienceService:RegisterForExperienceLeave(function() -- line: 131
				-- upvalues: viewportVideoAutoplayController (copy)
				viewportVideoAutoplayController:scheduleUpdateWinner("Y", nil, true)
			end)

			return function() -- line: 136
				-- upvalues: connection (copy), v31 (copy)
				connection:Disconnect()
				v31:Disconnect()
			end
		end, { t2.viewportVideoAutoplayController })
	end

	React.useEffect(function() -- line: 146
		-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), t2 (copy), v20 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), v24 (copy), VideoEndReason (copy), v17 (copy), FFlagVideoPlaybackDetectorCancelPendingScanTask (copy), AppLifecycleObserverService (copy), ExperienceService (copy)
		if FFlagLuaAppHomeTouchAutoplay and t2.viewportVideoAutoplayController ~= nil then
			return
		end

		local t3 = {}
		local u33 = nil

		if t2.itemFrameRef.current ~= nil then
			local current = t2.itemFrameRef.current
			local timestamp = nil
			local u36 = nil

			local function requestPlaybackIfEligible() -- line: 159
				-- upvalues: timestamp (ref), t2 (copy), v20 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), v24 (copy), VideoEndReason (copy)
				timestamp = tick()

				if t2.videoPlaybackCoordinator:isPlaybackCandidate(v20, if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded, t2.itemFrameRef, v24, t2.videoVisiblePercent) then
					t2.requestVideoPlayback(true)

					return
				end

				t2.cancelVideoPlayback(VideoEndReason.ExitViewport)
			end
			local function onItemFrameLayoutChange() -- line: 177
				-- upvalues: u36 (ref), timestamp (ref), v17 (copy), requestPlaybackIfEligible (copy), FFlagVideoPlaybackDetectorCancelPendingScanTask (copy), u33 (ref)
				if u36 ~= nil then
					return
				end

				local n1 = 0

				if timestamp ~= nil then
					u36 = timestamp + v17
					n1 = u36 - tick()
				end

				if n1 > 0 then
					local thread = task.delay(n1, function() -- line: 190
						-- upvalues: u36 (ref), requestPlaybackIfEligible (copy)
						u36 = nil
						requestPlaybackIfEligible()
					end)

					if FFlagVideoPlaybackDetectorCancelPendingScanTask then
						u33 = thread

						return
					end
				else
					u36 = nil
					requestPlaybackIfEligible()
				end
			end

			requestPlaybackIfEligible()

			local connection = AppLifecycleObserverService.OnUnhide:Connect(function() -- line: 207
				-- upvalues: requestPlaybackIfEligible (copy)
				requestPlaybackIfEligible()
			end)
			local v40 = ExperienceService:RegisterForExperienceLeave(function() -- line: 213
				-- upvalues: requestPlaybackIfEligible (copy)
				requestPlaybackIfEligible()
			end)

			t3 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onItemFrameLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onItemFrameLayoutChange)
			}
			table.insert(t3, connection)
			table.insert(t3, v40)
		end

		return function() -- line: 226
			-- upvalues: FFlagVideoPlaybackDetectorCancelPendingScanTask (copy), u33 (ref), t3 (ref)
			if FFlagVideoPlaybackDetectorCancelPendingScanTask and u33 then
				task.cancel(u33)
				u33 = nil
			end

			for _, v44 in t3 do
				v44:Disconnect()
			end
		end
	end, {
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t2.isItemOccluded,
		t2.itemFrameRef,
		t2.videoVisiblePercent,
		v20,
		v24,
		t2.videoPlaybackCoordinator,
		t2.requestVideoPlayback,
		t2.cancelVideoPlayback,
		if not FFlagLuaAppHomeTouchAutoplay then nil else t2.viewportVideoAutoplayController
	})

	return nil
end

return VideoViewportPlaybackDetector
