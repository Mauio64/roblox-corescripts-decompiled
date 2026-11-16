local RoduxNetworking = require(script.Parent.RoduxNetworking)

return function(p)
	local networkImpl = RoduxNetworking.getNetworkImpl()
	RoduxNetworking.setNetworkImpl(p)

	return function()
		RoduxNetworking.setNetworkImpl(networkImpl)
	end
end
