local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

local signal, v5 = Signals.createSignal(false)

return { getHasPendingTap = signal, setHasPendingTap = v5 }
