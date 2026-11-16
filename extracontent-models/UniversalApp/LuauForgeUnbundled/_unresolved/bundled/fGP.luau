local promise = require("@luauforge/bundled/fGi").Promise
local module = require("@luauforge/bundled/fGQ")
require("@luauforge/bundled/fGz")
local module2 = require("@luauforge/bundled/fGK")
local module3 = require("@luauforge/bundled/fGL")

local defineFastFlag = game:DefineFastFlag("ValidateCodeCheckBodyForOtpErrors", false)

return function(p2, p3)
	return function()
		return module(p2, p3):andThen(function(p4)
			return promise.resolve(p4.responseBody)
		end):catch(function(data)
			if data.data then
				return promise.reject(data.data.errorCode)
			end

			local v5 = module2() and module3(data.Body)

			if v5 then
				return promise.reject(v5)
			end

			if
				defineFastFlag
				and data.Body
				and (type(data.Body) == "number" or tonumber(data.Body) ~= nil)
			then
				return promise.reject(data.Body)
			end

			if data.StatusCode then
				return promise.reject(data.StatusCode)
			end

			return promise.reject()
		end)
	end
end
