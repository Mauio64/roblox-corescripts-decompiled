local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking")

return function(p2)
	local networkImpl = RoduxNetworking.getNetworkImpl()
	RoduxNetworking.setNetworkImpl(p2)

	return function()
		RoduxNetworking.setNetworkImpl(networkImpl)
	end
end
