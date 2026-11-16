local parent = script:FindFirstAncestor("Localization").Parent

local Signals = require(parent.Signals)
local createLocalizationServiceStore = require(script.createLocalizationServiceStore)

return Signals.createComputed(createLocalizationServiceStore)
