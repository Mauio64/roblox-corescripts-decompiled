local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SetFavoriteBundle = require(parent.Actions.SetFavoriteBundle)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getFavoriteForBundle")

local function GetFavoriteForBundle(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function(_)
			return v2.getFavoriteForBundle(p):andThen(function(p3)
				if p3 == "null" then
					object:dispatch(SetFavoriteBundle(tostring(p), false))
				else
					object:dispatch(SetFavoriteBundle(tostring(p), true))
				end

				object:dispatch(SendCounter(Constants.Counters.GetFavoriteForBundle .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetFavoriteForBundle .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetFavoriteForBundle .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetFavoriteForBundle
