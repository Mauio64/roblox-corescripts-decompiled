local performFetch = require("@luauforge/bundled/dus").PerformFetch

local module = require("@luauforge/bundled/dwm")
local module2 = require("@luauforge/bundled/dwD")
local module3 = require("@luauforge/bundled/dtW")

return {
	KeyMapper = function(p2)
		return "luaapp.gamesapi.gamemedia." .. p2
	end,
	Fetch = function(p2, value)
		assert(typeof(value) == "string", "universeId should be a string")
		assert(#value > 0, "universeId should not be empty")
		local v5 = "luaapp.gamesapi.gamemedia." .. value

		return performFetch.Single(v5, function(object)
			return module2(p2, value):andThen(function(p3)
				assert(
					typeof(p3.responseBody.data) == "table",
					"Malformed response from server, missing 'data' object"
				)

				local result = {}

				for i, v6 in ipairs(p3.responseBody.data) do
					table.insert(result, (module.fromJsonData(v6)))
				end

				if #result > 0 then
					object:dispatch(module3(value, result))
				end

				return result
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.gamemedia." .. p3)
	end
}
