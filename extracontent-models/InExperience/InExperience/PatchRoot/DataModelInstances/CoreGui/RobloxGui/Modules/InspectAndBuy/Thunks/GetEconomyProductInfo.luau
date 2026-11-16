local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local AssetInfo = require(parent.Models.AssetInfo)
local BundleInfo = require(parent.Models.BundleInfo)
local Network = require(parent.Services.Network)
local SetAssets = require(parent.Actions.SetAssets)
local SetBundles = require(parent.Actions.SetBundles)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getEconomyProductInfo")

local function GetEconomyProductInfo(p, p2, p3)
	return Thunk.new(script.Name, v, function(object, p4)
		local v2 = p4[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function()
			return v2.getEconomyProductInfo(p):andThen(function(data)
				local v4 = not data.purchasable and data.reason == "AlreadyOwned"
				local price = data.price or 0
				local purchasable = data.purchasable
				local premiumPricing = data.premiumPricing

				local v5 = not data.purchasable and data.reason == "InsufficientFunds" or purchasable

				if p2 then
					object:dispatch(SetBundles({ (BundleInfo.fromGetEconomyProductInfo(v4, p3, price, v5)) }))
				else
					object:dispatch(SetAssets({ (AssetInfo.fromGetEconomyProductInfo(
							data,
							v4,
							price,
							v5,
							premiumPricing
						)) }))
				end

				object:dispatch(SendCounter(Constants.Counters.GetEconomyProductInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetEconomyProductInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetEconomyProductInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetEconomyProductInfo
