local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local SetAvatarPreviewDetails = require(ParentParent.Actions.SetAvatarPreviewDetails)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local BundleInfo = require(ParentParent.Models.BundleInfo)
local SetAssets = require(ParentParent.Actions.SetAssets)
local SetBundles = require(ParentParent.Actions.SetBundles)
local AvatarExperienceInspectAndBuy = require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local GetItemDetails = require(ParentParent.Thunks.GetItemDetails)
local FFlagAXEnableBatchItemDetailsFetchV2 = AvatarExperienceFlags.FFlagAXEnableBatchItemDetailsFetchV2
local BatchItemDetailsPerformFetchKey = AvatarExperienceInspectAndBuy.Constants.BatchItemDetailsPerformFetchKey
local FFlagAXWrapInspectAndBuyThunksInTasks = require(ParentParent.Flags.FFlagAXWrapInspectAndBuyThunksInTasks)
local t1 = { Network }

local function GetAvatarPreview(p1) -- line: 33
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), PerformFetch (copy), SetAvatarPreviewDetails (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), FFlagAXWrapInspectAndBuyThunksInTasks (copy), ItemTypeEnum (copy), GetItemDetails (copy), BatchItemDetailsPerformFetchKey (copy), AssetInfo (copy), BundleInfo (copy), SetAssets (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 34
		-- upvalues: Network (copy), p1 (copy), PerformFetch (copy), SetAvatarPreviewDetails (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), FFlagAXWrapInspectAndBuyThunksInTasks (copy), ItemTypeEnum (copy), GetItemDetails (copy), BatchItemDetailsPerformFetchKey (copy), AssetInfo (copy), BundleInfo (copy), SetAssets (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
		local v25 = p3[Network]
		local t2 = {}

		if p1 then
			for _, v28 in p1 do
				table.insert(t2, {
					id = v28.assetId,
					meta = v28.meta
				})
			end
		end

		return PerformFetch.Single("PreviewAvatar", function() -- line: 47
			-- upvalues: v25 (copy), t2 (copy), p2 (copy), SetAvatarPreviewDetails (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), FFlagAXWrapInspectAndBuyThunksInTasks (copy), ItemTypeEnum (copy), GetItemDetails (copy), PerformFetch (copy), BatchItemDetailsPerformFetchKey (copy), AssetInfo (copy), BundleInfo (copy), SetAssets (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
			return v25.getPreviewAvatar(t2):andThen(function(p4) -- line: 48
				-- upvalues: p2 (copy), SetAvatarPreviewDetails (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), FFlagAXWrapInspectAndBuyThunksInTasks (copy), ItemTypeEnum (copy), GetItemDetails (copy), PerformFetch (copy), BatchItemDetailsPerformFetchKey (copy), v25 (copy), AssetInfo (copy), BundleInfo (copy), SetAssets (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SetAvatarPreviewDetails(p4))

				if not FFlagAXEnableBatchItemDetailsFetchV2 and (p4.look and p4.look.items) then
					for _, v32 in p4.look.items do
						if FFlagAXWrapInspectAndBuyThunksInTasks then
							task.spawn(function() -- line: 58
								-- upvalues: v32 (copy), ItemTypeEnum (copy), p2 (copy), GetItemDetails (copy)
								if v32.itemType == ItemTypeEnum.Asset then
									p2:dispatch(GetItemDetails(v32.id, Enum.AvatarItemType.Asset))

									return
								end

								if v32.itemType == ItemTypeEnum.Bundle then
									p2:dispatch(GetItemDetails(v32.id, Enum.AvatarItemType.Bundle))
								end
							end)
						elseif v32.itemType == ItemTypeEnum.Asset then
							p2:dispatch(GetItemDetails(v32.id, Enum.AvatarItemType.Asset))
						elseif v32.itemType == ItemTypeEnum.Bundle then
							p2:dispatch(GetItemDetails(v32.id, Enum.AvatarItemType.Bundle))
						end
					end
				end

				if FFlagAXEnableBatchItemDetailsFetchV2 then
					local t3 = {}

					if p4.look and p4.look.items then
						for _, v35 in p4.look.items do
							table.insert(t3, {
								itemType = if v35.itemType ~= ItemTypeEnum.Asset then Enum.AvatarItemType.Bundle.Value else Enum.AvatarItemType.Asset.Value,
								id = tonumber(v35.id) or 0
							})
						end
					end

					PerformFetch.Single(BatchItemDetailsPerformFetchKey, function() -- line: 91
						-- upvalues: v25 (copy), t3 (copy), FFlagAXWrapInspectAndBuyThunksInTasks (copy), ItemTypeEnum (copy), AssetInfo (copy), BundleInfo (copy), p2 (copy), SetAssets (copy), SetBundles (copy), SendCounter (copy), Constants (copy)
						return v25.getBatchItemDetailsV2(t3):andThen(function(p5) -- line: 94
							-- upvalues: FFlagAXWrapInspectAndBuyThunksInTasks (copy), ItemTypeEnum (copy), AssetInfo (copy), BundleInfo (copy), p2 (copy), SetAssets (copy), SetBundles (copy)
							if FFlagAXWrapInspectAndBuyThunksInTasks and (p5 and p5.data) then
								task.spawn(function() -- line: 96
									-- upvalues: p5 (copy), ItemTypeEnum (copy), AssetInfo (copy), BundleInfo (copy), p2 (copy), SetAssets (copy), SetBundles (copy)
									local t4 = {}
									local t5 = {}

									for _, v46 in p5.data do
										if v46.itemType == ItemTypeEnum.Asset then
											table.insert(t4, AssetInfo.fromGetItemDetailsV2(v46))
										elseif v46.itemType == ItemTypeEnum.Bundle then
											table.insert(t5, BundleInfo.fromGetItemDetailsV2(v46))
										end
									end

									p2:dispatch(SetAssets(t4))
									p2:dispatch(SetBundles(t5))
								end)

								return
							end

							if p5 and p5.data then
								local t6 = {}
								local t7 = {}

								for _, v41 in p5.data do
									if v41.itemType == ItemTypeEnum.Asset then
										table.insert(t6, AssetInfo.fromGetItemDetailsV2(v41))
									elseif v41.itemType == ItemTypeEnum.Bundle then
										table.insert(t7, BundleInfo.fromGetItemDetailsV2(v41))
									end
								end

								p2:dispatch(SetAssets(t6))
								p2:dispatch(SetBundles(t7))
							end
						end, function(_) -- line: 126
							-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
							p2:dispatch(SendCounter(Constants.Counters.BatchGetItemDetails .. Constants.CounterSuffix.RequestRejected))
						end)
					end)(p2)
					p2:dispatch(SendCounter(Constants.Counters.BatchGetItemDetails .. Constants.CounterSuffix.RequestSucceeded))
				end
			end, function(_) -- line: 140
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetAvatarPreview .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 145
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetAvatarPreview .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetAvatarPreview
