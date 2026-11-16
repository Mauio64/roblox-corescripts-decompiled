local parent = script:FindFirstAncestor("MomentsCommon").Parent

local Signals = require(parent.Signals)

local signal, setCovering = Signals.createSignal(false)

return { getCovering = signal, setCovering = setCovering }
