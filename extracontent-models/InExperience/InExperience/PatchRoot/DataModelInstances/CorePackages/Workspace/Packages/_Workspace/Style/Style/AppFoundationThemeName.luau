local parent = script:FindFirstAncestor("Style").Parent

require(parent.Foundation)
local Signals = require(parent.Signals)

local signal, setAppFoundationThemeName = Signals.createSignal(nil)

return { getAppFoundationThemeName = signal, setAppFoundationThemeName = setAppFoundationThemeName }
