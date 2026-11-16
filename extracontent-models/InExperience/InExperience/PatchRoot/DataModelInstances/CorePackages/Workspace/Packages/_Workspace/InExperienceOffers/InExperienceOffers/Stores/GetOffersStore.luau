local parent = script:FindFirstAncestor("InExperienceOffers").Parent
local Signals = require(parent.Signals)
local createOffersStore = require(script.createOffersStore)

return Signals.createComputed(createOffersStore)
