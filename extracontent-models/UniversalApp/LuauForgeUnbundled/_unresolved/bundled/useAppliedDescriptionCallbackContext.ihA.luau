local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/igp")

local function useAppliedDescriptionCallbackContext()
	return React.useContext(module)
end

return useAppliedDescriptionCallbackContext
