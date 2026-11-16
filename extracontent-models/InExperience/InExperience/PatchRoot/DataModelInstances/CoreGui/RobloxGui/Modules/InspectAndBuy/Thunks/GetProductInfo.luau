local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local AssetInfo = require(parent.Models.AssetInfo)
local SetAssets = require(parent.Actions.SetAssets)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getProductInfo")

local function GetProductInfo(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function()
			return v2.getProductInfo(p):andThen(function(p3)
				object:dispatch(SetAssets({ (AssetInfo.fromGetProductInfo(p3)) }))
				object:dispatch(SendCounter(Constants.Counters.GetProductInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetProductInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetProductInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetProductInfo
