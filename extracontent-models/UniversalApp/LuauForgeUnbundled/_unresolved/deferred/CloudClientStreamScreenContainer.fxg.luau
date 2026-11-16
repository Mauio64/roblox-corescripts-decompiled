local module = require("@luauforge/deferred/fxh")

local module2 = require("@luauforge/deferred/fxi")
local module3 = require("@luauforge/deferred/fxj")
local module4 = require("@luauforge/deferred/fxm")
local overlayScreen = require("@luauforge/deferred/fxF").OverlayScreen

local function CloudClientStreamScreenContainer()
	local v5 = module4()
	local element = module.createElement(module3, v5)

	if module2 then
		return module.createElement(module.Fragment, {}, {
			CloudClientStreamScreen = element,
			OverlayScreen = module.createElement(overlayScreen)
		})
	end

	return element
end

return CloudClientStreamScreenContainer
