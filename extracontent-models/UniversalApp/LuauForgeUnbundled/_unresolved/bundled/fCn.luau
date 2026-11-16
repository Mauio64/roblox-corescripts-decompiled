local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/fCh")

local module2 = require("@luauforge/bundled/fCo")
require("@luauforge/bundled/fCl")

return function(p2, p3)
	return function()
		return module2(p2, p3):andThen(function(p4)
			if p4 and p4.responseBody then
				return p4.responseBody
			end

			return module.reject()
		end, function(p4)
			local v5 = not p4.Body and 0 or HttpService:JSONDecode(p4.Body).errors[1].code

			return module.reject({ errorCode = v5 })
		end)
	end
end
