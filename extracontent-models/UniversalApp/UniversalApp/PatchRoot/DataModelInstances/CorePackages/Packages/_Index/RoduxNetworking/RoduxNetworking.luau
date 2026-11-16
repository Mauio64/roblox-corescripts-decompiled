local RoduxNetworking = require(script.RoduxNetworking)
local NetworkStatus = require(script.NetworkStatus)
local mockRoduxNetworking = require(script.mockRoduxNetworking)
require(script.Types)

return {
	config = function(p)
		local roduxNetworking = RoduxNetworking(p)
		local networkStatus = NetworkStatus(p)

		return {
			GET = function(p2, p3)
				return roduxNetworking.GET(p2, p3)
			end,
			POST = function(p2, p3)
				return roduxNetworking.POST(p2, p3)
			end,
			PATCH = function(p2, p3)
				return roduxNetworking.PATCH(p2, p3)
			end,
			DELETE = function(p2, p3)
				return roduxNetworking.DELETE(p2, p3)
			end,
			getNetworkImpl = function()
				return roduxNetworking.getNetworkImpl()
			end,
			setNetworkImpl = function(...)
				roduxNetworking.setNetworkImpl(...)
			end,
			installReducer = networkStatus.installReducer,
			Enum = { NetworkStatus = networkStatus.Enum.Status }
		}
	end,
	mock = mockRoduxNetworking
}
