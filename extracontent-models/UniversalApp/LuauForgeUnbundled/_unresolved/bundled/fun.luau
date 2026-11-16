local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/fuo")

return Signals.createComputed(module)
