local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/bundled/dwL")
local module3 = require("@luauforge/deferred/hLL")
local module4 = require("@luauforge/bundled/ecW")
local module5 = require("@luauforge/deferred/fuZ")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module6 = require("@luauforge/deferred/hLN")
local module7 = require("@luauforge/deferred/hLM")

local function purchaseProductKeyMapper(p2)
	return "luaapp.purchaseproduct." .. p2
end

local tuple = t.tuple(t.callback, t.numberPositive, module7.PurchaseDetail, t.optional(t.callback))
return {
	Post = function(p2, p3, p4, callback)
		module2.assert(tuple(p2, p3, p4, callback))
		return performFetch.Single("luaapp.purchaseproduct." .. p3, function(object)
			return module3(p2, p3, p4):andThen(function(p5)
				local responseBody = p5.responseBody

				if type(responseBody) == "table" then
					local v6 = module6.fromJsonData(responseBody)

					if v6.purchased then
						return module.resolve(v6)
					end

					if callback == nil or callback(v6) == false then
						object:dispatch(module5(v6))
					end

					return module.reject(v6)
				end

				logging.warn("Response from PurchaseProduct is malformed!")
				object:dispatch(module4({ HttpError = Enum.HttpError.OK }))
				return module.reject({ HttpError = Enum.HttpError.OK })
			end, function(p5)
				object:dispatch(module4(p5))
				return module.reject(p5)
			end)
		end)
	end,
	GetPostingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.purchaseproduct." .. p3)
	end
}
