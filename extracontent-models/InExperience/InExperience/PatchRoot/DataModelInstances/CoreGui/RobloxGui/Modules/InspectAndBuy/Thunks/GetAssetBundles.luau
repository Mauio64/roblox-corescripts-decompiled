local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local BundleInfo = require(parent.Models.BundleInfo)
local SetBundles = require(parent.Actions.SetBundles)
local GetProductInfo = require(parent.Thunks.GetProductInfo)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SetAssetToBundlesMapping = require(parent.Actions.SetAssetToBundlesMapping)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getAssetBundles")

local function GetAssetBundles(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function(_)
			return v2.getAssetBundles(p):andThen(function(p3)
				local v4 = {}
				local bundleIds = {}

				for _, v5 in pairs(p3.data) do
					local v6 = BundleInfo.fromGetAssetBundles(v5)
					table.insert(v4, v6)
					table.insert(bundleIds, (tostring(v6.bundleId)))
					local v7 = false

					for _, item in pairs(v5.items) do
						if item.type == "UserOutfit" then
							v7 = true
							break
						end
					end

					if v7 then
						continue
					end

					for _, item in pairs(v5.items) do
						if object:getState().assets[item.id] then
							continue
						end

						local v8 = item
						coroutine.wrap(function()
							object:dispatch(GetProductInfo(v8.id))
						end)()
					end
				end

				object:dispatch(SetBundles(v4))

				object:dispatch(SetAssetToBundlesMapping(tostring(p), bundleIds))

				object:dispatch(SendCounter(Constants.Counters.GetAssetBundles .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetAssetBundles .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetAssetBundles .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetAssetBundles
