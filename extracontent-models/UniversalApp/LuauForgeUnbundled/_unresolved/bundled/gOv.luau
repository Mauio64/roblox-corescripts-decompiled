local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)

local module = require("@luauforge/bundled/gOw")

return Signals.createComputed(module)
