local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/gVZ")

local function useAdjustmentDataCallbacksContext()
	return React.useContext(module)
end

return useAdjustmentDataCallbacksContext
