local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

local function createEdpPerUniverseVisibilityStore()
	local signal, v5 = Signals.createSignal(nil)
	return { getVisibilityVariables = signal, setVisibilityVariables = v5 }
end

local v5 = {}

local function getEdpPerUniverseVisibilityStore(p2)
	local edpPerUniverseVisibilityStore = v5[p2]

	if edpPerUniverseVisibilityStore ~= nil then
		return edpPerUniverseVisibilityStore
	end

	local v6 = v5
	local signal, v7 = Signals.createSignal(nil)
	v6[p2] = { getVisibilityVariables = signal, setVisibilityVariables = v7 }
	edpPerUniverseVisibilityStore = v5[p2]

	return edpPerUniverseVisibilityStore
end

return getEdpPerUniverseVisibilityStore
