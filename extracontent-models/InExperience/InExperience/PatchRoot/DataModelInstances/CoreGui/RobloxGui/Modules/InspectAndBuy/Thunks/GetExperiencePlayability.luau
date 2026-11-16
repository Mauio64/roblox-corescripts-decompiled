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

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getExperiencePlayabilityStatus")

local function GetExperiencePlayability(p: string)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function()
			return v2.getExperiencePlayability(p):andThen(function(list)
				local item = list[1]
				object:dispatch(SetExperienceInfo((ExperienceInfo.fromGetPlayabilityStatus(item))))
				object:dispatch(SendCounter(Constants.Counters.GetExperiencePlayability .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetExperiencePlayability .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetExperiencePlayability .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetExperiencePlayability
