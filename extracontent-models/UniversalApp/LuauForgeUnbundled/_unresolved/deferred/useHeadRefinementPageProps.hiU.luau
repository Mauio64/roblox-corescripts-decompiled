local HttpService = game:GetService("HttpService")

local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local module = require("@luauforge/bundled/dKX")
local module2 = require("@luauforge/bundled/dPt")
local setDynamicHeadShape = module.Thunks.SetDynamicHeadShape
local setStaticFacialAnimation = module.Thunks.SetStaticFacialAnimation
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAddFacesToHeadList = AvatarExperienceFlags.FFlagAXAddFacesToHeadList
local fFlagAXLogFacialAnimationToggle = AvatarExperienceFlags.FFlagAXLogFacialAnimationToggle
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

local getUserOwnedClassicHeads = module.Thunks.GetUserOwnedClassicHeads
local setLastSelectedHeadShape = module.Actions.SetLastSelectedHeadShape

local headShape = module2.Enums.HeadShape
local headShapeProperties = module.Enums.HeadShapeProperties
local counters = module.Counters
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local useRoactService = RobloxAppHooks.useRoactService
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local module8 = require("@luauforge/bundled/fCe")
local module9 = require("@luauforge/bundled/fCI")
local module10 = require("@luauforge/bundled/dPN")

local module11 = require("@luauforge/bundled/gLb")

local module12 = require("@luauforge/deferred/hiV")
local getEquippedHeadShapeName = module.Utils.getEquippedHeadShapeName
local getDefaultSelectedHeadShapeName = module.Utils.getDefaultSelectedHeadShapeName

local module13 = require("@luauforge/deferred/hfD")
local fFlagAXFixTryOnHeadShapeThumbnail = AvatarExperienceFlags.FFlagAXFixTryOnHeadShapeThumbnail
local fFlagAXUseSignalsForLayeredClothingEntryPage = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingEntryPage
local getLayeredClothingEntryPageStore

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	getLayeredClothingEntryPageStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingEntryPageStore
else
	getLayeredClothingEntryPageStore = nil
end

require("@luauforge/bundled/dKT")
require("@luauforge/bundled/dPs")

local function selectLocalUserId(p2)
	return p2.LocalUserId
end

local function selectEquippedAssets(p2)
	return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
end

local function selectOutfitTryOn(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn
end

local function selectAvailableHeadShapes(p2)
	return p2.AvatarExperience.AvatarScene.HeadRefinement
		and p2.AvatarExperience.AvatarScene.HeadRefinement.availableHeadShapes
end

local function selectLastSelectedHeadShape(p2)
	return p2.AvatarExperience.AvatarScene.HeadRefinement
		and p2.AvatarExperience.AvatarScene.HeadRefinement.lastSelectedHeadShape
end

local function selectEntryPage(p2)
	return p2.AvatarExperience.LayeredClothingSort.EntryPage
end

local function selectAssetInfos(p2)
	return p2.AvatarExperience.Common.AssetInfos
end

local function selectBundleInfos(p2)
	return p2.AvatarExperience.Common.BundleInfos
end

local function useHeadRefinementPageProps()
	local v5 = useRoactService(roactNetworking)
	local v6 = useDispatch()

	local v7 = useSelector(selectLocalUserId)
	local v8 = useSelector(selectEquippedAssets)
	local v9 = useSelector(selectOutfitTryOn)
	local v10

	if fFlagAXUseSignalsForLayeredClothingEntryPage then
		v10 = SignalsReact.useSignalState(getLayeredClothingEntryPageStore(false).getEntryPage)
	else
		v10 = useSelector(selectEntryPage)
	end

	local v11 = useSelector(selectAssetInfos)
	local v12 = useSelector(selectBundleInfos)

	local v13 = useSelector(selectAvailableHeadShapes)
	local v14 = useSelector(selectLastSelectedHeadShape)
	local v15 = useSelector(module11)

	local tryOnItems = v9.TryOnItems
	local lookId = v9.LookId

	local v16 = v10 == avatarScreen.Catalog
	local v17

	if fFlagAXAddFacesToHeadList then
		v17 = v8 and v8[module10.AssetTypeIdStrings.DynamicHead]
	end

	local v18 = if fFlagAXAddFacesToHeadList then v17 and next(v17) else nil

	local v19 = nil

	if fFlagAXFixTryOnHeadShapeThumbnail and tryOnItems then
		for k, tryOnItem in tryOnItems do
			local bundleInfo = tryOnItem.bundleInfo

			if not bundleInfo then
				continue
			end

			for k2, v20 in bundleInfo do
				if v20.assetType == module10.AssetTypeIdStrings.DynamicHead then
					v19 = k2
				end
			end
		end
	end

	local state, setState = React.useState(true)
	local ref = React.useRef(false)

	local v20 = React.useMemo(function()
		return v16 or not Cryo.isEmpty(tryOnItems)
	end, { v16, tryOnItems })

	local ref2 = React.useRef(false)

	React.useEffect(function()
		sendAXCounterV2(counters.Enter)
	end, {})

	React.useEffect(function()
		if Cryo.isEmpty(v13) and v5 and v7 and not ref.current then
			v6(getUserOwnedClassicHeads(v5, v7, sendAXCounterV2))
			ref.current = true
		else
			setState(false)
		end
	end, { v13, v5, v7 })

	local v21 = module13(false)

	local v22 = if v21 then SignalsReact.useSignalState(v21.getInventory) else nil

	local useMemo = React.useMemo
	local function fn()
		local fromInventory = headShapeProperties.fromInventory
		local v24 = if fFlagAXAddFacesToHeadList then v18 else nil
		return fromInventory(v22, v24, if fFlagAXFixTryOnHeadShapeThumbnail then v19 else nil)
	end

	local v24 = if fFlagAXFixTryOnHeadShapeThumbnail then v19 else nil
	local v26 = useMemo(fn, { v22, v24, if fFlagAXFixTryOnHeadShapeThumbnail then v18 else nil })

	local v27 = React.useMemo(function()
		return getEquippedHeadShapeName(v8, module10.AssetTypeIdStrings.Head)
	end, { v8 })

	local v28 = React.useMemo(function()
		return getDefaultSelectedHeadShapeName({
			isTryingOnItems = v20,
			equippedHeadShapeName = v27,
			lastTryOnHeadShapeName = v15,
			equippedAssets = v8,
			defaultHeadShapeName = v14 or headShape.Default
		})
	end, { v20, v27, v15, v8, v14 })

	local v29 = useSelector(module12)

	local v30 = if fFlagHeadRefinementFacialAnimationToggle then v29 == nil or not v29 else nil
	local v31

	if fFlagHeadRefinementFacialAnimationToggle then
		v31 = React.useMemo(function()
			local v32 = v8 and v8[module10.AssetTypeIdStrings.DynamicHead]

			if v32 then
				for k, v33 in v32 do
					return (tostring(k))
				end
			end

			if not tryOnItems then
				return nil
			end

			for k, tryOnItem in tryOnItems do
				if tryOnItem.bundleInfo then
					for k2, v33 in tryOnItem.bundleInfo do
						if v33.assetType == module10.AssetTypeIdStrings.DynamicHead then
							return (tostring(k2))
						end
					end
				elseif tryOnItem.itemSubType == module10.AssetTypeIdStrings.DynamicHead then
					return (tostring(tryOnItem.itemId))
				end
			end

			return nil
		end, { v8, tryOnItems })
	else
		v31 = nil
	end

	local v32

	if fFlagHeadRefinementFacialAnimationToggle then
		v32 = React.useCallback(function(p2)
			if v31 then
				if fFlagAXLogFacialAnimationToggle then
					sendUnifiedEventLog({
						action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						elementName = "FACIAL_ANIMATION_TOGGLE",
						surface = unifiedLoggingSurface.CUSTOMIZE,
						itemId = v31,
						elementMetadata = HttpService:JSONEncode({
							trigger = "MANUAL_TOGGLE",
							change_from_FACS_status = tostring(v30),
							change_to_FACS_status = tostring(p2)
						})
					})
				end

				v6(setStaticFacialAnimation(not p2, v31))
			end
		end, { v6, v31, v30 })
	end

	local v33 = React.useMemo(function(): boolean
		if v20 and not Cryo.isEmpty(tryOnItems) then
			for k, tryOnItem in tryOnItems do
				if tryOnItem.itemSubType == module10.AssetTypeIdStrings.DynamicHead then
					local v34 = if v11 and tryOnItem.itemId then v11[tostring(tryOnItem.itemId)] else nil

					if v34 and v34.supportsHeadShapes then
						return true
					end
				end

				if not (tryOnItem.itemType == module10.ItemType.Bundle and tryOnItem.itemSubType == module10.BundleTypeIdStrings.DynamicHead and tryOnItem.bundleInfo) then
					continue
				end

				for k2, v34 in tryOnItem.bundleInfo do
					local v35 = if v11 then v11[tostring(k2)] else nil

					if v35 and v35.supportsHeadShapes then
						return true
					end
				end

				if not (v12 and v12[tryOnItem.itemId]) then
					continue
				end

				local v34 = v12[tryOnItem.itemId]

				if v34 and v34.supportsHeadShapes then
					return true
				end
			end
		end

		if v20 and not Cryo.isEmpty(tryOnItems) and module8.isTryingOnDynamicHead(tryOnItems) then
			return false
		end

		local v34 = if v8 then v8[module10.AssetTypeIdStrings.DynamicHead] else nil

		if not v34 then
			return false
		end

		for k, v35 in v34 do
			local v36 = if v11 then v11[k] else nil

			if v36 and v36.supportsHeadShapes then
				return true
			end
		end

		return false
	end, { v20, tryOnItems, v8, v11, v12 })

	local v34 = React.useMemo(function()
		local keys = Dash.keys(v26)

		local result = {}

		for k, key in keys do
			local v35 = v26[key]

			if v35 then
				table.insert(result, {
					headShapeName = key,
					headShapeData = v35,
					isSelected = v28 == key,
					onActivated = function()
						local assetId = v35.assetId
						sendAXCounterV2(counters.HeadShapeSelect, {
							headShapeName = key or "none",
							isTryingOnItems = v20 and "true" or "false"
						})

						v6(setDynamicHeadShape(key, (tostring(assetId))))
						v6(setLastSelectedHeadShape(key))
					end
				})
			end
		end

		return result
	end, { v13, v28, v6, v20, v26, v33 })
	local v35

	if fFlagRemoveClassicHeadsAndFaces then
		v35 = React.useMemo(function(): boolean
			if v20 and lookId ~= nil then
				return true
			end

			if module9.isDynamicHeadEquipped(v8) then
				return not v33
			end

			if not v20 or v15 then
				return false
			end

			local tryingOnDynamicHead = module8.isTryingOnDynamicHead(tryOnItems)
			local v36 = lookId ~= nil

			if tryingOnDynamicHead then
				return not v33
			end

			if not v36 then
				return false
			end

			for k, tryOnItem in tryOnItems do
				if tryOnItem.itemSubType == module10.AssetTypeIdStrings.DynamicHead then
					local v37 = if v11 and tryOnItem.itemId then v11[tostring(tryOnItem.itemId)] else nil

					if v37 and v37.supportsHeadShapes then
						return false
					end

					return true
				end
			end

			return false
		end, { v8, tryOnItems, v20, lookId, v15, v33, v11 })
	else
		v35 = React.useMemo(function()
			if v20 then
				if module8.isTryingOnDynamicHead(tryOnItems) or lookId ~= nil then
					return true
				end

				if v15 then
					return false
				end
			end

			return module9.isDynamicHeadEquipped(v8)
		end, { v8, tryOnItems, v20, lookId, v15 })
	end

	React.useEffect(function()
		if v35 and not ref2.current then
			ref2.current = true
			sendAXCounterV2(counters.Unsupported)
		end
	end, { v35 })

	return v34, v35, state, v30, v32
end

return useHeadRefinementPageProps
