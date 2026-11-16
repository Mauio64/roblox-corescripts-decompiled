local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dCn")
local module2 = require("@luauforge/bundled/dHO")
local setEquippedDynamicHeadShape = module2.Actions.SetEquippedDynamicHeadShape
local setEquippedStaticFacialAnimation = module2.Actions.SetEquippedStaticFacialAnimation
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local module5 = require("@luauforge/bundled/dHL")
local constants = module5.Constants
local assetTypeToAssetCategory = constants.AssetTypeToAssetCategory
local assetCategoryToAssetTypes = constants.AssetCategoryToAssetTypes

local module6 = require("@luauforge/bundled/dOx")
local module7 = require("@luauforge/bundled/dOy")
local module8 = require("@luauforge/bundled/dOz")
local module9 = require("@luauforge/bundled/dOA")
local module10 = require("@luauforge/bundled/dOB")
local module11 = require("@luauforge/bundled/dNc")
local module12 = require("@luauforge/bundled/dOC")
local module13 = require("@luauforge/bundled/dMx")
local module14 = require("@luauforge/bundled/dNQ")
local module15 = require("@luauforge/bundled/dOD")
local module16 = require("@luauforge/bundled/dOG")
local module17 = require("@luauforge/bundled/dOE")

local module18 = require("@luauforge/bundled/dOH")
local module19 = require("@luauforge/bundled/dOI")
local module20 = require("@luauforge/bundled/dOJ")
local setAccessoryAdjustments = module5.Actions.SetAccessoryAdjustments
require("@luauforge/bundled/dMc")
local headShape = require("@luauforge/bundled/dMd").Enums.HeadShape
local headShapeProperties = module2.Enums.HeadShapeProperties

local module21 = require("@luauforge/bundled/dOK")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local purchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local MAKEUP_LOOK_ASSET_TYPES = AvatarExperienceCommon.Constants.MAKEUP_LOOK_ASSET_TYPES
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration

local avatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local module23 = require("@luauforge/bundled/dOL")
local fFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix

local defineFastFlag = game:DefineFastFlag("AXRefactorToggleEquipAsset3", false)
local fFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local fFlagAXSkipEmotesInAvatarData = AvatarExperienceFlags.FFlagAXSkipEmotesInAvatarData

local fFlagAXPopulateSupportsHeadShapesFromAvatarData = AvatarExperienceFlags.FFlagAXPopulateSupportsHeadShapesFromAvatarData
local fFlagAXBlockMakeupEquipR6 = AvatarExperienceFlags.FFlagAXBlockMakeupEquipR6

local function checkIfWearingAsset(p2, p3): boolean
	if p2 and p2[p3] then
		return true
	end

	return false
end

local function replaceOutfitParts(p2, assets)
	if not module23() then
		return Cryo.Dictionary.join(p2, assets)
	end

	if assets[module13.AssetTypeIdStrings.Head] or assets[module13.AssetTypeIdStrings.DynamicHead] then
		local v5 = {
			[module13.AssetTypeIdStrings.Head] = {},
			[module13.AssetTypeIdStrings.DynamicHead] = {}
		}

		for k, dynamicHeadAssetType in module13.DynamicHeadAssetTypes do
			v5[k] = {}
		end

		assets = Cryo.Dictionary.join(v5, assets)
	end

	return (Cryo.Dictionary.join(p2, assets))
end

