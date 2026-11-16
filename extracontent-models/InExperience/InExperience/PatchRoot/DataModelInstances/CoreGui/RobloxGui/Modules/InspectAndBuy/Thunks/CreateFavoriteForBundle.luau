local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local Analytics = require(parent.Services.Analytics)
local SetFavoriteBundle = require(parent.Actions.SetFavoriteBundle)
local SetBundles = require(parent.Actions.SetBundles)
local BundleInfo = require(parent.Models.BundleInfo)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network, Analytics }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("createFavoriteForBundle")

local function CreateFavoriteForBundle(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]
		local v3 = p2[Analytics]

		local v4 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v4, function()
			return v2.createFavoriteForBundle(p):andThen(function()
				object:dispatch(SetFavoriteBundle(p, true))
				local numFavorites = object:getState().bundles[p].numFavorites

				object:dispatch(SetBundles({ (BundleInfo.fromGetBundleFavoriteCount(p, numFavorites + 1)) }))
				v3.reportFavoriteItem("Bundle", p, true, true, "", numFavorites + 1)
				object:dispatch(SendCounter(Constants.Counters.CreateFavoriteForBundle .. Constants.CounterSuffix.RequestSucceeded))

				return Promise.resolve()
			end, function(p3)
				object:dispatch(SendCounter(Constants.Counters.CreateFavoriteForBundle .. Constants.CounterSuffix.RequestRejected))

				return Promise.reject((tostring(p3.StatusMessage)))
			end)
		end)(object):catch(function(p3)
			local numFavorites = object:getState().bundles[p].numFavorites
			v3.reportFavoriteItem("Bundle", p, true, false, p3, numFavorites)
			object:dispatch(SendCounter(Constants.Counters.CreateFavoriteForBundle .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return CreateFavoriteForBundle
