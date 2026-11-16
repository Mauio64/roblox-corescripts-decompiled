local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local Analytics = require(parent.Services.Analytics)
local SetFavoriteAsset = require(parent.Actions.SetFavoriteAsset)
local SetAssets = require(parent.Actions.SetAssets)
local AssetInfo = require(parent.Models.AssetInfo)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network, Analytics }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("createFavoriteForAsset")

local function CreateFavoriteForAsset(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]
		local v3 = p2[Analytics]

		local v4 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v4, function(_)
			return v2.createFavoriteForAsset(p):andThen(function()
				object:dispatch(SetFavoriteAsset(p, true))
				local numFavorites = object:getState().assets[p].numFavorites
				object:dispatch(SetAssets({ (AssetInfo.fromGetAssetFavoriteCount(p, numFavorites + 1)) }))
				v3.reportFavoriteItem("Asset", p, true, true, "", numFavorites + 1)

				object:dispatch(SendCounter(Constants.Counters.CreateFavoriteForAsset .. Constants.CounterSuffix.RequestSucceeded))

				return Promise.resolve()
			end, function(p3)
				object:dispatch(SendCounter(Constants.Counters.CreateFavoriteForAsset .. Constants.CounterSuffix.RequestRejected))

				return Promise.reject((tostring(p3.StatusMessage)))
			end)
		end)(object):catch(function(p3)
			local numFavorites = object:getState().assets[p].numFavorites
			v3.reportFavoriteItem("Asset", p, true, false, p3, numFavorites)
			object:dispatch(SendCounter(Constants.Counters.CreateFavoriteForAsset .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return CreateFavoriteForAsset
