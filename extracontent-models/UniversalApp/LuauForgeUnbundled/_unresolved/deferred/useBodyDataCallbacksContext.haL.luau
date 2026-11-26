local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/haM")

local function useBodyDataCallbacksContext()
	return React.useContext(module)
end

return useBodyDataCallbacksContext
