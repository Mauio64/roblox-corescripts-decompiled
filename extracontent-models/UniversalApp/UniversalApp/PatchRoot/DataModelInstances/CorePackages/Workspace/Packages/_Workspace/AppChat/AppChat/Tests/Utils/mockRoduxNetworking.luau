local AppChat = script:FindFirstAncestor("AppChat")
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)

return function(p1) -- line: 5
	-- upvalues: RoduxNetworking (copy)
	local v4 = RoduxNetworking.getNetworkImpl()

	RoduxNetworking.setNetworkImpl(p1)

	return function() -- line: 9
		-- upvalues: RoduxNetworking (copy), v4 (copy)
		RoduxNetworking.setNetworkImpl(v4)
	end
end
