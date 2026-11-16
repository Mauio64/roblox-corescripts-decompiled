local parent = script:FindFirstAncestor("WhatsNew").Parent

local Signals = require(parent.Signals)
local createWhatsNewStore = require(script.createWhatsNewStore)

return Signals.createComputed(createWhatsNewStore)
