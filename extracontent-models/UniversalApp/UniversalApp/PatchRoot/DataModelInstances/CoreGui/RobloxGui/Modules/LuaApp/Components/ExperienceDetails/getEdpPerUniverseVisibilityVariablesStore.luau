local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)

local function createEdpPerUniverseVisibilityStore() -- line: 21
	-- upvalues: Signals (copy)
	local v6, v7 = Signals.createSignal(nil)

	return {
		getVisibilityVariables = v6,
		setVisibilityVariables = v7
	}
end

local t1 = {}

local function getEdpPerUniverseVisibilityStore(s1: string) -- line: 31
	-- upvalues: t1 (copy), Signals (copy)
	local v9 = t1[s1]

	if v9 == nil then
		local v10 = t1
		local v11, v12 = Signals.createSignal(nil)

		v10[s1] = {
			getVisibilityVariables = v11,
			setVisibilityVariables = v12
		}
		v9 = t1[s1]
	end

	return v9
end

return getEdpPerUniverseVisibilityStore
