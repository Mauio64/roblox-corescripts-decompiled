local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetIAPProducts = require(Modules.LuaApp.Http.Requests.GetIAPProducts)
local SetIAPProducts = require(Modules.LuaApp.Actions.SetIAPProducts)
local IAPProduct = require(Modules.LuaApp.Models.PremiumFeaturesApi.IAPProduct)

return {
	Fetch = function(p1) -- line: 15
		-- upvalues: PerformFetch (copy), GetIAPProducts (copy), ArgCheck (copy), IAPProduct (copy), SetIAPProducts (copy)
		return PerformFetch.Single("IAPProducts", function(p2) -- line: 16
			-- upvalues: GetIAPProducts (copy), p1 (copy), ArgCheck (copy), IAPProduct (copy), SetIAPProducts (copy)
			return GetIAPProducts(p1):andThen(function(p3) -- line: 17
				-- upvalues: ArgCheck (copy), IAPProduct (copy), p2 (copy), SetIAPProducts (copy)
				if p3 == nil or (p3[1] == nil or p3[1].products == nil or type(p3[1].products) ~= "table") then
					ArgCheck.assert("Invalid response from GetIAPProducts")

					return
				end

				local t1 = {}
				local t2 = {}
				local t3 = {}

				for _, v in ipairs(p3[1].products) do
					local v17 = IAPProduct.fromJsonData(v, p2:getState().Platform)

					if v17 ~= nil then
						if v17.isSubscription then
							table.insert(t3, v17)
						elseif v17.requiresPremium then
							table.insert(t1, v17)
						else
							table.insert(t2, v17)
						end
					end
				end

				local function v18(p4, p5) -- line: 41
					return p4.robuxAmount < p5.robuxAmount
				end

				table.sort(t1, v18)
				table.sort(t2, v18)
				table.sort(t3, v18)
				p2:dispatch(SetIAPProducts(t2, t1, t3))
			end)
		end)
	end,
	GetFetchingStatus = function(p6) -- line: 54
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p6, "IAPProducts")
	end
}
