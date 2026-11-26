local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/hhX")

local function useAppliedDescriptionValueContext()
	return React.useContext(module)
end

return useAppliedDescriptionValueContext
