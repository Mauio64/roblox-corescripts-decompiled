local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/InternalHttpStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/Types")

local function createErrorStatusHandler(p2)
	return function(callback)
		return Signals.createComputed(function(p3)
			local v5 = callback(p3)

			if v5.status == "Success" then
				local statusCode = v5.response.StatusCode

				if p2[statusCode] ~= nil then
					p2[statusCode](v5)
				end
			end

			return v5
		end)
	end
end

return createErrorStatusHandler
