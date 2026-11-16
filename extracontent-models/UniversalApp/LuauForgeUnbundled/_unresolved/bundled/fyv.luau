local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/fyw")

return Signals.createComputed(module)
