local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/AppCommonLib")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/createPageScrollStore")

local function createFeedContextAdapter(p2, p3)
	local signal = AppCommonLib.Signal.new()

	local effect = Signals.createEffect(function(p4)
		p2.getCanvasPosition(p4)
		p2.getContentHeight(p4)
		signal:fire()
	end)

	return {
		scrollViewPositionChangedSignal = signal,
		verticalScrollingFrameRef = p3,
		destroy = function()
			effect()
		end
	}
end

return createFeedContextAdapter
