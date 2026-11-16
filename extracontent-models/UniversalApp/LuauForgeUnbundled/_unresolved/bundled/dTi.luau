local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dTj")

return Rodux.createReducer({}, {
	[module.name] = function(p2, data)
		local v6 = p2[data.screenName] or {}

		return Cryo.Dictionary.join(p2, {
			[data.screenName] = Cryo.Dictionary.join(v6, {
				screenHeightPix = data.screenHeightPix,
				topYPix = data.topYPix,
				viewportSizePix = data.viewportSizePix
			})
		})
	end
})
