local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/igl")

local function useBodyDataEventsContext()
	return React.useContext(module)
end

return useBodyDataEventsContext
