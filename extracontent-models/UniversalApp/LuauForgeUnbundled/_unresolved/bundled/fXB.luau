local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module = require("@luauforge/bundled/fXC")
local module2 = require("@luauforge/bundled/dyH")

return function(p2, p3, p4, p5)
	return performFetch.Single("ApiFetchDeveloperProductsStatus" .. p3 .. p5, function(object)
		return module(p2, p3, p5):andThen(function(p6)
			local v5 = {}

			if p6 and p6.responseBody then
				for i, v6 in ipairs(p6.responseBody) do
					if not (v6.actionArgs and v6.receipt) then
						continue
					end

					for j, actionArg in ipairs(v6.actionArgs) do
						if not (actionArg.Key == "productId" and actionArg.Value) then
							continue
						end

						if v5[actionArg.Value] == nil then
							v5[actionArg.Value] = {}
						end

						table.insert(v5[actionArg.Value], v6.receipt)
					end
				end
			end

			return object:dispatch(module2(p4, v5))
		end, function(p6)
			return Promise.resolve()
		end)
	end)
end
