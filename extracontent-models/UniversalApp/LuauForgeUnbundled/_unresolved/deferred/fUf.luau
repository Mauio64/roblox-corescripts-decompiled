local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/deferred/fUg")
local module3 = require("@luauforge/bundled/fUh")

return function(p2, p3, p4)
	return function(p5)
		if module3(p3) then
			return module2(p2, p3, p4):andThen(function(p6)
				return module.resolve()
			end, function(p6)
				local v5, v6, v7, v8

				if p6.Body then
					local err = HttpService:JSONDecode(p6.Body).errors[1]
					v5 = err.code
					v6 = v5 == 8
					v7 = v5 == 9
					v8 = err.message
				else
					v7 = false
					v6 = false
					v8 = ""
					v5 = 0
				end

				return module.reject({
					EmailInvalid = v7,
					PasswordIncorrect = v6,
					Message = v8,
					ErrorCode = v5
				})
			end)
		end

		return module.reject({ EmailInvalid = true })
	end
end
