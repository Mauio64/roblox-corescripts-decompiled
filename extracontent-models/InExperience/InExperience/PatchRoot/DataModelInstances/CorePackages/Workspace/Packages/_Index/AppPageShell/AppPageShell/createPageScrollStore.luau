local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)

local isEndReached = require(AppPageShell.isEndReached)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppPageShellScrollTelemetry = SharedFlags2.FFlagAppPageShellScrollTelemetry

local function createPageScrollStore(debugName: string?)
	local signal, v = Signals.createSignal(nil)
	local signal2, v2 = Signals.createSignal(0)
	local signal3, setViewportHeight = Signals.createSignal(0)
	local signal4, setContentHeight = Signals.createSignal(0)
	local signal5, setEndReachedThreshold = Signals.createSignal(nil)

	local getIsEndReached = Signals.createComputed(function(p)
		return isEndReached(signal2(p), signal3(p), signal4(p), signal5(p))
	end)

	local v3 = nil

	local function rebindTracker(p)
		if v3 then
			v3.cleanup()
			v3 = nil
		end

		if debugName and p then
			v3 = IntervalPerformanceTracker.createScrollIntervalPerformanceTracker(debugName, p, nil, {
				scrollOptions = { debugName = debugName }
			})
		end
	end

	local function setCanvasPosition(y: number) -- 1 equivalent call inferred from this helper
		v2(y)

		if FFlagAppPageShellScrollTelemetry and v3 then
			v3.onScrollTick()
		end
	end
	local function setCanvasPositionFromScrollingFrame(p) -- 1 equivalent call inferred from this helper
		setCanvasPosition(p.CanvasPosition.Y) -- inferred equivalent call
	end
	local function setViewportHeightFromScrollingFrame(p) -- 3 equivalent calls inferred from this helper
		setViewportHeight(p.AbsoluteWindowSize.Y)
	end
	local function setContentHeightFromScrollingFrame(p) -- 3 equivalent calls inferred from this helper
		setContentHeight(p.AbsoluteCanvasSize.Y)
	end

	local function writeExtents(p)
		setViewportHeightFromScrollingFrame(p) -- inferred equivalent call
		setContentHeightFromScrollingFrame(p) -- inferred equivalent call
	end
	return {
		getScrollingFrame = signal,
		setScrollingFrame = function(p)
			if FFlagAppPageShellScrollTelemetry and p ~= signal(false) then
				rebindTracker(p)
			end

			v(p)

			if FFlagSduiFeedScrollBarFixes and p ~= nil then
				SignalsExperimental.batch(function()
					setCanvasPositionFromScrollingFrame(p) -- inferred equivalent call
					local v4 = p
					setViewportHeightFromScrollingFrame(v4) -- inferred equivalent call
					setContentHeightFromScrollingFrame(v4) -- inferred equivalent call
				end)
			end
		end,
		getCanvasPosition = signal2,
		getViewportHeight = signal3,
		getContentHeight = signal4,
		setCanvasPosition = setCanvasPosition,
		setViewportHeight = setViewportHeight,
		setContentHeight = setContentHeight,
		setCanvasPositionFromScrollingFrame = setCanvasPositionFromScrollingFrame,
		setViewportHeightFromScrollingFrame = setViewportHeightFromScrollingFrame,
		setContentHeightFromScrollingFrame = setContentHeightFromScrollingFrame,
		setExtentsFromScrollingFrame = function(p)
			SignalsExperimental.batch(function()
				local v4 = p
				setViewportHeightFromScrollingFrame(v4) -- inferred equivalent call
				setContentHeightFromScrollingFrame(v4) -- inferred equivalent call
			end)
		end,
		getIsEndReached = getIsEndReached,
		setEndReachedThreshold = setEndReachedThreshold
	}
end

return createPageScrollStore
