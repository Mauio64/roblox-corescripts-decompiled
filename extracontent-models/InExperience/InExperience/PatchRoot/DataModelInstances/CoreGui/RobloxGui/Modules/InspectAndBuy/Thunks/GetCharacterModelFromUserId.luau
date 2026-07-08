local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v10 = createInspectAndBuyKeyMapper("getPlayerModel")

local function GetCharacterModelFromUserId(p1, p2, p3) -- line: 19
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v10 (copy), PerformFetch (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p4, p5) -- line: 20
		-- upvalues: Network (copy), v10 (copy), p1 (copy), p2 (copy), PerformFetch (copy), p3 (copy), SendCounter (copy), Constants (copy)
		local v17 = p5[Network]
		local v18 = v10(p4:getState().storeId, p1, p2)

		return PerformFetch.Single(v18, function() -- line: 25
			-- upvalues: v17 (copy), p1 (copy), p3 (copy), p4 (copy), SendCounter (copy), Constants (copy)
			return v17.getModelFromUserId(p1):andThen(function(p6) -- line: 26
				-- upvalues: p3 (copy), p4 (copy), SendCounter (copy), Constants (copy)
				p3(p6)
				p4:dispatch(SendCounter(Constants.Counters.GetCharacterModelFromUserId .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 33
				-- upvalues: p4 (copy), SendCounter (copy), Constants (copy)
				p4:dispatch(SendCounter(Constants.Counters.GetCharacterModelFromUserId .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p4):catch(function(_) -- line: 40
			-- upvalues: p4 (copy), SendCounter (copy), Constants (copy)
			p4:dispatch(SendCounter(Constants.Counters.GetCharacterModelFromUserId .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetCharacterModelFromUserId
