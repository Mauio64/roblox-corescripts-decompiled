local RoduxNetworking = require(script.Parent.RoduxNetworking)

return function(p1) -- line: 3
	-- upvalues: RoduxNetworking (copy)
	local v3 = RoduxNetworking.getNetworkImpl()

	RoduxNetworking.setNetworkImpl(p1)

	return function() -- line: 7
		-- upvalues: RoduxNetworking (copy), v3 (copy)
		RoduxNetworking.setNetworkImpl(v3)
	end
end
