local CorePackages = game:GetService("CorePackages")
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local module = require("@luauforge/deferred/fWN")

local function useEdpServerIxpVariables()
	return SignalsReact.useSignalState(module().getEdpServerIxpVariablesGetter)
end

return useEdpServerIxpVariables
