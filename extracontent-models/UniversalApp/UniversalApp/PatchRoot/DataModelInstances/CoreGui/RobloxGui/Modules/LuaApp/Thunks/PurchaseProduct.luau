local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t = require(CorePackages.Packages.t)
local Promise = require(Modules.LuaApp.Promise)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local PurchaseProduct = require(Modules.LuaApp.Http.Requests.PurchaseProduct)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetPurchaseErrorToast = require(Modules.LuaApp.Thunks.SetPurchaseErrorToast)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local PurchaseProduct2 = require(Modules.LuaApp.Models.EconomyApi.PurchaseProduct)
local EconomyTypes = require(Modules.LuaApp.Types.EconomyTypes)
local t1 = {}

local function purchaseProductKeyMapper(p1) -- line: 16
	return "luaapp.purchaseproduct." .. p1
end

local v15 = t.tuple(t.callback, t.numberPositive, EconomyTypes.PurchaseDetail, t.optional(t.callback))

function t1.Post(p2, p3, p4, p5) -- line: 22
	-- upvalues: ArgCheck (copy), v15 (copy), PerformFetch (copy), PurchaseProduct (copy), PurchaseProduct2 (copy), SetPurchaseErrorToast (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
	ArgCheck.assert(v15(p2, p3, p4, p5))

	return PerformFetch.Single("luaapp.purchaseproduct." .. p3, function(p6) -- line: 25
		-- upvalues: PurchaseProduct (copy), p2 (copy), p3 (copy), p4 (copy), PurchaseProduct2 (copy), p5 (copy), SetPurchaseErrorToast (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
		return PurchaseProduct(p2, p3, p4):andThen(function(p7) -- line: 26
			-- upvalues: PurchaseProduct2 (copy), p5 (copy), p6 (copy), SetPurchaseErrorToast (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
			local responseBody = p7.responseBody

			if type(responseBody) == "table" then
				local v26 = PurchaseProduct2.fromJsonData(responseBody)

				if not v26.purchased then
					if p5 == nil or p5(v26) == false then
						p6:dispatch(SetPurchaseErrorToast(v26))
					end

					return Promise.reject(v26)
				end

				return Promise.resolve(v26)
			end

			Logging.warn("Response from PurchaseProduct is malformed!")
			p6:dispatch(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p8) -- line: 50
			-- upvalues: p6 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p6:dispatch(SetNetworkingErrorToast(p8))

			return Promise.reject(p8)
		end)
	end)
end
function t1.GetPostingStatus(p9, p10) -- line: 57
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p9, "luaapp.purchaseproduct." .. p10)
end

return t1
