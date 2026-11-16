local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent
local HttpRequest = require(parent.HttpRequest)
local RoduxNetworking = require(parent.RoduxNetworking)
local Constants = require(UserList.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local Lumberyak = require(parent.Lumberyak)

local v = Lumberyak.Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = function(p, p2, p3)
			v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
			return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end,
		postRequestFunction = function(p, p2)
			v:debug(
				"Returned: {}",
				string.format(
					"[ requestMethod = %q, url = %q, statusCode = %s ]",
					p2.requestMethod,
					p2.url,
					p.StatusCode
				)
			)
		end
	})
}))
