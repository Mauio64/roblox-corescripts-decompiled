local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/fCh")

local module2 = require("@luauforge/bundled/fCq")

return function(p2)
	return function()
		return module2(p2):andThen(function(p3)
			if p3 and p3.responseBody then
				return p3.responseBody
			end

			return module.reject()
		end, function(p3)
			local v5 = not p3.Body and 0 or HttpService:JSONDecode(p3.Body).errors[1].code

			return module.reject({ errorCode = v5 })
		end)
	end
end
