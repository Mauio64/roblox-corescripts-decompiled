local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/hNb")
local module2 = require("@luauforge/deferred/hNi")
local module3 = require("@luauforge/bundled/ecV")

local enum = module.Enum

return function(p2, p3)
	return function(p4)
		return module2(p2, p3):andThen(function(p5)
			return p5.responseBody
		end):catch(function(p5)
			if not p5.Body then
				return module3.reject(enum.Default)
			end

			local code = HttpService:JSONDecode(p5.Body).errors[1].code
			local v5 = enum.fromRawValue(code)

			return module3.reject(v5 or enum.Default)
		end)
	end
end
