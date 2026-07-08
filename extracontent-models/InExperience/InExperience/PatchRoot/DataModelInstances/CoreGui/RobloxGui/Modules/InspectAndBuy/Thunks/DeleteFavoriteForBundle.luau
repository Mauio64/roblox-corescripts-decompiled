local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local Analytics = require(ParentParent.Services.Analytics)
local SetFavoriteBundle = require(ParentParent.Actions.SetFavoriteBundle)
local SetBundles = require(ParentParent.Actions.SetBundles)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = {
	Network,
	Analytics
}
local v15 = createInspectAndBuyKeyMapper("deleteFavoriteForBundle")

local function DeleteFavoriteForBundle(p1) -- line: 26
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), Analytics (copy), v15 (copy), PerformFetch (copy), SetFavoriteBundle (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy), Promise (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 27
		-- upvalues: Network (copy), Analytics (copy), v15 (copy), p1 (copy), PerformFetch (copy), SetFavoriteBundle (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy), Promise (copy)
		local v20 = p3[Network]
		local v21 = p3[Analytics]
		local v22 = v15(p2:getState().storeId, p1)

		return PerformFetch.Single(v22, function() -- line: 33
			-- upvalues: v20 (copy), p1 (copy), p2 (copy), SetFavoriteBundle (copy), BundleInfo (copy), SetBundles (copy), v21 (copy), SendCounter (copy), Constants (copy), Promise (copy)
			return v20.deleteFavoriteForBundle(p1):andThen(function() -- line: 34
				-- upvalues: p2 (copy), SetFavoriteBundle (copy), p1 (copy), BundleInfo (copy), SetBundles (copy), v21 (copy), SendCounter (copy), Constants (copy), Promise (copy)
				p2:dispatch(SetFavoriteBundle(p1, false))

				local numFavorites = p2:getState().bundles[p1].numFavorites
				local v26 = BundleInfo.fromGetBundleFavoriteCount(p1, numFavorites - 1)

				p2:dispatch(SetBundles({ v26 }))
				v21.reportFavoriteItem("Bundle", p1, false, true, "", numFavorites - 1)
				p2:dispatch(SendCounter(Constants.Counters.DeleteFavoriteForBundle .. Constants.CounterSuffix.RequestSucceeded))

				return Promise.resolve()
			end, function(p4) -- line: 46
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy), Promise (copy)
				p2:dispatch(SendCounter(Constants.Counters.DeleteFavoriteForBundle .. Constants.CounterSuffix.RequestRejected))

				return Promise.reject((tostring(p4.StatusMessage)))
			end)
		end)(p2):catch(function(p5) -- line: 52
			-- upvalues: p2 (copy), p1 (copy), v21 (copy), SendCounter (copy), Constants (copy)
			local numFavorites = p2:getState().bundles[p1].numFavorites

			v21.reportFavoriteItem("Bundle", p1, false, false, p5, numFavorites)
			p2:dispatch(SendCounter(Constants.Counters.DeleteFavoriteForBundle .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return DeleteFavoriteForBundle
