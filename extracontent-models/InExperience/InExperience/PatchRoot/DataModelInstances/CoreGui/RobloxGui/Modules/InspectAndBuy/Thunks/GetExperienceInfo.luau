local CorePackages = game:GetService("CorePackages")

local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch

local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local ExperienceInfo = require(parent.Models.ExperienceInfo)
local SetExperienceInfo = require(parent.Actions.SetExperienceInfo)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getExperienceInfo")

local function GetExperienceInfo(p: string)
	local v2 = tostring(p)

	return Thunk.new(script.Name, v, function(object, p2)
		local v3 = p2[Network]

		local v4 = inspectAndBuyKeyMapper(object:getState().storeId, v2)

		return PerformFetch.Single(v4, function()
			return v3.getExperienceInfo(v2):andThen(function(p3)
				local v5 = p3.data[1]
				object:dispatch(SetExperienceInfo((ExperienceInfo.fromGetExperienceInfo(v5))))
				object:dispatch(SendCounter(Constants.Counters.GetExperienceInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetExperienceInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetExperienceInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetExperienceInfo
