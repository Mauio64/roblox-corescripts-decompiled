local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getPlayerModel")

local function GetCharacterModelFromUserId(p, p2, callback)
	return Thunk.new(script.Name, v, function(object, p3)
		local v2 = p3[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p, p2)

		return PerformFetch.Single(v3, function()
			return v2.getModelFromUserId(p):andThen(function(p4)
				callback(p4)
				object:dispatch(SendCounter(Constants.Counters.GetCharacterModelFromUserId .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetCharacterModelFromUserId .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetCharacterModelFromUserId .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetCharacterModelFromUserId
