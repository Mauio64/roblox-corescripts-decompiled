local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local isEndReached = require(AppPageShell.isEndReached)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes

local function createPageScrollStore()
	local signal, v = Signals.createSignal(nil)
	local signal2, setCanvasPosition = Signals.createSignal(0)
	local signal3, setViewportHeight = Signals.createSignal(0)
	local signal4, setContentHeight = Signals.createSignal(0)
	local signal5, setEndReachedThreshold = Signals.createSignal(nil)

	local function setCanvasPositionFromScrollingFrame(p) -- 1 equivalent call inferred from this helper
		setCanvasPosition(p.CanvasPosition.Y)
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
			v(p)

			if FFlagSduiFeedScrollBarFixes and p ~= nil then
				SignalsExperimental.batch(function()
					setCanvasPositionFromScrollingFrame(p) -- inferred equivalent call
					local v2 = p
					setViewportHeightFromScrollingFrame(v2) -- inferred equivalent call
					setContentHeightFromScrollingFrame(v2) -- inferred equivalent call
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
				local v2 = p
				setViewportHeightFromScrollingFrame(v2) -- inferred equivalent call
				setContentHeightFromScrollingFrame(v2) -- inferred equivalent call
			end)
		end,
		getIsEndReached = Signals.createComputed(function(p)
			return isEndReached(signal2(p), signal3(p), signal4(p), signal5(p))
		end),
		setEndReachedThreshold = setEndReachedThreshold
	}
end

return createPageScrollStore
