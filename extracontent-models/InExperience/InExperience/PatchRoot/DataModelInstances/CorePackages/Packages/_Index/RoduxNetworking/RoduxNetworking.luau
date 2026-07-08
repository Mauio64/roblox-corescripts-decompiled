local RoduxNetworking = require(script.RoduxNetworking)
local NetworkStatus = require(script.NetworkStatus)
local mockRoduxNetworking = require(script.mockRoduxNetworking)

require(script.Types)

return {
	config = function(p1) -- line: 11
		-- upvalues: RoduxNetworking (copy), NetworkStatus (copy)
		local v5 = RoduxNetworking(p1)
		local v6 = NetworkStatus(p1)

		return {
			GET = function(p2, p3) -- line: 16
				-- upvalues: v5 (copy)
				return v5.GET(p2, p3)
			end,
			POST = function(p4, p5) -- line: 19
				-- upvalues: v5 (copy)
				return v5.POST(p4, p5)
			end,
			PATCH = function(p6, p7) -- line: 22
				-- upvalues: v5 (copy)
				return v5.PATCH(p6, p7)
			end,
			DELETE = function(p8, p9) -- line: 25
				-- upvalues: v5 (copy)
				return v5.DELETE(p8, p9)
			end,
			getNetworkImpl = function() -- line: 28
				-- upvalues: v5 (copy)
				return v5.getNetworkImpl()
			end,
			setNetworkImpl = function(...) -- line: 31
				-- upvalues: v5 (copy)
				v5.setNetworkImpl(...)
			end,
			installReducer = v6.installReducer,
			Enum = {
				NetworkStatus = v6.Enum.Status
			}
		}
	end,
	mock = mockRoduxNetworking
}
