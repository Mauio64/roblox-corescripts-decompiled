local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local Network = require(ParentParent.Services.Network)
local SetAssets = require(ParentParent.Actions.SetAssets)
local SetBundles = require(ParentParent.Actions.SetBundles)
local GetExperiencePlayability = require(ParentParent.Thunks.GetExperiencePlayability)
local GetExperienceInfo = require(ParentParent.Thunks.GetExperienceInfo)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v16 = createInspectAndBuyKeyMapper("getItemDetails")

local function GetItemDetails(p1, p2) -- line: 25
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v16 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy)
	return Thunk.new(script.Name, t1, function(p3, p4) -- line: 26
		-- upvalues: Network (copy), v16 (copy), p1 (copy), p2 (copy), PerformFetch (copy), AssetInfo (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy)
		local v22 = p4[Network]
		local v23 = v16(p3:getState().storeId, p1, p2)

		return PerformFetch.Single(v23, function() -- line: 31
			-- upvalues: v22 (copy), p1 (copy), p2 (copy), AssetInfo (copy), p3 (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy)
			return v22.getItemDetails(p1, p2):andThen(function(p5) -- line: 32
				-- upvalues: p2 (copy), AssetInfo (copy), p3 (copy), SetAssets (copy), BundleInfo (copy), SetBundles (copy), SendCounter (copy), Constants (copy), GetExperiencePlayability (copy), GetExperienceInfo (copy)
				if p2 == Enum.AvatarItemType.Asset then
					local v26 = AssetInfo.fromGetItemDetails(p5)

					p3:dispatch(SetAssets({ v26 }))
				elseif p2 == Enum.AvatarItemType.Bundle then
					local v27 = BundleInfo.fromGetItemDetails(p5)

					p3:dispatch(SetBundles({ v27 }))
				else
					p3:dispatch(SendCounter(Constants.Counters.GetItemDetailsRespondedWithUnknownItemType))
				end

				if p5.CreatingUniverseId then
					p3:dispatch(GetExperiencePlayability(p5.CreatingUniverseId))
					p3:dispatch(GetExperienceInfo(p5.CreatingUniverseId))
				end

				p3:dispatch(SendCounter(Constants.Counters.GetItemDetails .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 51
				-- upvalues: p3 (copy), SendCounter (copy), Constants (copy)
				p3:dispatch(SendCounter(Constants.Counters.GetItemDetails .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p3):catch(function(_) -- line: 56
			-- upvalues: p3 (copy), SendCounter (copy), Constants (copy)
			p3:dispatch(SendCounter(Constants.Counters.GetItemDetails .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetItemDetails
