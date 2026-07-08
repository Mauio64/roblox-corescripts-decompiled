local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SetPlayerName = require(ParentParent.Actions.SetPlayerName)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v11 = createInspectAndBuyKeyMapper("getPlayerName")

local function GetPlayerName(p1) -- line: 20
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v11 (copy), PerformFetch (copy), SetPlayerName (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 21
		-- upvalues: Network (copy), v11 (copy), p1 (copy), PerformFetch (copy), SetPlayerName (copy), SendCounter (copy), Constants (copy)
		local v16 = p3[Network]
		local v17 = v11(p2:getState().storeId, p1)

		return PerformFetch.Single(v17, function() -- line: 26
			-- upvalues: v16 (copy), p1 (copy), p2 (copy), SetPlayerName (copy), SendCounter (copy), Constants (copy)
			return v16.getPlayerName(p1):andThen(function(p4) -- line: 27
				-- upvalues: p2 (copy), SetPlayerName (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SetPlayerName(p4))
				p2:dispatch(SendCounter(Constants.Counters.GetPlayerName .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 32
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetPlayerName .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 35
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetPlayerName .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetPlayerName
