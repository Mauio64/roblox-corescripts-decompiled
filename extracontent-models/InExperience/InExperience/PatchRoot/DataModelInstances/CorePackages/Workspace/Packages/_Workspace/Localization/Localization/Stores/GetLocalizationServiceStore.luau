local Parent = script:FindFirstAncestor("Localization").Parent
local Signals = require(Parent.Signals)
local createLocalizationServiceStore = require(script.createLocalizationServiceStore)

return Signals.createComputed(createLocalizationServiceStore)
