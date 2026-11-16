local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dTl")
local module2 = require("@luauforge/bundled/dTm")

return Rodux.createReducer({ zoomSliderValue = 0, rotateSliderValue = 0 }, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { zoomSliderValue = p3.zoomSliderValue })
	end,
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { rotateSliderValue = p3.rotateSliderValue })
	end
})
