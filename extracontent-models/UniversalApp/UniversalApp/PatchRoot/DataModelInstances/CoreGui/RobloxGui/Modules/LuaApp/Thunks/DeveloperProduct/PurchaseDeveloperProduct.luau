local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t = require(CorePackages.Packages.t)
local Promise = require(Modules.LuaApp.Promise)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local PurchaseDeveloperProduct = require(Modules.LuaApp.Http.Requests.DeveloperProductApi.PurchaseDeveloperProduct)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local PurchaseDeveloperProductModel = require(Modules.LuaApp.Models.DeveloperProductApi.PurchaseDeveloperProductModel)
local EconomyTypes = require(Modules.LuaApp.Types.EconomyTypes)
local isEconomicRestrictionResponse = require(CorePackages.Workspace.Packages.IAPExperience).Utility.isEconomicRestrictionResponse
local t1 = {}

local function purchaseDeveloperProductKeyMapper(p1) -- line: 21
	return "luaapp.purchasedeveloperproduct." .. p1
end

local v17 = t.tuple(t.callback, t.numberPositive, EconomyTypes.PurchaseDetail, t.optional(t.callback))

local function updateRobux(p2, p3) -- line: 27
	-- upvalues: ArgCheck (copy), ApiFetchEconomyCurrency (copy)
	local LocalUserId = p3:getState().LocalUserId

	ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
		p3:dispatch(ApiFetchEconomyCurrency(p2, LocalUserId, true))
	end
end

function t1.Post(p4, p5, p6, p7, p8) -- line: 35
	-- upvalues: ArgCheck (copy), v17 (copy), PerformFetch (copy), PurchaseDeveloperProduct (copy), PurchaseDeveloperProductModel (copy), isEconomicRestrictionResponse (copy), Promise (copy), ApiFetchEconomyCurrency (copy), Logging (copy), SetNetworkingErrorToast (copy), HttpService (copy)
	ArgCheck.assert(v17(p4, p5, p6, p7))

	return PerformFetch.Single("luaapp.purchasedeveloperproduct." .. p5, function(p9) -- line: 43
		-- upvalues: PurchaseDeveloperProduct (copy), p4 (copy), p5 (copy), p6 (copy), PurchaseDeveloperProductModel (copy), isEconomicRestrictionResponse (copy), p8 (copy), Promise (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), Logging (copy), SetNetworkingErrorToast (copy), p7 (copy), HttpService (copy)
		return PurchaseDeveloperProduct(p4, p5, p6):andThen(function(p10) -- line: 44
			-- upvalues: PurchaseDeveloperProductModel (copy), isEconomicRestrictionResponse (copy), p8 (copy), Promise (copy), p4 (copy), p9 (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), Logging (copy), SetNetworkingErrorToast (copy)
			local responseBody = p10.responseBody
			local v33 = PurchaseDeveloperProductModel.fromJsonData(responseBody)

			if type(responseBody) == "table" then
				if isEconomicRestrictionResponse(responseBody) and p8 ~= nil then
					p8(responseBody)

					return Promise.reject(v33)
				end

				local v34 = p4
				local v35 = p9
				local LocalUserId = v35:getState().LocalUserId

				ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

				if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
					v35:dispatch(ApiFetchEconomyCurrency(v34, LocalUserId, true))
				end

				return Promise.resolve(v33)
			end

			Logging.warn("Response from PurchaseDeveloperProduct is malformed!")
			p9:dispatch(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p11) -- line: 60
			-- upvalues: p7 (copy), HttpService (copy), p9 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			if p7 ~= nil and p11.Body then
				p7(HttpService:JSONDecode(p11.Body))
			else
				p9:dispatch(SetNetworkingErrorToast(p11))
			end

			return Promise.reject(p11)
		end)
	end)
end
function t1.GetPostingStatus(p12, p13) -- line: 71
	-- upvalues: PerformFetch (copy)
	if p13 == nil then
		return nil
	end

	return PerformFetch.GetStatus(p12, "luaapp.purchasedeveloperproduct." .. p13)
end

return t1
