local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzS")
local module2 = require("@luauforge/bundled/dzT")

return Rodux.createReducer({ boundInputs = {}, focusController = nil }, {
	[module.name] = function(p2, p3)
		return {
			boundInputs = p3.boundInputs or {},
			focusController = p3.focusController
		}
	end,
	[module2.name] = function(p2, p3)
		if p2.focusController == p3.focusController then
			return { boundInputs = {}, focusController = nil }
		end

		return p2
	end
})
