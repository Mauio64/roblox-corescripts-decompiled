local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/goH")

local function useSceneInteractionCallbacks()
	return React.useContext(module)
end

return useSceneInteractionCallbacks
