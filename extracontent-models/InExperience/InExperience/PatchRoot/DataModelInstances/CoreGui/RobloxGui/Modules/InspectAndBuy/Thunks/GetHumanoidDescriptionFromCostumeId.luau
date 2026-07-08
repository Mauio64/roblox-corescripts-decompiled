local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v10 = createInspectAndBuyKeyMapper("getHumanoidDescriptionFromCostumeId")

local function GetHumanoidDescriptionFromCostumeId(p1, p2: ((...any) -> ...any)) -- line: 19
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v10 (copy), PerformFetch (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p3, p4) -- line: 20
		-- upvalues: Network (copy), v10 (copy), p1 (copy), PerformFetch (copy), p2 (copy), SendCounter (copy), Constants (copy)
		local v16 = p4[Network]
		local v17 = v10(p3:getState().storeId, p1)

		return PerformFetch.Single(v17, function() -- line: 25
			-- upvalues: v16 (copy), p1 (copy), p2 (copy), p3 (copy), SendCounter (copy), Constants (copy)
			return v16.getHumanoidDescriptionFromCostumeId(p1):andThen(function(p5) -- line: 26
				-- upvalues: p2 (copy), p3 (copy), SendCounter (copy), Constants (copy)
				p2(p5)
				p3:dispatch(SendCounter(Constants.Counters.GetHumanoidDescriptionFromCostumeId .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 34
				-- upvalues: p3 (copy), SendCounter (copy), Constants (copy)
				p3:dispatch(SendCounter(Constants.Counters.GetHumanoidDescriptionFromCostumeId .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p3):catch(function(_) -- line: 42
			-- upvalues: p3 (copy), SendCounter (copy), Constants (copy)
			p3:dispatch(SendCounter(Constants.Counters.GetHumanoidDescriptionFromCostumeId .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetHumanoidDescriptionFromCostumeId
