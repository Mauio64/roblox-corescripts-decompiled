local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)

local signal, v5 = Signals.createSignal(0)

return {
	getGeneration = signal,
	request = function()
		v5(signal(false) + 1)
	end
}
