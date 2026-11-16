local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SetPlayerName = require(parent.Actions.SetPlayerName)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getPlayerName")

local function GetPlayerName(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function()
			return v2.getPlayerName(p):andThen(function(p3)
				object:dispatch(SetPlayerName(p3))
				object:dispatch(SendCounter(Constants.Counters.GetPlayerName .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetPlayerName .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetPlayerName .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetPlayerName
