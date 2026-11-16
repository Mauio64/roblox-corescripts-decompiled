local module = require("@luauforge/bundled/dys")
local module2 = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module3 = require("@luauforge/bundled/fWR")
local module4 = require("@luauforge/bundled/fXk")

return function(p2, p3)
	return performFetch.Single("ApiFetchGamePasses" .. p3, function(object)
		return module4(p2, p3):andThen(function(p4)
			local gamePasses = p4.responseBody.gamePasses
			object:dispatch(module(p3, gamePasses))

			if #gamePasses > 0 then
				local ids = {}

				for i, gamePass in ipairs(gamePasses) do
					table.insert(ids, gamePass.id)
				end

				object:dispatch(module3(p2, ids))
			end

			return module2.resolve(p4)
		end)
	end)
end
