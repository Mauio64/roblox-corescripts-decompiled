local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local SetDynamicHeadShape = AvatarExperienceHeadRefinement.Thunks.SetDynamicHeadShape
local SetStaticFacialAnimation = AvatarExperienceHeadRefinement.Thunks.SetStaticFacialAnimation
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagAXAddFacesToHeadList = AvatarExperienceFlags.FFlagAXAddFacesToHeadList
local FFlagAXLogFacialAnimationToggle = AvatarExperienceFlags.FFlagAXLogFacialAnimationToggle
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local GetUserOwnedClassicHeads = AvatarExperienceHeadRefinement.Thunks.GetUserOwnedClassicHeads
local TryOnClassicHeadShape = AvatarExperienceHeadRefinement.Actions.TryOnClassicHeadShape
local SetLastSelectedHeadShape = AvatarExperienceHeadRefinement.Actions.SetLastSelectedHeadShape
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local HeadShape = AvatarExperienceHeadRefinement.Enums.HeadShape
local HeadShapeProperties = AvatarExperienceHeadRefinement.Enums.HeadShapeProperties
local Counters = AvatarExperienceHeadRefinement.Counters
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local useRoactService = RobloxAppHooks.useRoactService
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local selectLastTryOnClassicHeadShape = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Selectors.selectLastTryOnClassicHeadShape)
local selectFacialAnimationForHeadAdjustment = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Selectors.selectFacialAnimationForHeadAdjustment)
local getEquippedHeadShapeName = AvatarExperienceHeadRefinement.Utils.getEquippedHeadShapeName
local getDefaultSelectedHeadShapeName = AvatarExperienceHeadRefinement.Utils.getDefaultSelectedHeadShapeName
local GetHeadShapeInventoryStore = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Stores.GetHeadShapeInventoryStore)
local FFlagAXFixTryOnHeadShapeThumbnail = AvatarExperienceFlags.FFlagAXFixTryOnHeadShapeThumbnail

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local function selectLocalUserId(p1) -- line: 62
	return p1.LocalUserId
end
local function selectEquippedAssets(p2) -- line: 66
	return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
end
local function selectOutfitTryOn(p3) -- line: 70
	return p3.AvatarExperience.AvatarScene.OutfitTryOn
end
local function selectAvailableHeadShapes(p4) -- line: 74
	return p4.AvatarExperience.AvatarScene.HeadRefinement and p4.AvatarExperience.AvatarScene.HeadRefinement.availableHeadShapes
end
local function selectLastSelectedHeadShape(p5) -- line: 79
	return p5.AvatarExperience.AvatarScene.HeadRefinement and p5.AvatarExperience.AvatarScene.HeadRefinement.lastSelectedHeadShape
end
local function selectEntryPage(p6) -- line: 84
	return p6.AvatarExperience.LayeredClothingSort.EntryPage
end
local function selectAssetInfos(p7) -- line: 88
	return p7.AvatarExperience.Common.AssetInfos
end
local function selectBundleInfos(p8) -- line: 92
	return p8.AvatarExperience.Common.BundleInfos
end
local function useHeadRefinementPageProps() -- line: 105
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useSelector (copy), selectLocalUserId (copy), selectEquippedAssets (copy), selectOutfitTryOn (copy), selectEntryPage (copy), FFlagDynamicHeadsMigration (copy), selectAssetInfos (copy), selectBundleInfos (copy), selectAvailableHeadShapes (copy), selectLastSelectedHeadShape (copy), selectLastTryOnClassicHeadShape (copy), AvatarScreen (copy), FFlagAXAddFacesToHeadList (copy), Constants (copy), FFlagAXFixTryOnHeadShapeThumbnail (copy), React (copy), Cryo (copy), sendAXCounterV2 (copy), Counters (copy), GetUserOwnedClassicHeads (copy), GetHeadShapeInventoryStore (copy), SignalsReact (copy), HeadShapeProperties (copy), getEquippedHeadShapeName (copy), getDefaultSelectedHeadShapeName (copy), HeadShape (copy), selectFacialAnimationForHeadAdjustment (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagAXLogFacialAnimationToggle (copy), sendUnifiedEventLog (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), HttpService (copy), SetStaticFacialAnimation (copy), Utils (copy), Dash (copy), SetDynamicHeadShape (copy), TryOnClassicHeadShape (copy), ToggleEquipAsset (copy), SetLastSelectedHeadShape (copy), FFlagRemoveClassicHeadsAndFaces (copy), Utils2 (copy)
	local v63 = useRoactService(RoactNetworking)
	local v64 = useDispatch()
	local v65 = useSelector(selectLocalUserId)
	local v66 = useSelector(selectEquippedAssets)
	local v67 = useSelector(selectOutfitTryOn)
	local v68 = useSelector(selectEntryPage)
	local v69 = if not FFlagDynamicHeadsMigration then nil else useSelector(selectAssetInfos)
	local v70 = if not FFlagDynamicHeadsMigration then nil else useSelector(selectBundleInfos)
	local v71 = useSelector(selectAvailableHeadShapes)
	local v72 = useSelector(selectLastSelectedHeadShape)
	local v73 = useSelector(selectLastTryOnClassicHeadShape)
	local TryOnItems = v67.TryOnItems
	local LookId = v67.LookId
	local v76 = v68 == AvatarScreen.Catalog
	local v77 = if not FFlagAXAddFacesToHeadList then nil else v66 and v66[Constants.AssetTypeIdStrings.DynamicHead]
	local v78 = if not FFlagAXAddFacesToHeadList then nil else v77 and next(v77)
	local u79 = nil

	if FFlagAXFixTryOnHeadShapeThumbnail and TryOnItems then
		for _, v81 in TryOnItems do
			local bundleInfo = v81.bundleInfo

			if bundleInfo then
				for v83, v84 in bundleInfo do
					if v84.assetType == Constants.AssetTypeIdStrings.DynamicHead then
						u79 = v83
					end
				end
			end
		end
	end

	local v85, v86 = React.useState(true)
	local v87 = React.useRef(false)
	local v88 = React.useMemo(function() -- line: 154
		-- upvalues: v76 (copy), Cryo (copy), TryOnItems (copy)
		return v76 or not Cryo.isEmpty(TryOnItems)
	end, {
		v76,
		TryOnItems
	})
	local v89 = React.useRef(false)

	React.useEffect(function() -- line: 160
		-- upvalues: sendAXCounterV2 (copy), Counters (copy)
		sendAXCounterV2(Counters.Enter)
	end, {})
	React.useEffect(function() -- line: 165
		-- upvalues: Cryo (copy), v71 (copy), v63 (copy), v65 (copy), v87 (copy), v64 (copy), GetUserOwnedClassicHeads (copy), sendAXCounterV2 (copy), v86 (copy)
		if Cryo.isEmpty(v71) and (v63 and v65 and not v87.current) then
			v64(GetUserOwnedClassicHeads(v63, v65, sendAXCounterV2))
			v87.current = true

			return
		end

		v86(false)
	end, {
		v71,
		v63,
		v65
	})

	local v90 = if not FFlagDynamicHeadsMigration then nil else GetHeadShapeInventoryStore(false)
	local v91 = if not FFlagDynamicHeadsMigration or not v90 then nil else SignalsReact.useSignalState(v90.getInventory)
	local v92 = React.useMemo(function() -- line: 181
		-- upvalues: FFlagDynamicHeadsMigration (copy), HeadShapeProperties (copy), v91 (copy), FFlagAXAddFacesToHeadList (copy), v78 (copy), FFlagAXFixTryOnHeadShapeThumbnail (copy), u79 (ref)
		if FFlagDynamicHeadsMigration then
			return HeadShapeProperties.fromInventory(v91, if not FFlagAXAddFacesToHeadList then nil else v78, if not FFlagAXFixTryOnHeadShapeThumbnail then nil else u79)
		end

		return HeadShapeProperties
	end, {
		v91,
		if not FFlagAXFixTryOnHeadShapeThumbnail then nil else u79,
		if not FFlagAXFixTryOnHeadShapeThumbnail then nil else v78
	})
	local v93 = React.useMemo(function() -- line: 199
		-- upvalues: getEquippedHeadShapeName (copy), v66 (copy), Constants (copy)
		return getEquippedHeadShapeName(v66, Constants.AssetTypeIdStrings.Head)
	end, { v66 })
	local v94 = React.useMemo(function() -- line: 204
		-- upvalues: getDefaultSelectedHeadShapeName (copy), v88 (copy), v93 (copy), v73 (copy), v66 (copy), v72 (copy), HeadShape (copy)
		return getDefaultSelectedHeadShapeName({
			isTryingOnItems = v88,
			equippedHeadShapeName = v93,
			lastTryOnHeadShapeName = v73,
			equippedAssets = v66,
			defaultHeadShapeName = v72 or HeadShape.Default
		})
	end, {
		v88,
		v93,
		v73,
		v66,
		v72
	})
	local v95 = useSelector(selectFacialAnimationForHeadAdjustment)
	local v96 = if not FFlagHeadRefinementFacialAnimationToggle then nil else v95 == nil or not v95
	local v97 = if not FFlagHeadRefinementFacialAnimationToggle then nil else React.useMemo(function() -- line: 224
		-- upvalues: v66 (copy), Constants (copy), TryOnItems (copy)
		if v66 then
			local v102 = v66[Constants.AssetTypeIdStrings.DynamicHead]

			if v102 then
				for v103, _ in v102 do
					return (tostring(v103))
				end
			end
		end

		if TryOnItems then
			for _, v106 in TryOnItems do
				if not v106.bundleInfo then
					if v106.itemSubType ~= Constants.AssetTypeIdStrings.DynamicHead then
						continue
					end

					return (tostring(v106.itemId))
				end

				for v107, v108 in v106.bundleInfo do
					if v108.assetType == Constants.AssetTypeIdStrings.DynamicHead then
						return (tostring(v107))
					end
				end
			end
		end

		return nil
	end, {
		v66,
		TryOnItems
	})
	local v98 = if not FFlagHeadRefinementFacialAnimationToggle then nil else React.useCallback(function(b1: boolean) -- line: 252
		-- upvalues: v97 (copy), FFlagAXLogFacialAnimationToggle (copy), sendUnifiedEventLog (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), HttpService (copy), v96 (copy), v64 (copy), SetStaticFacialAnimation (copy)
		if v97 then
			if FFlagAXLogFacialAnimationToggle then
				sendUnifiedEventLog({
					elementName = "FACIAL_ANIMATION_TOGGLE",
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					surface = UnifiedLoggingSurface.CUSTOMIZE,
					itemId = v97,
					elementMetadata = HttpService:JSONEncode({
						trigger = "MANUAL_TOGGLE",
						change_from_FACS_status = tostring(v96),
						change_to_FACS_status = tostring(b1)
					})
				})
			end

			v64(SetStaticFacialAnimation(not b1, v97))
		end
	end, {
		v64,
		v97,
		v96
	})
	local v99 = if not FFlagDynamicHeadsMigration then nil else React.useMemo(function() -- line: 295
		-- upvalues: v88 (copy), Cryo (copy), TryOnItems (copy), Constants (copy), v69 (copy), v70 (copy), Utils (copy), v66 (copy)
		if v88 and not Cryo.isEmpty(TryOnItems) then
			for _, v111 in TryOnItems do
				if v111.itemSubType == Constants.AssetTypeIdStrings.DynamicHead then
					local v112 = if not v69 or not v111.itemId then nil else v69[tostring(v111.itemId)]

					if v112 and v112.supportsHeadShapes then
						return true
					end
				end

				if v111.itemType == Constants.ItemType.Bundle and v111.itemSubType == Constants.BundleTypeIdStrings.DynamicHead and v111.bundleInfo then
					for v113, _ in v111.bundleInfo do
						local v115 = if not v69 then nil else v69[tostring(v113)]

						if v115 and v115.supportsHeadShapes then
							return true
						end
					end

					if not v70 or not v70[v111.itemId] then
						continue
					end

					local v116 = v70[v111.itemId]

					if not v116 or not v116.supportsHeadShapes then
						continue
					end

					return true
				end
			end
		end

		if v88 and not Cryo.isEmpty(TryOnItems) and Utils.isTryingOnDynamicHead(TryOnItems) then
			return false
		end

		local v117 = if not v66 then nil else v66[Constants.AssetTypeIdStrings.DynamicHead]

		if v117 then
			for v118, _ in v117 do
				local v120 = if not v69 then nil else v69[v118]

				if v120 and v120.supportsHeadShapes then
					return true
				end
			end
		end

		return false
	end, {
		v88,
		TryOnItems,
		v66,
		v69,
		v70
	})
	local v100 = React.useMemo(function() -- line: 365
		-- upvalues: FFlagDynamicHeadsMigration (copy), Dash (copy), v92 (copy), v71 (copy), v94 (copy), sendAXCounterV2 (copy), Counters (copy), v88 (copy), v64 (copy), SetDynamicHeadShape (copy), TryOnClassicHeadShape (copy), ToggleEquipAsset (copy), Constants (copy), SetLastSelectedHeadShape (copy)
		local t1 = {}

		for _, v123 in if not FFlagDynamicHeadsMigration then v71 else Dash.keys(v92) do
			local v124 = v92[v123]

			if v124 then
				table.insert(t1, {
					headShapeName = v123,
					headShapeData = v124,
					isSelected = v123 == v94,
					onActivated = function() -- line: 381
						-- upvalues: v124 (copy), sendAXCounterV2 (copy), Counters (copy), v123 (copy), v88 (copy), FFlagDynamicHeadsMigration (copy), v64 (copy), SetDynamicHeadShape (copy), TryOnClassicHeadShape (copy), ToggleEquipAsset (copy), Constants (copy), SetLastSelectedHeadShape (copy)
						local assetId = v124.assetId

						sendAXCounterV2(Counters.HeadShapeSelect, {
							headShapeName = v123 or "none",
							isTryingOnItems = not v88 and "false" or "true"
						})

						if FFlagDynamicHeadsMigration then
							v64(SetDynamicHeadShape(v123, (tostring(assetId))))
						elseif v88 then
							v64(TryOnClassicHeadShape(v123))
						else
							v64(ToggleEquipAsset(Constants.AssetTypeIdStrings.Head, (tostring(assetId))))
						end

						if FFlagDynamicHeadsMigration then
							v64(SetLastSelectedHeadShape(v123))

							return
						end

						v64(SetLastSelectedHeadShape(v123))
					end
				})
			end
		end

		return t1
	end, {
		v71,
		v94,
		v64,
		v88,
		v92,
		v99
	})
	local v101 = if not FFlagRemoveClassicHeadsAndFaces then React.useMemo(function() -- line: 469
		-- upvalues: v88 (copy), Utils (copy), TryOnItems (copy), LookId (copy), v73 (copy), Utils2 (copy), v66 (copy)
		if v88 then
			if Utils.isTryingOnDynamicHead(TryOnItems) or LookId ~= nil then
				return true
			end

			if v73 then
				return false
			end
		end

		return Utils2.isDynamicHeadEquipped(v66)
	end, {
		v66,
		TryOnItems,
		v88,
		LookId,
		v73
	}) else React.useMemo(function() -- line: 420
		-- upvalues: v88 (copy), LookId (copy), FFlagDynamicHeadsMigration (copy), Utils2 (copy), v66 (copy), v99 (copy), v73 (copy), Utils (copy), TryOnItems (copy), Constants (copy), v69 (copy)
		if v88 and LookId ~= nil then
			return true
		end

		if FFlagDynamicHeadsMigration and Utils2.isDynamicHeadEquipped(v66) then
			return not v99
		end

		if v88 then
			if v73 then
				return false
			end

			local v125 = Utils.isTryingOnDynamicHead(TryOnItems)
			local v126 = LookId ~= nil

			if v125 then
				return not v99
			end

			if v126 then
				for _, v128 in TryOnItems do
					if v128.itemSubType == Constants.AssetTypeIdStrings.DynamicHead then
						local v129 = if not v69 or not v128.itemId then nil else v69[tostring(v128.itemId)]

						if not v129 or not v129.supportsHeadShapes then
							return true
						end

						return false
					end
				end

				return false
			end

			return false
		end

		return false
	end, {
		v66,
		TryOnItems,
		v88,
		LookId,
		v73,
		v99,
		v69
	})

	React.useEffect(function() -- line: 485
		-- upvalues: v101 (copy), v89 (copy), sendAXCounterV2 (copy), Counters (copy)
		if v101 and not v89.current then
			v89.current = true
			sendAXCounterV2(Counters.Unsupported)
		end
	end, { v101 })

	return v100, v101, v85, v96, v98
end

return useHeadRefinementPageProps
