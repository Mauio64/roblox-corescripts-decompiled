local Parent = script:FindFirstAncestor("ServerUI").Parent
local HttpRequest = require(Parent.HttpRequest)
local v3 = require(Parent.Lumberyak).Logger.new(nil, "UIConfiguration")
local RoduxNetworking = require(Parent.RoduxNetworking)
local Url = require(Parent.Http).Url
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}?) -- line: 17
	-- upvalues: v3 (copy), HttpRequest (copy), RoduxNetworking (copy), t1 (copy)
	local v8 = if not t2 or not t2.enableLogging then nil else v3:new("UIConfiguration Networking")
	local v9 = HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 20
			-- upvalues: v8 (copy), HttpRequest (copy)
			if v8 then
				v8:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))
			end

			return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
		end,
		postRequestFunction = function(p4, p5) -- line: 26
			-- upvalues: v8 (copy)
			if v8 then
				v8:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
			end
		end,
		maxRetryCount = t2 and t2.maxRetryCount or 0
	})
	local t3 = {
		networking = RoduxNetworking.config({
			keyPath = t2 and t2.roduxKeyPath or "UIConfiguration.NetworkStatus",
			networkImpl = v9
		})
	}

	setmetatable(t3, t1)

	return t3
end
function t1.fetch(t4: {[any]: any}, s1: string, p6) -- line: 56
	-- upvalues: Url (copy)
	return t4.networking.GET(script.Name, function(p7) -- line: 57
		-- upvalues: Url (copy), s1 (copy), p6 (copy)
		return p7(Url.APIS_URL):path(s1):queryArgs(p6)
	end).API()
end

return t1
