local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local module = require("@luauforge/bundled/fvF")
local module2 = require("@luauforge/bundled/eda")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Promise = require(CorePackages.Packages.Promise)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local robloxEventReceiver = require("@luauforge/bundled/ees").RobloxEventReceiver
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local gridMetrics = UIBlox.App.Grid.GridMetrics
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module5 = require("@luauforge/bundled/fuM")
local module6 = require("@luauforge/bundled/dMd")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getGrantedOutfitIds = AvatarExperienceCommon.Utils.getGrantedOutfitIds
local useSlotBasedEditorContext = module5.Context.useSlotBasedEditorContext
local useAvatarEditorStores = module5.Context.useAvatarEditorStores

local module10 = require("@luauforge/deferred/gOO")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local useUnifiedImpressionExposer = AvatarExperienceCommon.Hooks.useUnifiedImpressionExposer

local signal = AppCommonLib.Signal
local module12 = require("@luauforge/bundled/dxy")
local module13 = require("@luauforge/bundled/dwA")
local module14 = require("@luauforge/bundled/fvh")
local module15 = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module16 = require("@luauforge/bundled/dNQ")
local fullView = AvatarExperienceCommon.Enums.FullView
local module17 = require("@luauforge/bundled/goe")
local module18 = require("@luauforge/bundled/fuD")

local module19 = require("@luauforge/bundled/ggX")
local module20 = require("@luauforge/deferred/gOP")
local module21 = require("@luauforge/bundled/fuC")

local fFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext
local fFlagAXBackgroundsOutfitHighlight = AvatarExperienceFlags.FFlagAXBackgroundsOutfitHighlight
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXFixEmptyMakeupLooks = AvatarExperienceFlags.FFlagAXFixEmptyMakeupLooks

local fFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/ggZ").EditorInventoryTTIMilestoneManager

local module22 = require("@luauforge/deferred/gOS")
local avatarEditorCategories = module6.Enums.AvatarEditorCategories
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags.FFlagAXRefetchInventoryOnUpdate

local v6 = fFlagAXRecommendedItemsImpressionExposureLogging
	and game:DefineFastFlag("AXYouMayAlsoLikeLooksExposureLogging", false)

local defineFastString = game:DefineFastString(
	"AXYouMayAlsoLikeLooksExposureLayer",
	appUserLayers.AvatarExperienceUACustomizeView
)

