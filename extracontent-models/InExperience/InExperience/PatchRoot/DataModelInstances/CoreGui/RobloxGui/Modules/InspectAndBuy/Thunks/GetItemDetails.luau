local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local AssetInfo = require(parent.Models.AssetInfo)
local BundleInfo = require(parent.Models.BundleInfo)
local Network = require(parent.Services.Network)
local SetAssets = require(parent.Actions.SetAssets)
local SetBundles = require(parent.Actions.SetBundles)
local GetExperiencePlayability = require(parent.Thunks.GetExperiencePlayability)
local GetExperienceInfo = require(parent.Thunks.GetExperienceInfo)
local createInspectAndBuyKeyMapper = require(parent.createInspectAndBuyKeyMapper)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Network }

local inspectAndBuyKeyMapper = createInspectAndBuyKeyMapper("getItemDetails")

local function GetItemDetails(p, p2)
	return Thunk.new(script.Name, v, function(object, p3)
		local v2 = p3[Network]

		local v3 = inspectAndBuyKeyMapper(object:getState().storeId, p, p2)

		return PerformFetch.Single(v3, function()
			return v2.getItemDetails(p, p2):andThen(function(p4)
				if p2 == Enum.AvatarItemType.Asset then
					object:dispatch(SetAssets({ (AssetInfo.fromGetItemDetails(p4)) }))
				elseif p2 == Enum.AvatarItemType.Bundle then
					object:dispatch(SetBundles({ (BundleInfo.fromGetItemDetails(p4)) }))
				else
					object:dispatch(SendCounter(Constants.Counters.GetItemDetailsRespondedWithUnknownItemType))
				end

				if p4.CreatingUniverseId then
					object:dispatch(GetExperiencePlayability(p4.CreatingUniverseId))
					object:dispatch(GetExperienceInfo(p4.CreatingUniverseId))
				end

				object:dispatch(SendCounter(Constants.Counters.GetItemDetails .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetItemDetails .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetItemDetails .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetItemDetails
