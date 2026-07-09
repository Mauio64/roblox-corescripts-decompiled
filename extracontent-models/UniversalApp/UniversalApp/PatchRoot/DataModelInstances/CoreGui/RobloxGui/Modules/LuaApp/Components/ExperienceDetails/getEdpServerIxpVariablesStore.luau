local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local t1 = nil

local function getEdpServerIxpVariablesStore() -- line: 34
	-- upvalues: t1 (ref), Signals (copy)
	if t1 == nil then
		local v5, v6 = Signals.createSignal(nil)

		t1 = {
			getEdpServerIxpVariablesGetter = v5,
			setEdpServerIxpVariables = v6
		}
	end

	return t1
end

return getEdpServerIxpVariablesStore
