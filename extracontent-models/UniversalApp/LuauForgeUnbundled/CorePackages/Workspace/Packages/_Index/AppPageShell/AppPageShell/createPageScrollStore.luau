local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SignalsExperimental")
local IntervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/IntervalPerformanceTracker")

local isEndReached = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/isEndReached")
local fFlagSduiFeedScrollBarFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags").FFlagSduiFeedScrollBarFixes
local fFlagAppPageShellScrollTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags").FFlagAppPageShellScrollTelemetry

local function createPageScrollStore(p2)
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(0)
	local signal3, v7 = Signals.createSignal(0)
	local signal4, v8 = Signals.createSignal(0)
	local signal5, v9 = Signals.createSignal(nil)

	local computed = Signals.createComputed(function(p3)
		return isEndReached(signal2(p3), signal3(p3), signal4(p3), signal5(p3))
	end)

	local v10 = nil

	local function rebindTracker(p3)
		if v10 then
			v10.cleanup()
			v10 = nil
		end

		if p2 and p3 then
			v10 = IntervalPerformanceTracker.createScrollIntervalPerformanceTracker(p2, p3, nil, {
				scrollOptions = { debugName = p2 }
			})
		end
	end

	local function writeExtents(p3)
		v7(p3.AbsoluteWindowSize.Y)

		v8(p3.AbsoluteCanvasSize.Y)
	end

	return {
		getScrollingFrame = signal,
		setScrollingFrame = function(p3)
			if fFlagAppPageShellScrollTelemetry and p3 ~= signal(false) then
				rebindTracker(p3)
			end

			v5(p3)

			if fFlagSduiFeedScrollBarFixes and p3 ~= nil then
				SignalsExperimental.batch(function()
					v6(p3.CanvasPosition.Y)

					if fFlagAppPageShellScrollTelemetry and v10 then
						v10.onScrollTick()
					end

					local v11 = p3
					v7(v11.AbsoluteWindowSize.Y)

					v8(v11.AbsoluteCanvasSize.Y)
				end)
			end
		end,
		getCanvasPosition = signal2,
		getViewportHeight = signal3,
		getContentHeight = signal4,
		setCanvasPosition = function(p3)
			v6(p3)

			if fFlagAppPageShellScrollTelemetry and v10 then
				v10.onScrollTick()
			end
		end,
		setViewportHeight = v7,
		setContentHeight = v8,
		setCanvasPositionFromScrollingFrame = function(p3)
			v6(p3.CanvasPosition.Y)

			if fFlagAppPageShellScrollTelemetry and v10 then
				v10.onScrollTick()
			end
		end,
		setViewportHeightFromScrollingFrame = function(p3)
			v7(p3.AbsoluteWindowSize.Y)
		end,
		setContentHeightFromScrollingFrame = function(p3)
			v8(p3.AbsoluteCanvasSize.Y)
		end,
		setExtentsFromScrollingFrame = function(p3)
			SignalsExperimental.batch(function()
				local v11 = p3
				v7(v11.AbsoluteWindowSize.Y)

				v8(v11.AbsoluteCanvasSize.Y)
			end)
		end,
		getIsEndReached = computed,
		setEndReachedThreshold = v9
	}
end

return createPageScrollStore
