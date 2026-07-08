local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local Network = require(ParentParent.Services.Network)
local SetAssets = require(ParentParent.Actions.SetAssets)
local SetBundles = require(ParentParent.Actions.SetBundles)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v14 = createInspectAndBuyKeyMapper("getEconomyProductInfo")

local function GetEconomyProductInfo(p1, p2, p3) -- line: 26
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v14 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p4, p5) -- line: 27
		-- upvalues: Network (copy), v14 (copy), p1 (copy), PerformFetch (copy), p2 (copy), AssetInfo (copy), SetAssets (copy), BundleInfo (copy), p3 (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
		local v21 = p5[Network]
		local v22 = v14(p4:getState().storeId, p1)

		return PerformFetch.Single(v22, function() -- line: 32
			-- upvalues: v21 (copy), p1 (copy), p2 (copy), AssetInfo (copy), p4 (copy), SetAssets (copy), BundleInfo (copy), p3 (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
			return v21.getEconomyProductInfo(p1):andThen(function(p6) -- line: 33
				-- upvalues: p2 (copy), AssetInfo (copy), p4 (copy), SetAssets (copy), BundleInfo (copy), p3 (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
				local v25 = not p6.purchasable and (p6.reason == "AlreadyOwned" or false)
				local v26 = p6.price or 0
				local purchasable = p6.purchasable
				local premiumPricing = p6.premiumPricing

				if not p6.purchasable and p6.reason == "InsufficientFunds" then
					purchasable = true
				end

				if not p2 then
					local v29 = AssetInfo.fromGetEconomyProductInfo(p6, v25, v26, purchasable, premiumPricing)

					p4:dispatch(SetAssets({ v29 }))
				else
					local v30 = BundleInfo.fromGetEconomyProductInfo(v25, p3, v26, purchasable)

					p4:dispatch(SetBundles({ v30 }))
				end

				p4:dispatch(SendCounter(Constants.Counters.GetEconomyProductInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 54
				-- upvalues: p4 (copy), SendCounter (copy), Constants (copy)
				p4:dispatch(SendCounter(Constants.Counters.GetEconomyProductInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p4):catch(function(_) -- line: 59
			-- upvalues: p4 (copy), SendCounter (copy), Constants (copy)
			p4:dispatch(SendCounter(Constants.Counters.GetEconomyProductInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetEconomyProductInfo
