local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ign")

local function useAdjustmentDataEventsContext()
	return React.useContext(module)
end

return useAdjustmentDataEventsContext
