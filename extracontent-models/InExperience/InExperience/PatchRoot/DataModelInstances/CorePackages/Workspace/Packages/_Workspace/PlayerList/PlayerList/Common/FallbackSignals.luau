local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)

return { getHasActiveLeaderboard = Signals.createSignal(false) }
