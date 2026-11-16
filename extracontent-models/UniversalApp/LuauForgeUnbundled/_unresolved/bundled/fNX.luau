local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/bundled/dwL")
local module3 = require("@luauforge/bundled/fNY")
local module4 = require("@luauforge/bundled/fNV")

return function(p2, p3, p4, p5)
	module2.isType(p2, "table", "networkImpl")
	module2.isType(p4, "string", "authMethod")
	module2.isType(p5, "table", "body")
	return function(object)
		return module3(p2, p4, p5):andThen(function(p6)
			return module.resolve(p6.responseBody)
		end, function(p6)
			object:dispatch(module4("Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"))
			p3.Diag:reportCounter("TokenAuthenticationPostRequestFailure", 1)
			return module.reject(p6)
		end)
	end
end
