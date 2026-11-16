local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ftd")

local function SduiHomeUserInfoWidget()
	return React.createElement(module, { sideMargin = 0 })
end

return React.memo(SduiHomeUserInfoWidget)
