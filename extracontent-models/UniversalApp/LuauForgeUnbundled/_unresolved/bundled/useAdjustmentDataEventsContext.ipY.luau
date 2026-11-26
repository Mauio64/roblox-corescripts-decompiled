local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ioM")

local function useAdjustmentDataEventsContext()
	return React.useContext(module)
end

return useAdjustmentDataEventsContext
