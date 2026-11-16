local parent = script:FindFirstAncestor("MomentsCommon").Parent

local Signals = require(parent.Signals)

local signal, setSuspended = Signals.createSignal(false)

return { getSuspended = signal, setSuspended = setSuspended }
