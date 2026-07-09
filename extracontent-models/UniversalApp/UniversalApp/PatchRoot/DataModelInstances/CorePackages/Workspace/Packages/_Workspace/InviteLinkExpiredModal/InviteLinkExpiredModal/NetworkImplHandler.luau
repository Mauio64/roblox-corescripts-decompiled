local InviteLinkExpiredModal = script:FindFirstAncestor("InviteLinkExpiredModal")
local dependencies = require(InviteLinkExpiredModal.dependencies)

require(InviteLinkExpiredModal.devDependencies).JestGlobals.beforeAll(function(_) -- line: 7
	-- upvalues: dependencies (copy)
	dependencies.RoduxNetworking.setNetworkImpl(function(p2) -- line: 8
		error(string.format("Should have replaced network implementation for url: %s", (tostring(p2))))
	end)
end)
