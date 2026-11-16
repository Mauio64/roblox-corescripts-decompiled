local CorePackages = game:GetService("CorePackages")
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local module = require("@luauforge/deferred/fWO")

local function useEdpPerUniverseVisibilityVariablesForUniverse(p2)
	return SignalsReact.useSignalState(module(p2).getVisibilityVariables)
end

return useEdpPerUniverseVisibilityVariablesForUniverse
