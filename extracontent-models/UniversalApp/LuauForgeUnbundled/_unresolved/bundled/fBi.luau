local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/fBj")
local module2 = require("@luauforge/bundled/fBk")
local module3 = require("@luauforge/bundled/dBY")
local module4 = require("@luauforge/bundled/ecV")

local function getFetchName(p2, value)
	return "luaapp.autocomplete.getlocalcache." .. p2 .. "." .. (value or "none")
end

local v5 = {}

function v5.Fetch(p2, p3, value, p4)
	return performFetch.Single(
		"luaapp.autocomplete.getlocalcache." .. p3 .. "." .. (value or "none"),
		function(object)
			return module2(p2, p3, value, p4):andThen(function(p5)
				if not (p5 and p5.responseBody) then
					return module4.reject()
				end

				local responseBody = p5.responseBody
				module.fromJsonData(responseBody):match(function(p6)
					object:dispatch(module3(p6))
				end):matchError(function(p6)
					warn(p6)
				end)

				if responseBody.hasNextPage and responseBody.pageNumber then
					object:dispatch(v5.Fetch(p2, responseBody.pageNumber + 1, value, p4))
				end

				return module4.resolve()
			end, function(p5)
				return module4.reject(p5)
			end)
		end
	)
end

return v5
