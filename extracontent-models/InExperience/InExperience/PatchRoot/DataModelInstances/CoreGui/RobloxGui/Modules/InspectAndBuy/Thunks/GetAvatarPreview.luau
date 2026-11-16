local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)
local SetAvatarPreviewDetails = require(parent.Actions.SetAvatarPreviewDetails)
local AssetInfo = require(parent.Models.AssetInfo)
local BundleInfo = require(parent.Models.BundleInfo)
local SetAssets = require(parent.Actions.SetAssets)
local SetBundles = require(parent.Actions.SetBundles)
local AvatarExperienceInspectAndBuy = require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceModel = require(CorePackages.Workspace.Packages.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local GetItemDetails = require(parent.Thunks.GetItemDetails)
local FFlagAXEnableBatchItemDetailsFetchV2 = AvatarExperienceFlags.FFlagAXEnableBatchItemDetailsFetchV2
local BatchItemDetailsPerformFetchKey = AvatarExperienceInspectAndBuy.Constants.BatchItemDetailsPerformFetchKey
local FFlagAXWrapInspectAndBuyThunksInTasks = require(parent.Flags.FFlagAXWrapInspectAndBuyThunksInTasks)

local v = { Network }

local function GetAvatarPreview(items)
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[Network]

		local v3 = {}

		if items then
			for _, item in items do
				table.insert(v3, { id = item.assetId, meta = item.meta })
			end
		end

		return PerformFetch.Single("PreviewAvatar", function()
			return v2.getPreviewAvatar(v3):andThen(function(p2)
				object:dispatch(SetAvatarPreviewDetails(p2))

				if not FFlagAXEnableBatchItemDetailsFetchV2 and p2.look and p2.look.items then
					for _, item in p2.look.items do
						if FFlagAXWrapInspectAndBuyThunksInTasks then
							task.spawn(function()
								if item.itemType == ItemTypeEnum.Asset then
									object:dispatch(GetItemDetails(item.id, Enum.AvatarItemType.Asset))
								elseif item.itemType == ItemTypeEnum.Bundle then
									object:dispatch(GetItemDetails(item.id, Enum.AvatarItemType.Bundle))
								end
							end)
						elseif item.itemType == ItemTypeEnum.Asset then
							object:dispatch(GetItemDetails(item.id, Enum.AvatarItemType.Asset))
						elseif item.itemType == ItemTypeEnum.Bundle then
							object:dispatch(GetItemDetails(item.id, Enum.AvatarItemType.Bundle))
						end
					end
				end

				if FFlagAXEnableBatchItemDetailsFetchV2 then
					local v4 = {}

					if p2.look and p2.look.items then
						for _, item in p2.look.items do
							local itemType

							if item.itemType == ItemTypeEnum.Asset then
								itemType = Enum.AvatarItemType.Asset.Value
							else
								itemType = Enum.AvatarItemType.Bundle.Value
							end

							local v5 = {
								itemType = itemType,
								id = tonumber(item.id) or 0
							}
							table.insert(v4, v5)
						end
					end

					PerformFetch.Single(BatchItemDetailsPerformFetchKey, function()
						return v2.getBatchItemDetailsV2(v4):andThen(function(p3)
							if FFlagAXWrapInspectAndBuyThunksInTasks and p3 and p3.data then
								task.spawn(function()
									local v5 = {}
									local v6 = {}

									for _, v7 in p3.data do
										if v7.itemType == ItemTypeEnum.Asset then
											table.insert(v5, AssetInfo.fromGetItemDetailsV2(v7))
										elseif v7.itemType == ItemTypeEnum.Bundle then
											table.insert(v6, BundleInfo.fromGetItemDetailsV2(v7))
										end
									end

									object:dispatch(SetAssets(v5))
									object:dispatch(SetBundles(v6))
								end)
							elseif p3 and p3.data then
								local v5 = {}
								local v6 = {}

								for _, v7 in p3.data do
									if v7.itemType == ItemTypeEnum.Asset then
										table.insert(v5, AssetInfo.fromGetItemDetailsV2(v7))
									elseif v7.itemType == ItemTypeEnum.Bundle then
										table.insert(v6, BundleInfo.fromGetItemDetailsV2(v7))
									end
								end

								object:dispatch(SetAssets(v5))
								object:dispatch(SetBundles(v6))
							end
						end, function(_)
							object:dispatch(SendCounter(Constants.Counters.BatchGetItemDetails .. Constants.CounterSuffix.RequestRejected))
						end)
					end)(object)

					object:dispatch(SendCounter(Constants.Counters.BatchGetItemDetails .. Constants.CounterSuffix.RequestSucceeded))
				end
			end, function(_)
				object:dispatch(SendCounter(Constants.Counters.GetAvatarPreview .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(object):catch(function(_)
			object:dispatch(SendCounter(Constants.Counters.GetAvatarPreview .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetAvatarPreview
