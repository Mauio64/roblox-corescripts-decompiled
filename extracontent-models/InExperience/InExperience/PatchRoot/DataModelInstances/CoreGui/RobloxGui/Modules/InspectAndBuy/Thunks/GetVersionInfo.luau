local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local AssetInfo = require(parent.Models.AssetInfo)
local SetAssets = require(parent.Actions.SetAssets)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local GetExperiencePlayability = require(parent.Thunks.GetExperiencePlayability)
local GetExperienceInfo = require(parent.Thunks.GetExperienceInfo)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getVersionInfo")

local function GetVersionInfo(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p)

		return PerformFetch.Single(v3, function()
			return v2.getVersionInfo(p):andThen(function(p3)
				local v4 = p3.data[1]
				local creatingUniverseId

				if v4 then
					creatingUniverseId = v4.creatingUniverseId
				end

				if creatingUniverseId then
					local v5 = tostring(creatingUniverseId)

					object:dispatch(SetAssets({ (AssetInfo.fromGetVersionInfo(p, v4)) }))

					object:dispatch(GetExperiencePlayability(v5))

					object:dispatch(GetExperienceInfo(v5))
				end

				object:dispatch(SendCounter(Constants.Counters.GetVersionInfo .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetVersionInfo .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetVersionInfo .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetVersionInfo
