local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dwM")
local Roact = require(CorePackages.Packages.Roact)
local module2 = require("@luauforge/bundled/fsI")

return function(p2)
	module.isNotNil(p2, "withTopBarSearchSignal must be passed a render prop")

	return Roact.createElement(module2.Consumer, { render = p2 })
end
