local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local signal, setCovering = Signals.createSignal(false)

return { getCovering = signal, setCovering = setCovering }
