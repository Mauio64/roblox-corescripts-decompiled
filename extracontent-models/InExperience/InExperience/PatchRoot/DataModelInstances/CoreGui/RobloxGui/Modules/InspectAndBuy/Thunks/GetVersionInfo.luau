local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local SetAssets = require(ParentParent.Actions.SetAssets)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local GetExperiencePlayability = require(ParentParent.Thunks.GetExperiencePlayability)
local GetExperienceInfo = require(ParentParent.Thunks.GetExperienceInfo)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v14 = createInspectAndBuyKeyMapper("getVersionInfo")

local function GetVersionInfo(p1) -- line: 29
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v14 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 30
		-- upvalues: Network (copy), v14 (copy), p1 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy), SendCounter (copy), Constants (copy)
		local v19 = p3[Network]
		local v20 = v14(p2:getState().storeId, p1)

		return PerformFetch.Single(v20, function() -- line: 35
			-- upvalues: v19 (copy), p1 (copy), AssetInfo (copy), p2 (copy), SetAssets (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy), SendCounter (copy), Constants (copy)
			return v19.getVersionInfo(p1):andThen(function(p4) -- line: 36
				-- upvalues: AssetInfo (copy), p1 (copy), p2 (copy), SetAssets (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy), SendCounter (copy), Constants (copy)
				local v23 = p4.data[1]
				local v24 = if not v23 then nil else v23.creatingUniverseId

				if v24 then
					local str = tostring(v24)
					local v26 = AssetInfo.fromGetVersionInfo(p1, v23)

					p2:dispatch(SetAssets({ v26 }))
					p2:dispatch(GetExperiencePlayability(str))
					p2:dispatch(GetExperienceInfo(str))
				end

				p2:dispatch(SendCounter(Constants.Counters.GetVersionInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 55
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetVersionInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 60
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetVersionInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetVersionInfo
