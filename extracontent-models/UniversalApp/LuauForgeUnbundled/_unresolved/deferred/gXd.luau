local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local accountUnlockDeepLinkPage = require("@luauforge/deferred/gXe").AccountUnlockDeepLinkPage

local module = require("@luauforge/bundled/dKv")
local module2 = require("@luauforge/bundled/fCM")
local module3 = require("@luauforge/bundled/gXF")

return function(options)
	return React.createElement(
		accountUnlockDeepLinkPage,
		Cryo.Dictionary.join(options or {}, {
			ResetNavigationHistory = module,
			ApiFetchAccessStatus = module3,
			closeCentralOverlayThunk = module2
		})
	)
end
