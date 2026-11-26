local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/gTl")

local function useSceneInteractionCallbacks()
	return React.useContext(module)
end

return useSceneInteractionCallbacks
