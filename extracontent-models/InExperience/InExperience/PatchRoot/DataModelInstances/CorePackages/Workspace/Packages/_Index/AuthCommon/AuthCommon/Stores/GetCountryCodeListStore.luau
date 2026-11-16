local parent = script:FindFirstAncestor("AuthCommon").Parent

local Signals = require(parent.Signals)
local createCountryCodeListStore = require(script.createCountryCodeListStore)

return Signals.createComputed(createCountryCodeListStore)
