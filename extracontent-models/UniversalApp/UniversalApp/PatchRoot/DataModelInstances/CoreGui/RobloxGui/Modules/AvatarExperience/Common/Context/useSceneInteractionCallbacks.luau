local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local SceneInteractionCallbacksContext = require(script.Parent.SceneInteractionCallbacksContext)

local function useSceneInteractionCallbacks() -- line: 6
	-- upvalues: React (copy), SceneInteractionCallbacksContext (copy)
	return React.useContext(SceneInteractionCallbacksContext)
end

return useSceneInteractionCallbacks
