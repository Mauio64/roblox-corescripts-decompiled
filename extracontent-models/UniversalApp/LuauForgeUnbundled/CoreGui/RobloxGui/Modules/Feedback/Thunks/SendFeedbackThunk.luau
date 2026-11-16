local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/fXK")
local module2 = require("@luauforge/bundled/dyA")

local module3 = require("@luauforge/bundled/dyB")

return function(p2, items, p3)
	return performFetch.Single("ApiFetchSubscriptionsStatus" .. p3, function(object)
		return module(p2, items):andThen(function(p4)
			local v5 = {}

			for k, item in items do
				local v6 = p4[item]

				if v6 then
					v5[item] = module3.fromJsonData(v6)
				end
			end

			return object:dispatch(module2(v5))
		end, function(p4)
			return Promise.resolve()
		end)
	end)
end
