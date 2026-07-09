local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local HttpRequest = require(UserListParent.HttpRequest)
local RoduxNetworking = require(UserListParent.RoduxNetworking)
local RODUX_KEY = require(UserList.Common.Constants).RODUX_KEY
local v6 = require(UserListParent.Lumberyak).Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 14
			-- upvalues: v6 (copy), HttpRequest (copy)
			v6:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

			return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
		end,
		postRequestFunction = function(p4, p5) -- line: 18
			-- upvalues: v6 (copy)
			v6:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s ]", p5.requestMethod, p5.url, p4.StatusCode))
		end
	})
}))
