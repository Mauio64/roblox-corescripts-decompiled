local Parent = script:FindFirstAncestor("WhatsNew").Parent
local Signals = require(Parent.Signals)
local createWhatsNewStore = require(script.createWhatsNewStore)

return Signals.createComputed(createWhatsNewStore)
