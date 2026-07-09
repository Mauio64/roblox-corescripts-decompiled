local CorePackages = game:GetService("CorePackages")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getEdpServerIxpVariablesStore = require(Modules.LuaApp.Components.ExperienceDetails.getEdpServerIxpVariablesStore)

local function useEdpServerIxpVariables() -- line: 16
	-- upvalues: SignalsReact (copy), getEdpServerIxpVariablesStore (copy)
	return SignalsReact.useSignalState(getEdpServerIxpVariablesStore().getEdpServerIxpVariablesGetter)
end

return useEdpServerIxpVariables
