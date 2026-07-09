local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local createRobloxPlusThemeStore = require(script.createRobloxPlusThemeStore)

return Signals.createComputed(createRobloxPlusThemeStore)
