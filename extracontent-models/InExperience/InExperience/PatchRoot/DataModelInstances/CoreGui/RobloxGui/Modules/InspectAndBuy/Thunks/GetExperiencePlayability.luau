local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local ExperienceInfo = require(ParentParent.Models.ExperienceInfo)
local SetExperienceInfo = require(ParentParent.Actions.SetExperienceInfo)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v12 = createInspectAndBuyKeyMapper("getExperiencePlayabilityStatus")

local function GetExperiencePlayability(s1: string) -- line: 23
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v12 (copy), PerformFetch (copy), ExperienceInfo (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 24
		-- upvalues: Network (copy), v12 (copy), s1 (copy), PerformFetch (copy), ExperienceInfo (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
		local v17 = p2[Network]
		local v18 = v12(p1:getState().storeId, s1)

		return PerformFetch.Single(v18, function() -- line: 29
			-- upvalues: v17 (copy), s1 (copy), ExperienceInfo (copy), p1 (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
			return v17.getExperiencePlayability(s1):andThen(function(p3) -- line: 30
				-- upvalues: ExperienceInfo (copy), p1 (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
				local v21 = p3[1]
				local v22 = ExperienceInfo.fromGetPlayabilityStatus(v21)

				p1:dispatch(SetExperienceInfo(v22))
				p1:dispatch(SendCounter(Constants.Counters.GetExperiencePlayability .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 38
				-- upvalues: p1 (copy), SendCounter (copy), Constants (copy)
				p1:dispatch(SendCounter(Constants.Counters.GetExperiencePlayability .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p1):catch(function(_) -- line: 43
			-- upvalues: p1 (copy), SendCounter (copy), Constants (copy)
			p1:dispatch(SendCounter(Constants.Counters.GetExperiencePlayability .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetExperiencePlayability
