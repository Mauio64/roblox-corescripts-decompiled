local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Signals = require(Parent.Signals)
local createCountryCodeListStore = require(script.createCountryCodeListStore)

return Signals.createComputed(createCountryCodeListStore)
