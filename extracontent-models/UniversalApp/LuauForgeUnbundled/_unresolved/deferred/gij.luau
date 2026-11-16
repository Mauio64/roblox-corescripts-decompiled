local module = require("@luauforge/bundled/dwL")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/deferred/gik")
local module3 = require("@luauforge/bundled/gil")
local module4 = require("@luauforge/bundled/gdF")
local fFlagUseSignalsForPlatform = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForPlatform

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fyv") else nil

return {
	Fetch = function(p2)
		return performFetch.Single("IAPProducts", function(object)
			return module2(p2):andThen(function(list)
				if
					list == nil
					or list[1] == nil
					or list[1].products == nil
					or type(list[1].products) ~= "table"
				then
					module.assert("Invalid response from GetIAPProducts")
					return
				end

				local v6 = {}
				local v7 = {}
				local v8 = {}

				for i, product in ipairs(list[1].products) do
					local fromJsonData = module4.fromJsonData
					local v9

					if fFlagUseSignalsForPlatform then
						v9 = v5(false).getPlatform(false)
					else
						v9 = object:getState().Platform
					end

					local v10 = fromJsonData(product, v9)

					if v10 == nil then
						continue
					end

					if v10.isSubscription then
						table.insert(v6, v10)
					elseif v10.requiresPremium then
						table.insert(v7, v10)
					else
						table.insert(v8, v10)
					end
				end

				local function fn(p3, p4): boolean
					return p3.robuxAmount < p4.robuxAmount
				end

				table.sort(v7, fn)
				table.sort(v8, fn)
				table.sort(v6, fn)

				object:dispatch(module3(v8, v7, v6))
			end)
		end)
	end,
	GetFetchingStatus = function(p2)
		return performFetch.GetStatus(p2, "IAPProducts")
	end
}