require("@luauforge/bundled/dMc")
require("@luauforge/bundled/fuM")
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local function selectPageFinished(p2)
	return p2.AvatarExperience.AvatarEditor.PageFinished
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectAnalyticsMetadata(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function useResetScrollOnKeyChange(p2, p3, p4)
	React.useEffect(function()
		if not p4 or p2 == nil then
			return
		end

		local current = p2.current

		if current == nil then
			return
		end

		current.CanvasPosition = Vector2.zero

		local v7 = false
		task.defer(function()
			if not v7 then
				current.CanvasPosition = Vector2.zero
			end
		end)

		return function()
			v7 = true
		end
	end, { p3, p4, p2 })
end

local function shouldRenderSettingsTile(p2): boolean
	return p2 == "OUTFIT_SWITCHER_SETTINGS_TILE"
end

local function useOutfitSwitcherFrameProps(data)
	local v7

	if fFlagAXMigrateOutfitsToUserInventory then
		v7 = data.categoryInfo
	elseif fFlagAXInventoryDurablesSupport then
		v7 = useSelector(module18.getAvatarEditorCategoryInfoFromState)
	else
		v7 = nil
	end

	local v8 = nil
	local v9 = nil

	if fFlagAXMigrateOutfitsToUserInventory or fFlagAXInventoryDurablesSupport then
		if fFlagAXAvatarEditorStoresContext then
			v8 = useAvatarEditorStores()
		else
			v9 = useSlotBasedEditorContext()
		end
	end

	local v10

	if (fFlagAXMigrateOutfitsToUserInventory or fFlagAXInventoryDurablesSupport) and v7 then
		if fFlagAXAvatarEditorStoresContext then
			v10 = v8.categoryInventoryStores[v7.NavigationKey]
		else
			v10 = v9.categoryInventoryStores[v7.NavigationKey]
		end
	else
		v10 = nil
	end

	local v11 = if fFlagAXMigrateOutfitsToUserInventory then useSignalState(v10.getItems) else nil

	local useCallback = React.useCallback
	local function fn(p2)
		local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
		local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
		local bodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
		local ownedItemIdsBySubtype

		if not fFlagAXMigrateOutfitsToUserInventory then
			ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		end

		local v12

		if fFlagAXBackgroundsOutfitHighlight then
			v12 = AvatarExperienceCommon.Backgrounds.selectActiveBackground(p2)
		end

		local wearingOutfitNoStates = {}
		local v13 = false
		local v14 = {}

		if fFlagAXMigrateOutfitsToUserInventory then
			local set = {}

			if not fFlagAXRefetchInventoryOnUpdate then
				local grantedOutfitIds = getGrantedOutfitIds(
					p2.AvatarExperience.AvatarEditor.GrantedItems,
					data.outfitType,
					true
				)

				for k, grantedOutfitId in grantedOutfitIds do
					if set[grantedOutfitId] then
						continue
					end

					set[grantedOutfitId] = true
					table.insert(v14, grantedOutfitId)
				end
			end

			if v11 then
				for k, v15 in v11 do
					local itemId = tostring(v15.itemId)

					if set[itemId] then
						continue
					end

					set[itemId] = true
					table.insert(v14, itemId)
				end
			end
		elseif ownedItemIdsBySubtype then
			local v15 = ownedItemIdsBySubtype[data.outfitKey] or {}

			v14 = table.clone(v15)
		end

		local v15 = not fFlagAXMigrateOutfitsToUserInventory and {} or nil

		for k, v16 in v14 do
			local outfitInfo = outfitInfos[v16]

			if not outfitInfo then
				continue
			end

			if
				not fFlagAXMigrateOutfitsToUserInventory
				and data.outfitType == module15.OutfitTypes.Makeup
				and outfitInfo.outfitType == module15.OutfitTypes.Makeup
			then
				table.insert(v15, v16)
			end

			local wearingOutfitNoState = module14.isWearingOutfitNoState(
				outfitInfo,
				avatarType,
				bodyColor3s,
				equippedAssets,
				avatarScales,
				nil,
				nil,
				v12
			)

			wearingOutfitNoStates[v16] = wearingOutfitNoState

			if wearingOutfitNoState then
				v13 = true
			end
		end

		if not fFlagAXMigrateOutfitsToUserInventory and data.outfitType == module15.OutfitTypes.Makeup then
			v14 = v15
		end

		return {
			ownedItemIds = v14,
			itemIdsToIsWearing = wearingOutfitNoStates,
			hasItemEquipped = v13
		}
	end

	local outfitKey = data.outfitKey
	local outfitType = if fFlagAXMigrateOutfitsToUserInventory then data.outfitType else nil
	local v14 = useCallback(fn, {
		outfitKey,
		outfitType,
		if fFlagAXMigrateOutfitsToUserInventory then v11 else nil
	})

	local v15 = React.useCallback(function(p2)
		return performFetch.GetStatus(p2, data.outfitKey)
	end, { data.outfitKey })

	local v16 = useDispatch()
	local v17 = useNavigation()
	local v18 = useAvatarRoute()
	local v19 = useStore()
	local v20 = useRoactService(module2)
	local v21 = useRoactService(module)
	local v22 = Foundation.Hooks.useTokens()

	local v23 = nil

	if fFlagAXAvatarEditorStoresContext and fFlagAXEditorEnableThumbnailLatencyStore and v8 then
		local thumbnailLatencyStores = v8.thumbnailLatencyStores

		if thumbnailLatencyStores then
			v23 = thumbnailLatencyStores[avatarEditorCategories.Avatars]
		end
	elseif fFlagAXEditorEnableThumbnailLatencyStore and not fFlagAXAvatarEditorStoresContext and v9 then
		local thumbnailLatencyStores = v9.thumbnailLatencyStores

		if thumbnailLatencyStores then
			v23 = thumbnailLatencyStores[avatarEditorCategories.Avatars]
		end
	end

	if fFlagAXEditorEnableThumbnailLatencyStore then
		module22(v23)
	end

	local v24 = useNetworking()
	local v25

	if fFlagAXRefetchInventoryOnUpdate then
		v25 = React.useCallback(function()
			if v24 and v7 and v10 then
				v16(module20(v24, v7, nil, v10))
			end
		end, { v16, v24, v7, v10 })
	end

	if fFlagAXRefetchInventoryOnUpdate then
		module10(data.outfitKey, v10, v25)
	end

	local v26 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local v27 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v28 = useSelector(selectPageFinished, getUseSelectorDeepEquals())
	local v29 = useSelector(function(p2)
		return module17(p2, v18.opaque.name)
	end, getUseSelectorDeepEquals())
	local v30 = useSelector(v14, getUseSelectorDeepEquals())
	local v31 = useSelector(v15, getUseSelectorDeepEquals())
	local itemIdsToIsWearing = v30.itemIdsToIsWearing
	local hasItemEquipped = v30.hasItemEquipped
	local v32

	if fFlagAXMigrateOutfitsToUserInventory then
		v32 = not (v10 == nil) and not useSignalState(v10.getHasReachedLastPage)
	else
		v32 = not v28[data.outfitKey]
	end

	local v33 = not v26 and v32 and (fFlagAXMigrateOutfitsToUserInventory or v31 ~= module12.Fetching)

	local useState = React.useState
	local x = v27.X
	local v34 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module15.LandscapeNavWidth
	local state, setState = useState(x * v34)

	local v35 = math.max(0, state - v22.Gap.Small * 2)

	local v36 = v29 == fullView.SceneFullView
	local v37 = v29 == fullView.UIFullView

	local xLarge = v22.Gap.XLarge

	local v38 = React.useMemo(function()
		local metricsForFixedColumns = gridMetrics.getMetricsForFixedColumns(math.max(v35, 0), xLarge, 4)
		local v39 = gridMetrics.getMediumMetrics(math.max(v35, 0), xLarge)

		if metricsForFixedColumns.itemsPerRow > v39.itemsPerRow then
			v39 = metricsForFixedColumns
		end

		return v39
	end, { state })

	local v39 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
	end, { setState })

	local folderFilter = if fFlagAXAvatarFoldersEnabled then data.folderFilter else nil
	local itemIdsFilter = if fFlagAXAvatarFoldersEnabled and folderFilter then folderFilter.itemIdsFilter else nil
	local selectedFolderId

	if fFlagAXAvatarFoldersEnabled and folderFilter then
		selectedFolderId = folderFilter.selectedFolderId
	end

	local ref = if fFlagAXAvatarFoldersEnabled then React.useRef(nil) else nil

	if fFlagAXAvatarFoldersEnabled then
		local showFolders = data.showFolders == true
		React.useEffect(function()
			if not showFolders or ref == nil then
				return
			end

			local current = ref.current

			if current == nil then
				return
			end

			current.CanvasPosition = Vector2.zero

			local v40 = false
			task.defer(function()
				if not v40 then
					current.CanvasPosition = Vector2.zero
				end
			end)

			return function()
				v40 = true
			end
		end, { selectedFolderId, showFolders, ref })
	end

	local function fn2()
		if not v30.ownedItemIds then
			return {}
		end

		local clone = table.clone(v30.ownedItemIds)

		if fFlagAXAvatarFoldersEnabled and itemIdsFilter then
			clone = itemIdsFilter(clone)
		end

		if data.showSettingsTile then
			table.insert(clone, 1, "OUTFIT_SWITCHER_SETTINGS_TILE")
		end

		return clone
	end

	local v42 = React.useMemo(fn2, {
		v30.ownedItemIds,
		data.showSettingsTile,
		if fFlagAXAvatarFoldersEnabled then itemIdsFilter else nil
	})

	local ref2 = if fFlagAXTTIEditorEnableMilestones then React.useRef(false) else nil

	local useCallback2 = React.useCallback
	local function fn3()
		if fFlagAXTTIEditorEnableMilestones then
			if v32 and v31 ~= module12.Fetching then
				if
					fFlagAXMigrateOutfitsToUserInventory and v24 and v7 and v10
					or fFlagAXInventoryDurablesSupport and v24 and v10
				then
					v16(module20(v24, v7, nil, v10, nil, fFlagAXTTIEditorEnableMilestones and true or nil))
				end

				if not fFlagAXMigrateOutfitsToUserInventory then
					v16(module19(
						data.outfitKey,
						true,
						data.outfitKey,
						data.outfitType,
						v24,
						nil,
						nil,
						fFlagAXTTIEditorEnableMilestones and true or nil
					))
				end
			end
		elseif v32 and v31 ~= module12.Fetching then
			if not fFlagAXMigrateOutfitsToUserInventory then
				v16(module19(data.outfitKey, true, data.outfitKey, data.outfitType, v24))
			end

			if
				fFlagAXMigrateOutfitsToUserInventory and v7 and v24 and v10
				or fFlagAXInventoryDurablesSupport and v24 and v10
			then
				v16(module20(v24, v7, nil, v10))
			end
		end
	end

	local v44

	if fFlagAXMigrateOutfitsToUserInventory or fFlagAXInventoryDurablesSupport then
		v44 = v24
	end

	local v45

	if fFlagAXMigrateOutfitsToUserInventory or fFlagAXInventoryDurablesSupport then
		v45 = v7
	end

	local v46 = if fFlagAXMigrateOutfitsToUserInventory or fFlagAXInventoryDurablesSupport then v10 else nil
	local v47 = useCallback2(fn3, { v16, v32, v31, v44, v45, v46 })

	local v48 = React.useCallback(function()
		if v26 then
			v47()
		end
	end, { v26, v47 })

	React.useEffect(function()
		v47()
	end, { v47 })

	if fFlagAXTTIEditorEnableMilestones then
		React.useEffect(function()
			if editorInventoryTTIMilestoneManager then
				local v49

				if data.outfitType == module15.OutfitTypes.Makeup then
					v49 = avatarEditorCategories.Makeup
				elseif
					data.outfitType == module15.OutfitTypes.Avatar
					or data.outfitType == module15.OutfitTypes.EditableAvatar
				then
					v49 = avatarEditorCategories.Avatars
				elseif data.outfitType == module15.OutfitTypes.Animations then
					v49 = avatarEditorCategories.Animations
				end

				editorInventoryTTIMilestoneManager.ensureSessionActive({
					category = v49,
					page = v18.current.name,
					opaquePage = v18.opaque.name
				})
			end

			if fFlagAXEditorEnableThumbnailLatencyStore and v23 then
				v23.startTracking()
			end
		end, { v23, data.outfitType })

		local ownedItemIds2 = v30.ownedItemIds
		React.useEffect(function()
			if
				editorInventoryTTIMilestoneManager
				and ref2
				and not ref2.current
				and ownedItemIds2 ~= nil
				and #ownedItemIds2 > 0
			then
				ref2.current = true

				editorInventoryTTIMilestoneManager.L2.functionallyReady()
				editorInventoryTTIMilestoneManager.endTilesTracking()
			end
		end, { ownedItemIds2 })
	end

	local v49 = useSelector(selectAnalyticsMetadata)

	local key = v18.current.key
	local v50 = module13.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local v51 = React.useMemo(function()
		return signal.new()
	end, {})

	local v52 = React.useCallback(function(): boolean
		return key == v17.state.key
	end, { key, v17.state.key })

	local v53 = React.useCallback(function()
		v51:fire()
	end, { v51 })
	local ref3, v54

	if v6 then
		ref3 = React.useRef(nil)

		local v55 = useUnifiedImpressionExposer(ref3, defineFastString)

		v54 = React.useMemo(function()
			return { v55 }
		end, { v55 })
	end

	if fFlagAXEnableExpiredUserLookCheckout then
		local v55 = React.useMemo(function()
			return robloxEventReceiver.new(NotificationService)
		end, {})
		local ref4 = React.useRef(nil)

		if v55 ~= nil then
			ref4.current = v55:observeEvent("AvatarAssetOwnershipNotifications", function()
				local v56 = v20

				local v57 = v16(module19(
					module16.EditableCharacterKey,
					true,
					module16.EditableCharacterKey,
					module15.OutfitTypes.Avatar,
					v56,
					true,
					true
				))
				local v58

				if module15.OutfitTypes.Makeup ~= nil then
					v58 = v16(module19(
						module16.MakeupOutfitKey,
						true,
						module16.MakeupOutfitKey,
						module15.OutfitTypes.Makeup,
						v56,
						true,
						true
					))
				end

				local v59

				if v58 and typeof(v58.andThen) == "function" then
					v59 = v58:andThen(function()
						local state2 = v19:getState()

						local ownedItemId = state2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[module16.MakeupOutfitKey]

						if ownedItemId == nil then
							return
						end

						local outfitInfos = state2.AvatarExperience.AvatarEditor.OutfitInfos
						local set = {}

						for k, v60 in ownedItemId do
							local outfitInfo = outfitInfos[v60]

							if not (outfitInfo ~= nil and outfitInfo.assets ~= nil) then
								continue
							end

							for k2, asset in outfitInfo.assets do
								for k3 in asset do
									if set[k3] then
										continue
									end

									set[k3] = true
									v16(module21(v20, v21, k3, module15.ItemType.Asset, true))
								end
							end
						end
					end)
				end

				local v60 = {}

				if v57 and typeof(v57.andThen) == "function" then
					table.insert(v60, v57)
				end

				if v59 and typeof(v59.andThen) == "function" then
					table.insert(v60, v59)
				elseif v58 and typeof(v58.andThen) == "function" then
					table.insert(v60, v58)
				end

				if #v60 > 0 then
					Promise.all(v60)
				end
			end)
		end

		React.useEffect(function()
			return function()
				if ref4.current ~= nil then
					ref4.current:disconnect()
					ref4.current = nil
				end
			end
		end, {})
	end

	local v55

	if fFlagAXEditorEnableThumbnailLatencyStore then
		local ref4 = React.useRef({})
		v55 = React.useCallback(function(p2)
			if v23 == nil then
				return nil
			end

			local current = ref4.current
			local v56 = current[p2]

			if v56 then
				return v56
			end

			local v57 = v23
			local function fn4(p3)
				v57.setThumbnailLoaded(p2)
			end
			current[p2] = fn4
			return fn4
		end, { v23 })
	end

	local v56 = {
		fetchMoreOutfits = v47,
		gridMetrics = v38,
		hasItemFromCurrentPageEquipped = hasItemEquipped,
		isSceneFullView = v36,
		isUIFullView = v37,
		itemIds = v42,
		itemIdsToIsWearing = itemIdsToIsWearing,
		onAbsoluteSizeChanged = v39,
		onScrollingFrameThresholdReached = v48,
		shouldRenderSettingsTile = shouldRenderSettingsTile,
		impressionsTag = v50,
		analyticsMetadata = v49,
		requestImpressionsSignal = v51,
		impressionsPageFilter = v52,
		onCanvasPositionChanged = v53,
		searchUuid = data.outfitKey,
		showLoadMoreButton = v33,
		outfitType = 0,
		recommendedItemsRef = 0,
		tagBasedImpressionsDetectorExtensions = 0,
		showFolders = 0,
		scrollResetKey = 0,
		getOnThumbnailLoaded = 0,
		scrollingFrameRef = 0,
		scrollPerformanceIntervalName = 0
	}

	local v57 = if fFlagAXFixEmptyMakeupLooks or fFlagAXOutfitPageRevamp then data.outfitType else nil
	v56.outfitType = v57

	if not fFlagAXRecommendedItemsImpressionExposureLogging then
		ref3 = nil
	end

	v56.recommendedItemsRef = ref3

	if not fFlagAXRecommendedItemsImpressionExposureLogging then
		v54 = nil
	end

	v56.tagBasedImpressionsDetectorExtensions = v54

	local v58 = if fFlagAXAvatarFoldersEnabled then data.showFolders else nil
	v56.showFolders = v58

	if not fFlagAXAvatarFoldersEnabled then
		selectedFolderId = nil
	end

	v56.scrollResetKey = selectedFolderId

	if not fFlagAXEditorEnableThumbnailLatencyStore then
		v55 = nil
	end

	v56.getOnThumbnailLoaded = v55
	v56.scrollingFrameRef = if fFlagAXAvatarFoldersEnabled then ref else nil
	v56.scrollPerformanceIntervalName = data.scrollPerformanceIntervalName
	return v56
end

return useOutfitSwitcherFrameProps
