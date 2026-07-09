local CorePackages = game:GetService("CorePackages")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getEdpPerUniverseVisibilityVariablesStore = require(Modules.LuaApp.Components.ExperienceDetails.getEdpPerUniverseVisibilityVariablesStore)

local function useEdpPerUniverseVisibilityVariablesForUniverse(s1: string) -- line: 16
	-- upvalues: SignalsReact (copy), getEdpPerUniverseVisibilityVariablesStore (copy)
	return SignalsReact.useSignalState(getEdpPerUniverseVisibilityVariablesStore(s1).getVisibilityVariables)
end

return useEdpPerUniverseVisibilityVariablesForUniverse
