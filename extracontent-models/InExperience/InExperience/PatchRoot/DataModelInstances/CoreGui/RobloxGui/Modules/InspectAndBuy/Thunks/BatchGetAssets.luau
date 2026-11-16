local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)
local SetAssets = require(parent.Actions.SetAssets)
local GetProductInfo = require(parent.Thunks.GetProductInfo)
local GetAssetBundles = require(parent.Thunks.GetAssetBundles)
local GetVersionInfo = require(parent.Thunks.GetVersionInfo)

local v = { Network }

local function BatchGetAssets(items)
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[Network]

		local assetIds = {}

		if items then
			for _, item in items do
				table.insert(assetIds, (tonumber(item.assetId)))
			end
		end

		return PerformFetch.Single("BatchGetAssets", function()
			return v2.getBatchItemDetails(assetIds, Enum.AvatarItemType.Asset):andThen(function(items2)
				local v3 = {}

				for _, item in items2 do
					table.insert(v3, { assetId = tostring(item.Id) })
				end

				for _, v4 in v3 do
					coroutine.wrap(function()
						object:dispatch(GetProductInfo(v4.assetId))

						if v4.parentBundleId == nil then
							object:dispatch(GetAssetBundles(v4.assetId))
						end

						object:dispatch(GetVersionInfo(v4.assetId))
					end)()
				end

				object:dispatch(SetAssets(v3))

				object:dispatch(SendCounter(Constants.Counters.BatchGetAssets .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.BatchGetAssets .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.BatchGetAssets .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return BatchGetAssets
