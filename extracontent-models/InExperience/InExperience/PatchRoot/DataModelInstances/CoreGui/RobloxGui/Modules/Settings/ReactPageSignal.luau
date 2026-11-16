local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

require(script.Parent.EnumReactPage)

local function ReactPageSignal()
	local signal, setCurrentReactPage = Signals.createSignal(nil)
	return { currentReactPage = signal, setCurrentReactPage = setCurrentReactPage }
end

return Signals.createComputed(ReactPageSignal)
