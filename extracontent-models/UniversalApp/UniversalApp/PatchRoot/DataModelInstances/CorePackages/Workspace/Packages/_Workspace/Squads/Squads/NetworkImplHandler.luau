local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)

require(Squads.devDependencies).JestGlobals.beforeAll(function(_) -- line: 7
	-- upvalues: dependencies (copy)
	dependencies.RoduxNetworking.setNetworkImpl(function(p2) -- line: 8
		error(string.format("Should have replaced network implementation for url: %s", (tostring(p2))))
	end)
end)
