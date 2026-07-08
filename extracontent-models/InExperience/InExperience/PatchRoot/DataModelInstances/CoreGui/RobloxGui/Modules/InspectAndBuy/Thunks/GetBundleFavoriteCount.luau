local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SetBundles = require(ParentParent.Actions.SetBundles)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v12 = createInspectAndBuyKeyMapper("getBundleFavoriteCount")

local function GetBundleFavoriteCount(p1) -- line: 21
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v12 (copy), PerformFetch (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 22
		-- upvalues: Network (copy), v12 (copy), p1 (copy), PerformFetch (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
		local v17 = p3[Network]
		local v18 = v12(p2:getState().storeId, p1)

		return PerformFetch.Single(v18, function(_) -- line: 27
			-- upvalues: v17 (copy), p1 (copy), BundleInfo (copy), p2 (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
			return v17.getBundleFavoriteCount(p1):andThen(function(p5) -- line: 28
				-- upvalues: BundleInfo (copy), p1 (copy), p2 (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
				if p5 then
					local v22 = BundleInfo.fromGetBundleFavoriteCount(p1, p5)

					p2:dispatch(SetBundles({ v22 }))
				end

				p2:dispatch(SendCounter(Constants.Counters.GetBundleFavoriteCount .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 36
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetBundleFavoriteCount .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 41
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetBundleFavoriteCount .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetBundleFavoriteCount
