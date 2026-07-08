local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local SetAssets = require(ParentParent.Actions.SetAssets)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v12 = createInspectAndBuyKeyMapper("getProductInfo")

local function GetProductInfo(p1) -- line: 21
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v12 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 22
		-- upvalues: Network (copy), v12 (copy), p1 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
		local v17 = p3[Network]
		local v18 = v12(p2:getState().storeId, p1)

		return PerformFetch.Single(v18, function() -- line: 27
			-- upvalues: v17 (copy), p1 (copy), AssetInfo (copy), p2 (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
			return v17.getProductInfo(p1):andThen(function(p4) -- line: 28
				-- upvalues: AssetInfo (copy), p2 (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
				local v21 = AssetInfo.fromGetProductInfo(p4)

				p2:dispatch(SetAssets({ v21 }))
				p2:dispatch(SendCounter(Constants.Counters.GetProductInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 34
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetProductInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 39
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetProductInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetProductInfo
