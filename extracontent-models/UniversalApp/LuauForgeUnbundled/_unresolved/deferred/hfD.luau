local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

local module = require("@luauforge/deferred/hfE")

return (Signals.createComputed(function(p2)
	return module()
end))
