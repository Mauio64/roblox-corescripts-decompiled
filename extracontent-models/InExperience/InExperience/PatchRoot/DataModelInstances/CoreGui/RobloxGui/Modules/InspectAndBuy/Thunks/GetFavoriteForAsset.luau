local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SetFavoriteAsset = require(parent.Actions.SetFavoriteAsset)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getFavoriteForAsset")

local function GetFavoriteForAsset(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function(_)
			return v2.getFavoriteForAsset(p):andThen(function(p3)
				if p3 == "null" then
					object:dispatch(SetFavoriteAsset(tostring(p), false))
				else
					object:dispatch(SetFavoriteAsset(tostring(p), true))
				end

				object:dispatch(SendCounter(Constants.Counters.GetFavoriteForAsset .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetFavoriteForAsset .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetFavoriteForAsset .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetFavoriteForAsset
