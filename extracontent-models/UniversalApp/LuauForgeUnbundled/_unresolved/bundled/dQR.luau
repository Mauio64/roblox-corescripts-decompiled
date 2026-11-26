local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dQS")

return (Rodux.createReducer({ shouldPlayEmoteInBackground = false }, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			shouldPlayEmoteInBackground = p3.shouldPlayEmoteInBackground
		})
	end
}))
