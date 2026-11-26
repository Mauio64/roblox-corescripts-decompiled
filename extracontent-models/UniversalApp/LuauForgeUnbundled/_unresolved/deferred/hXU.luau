local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/hXV")
local module2 = require("@luauforge/deferred/hXW")
local module3 = require("@luauforge/bundled/egs")

local enum = module.Enum

return function(p2, p3, p4)
	return function(p5)
		return module2(p2, p3, p4):andThen(function(p6)
			return p6.responseBody
		end):catch(function(p6)
			if not p6.Body then
				return module3.reject(enum.Default)
			end

			local code = HttpService:JSONDecode(p6.Body).errors[1].code
			local v5 = enum.fromRawValue(code)

			return module3.reject(v5 or enum.Default)
		end)
	end
end
