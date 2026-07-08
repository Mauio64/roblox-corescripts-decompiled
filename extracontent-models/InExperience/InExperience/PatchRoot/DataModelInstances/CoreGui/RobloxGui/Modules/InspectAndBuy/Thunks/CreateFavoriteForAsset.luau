local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local Analytics = require(ParentParent.Services.Analytics)
local SetFavoriteAsset = require(ParentParent.Actions.SetFavoriteAsset)
local SetAssets = require(ParentParent.Actions.SetAssets)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = {
	Network,
	Analytics
}
local v15 = createInspectAndBuyKeyMapper("createFavoriteForAsset")

local function CreateFavoriteForAsset(p1) -- line: 26
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), Analytics (copy), v15 (copy), PerformFetch (copy), SetFavoriteAsset (copy), AssetInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy), Promise (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 27
		-- upvalues: Network (copy), Analytics (copy), v15 (copy), p1 (copy), PerformFetch (copy), SetFavoriteAsset (copy), AssetInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy), Promise (copy)
		local v20 = p3[Network]
		local v21 = p3[Analytics]
		local v22 = v15(p2:getState().storeId, p1)

		return PerformFetch.Single(v22, function(_) -- line: 33
			-- upvalues: v20 (copy), p1 (copy), p2 (copy), SetFavoriteAsset (copy), AssetInfo (copy), SetAssets (copy), v21 (copy), SendCounter (copy), Constants (copy), Promise (copy)
			return v20.createFavoriteForAsset(p1):andThen(function() -- line: 34
				-- upvalues: p2 (copy), SetFavoriteAsset (copy), p1 (copy), AssetInfo (copy), SetAssets (copy), v21 (copy), SendCounter (copy), Constants (copy), Promise (copy)
				p2:dispatch(SetFavoriteAsset(p1, true))

				local numFavorites = p2:getState().assets[p1].numFavorites
				local v27 = AssetInfo.fromGetAssetFavoriteCount(p1, numFavorites + 1)

				p2:dispatch(SetAssets({ v27 }))
				v21.reportFavoriteItem("Asset", p1, true, true, "", numFavorites + 1)
				p2:dispatch(SendCounter(Constants.Counters.CreateFavoriteForAsset .. Constants.CounterSuffix.RequestSucceeded))

				return Promise.resolve()
			end, function(p5) -- line: 46
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy), Promise (copy)
				p2:dispatch(SendCounter(Constants.Counters.CreateFavoriteForAsset .. Constants.CounterSuffix.RequestRejected))

				return Promise.reject((tostring(p5.StatusMessage)))
			end)
		end)(p2):catch(function(p6) -- line: 52
			-- upvalues: p2 (copy), p1 (copy), v21 (copy), SendCounter (copy), Constants (copy)
			local numFavorites = p2:getState().assets[p1].numFavorites

			v21.reportFavoriteItem("Asset", p1, true, false, p6, numFavorites)
			p2:dispatch(SendCounter(Constants.Counters.CreateFavoriteForAsset .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return CreateFavoriteForAsset
