local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)

local signal, v5 = Signals.createSignal(nil)

return {
	getContentRegionRect = signal,
	setFromInstance = function(p2)
		local absolutePosition = p2.AbsolutePosition
		v5(Rect.new(absolutePosition, absolutePosition + p2.AbsoluteSize))
	end,
	reset = function()
		v5(nil)
	end
}
