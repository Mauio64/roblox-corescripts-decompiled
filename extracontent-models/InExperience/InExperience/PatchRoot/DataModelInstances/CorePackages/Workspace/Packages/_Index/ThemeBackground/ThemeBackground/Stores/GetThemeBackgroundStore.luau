local parent = script:FindFirstAncestor("ThemeBackground").Parent

local Signals = require(parent.Signals)

local createThemeBackgroundStore = require(script.createThemeBackgroundStore)

return Signals.createComputed(createThemeBackgroundStore)
