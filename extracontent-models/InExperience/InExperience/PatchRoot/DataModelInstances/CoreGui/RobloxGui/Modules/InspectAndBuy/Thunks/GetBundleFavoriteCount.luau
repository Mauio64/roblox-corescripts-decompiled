local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SetBundles = require(parent.Actions.SetBundles)
local BundleInfo = require(parent.Models.BundleInfo)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getBundleFavoriteCount")

local function GetBundleFavoriteCount(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function(_)
			return v2.getBundleFavoriteCount(p):andThen(function(p3)
				if p3 then
					object:dispatch(SetBundles({ (BundleInfo.fromGetBundleFavoriteCount(p, p3)) }))
				end

				object:dispatch(SendCounter(Constants.Counters.GetBundleFavoriteCount .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetBundleFavoriteCount .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetBundleFavoriteCount .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetBundleFavoriteCount
