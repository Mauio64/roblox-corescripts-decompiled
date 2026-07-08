local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local SetBundles = require(ParentParent.Actions.SetBundles)
local GetProductInfo = require(ParentParent.Thunks.GetProductInfo)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SetAssetToBundlesMapping = require(ParentParent.Actions.SetAssetToBundlesMapping)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v14 = createInspectAndBuyKeyMapper("getAssetBundles")

local function GetAssetBundles(p1) -- line: 23
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v14 (copy), PerformFetch (copy), BundleInfo (copy), GetProductInfo (copy), SetBundles (copy), SetAssetToBundlesMapping (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 24
		-- upvalues: Network (copy), v14 (copy), p1 (copy), PerformFetch (copy), BundleInfo (copy), GetProductInfo (copy), SetBundles (copy), SetAssetToBundlesMapping (copy), SendCounter (copy), Constants (copy)
		local v19 = p3[Network]
		local v20 = v14(p2:getState().storeId, p1)

		return PerformFetch.Single(v20, function(_) -- line: 29
			-- upvalues: v19 (copy), p1 (copy), BundleInfo (copy), p2 (copy), GetProductInfo (copy), SetBundles (copy), SetAssetToBundlesMapping (copy), SendCounter (copy), Constants (copy)
			return v19.getAssetBundles(p1):andThen(function(p5) -- line: 30
				-- upvalues: BundleInfo (copy), p2 (copy), GetProductInfo (copy), SetBundles (copy), SetAssetToBundlesMapping (copy), p1 (copy), SendCounter (copy), Constants (copy)
				local t2 = {}
				local t3 = {}

				for _, v in pairs(p5.data) do
					local v28 = BundleInfo.fromGetAssetBundles(v)

					table.insert(t3, v28)
					table.insert(t2, (tostring(v28.bundleId)))

					local v29 = false

					for _, v2 in pairs(v.items) do
						if v2.type == "UserOutfit" then
							v29 = true

							break
						end
					end

					if not v29 then
						for _, v3 in pairs(v.items) do
							if not p2:getState().assets[v3.id] then
								coroutine.wrap(function() -- line: 54
									-- upvalues: p2 (copy), GetProductInfo (copy), v3 (copy)
									p2:dispatch(GetProductInfo(v3.id))
								end)()
							end
						end
					end
				end

				p2:dispatch(SetBundles(t3))
				p2:dispatch(SetAssetToBundlesMapping(tostring(p1), t2))
				p2:dispatch(SendCounter(Constants.Counters.GetAssetBundles .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 69
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetAssetBundles .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 74
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetAssetBundles .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetAssetBundles
