local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

local edpServerIxpVariablesStore = nil

local function getEdpServerIxpVariablesStore()
	if edpServerIxpVariablesStore == nil then
		local signal, v5 = Signals.createSignal(nil)
		edpServerIxpVariablesStore = {
			getEdpServerIxpVariablesGetter = signal,
			setEdpServerIxpVariables = v5
		}
	end

	return edpServerIxpVariablesStore
end

return getEdpServerIxpVariablesStore
