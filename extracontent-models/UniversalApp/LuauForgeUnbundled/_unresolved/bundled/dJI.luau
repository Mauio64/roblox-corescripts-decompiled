local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dJJ")

local module2 = require("@luauforge/bundled/dJK")
local module3 = require("@luauforge/bundled/dJM")
local module4 = require("@luauforge/bundled/dJN")

return function(p2, p3, p4)
	return function(p5)
		return module4(p2, p3, module2.toRawValue(p4)):andThen(function(p6)
			return p6.responseBody
		end):catch(function(p6)
			if not p6.Body then
				return module.reject(module3.Unknown)
			end

			local code = HttpService:JSONDecode(p6.Body).errors[1].code
			local v5 = module3.fromRawValue(code)

			return module.reject(v5 or module3.Unknown)
		end)
	end
end
