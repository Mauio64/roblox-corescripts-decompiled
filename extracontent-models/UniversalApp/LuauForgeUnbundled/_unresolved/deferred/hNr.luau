local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/hNb")
local module2 = require("@luauforge/deferred/hNs")
local module3 = require("@luauforge/bundled/ecV")

local enum = module.Enum

return function(p2)
	return function(p3)
		return module2(p2):andThen(function(p4)
			return p4.responseBody
		end):catch(function(p4)
			if not p4.Body then
				return module3.reject(enum.Default)
			end

			local code = HttpService:JSONDecode(p4.Body).errors[1].code
			local v5 = enum.fromRawValue(code)

			return module3.reject(v5 or enum.Default)
		end)
	end
end
