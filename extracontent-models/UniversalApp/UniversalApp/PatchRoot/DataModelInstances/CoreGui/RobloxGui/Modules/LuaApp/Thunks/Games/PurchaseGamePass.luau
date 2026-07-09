local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local isEconomicRestrictionResponse = require(CorePackages.Workspace.Packages.IAPExperience).Utility.isEconomicRestrictionResponse
local t = require(CorePackages.Packages.t)
local Promise = require(Modules.LuaApp.Promise)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local PurchaseGamePass = require(Modules.LuaApp.Http.Requests.GamesApi.PurchaseGamePass)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetPurchaseErrorToast = require(Modules.LuaApp.Thunks.SetPurchaseErrorToast)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local PurchaseProduct = require(Modules.LuaApp.Models.EconomyApi.PurchaseProduct)
local EconomyTypes = require(Modules.LuaApp.Types.EconomyTypes)
local t1 = {}

local function purchaseGamePassKeyMapper(p1) -- line: 18
	return "luaapp.purchasegamepass." .. p1
end

local v16 = t.tuple(t.callback, t.numberPositive, EconomyTypes.PurchaseDetail, t.optional(t.callback), t.callback)

function t1.Post(p2, p3, p4, p5, p6) -- line: 24
	-- upvalues: ArgCheck (copy), v16 (copy), PerformFetch (copy), PurchaseGamePass (copy), PurchaseProduct (copy), isEconomicRestrictionResponse (copy), SetPurchaseErrorToast (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
	ArgCheck.assert(v16(p2, p3, p4, p5, p6))

	return PerformFetch.Single("luaapp.purchasegamepass." .. p3, function(p7) -- line: 35
		-- upvalues: PurchaseGamePass (copy), p2 (copy), p3 (copy), p4 (copy), PurchaseProduct (copy), p5 (copy), isEconomicRestrictionResponse (copy), p6 (copy), SetPurchaseErrorToast (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
		return PurchaseGamePass(p2, p3, p4):andThen(function(p8) -- line: 36
			-- upvalues: PurchaseProduct (copy), p5 (copy), isEconomicRestrictionResponse (copy), p6 (copy), p7 (copy), SetPurchaseErrorToast (copy), Promise (copy), Logging (copy), SetNetworkingErrorToast (copy)
			local responseBody = p8.responseBody

			if type(responseBody) == "table" then
				local v28 = PurchaseProduct.fromJsonData(responseBody)

				if not v28.purchased then
					if p5 == nil or p5(v28) == false then
						if isEconomicRestrictionResponse(responseBody) then
							p6(responseBody)
						else
							p7:dispatch(SetPurchaseErrorToast(v28))
						end
					end

					return Promise.reject(v28)
				end

				return Promise.resolve(v28)
			end

			Logging.warn("Response from PurchaseGamePass is malformed!")
			p7:dispatch(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p9) -- line: 64
			-- upvalues: p7 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p7:dispatch(SetNetworkingErrorToast(p9))

			return Promise.reject(p9)
		end)
	end)
end
function t1.GetPostingStatus(p10, p11) -- line: 71
	-- upvalues: PerformFetch (copy)
	if p11 == nil then
		return nil
	end

	return PerformFetch.GetStatus(p10, "luaapp.purchasegamepass." .. p11)
end

return t1
