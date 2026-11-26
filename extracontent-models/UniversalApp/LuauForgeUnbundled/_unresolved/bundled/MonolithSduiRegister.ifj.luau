local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/ifk")

local function MonolithSduiRegister(): nil
	React.useEffect(function()
		module()
	end, {})
	return nil
end

return MonolithSduiRegister