local function toggleSingleAsset(options, data, p2)
	local joined = options or {}

	if data.assetTypeId == module13.AssetTypeIdStrings.EmoteAnimation then
		return joined
	end

	local v5 = joined[data.assetTypeId]
	local assetId = data.assetId

	if v5 and v5[assetId] then
		local v6 = joined[data.assetTypeId] or {}

		return Cryo.Dictionary.join(joined, {
			[data.assetTypeId] = Cryo.Dictionary.join(v6, { [data.assetId] = Cryo.None })
		})
	else
		local defaultMetadata = module17.getDefaultMetadata(data.assetTypeId)

		if data.overrideOrder then
			defaultMetadata.order = data.overrideOrder

			local sortedEquippedLayeredMakeup = module16.getSortedEquippedLayeredMakeup(joined)

			if
				ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.assetTypeId]
				and sortedEquippedLayeredMakeup
				and #sortedEquippedLayeredMakeup == MAX_MAKEUP_LAYERS
			then
				local v6 = sortedEquippedLayeredMakeup[#sortedEquippedLayeredMakeup]

				joined = Cryo.Dictionary.join(joined, {
					[v6.typeId] = Cryo.Dictionary.join(joined[v6.typeId] or {}, {
						[v6.id] = Cryo.None
					})
				})
			end
		elseif defaultMetadata.isLayered and module13.AssetTypeIdToAccessoryTypeEnum[data.assetTypeId] then
			local sortedEquippedLCIfNoDefault = module15.getSortedEquippedLCIfNoDefault(joined)

			if sortedEquippedLCIfNoDefault then
				local v6 = { id = data.assetId, typeId = data.assetTypeId }

				local tableAndOrderAfterEquippingIntoSort, v7 = module15.getTableAndOrderAfterEquippingIntoSort(
					sortedEquippedLCIfNoDefault,
					v6
				)

				for k, v8 in tableAndOrderAfterEquippingIntoSort do
					if v8.id == data.assetId then
						defaultMetadata.order = #tableAndOrderAfterEquippingIntoSort - k
					elseif joined[v8.typeId] then
						joined = Cryo.Dictionary.join(joined, {
							[v8.typeId] = Cryo.Dictionary.join(joined[v8.typeId], {
								[v8.id] = Cryo.Dictionary.join(joined[v8.typeId][v8.id], {
									order = #tableAndOrderAfterEquippingIntoSort - k
								})
							})
						})
					else
						module(`EquippedAssets.lua missing asset typeId post sort ID:{v8.id} typeId: {v8.typeId}`)
					end
				end
			end
		elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.assetTypeId] then
			local sortedEquippedLayeredMakeup = module16.getSortedEquippedLayeredMakeup(joined)

			if sortedEquippedLayeredMakeup then
				local v6 = { id = data.assetId, typeId = data.assetTypeId }

				local tableAndOrderAfterEquippingIntoSort, v7 = module16.getTableAndOrderAfterEquippingIntoSort(
					sortedEquippedLayeredMakeup,
					v6
				)

				for k, v8 in tableAndOrderAfterEquippingIntoSort do
					if v8.id == data.assetId then
						defaultMetadata.order = math.min(
							#tableAndOrderAfterEquippingIntoSort - k,
							MAX_MAKEUP_LAYERS - 1
						)
					else
						local v9 = joined[v8.typeId] or {}
						local v10 = v9[v8.id] or {}
						joined = Cryo.Dictionary.join(joined, {
							[v8.typeId] = Cryo.Dictionary.join(v9, {
								[v8.id] = Cryo.Dictionary.join(v10, {
									order = #tableAndOrderAfterEquippingIntoSort - k
								})
							})
						})
					end
				end

				if MAX_MAKEUP_LAYERS < #sortedEquippedLayeredMakeup then
					for i = MAX_MAKEUP_LAYERS + 1, #sortedEquippedLayeredMakeup do
						joined = Cryo.Dictionary.join(joined, {
							[sortedEquippedLayeredMakeup[i].typeId] = Cryo.Dictionary.join(
								joined[sortedEquippedLayeredMakeup[i].typeId] or {},
								{ [sortedEquippedLayeredMakeup[i].id] = Cryo.None }
							)
						})
					end
				end

				return Cryo.Dictionary.join(joined, {
					[data.assetTypeId] = Cryo.Dictionary.join(joined[data.assetTypeId] or {}, {
						[data.assetId] = defaultMetadata
					})
				})
			end
		elseif data.overrideAdjustments then
			defaultMetadata = Cryo.Dictionary.join(defaultMetadata, data.overrideAdjustments)
		end

		local joined2 = { [data.assetId] = defaultMetadata }

		local v6 = joined[data.assetTypeId] or {}

		if
			data.assetTypeId == module13.AssetTypeIdStrings.Hat
			and not (p2 and p2.ignoreAccessoryLimits)
		then
			if #Cryo.Dictionary.keys(v6) >= module14.MaxHats then
				return joined
			end

			return Cryo.Dictionary.join(joined, {
				[data.assetTypeId] = Cryo.Dictionary.join(v6, joined2)
			})
		else
			local v7 = assetTypeToAssetCategory[data.assetTypeId]

			if v7 then
				for k, v8 in assetCategoryToAssetTypes[v7] do
					if joined[v8] and next(joined[v8]) then
						joined = Cryo.Dictionary.join(joined, { [v8] = {} })
					end
				end
			end

			if data.assetTypeId == module13.AssetTypeIdStrings.Head then
				for k, dynamicHeadAssetType in module13.DynamicHeadAssetTypes do
					joined = Cryo.Dictionary.join(joined, { [k] = {} })
				end
			end

			if data.assetTypeId == module13.AssetTypeIdStrings.DynamicHead then
				joined = Cryo.Dictionary.join(joined, {
					[module13.AssetTypeIdStrings.Head] = {}
				})
			end

			if
				data.assetId
				and tostring(data.assetId) == tostring(headShapeProperties[headShape.Default].assetId)
			then
				return (Cryo.Dictionary.join(joined, {
					[module13.AssetTypeIdStrings.Head] = {},
					[module13.AssetTypeIdStrings.DynamicHead] = {}
				}))
			else
				local bypassAccessoryLimitsAccessoryAssetTypeIdString = module13.BypassAccessoryLimitsAccessoryAssetTypeIdStrings[data.assetTypeId]

				if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.assetTypeId] then
					return Cryo.Dictionary.join(joined, {
						[data.assetTypeId] = Cryo.Dictionary.join(v6, joined2)
					})
				else
					local join = Cryo.Dictionary.join
					local assetTypeId = data.assetTypeId

					if
						p2
						and p2.ignoreAccessoryLimits
						and bypassAccessoryLimitsAccessoryAssetTypeIdString
					then
						joined2 = Cryo.Dictionary.join(v6, joined2)
					end

					return join(joined, { [assetTypeId] = joined2 })
				end
			end
		end
	end
