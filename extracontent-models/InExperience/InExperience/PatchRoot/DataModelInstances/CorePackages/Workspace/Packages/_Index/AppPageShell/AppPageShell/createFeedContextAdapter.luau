local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signals = require(parent.Signals)

require(AppPageShell.createPageScrollStore)

local function createFeedContextAdapter(p, verticalScrollingFrameRef)
	local signal = AppCommonLib.Signal.new()

	local effect = Signals.createEffect(function(p2)
		p.getCanvasPosition(p2)
		p.getContentHeight(p2)
		signal:fire()
	end)

	return {
		scrollViewPositionChangedSignal = signal,
		verticalScrollingFrameRef = verticalScrollingFrameRef,
		destroy = function()
			effect()
		end
	}
end

return createFeedContextAdapter
