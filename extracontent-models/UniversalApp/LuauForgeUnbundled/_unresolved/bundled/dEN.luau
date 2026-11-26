local module = require("@luauforge/bundled/dEO")
local statusCodes = require("@luauforge/bundled/dEt").StatusCodes

local module2 = require("@luauforge/bundled/dEP")
local module3 = require("@luauforge/bundled/dER")
local module4 = require("@luauforge/bundled/dEq")
local module5 = require("@luauforge/bundled/dEr")

return function(p2, p3)
	return function(object)
		return module3(p2, p3):andThen(function(p4)
			if p4.responseBody ~= nil and p4.responseBody.communityId ~= nil then
				local v5 = module4.fromJsonData(p4.responseBody)

				if v5.visibility == module5.Public then
					object:dispatch(module2(p3, v5))
					return
				end
			end

			object:dispatch(module2(p3, false))
		end, function(p4)
			if p4.StatusCode == statusCodes.NOT_FOUND then
				object:dispatch(module2(p3, false))
			end

			return module.resolve()
		end)
	end
end
