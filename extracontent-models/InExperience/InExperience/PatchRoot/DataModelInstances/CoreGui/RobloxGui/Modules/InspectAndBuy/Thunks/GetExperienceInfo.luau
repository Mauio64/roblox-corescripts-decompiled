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
local v12 = createInspectAndBuyKeyMapper("getExperienceInfo")

local function GetExperienceInfo(s1: string) -- line: 23
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v12 (copy), PerformFetch (copy), ExperienceInfo (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
	local str = tostring(s1)

	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 26
		-- upvalues: Network (copy), v12 (copy), str (ref), PerformFetch (copy), ExperienceInfo (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
		local v18 = p2[Network]
		local v19 = v12(p1:getState().storeId, str)

		return PerformFetch.Single(v19, function() -- line: 31
			-- upvalues: v18 (copy), str (ref), ExperienceInfo (copy), p1 (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
			return v18.getExperienceInfo(str):andThen(function(p3) -- line: 32
				-- upvalues: ExperienceInfo (copy), p1 (copy), SetExperienceInfo (copy), SendCounter (copy), Constants (copy)
				local v22 = p3.data[1]
				local v23 = ExperienceInfo.fromGetExperienceInfo(v22)

				p1:dispatch(SetExperienceInfo(v23))
				p1:dispatch(SendCounter(Constants.Counters.GetExperienceInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 40
				-- upvalues: p1 (copy), SendCounter (copy), Constants (copy)
				p1:dispatch(SendCounter(Constants.Counters.GetExperienceInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p1):catch(function(_) -- line: 45
			-- upvalues: p1 (copy), SendCounter (copy), Constants (copy)
			p1:dispatch(SendCounter(Constants.Counters.GetExperienceInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetExperienceInfo
