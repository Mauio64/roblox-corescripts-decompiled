local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SetCollectibleResellableInstances = require(ParentParent.Actions.SetCollectibleResellableInstances)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v11 = createInspectAndBuyKeyMapper("getCollectibleResellableInstances")

local function GetCollectibleResellableInstances(p1, p2) -- line: 17
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v11 (copy), PerformFetch (copy), SetCollectibleResellableInstances (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p3, p4) -- line: 18
		-- upvalues: Network (copy), v11 (copy), p1 (copy), p2 (copy), PerformFetch (copy), SetCollectibleResellableInstances (copy), SendCounter (copy), Constants (copy)
		local v17 = p4[Network]
		local v18 = v11(p3:getState().storeId, p1, p2)

		return PerformFetch.Single(v18, function() -- line: 23
			-- upvalues: v17 (copy), p1 (copy), p2 (copy), p3 (copy), SetCollectibleResellableInstances (copy), SendCounter (copy), Constants (copy)
			return v17.getCollectibleResellableInstances(p1, p2):andThen(function(p5) -- line: 24
				-- upvalues: p3 (copy), SetCollectibleResellableInstances (copy), p1 (copy), SendCounter (copy), Constants (copy)
				local v21 = p5 and p5.itemInstances

				if v21 then
					p3:dispatch(SetCollectibleResellableInstances(p1, v21))
				end

				if v21 then
					p3:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstances .. Constants.CounterSuffix.RequestSucceeded))

					return
				end

				p3:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstancesRequestSucceededWithoutResult))
			end, function(_) -- line: 42
				-- upvalues: p3 (copy), SendCounter (copy), Constants (copy)
				p3:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstances .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p3):catch(function(_) -- line: 49
			-- upvalues: p3 (copy), SendCounter (copy), Constants (copy)
			p3:dispatch(SendCounter(Constants.Counters.GetCollectibleResellableInstances .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetCollectibleResellableInstances
