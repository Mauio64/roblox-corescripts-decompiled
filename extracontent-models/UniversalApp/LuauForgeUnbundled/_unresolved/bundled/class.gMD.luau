local module = require("@luauforge/bundled/gME")
local logger = require("@luauforge/bundled/gMF").Logger.new(nil, "UIConfiguration")
local module2 = require("@luauforge/bundled/gMG")
local url = require("@luauforge/bundled/gMH").Url

local class = {}
class.__index = class

function class.new(data)
	local v5 = if data and data.enableLogging then logger:new("UIConfiguration Networking") else nil
	local config = module.config({
		requestFunction = function(p2, p3, p4)
			if v5 then
				v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
			end

			return module.requestFunctions.HttpRbxApi(p2, p3, p4)
		end,
		postRequestFunction = function(p2, p3)
			if v5 then
				v5:debug(
					"Returned: {}",
					string.format(
						"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
						p3.requestMethod,
						p3.url,
						p2.StatusCode,
						p2.Body
					)
				)
			end
		end,
		maxRetryCount = data and data.maxRetryCount or 0
	})

	local v6 = {
		networking = module2.config({
			keyPath = data and data.roduxKeyPath or "UIConfiguration.NetworkStatus",
			networkImpl = config
		})
	}

	setmetatable(v6, class)
	return v6
end

function class.fetch(p2, p3, p4)
	return p2.networking.GET("UIConfiguration", function(callback)
		return callback(url.APIS_URL):path(p3):queryArgs(p4)
	end).API()
end

return class
