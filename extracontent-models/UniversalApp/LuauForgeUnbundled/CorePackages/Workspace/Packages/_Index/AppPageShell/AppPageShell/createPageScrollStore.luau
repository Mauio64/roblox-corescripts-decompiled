local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SignalsExperimental")

local isEndReached = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/isEndReached")
local fFlagSduiFeedScrollBarFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags").FFlagSduiFeedScrollBarFixes

local function createPageScrollStore()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(0)
	local signal3, v7 = Signals.createSignal(0)
	local signal4, v8 = Signals.createSignal(0)
	local signal5, v9 = Signals.createSignal(nil)

	local function writeExtents(p2)
		v7(p2.AbsoluteWindowSize.Y)

		v8(p2.AbsoluteCanvasSize.Y)
	end

	return {
		getScrollingFrame = signal,
		setScrollingFrame = function(p2)
			v5(p2)

			if fFlagSduiFeedScrollBarFixes and p2 ~= nil then
				SignalsExperimental.batch(function()
					v6(p2.CanvasPosition.Y)

					local v10 = p2
					v7(v10.AbsoluteWindowSize.Y)

					v8(v10.AbsoluteCanvasSize.Y)
				end)
			end
		end,
		getCanvasPosition = signal2,
		getViewportHeight = signal3,
		getContentHeight = signal4,
		setCanvasPosition = v6,
		setViewportHeight = v7,
		setContentHeight = v8,
		setCanvasPositionFromScrollingFrame = function(p2)
			v6(p2.CanvasPosition.Y)
		end,
		setViewportHeightFromScrollingFrame = function(p2)
			v7(p2.AbsoluteWindowSize.Y)
		end,
		setContentHeightFromScrollingFrame = function(p2)
			v8(p2.AbsoluteCanvasSize.Y)
		end,
		setExtentsFromScrollingFrame = function(p2)
			SignalsExperimental.batch(function()
				local v10 = p2
				v7(v10.AbsoluteWindowSize.Y)

				v8(v10.AbsoluteCanvasSize.Y)
			end)
		end,
		getIsEndReached = Signals.createComputed(function(p2)
			return isEndReached(signal2(p2), signal3(p2), signal4(p2), signal5(p2))
		end),
		setEndReachedThreshold = v9
	}
end

return createPageScrollStore
