local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/dzO")
local module3 = require("@luauforge/bundled/gsp")
local module4 = require("@luauforge/bundled/gsq")

return function(p2, p3, p4)
	module2.isType(p2, "table", "networkImpl")
	module2.isType(p4, "string", "authMethod")

	return function(object)
		return module3(p2, p4):andThen(function(p5)
			return module.resolve(p5.responseBody)
		end, function(p5)
			object:dispatch(module4("Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"))
			p3.Diag:reportCounter("RequestAuthMetaDataFailure", 1)
			return module.reject(p5)
		end)
	end
end
