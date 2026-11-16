local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SetCollectibleResellableInstances = require(parent.Actions.SetCollectibleResellableInstances)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getCollectibleResellableInstances")

local function GetCollectibleResellableInstances(p, p2)
	return Thunk.new(script.Name, v, function(object, p3)
		local v2 = p3[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p, p2)

		return PerformFetch.Single(v3, function()
			return v2.getCollectibleResellableInstances(p, p2):andThen(function(p4)
				local itemInstances = p4 and p4.itemInstances

				if itemInstances then
					object:dispatch(SetCollectibleResellableInstances(p, itemInstances))
				end

				if itemInstances then
					object:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstances .. Constants.CounterSuffix.RequestSucceeded))
				else
					object:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstancesRequestSucceededWithoutResult))
				end
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstances .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstances .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetCollectibleResellableInstances
