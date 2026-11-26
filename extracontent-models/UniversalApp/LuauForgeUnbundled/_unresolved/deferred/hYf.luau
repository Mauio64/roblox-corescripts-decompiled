local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/hXI")
local module2 = require("@luauforge/bundled/egs")
local module3 = require("@luauforge/deferred/hYg")

local enum = module.Enum

return function(p2)
	return function(p3)
		return module3(p2):andThen(function(p4)
			return p4.responseBody
		end):catch(function(p4)
			if not p4.Body then
				return module2.reject(enum.Default)
			end

			local code = HttpService:JSONDecode(p4.Body).errors[1].code
			local v5 = enum.fromRawValue(code)

			return module2.reject(v5 or enum.Default)
		end)
	end
end
