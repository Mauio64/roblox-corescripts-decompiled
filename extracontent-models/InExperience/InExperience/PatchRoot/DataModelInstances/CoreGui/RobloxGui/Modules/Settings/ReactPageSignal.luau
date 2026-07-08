local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

require(script.Parent.EnumReactPage)

local function ReactPageSignal() -- line: 11
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)

	return {
		currentReactPage = v4,
		setCurrentReactPage = v5
	}
end

return Signals.createComputed(ReactPageSignal)