end

return Rodux.createReducer(nil, {
	[module11.name] = function(p2, p3)
		local assets = p3.avatarData.assets

		if assets == nil then
			return p2
		end

		local result = {}

		for k, asset in assets do
			local id = tostring(asset.assetType.id)
			local id2 = tostring(asset.id)

			if not (not fFlagAXSkipEmotesInAvatarData or id ~= module13.AssetTypeIdStrings.EmoteAnimation) then
				continue
			end

			local v6 = result[id] or {}
			v6[id2] = module17.fromMetadata(asset.meta, id)

			if fFlagAXModeratedItemsFlow then
				v6[id2].availabilityStatus = asset.availabilityStatus
			end

			if fFlagAXPopulateSupportsHeadShapesFromAvatarData and asset.supportsHeadShapes ~= nil then
				v6[id2].supportsHeadShapes = asset.supportsHeadShapes
			end

			result[id] = v6
		end

		local v6 = result[module13.AssetTypeIdStrings.DynamicHead] or {}
		local v7 = result[module13.AssetTypeIdStrings.Face] or {}

		if not (Cryo.isEmpty(v6) or Cryo.isEmpty(v7)) then
			result[module13.AssetTypeIdStrings.Face] = {}
		end

		return result
	end,
	[module7.name] = function(options, data)
		if defineFastFlag then
			return toggleSingleAsset(options, data)
		end

		local joined = options or {}

		if data.assetTypeId == module13.AssetTypeIdStrings.EmoteAnimation then
			return joined
		end

		local v6 = joined[data.assetTypeId]
		local assetId = data.assetId

		if v6 and v6[assetId] then
			local v7 = joined[data.assetTypeId] or {}

			return Cryo.Dictionary.join(joined, {
				[data.assetTypeId] = Cryo.Dictionary.join(v7, {
					[data.assetId] = Cryo.None
				})
			})
		else
			local defaultMetadata = module17.getDefaultMetadata(data.assetTypeId)

			if data.overrideOrder then
				defaultMetadata.order = data.overrideOrder

				local sortedEquippedLayeredMakeup = module16.getSortedEquippedLayeredMakeup(joined)

				if
					ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.assetTypeId]
					and sortedEquippedLayeredMakeup
					and #sortedEquippedLayeredMakeup == MAX_MAKEUP_LAYERS
				then
					local v7 = sortedEquippedLayeredMakeup[#sortedEquippedLayeredMakeup]

					joined = Cryo.Dictionary.join(joined, {
						[v7.typeId] = Cryo.Dictionary.join(joined[v7.typeId] or {}, {
							[v7.id] = Cryo.None
						})
					})
				end
			elseif
				defaultMetadata.isLayered
				and module13.AssetTypeIdToAccessoryTypeEnum[data.assetTypeId]
			then
				local sortedEquippedLCIfNoDefault = module15.getSortedEquippedLCIfNoDefault(joined)

				if sortedEquippedLCIfNoDefault then
					local v7 = { id = data.assetId, typeId = data.assetTypeId }

					local tableAndOrderAfterEquippingIntoSort, v8 = module15.getTableAndOrderAfterEquippingIntoSort(
						sortedEquippedLCIfNoDefault,
						v7
					)

					for k, v9 in tableAndOrderAfterEquippingIntoSort do
						if v9.id == data.assetId then
							defaultMetadata.order = #tableAndOrderAfterEquippingIntoSort - k
						elseif joined[v9.typeId] then
							joined = Cryo.Dictionary.join(joined, {
								[v9.typeId] = Cryo.Dictionary.join(joined[v9.typeId], {
									[v9.id] = Cryo.Dictionary.join(joined[v9.typeId][v9.id], {
										order = #tableAndOrderAfterEquippingIntoSort - k
									})
								})
							})
						else
							module(`EquippedAssets.lua missing asset typeId post sort ID:{v9.id} typeId: {v9.typeId}`)
						end
					end
				end
			elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.assetTypeId] then
				local sortedEquippedLayeredMakeup = module16.getSortedEquippedLayeredMakeup(joined)

				if sortedEquippedLayeredMakeup then
					local v7 = { id = data.assetId, typeId = data.assetTypeId }

					local tableAndOrderAfterEquippingIntoSort, v8 = module16.getTableAndOrderAfterEquippingIntoSort(
						sortedEquippedLayeredMakeup,
						v7
					)

					for k, v9 in tableAndOrderAfterEquippingIntoSort do
						if v9.id == data.assetId then
							defaultMetadata.order = math.min(
								#tableAndOrderAfterEquippingIntoSort - k,
								MAX_MAKEUP_LAYERS - 1
							)
						else
							local v10 = joined[v9.typeId] or {}
							local v11 = v10[v9.id] or {}
							joined = Cryo.Dictionary.join(joined, {
								[v9.typeId] = Cryo.Dictionary.join(v10, {
									[v9.id] = Cryo.Dictionary.join(v11, {
										order = #tableAndOrderAfterEquippingIntoSort - k
									})
								})
							})
						end
					end

					if MAX_MAKEUP_LAYERS < #sortedEquippedLayeredMakeup then
						for i = MAX_MAKEUP_LAYERS + 1, #sortedEquippedLayeredMakeup do
							joined = Cryo.Dictionary.join(joined, {
								[sortedEquippedLayeredMakeup[i].typeId] = Cryo.Dictionary.join(
									joined[sortedEquippedLayeredMakeup[i].typeId] or {},
									{ [sortedEquippedLayeredMakeup[i].id] = Cryo.None }
								)
							})
						end
					end

					return Cryo.Dictionary.join(joined, {
						[data.assetTypeId] = Cryo.Dictionary.join(joined[data.assetTypeId] or {}, {
							[data.assetId] = defaultMetadata
						})
					})
				end
			elseif data.overrideAdjustments then
				defaultMetadata = Cryo.Dictionary.join(defaultMetadata, data.overrideAdjustments)
			end

			local defaultMetadatasByAssetId = { [data.assetId] = defaultMetadata }

			local v7 = joined[data.assetTypeId] or {}

			if data.assetTypeId == module13.AssetTypeIdStrings.Hat then
				if #Cryo.Dictionary.keys(v7) >= module14.MaxHats then
					return joined
				end

				return Cryo.Dictionary.join(joined, {
					[data.assetTypeId] = Cryo.Dictionary.join(v7, defaultMetadatasByAssetId)
				})
			else
				local v8 = assetTypeToAssetCategory[data.assetTypeId]

				if v8 then
					for k, v9 in assetCategoryToAssetTypes[v8] do
						if joined[v9] and next(joined[v9]) then
							joined = Cryo.Dictionary.join(joined, { [v9] = {} })
						end
					end
				end

				if data.assetTypeId == module13.AssetTypeIdStrings.Head then
					for k, dynamicHeadAssetType in module13.DynamicHeadAssetTypes do
						joined = Cryo.Dictionary.join(joined, { [k] = {} })
					end
				end

				if data.assetTypeId == module13.AssetTypeIdStrings.DynamicHead then
					joined = Cryo.Dictionary.join(joined, {
						[module13.AssetTypeIdStrings.Head] = {}
					})
				end

				if
					data.assetId
					and tostring(data.assetId) == tostring(headShapeProperties[headShape.Default].assetId)
				then
					return (Cryo.Dictionary.join(joined, {
						[module13.AssetTypeIdStrings.Head] = {},
						[module13.AssetTypeIdStrings.DynamicHead] = {}
					}))
				elseif ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data.assetTypeId] then
					return Cryo.Dictionary.join(joined, {
						[data.assetTypeId] = Cryo.Dictionary.join(v7, defaultMetadatasByAssetId)
					})
				else
					return Cryo.Dictionary.join(joined, {
						[data.assetTypeId] = defaultMetadatasByAssetId
					})
				end
			end
		end
	end,
	[module6.name] = function(p2, p3)
		local assets = p3.assets

		if assets and not Cryo.isEmpty(assets) then
			for k, asset in assets do
				p2 = toggleSingleAsset(p2, asset, { ignoreAccessoryLimits = true })
			end
		end

		return p2
	end,
	[module8.name] = function(options, p2)
		if p2.fullReset then
			return p2.assets
		end

		return replaceOutfitParts(options or {}, p2.assets)
	end,
	[module9.name] = function(options, p2)
		local joined = options or {}

		for k, assetIdToAssetMetadataModel in p2.assetTypeIdToAssetIdToAssetMetadataModel do
			for k2, assetMetadataModel in assetIdToAssetMetadataModel do
				joined = Cryo.Dictionary.join(joined, {
					[k] = Cryo.Dictionary.join(joined[k], { [k2] = Cryo.None })
				})
			end
		end

		return joined
	end,
	[module18.name] = function(options, p2)
		local v6 = options or {}

		local result = {}
		local flag = false

		for k, v7 in pairs(v6) do
			local v8 = {}
			local flag2 = false

			for k2, v9 in v7 do
				local v10 = k == module13.AssetTypeIdStrings.HairAccessory

				if v9.isLayered and (not v10 or p2.hasLayeredHair) then
					flag2 = true
				else
					v8[k2] = v9
				end
			end

			if flag2 then
				result[k] = v8
				flag = true
			else
				result[k] = v7
			end
		end

		if flag then
			return result
		end

		return v6
	end,
	[module20.name] = function(p2, p3)
		for k, orderAndAssetTypeId in p3.assetIdToOrderAndAssetTypeId do
			local assetTypeId = orderAndAssetTypeId.assetTypeId
			local order = orderAndAssetTypeId.order

			local v6 = p2[assetTypeId]
			local v7 = v6[k]

			p2 = Cryo.Dictionary.join(p2, {
				[assetTypeId] = Cryo.Dictionary.join(v6, {
					[k] = Cryo.Dictionary.join(v7, { order = order })
				})
			})
		end

		return p2
	end,
	[setAccessoryAdjustments.name] = function(items, data)
		for k, item in items do
			for k2, v6 in item do
				if k2 == data.itemId then
					return Cryo.Dictionary.join(items, {
						[k] = Cryo.Dictionary.join(item, {
							[k2] = Cryo.Dictionary.join(v6, {
								position = data.position,
								rotation = data.rotation,
								scale = data.scale
							})
						})
					})
				end
			end
		end

		return items
	end,
	[module10.name] = function(options, p2)
		if not module21() then
			return options
		end

		local joined = options or {}

		for k, assetTypeId in p2.assetTypeIds do
			if assetTypeId == module13.AssetTypeIdStrings.DynamicHead then
				for k2, dynamicHeadAssetType in module13.DynamicHeadAssetTypes do
					joined = Cryo.Dictionary.join(joined, { [k2] = Cryo.None })
				end
			end

			joined = Cryo.Dictionary.join(joined, { [assetTypeId] = Cryo.None })
		end

		return joined
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.equipped and p3.equipped.EquippedAssets then
			return table.clone(p3.equipped.EquippedAssets)
		end

		return p2
	end,
	[setEquippedDynamicHeadShape.name] = function(p2, p3)
		local v6 = p2[module13.AssetTypeIdStrings.DynamicHead]

		if not v6 then
			return p2
		end

		local values = {}
		local v7 = false

		for k, v8 in v6 do
			if v8.supportsHeadShapes == false then
				values[k] = v8
			else
				values[k] = Cryo.Dictionary.join(v8, { headShape = p3.headShapeName })
				v7 = true
			end
		end

		if not v7 then
			return p2
		end

		return Cryo.Dictionary.join(p2, {
			[module13.AssetTypeIdStrings.DynamicHead] = values
		})
	end,
	[setEquippedStaticFacialAnimation.name] = fFlagHeadRefinementFacialAnimationToggle and function(p2, p3)
		local v6 = p2[module13.AssetTypeIdStrings.DynamicHead]

		if not v6 then
			return p2
		end

		local values = {}

		for k, v7 in v6 do
			values[k] = Cryo.Dictionary.join(v7, {
				staticFacialAnimation = p3.isEnabled
			})
		end

		return Cryo.Dictionary.join(p2, {
			[module13.AssetTypeIdStrings.DynamicHead] = values
		})
	end or nil,
	[purchaseItemsSuccess.name] = function(options, data)
		local result = options or {}

		if not (data.equippableAssets and #data.equippableAssets > 0) then
			return result
		end

		if data.shouldClearEquippedMakeup then
			for k, v6 in MAKEUP_LOOK_ASSET_TYPES do
				result[k] = {}
			end
		end

		result = data.replaceAllEquippedAssets and {} or result

		for k, equippableAsset in data.equippableAssets do
			local v6 = result[equippableAsset.assetTypeId]
			local assetId = equippableAsset.assetId

			if
				v6 and v6[assetId]
				or tostring(equippableAsset.assetTypeId) == tostring(Enum.AvatarAssetType.EmoteAnimation.Value)
				or not (not fFlagAXBackgroundsCustomizeHydration or not avatarBackground or equippableAsset.assetTypeId ~= avatarBackground)
			then
				continue
			end

			local v7 = fFlagParseHeadShapeFromAPIResponse
				and equippableAsset.headShape ~= nil
				and { headShape = equippableAsset.headShape }
				or nil

			local v8 = nil

			if fFlagHeadRefinementFacialAnimationToggle then
				local staticFacialAnimation = equippableAsset.staticFacialAnimation

				v8 = staticFacialAnimation ~= nil and {
						staticFacialAnimation = staticFacialAnimation
					}
					or v8
			end

			local v9 = if v7 or v8 then Cryo.Dictionary.join(v7 or {}, v8 or {}) else nil

			result = toggleSingleAsset(
				result,
				{
					assetId = equippableAsset.assetId,
					assetTypeId = equippableAsset.assetTypeId,
					overrideOrder = equippableAsset.order,
					overrideAdjustments = v9
				},
				{ ignoreAccessoryLimits = false }
			)
		end

		if fFlagAXMISSaveWearFix and data.makeupAssetsOnHumanoid then
			for k, v6 in ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
				if not result[k] then
					continue
				end

				for k2, v7 in result[k] do
					if data.makeupAssetsOnHumanoid[k2] == nil then
						result[k][k2] = nil
					else
						result[k][k2].order = data.makeupAssetsOnHumanoid[k2]
					end
				end
			end
		end

		return result
	end,
	[module12.name] = function(options, p2)
		local joined = options or {}

		local v6 = {}

		for k, v7 in ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
			local v8 = joined[k]

			if not v8 then
				continue
			end

			for k2, v9 in v8 do
				table.insert(v6, { assetId = k2, assetTypeId = k, metadata = v9 })
			end
		end

		table.sort(v6, function(a, b): boolean
			return a.metadata.order ~= nil
				and (b.metadata.order == nil or a.metadata.order < b.metadata.order)
		end)

		for k, v7 in v6 do
			local assetTypeId = v7.assetTypeId
			local assetId = v7.assetId
			local v8 = joined[assetTypeId] and joined[assetTypeId][assetId] or v7.metadata

			local joined2 = Cryo.Dictionary.join(v8, {
				order = k - 1
			})

			joined = Cryo.Dictionary.join(joined, {
				[assetTypeId] = Cryo.Dictionary.join(joined[assetTypeId] or {}, {
					[assetId] = joined2
				})
			})
		end

		return joined
	end,
	[module19.name] = fFlagAXBlockMakeupEquipR6 and function(options, p2)
		local joined = options or {}

		for k, v6 in joined do
			if isMakeupAssetType(k) then
				joined = Cryo.Dictionary.join(joined, { [k] = Cryo.None })
			end
		end

		return joined
	end or nil
})
