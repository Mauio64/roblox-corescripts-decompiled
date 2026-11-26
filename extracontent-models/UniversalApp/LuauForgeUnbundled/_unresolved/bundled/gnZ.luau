local HttpService = game:GetService("HttpService")

require("@luauforge/bundled/goa")

local module = require("@luauforge/bundled/gob")
require("@luauforge/bundled/gnE")
local module2 = require("@luauforge/bundled/goc")

return function(p2)
	return function()
		return module(p2):andThen(function(p3)
			if not p3 or not p3.responseBody or p3.responseBody == "" then
				return {
					isError = true,
					errorCode = 0,
					errorKey = module2.UnknownErrorKey
				}
			end

			local responseBody = p3.responseBody
			local v5 = nil

			for i, v7 in ipairs(responseBody) do
				if v7.isDefault == true then
					v5 = i
					break
				end
			end

			if v5 and v5 ~= 1 then
				local v7 = responseBody[v5]
				table.remove(responseBody, v5)
				table.insert(responseBody, 1, v7)
			end

			return { isError = false, data = responseBody }
		end, function(p3)
			return {
				isError = true,
				errorCode = not p3.Body and 0 or HttpService:JSONDecode(p3.Body).errors[1].code,
				errorKey = module2.UnknownErrorKey
			}
		end)
	end
end
