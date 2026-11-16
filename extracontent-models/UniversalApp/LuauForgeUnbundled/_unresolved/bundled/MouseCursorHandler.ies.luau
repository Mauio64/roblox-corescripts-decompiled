local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/iet")

local function MouseCursorHandler(): nil
	React.useEffect(function()
		return module()
	end, {})
	return nil
end

return MouseCursorHandler
