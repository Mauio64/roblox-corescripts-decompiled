local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local SetAssets = require(ParentParent.Actions.SetAssets)
local GetProductInfo = require(ParentParent.Thunks.GetProductInfo)
local GetAssetBundles = require(ParentParent.Thunks.GetAssetBundles)
local GetVersionInfo = require(ParentParent.Thunks.GetVersionInfo)
local t1 = { Network }

local function BatchGetAssets(p1) -- line: 19
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), PerformFetch (copy), GetProductInfo (copy), GetAssetBundles (copy), GetVersionInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 20
		-- upvalues: Network (copy), p1 (copy), PerformFetch (copy), GetProductInfo (copy), GetAssetBundles (copy), GetVersionInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
		local v17 = p3[Network]
		local t2 = {}

		if p1 then
			for _, v20 in p1 do
				table.insert(t2, (tonumber(v20.assetId)))
			end
		end

		return PerformFetch.Single("BatchGetAssets", function() -- line: 30
			-- upvalues: v17 (copy), t2 (copy), p2 (copy), GetProductInfo (copy), GetAssetBundles (copy), GetVersionInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
			return v17.getBatchItemDetails(t2, Enum.AvatarItemType.Asset):andThen(function(p4) -- line: 31
				-- upvalues: p2 (copy), GetProductInfo (copy), GetAssetBundles (copy), GetVersionInfo (copy), SetAssets (copy), SendCounter (copy), Constants (copy)
				local t3 = {}

				for _, v25 in p4 do
					table.insert(t3, {
						assetId = tostring(v25.Id)
					})
				end

				for _, v27 in t3 do
					coroutine.wrap(function() -- line: 38
						-- upvalues: p2 (copy), GetProductInfo (copy), v27 (copy), GetAssetBundles (copy), GetVersionInfo (copy)
						p2:dispatch(GetProductInfo(v27.assetId))

						if v27.parentBundleId == nil then
							p2:dispatch(GetAssetBundles(v27.assetId))
						end

						p2:dispatch(GetVersionInfo(v27.assetId))
					end)()
				end

				p2:dispatch(SetAssets(t3))
				p2:dispatch(SendCounter(Constants.Counters.BatchGetAssets .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 60
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.BatchGetAssets .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 65
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.BatchGetAssets .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return BatchGetAssets
