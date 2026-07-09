local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local RobloxEventReceiver = require(CorePackages.Workspace.Packages.RealtimeDelivery).RobloxEventReceiver
local Foundation = require(CorePackages.Packages.Foundation)
local GridMetrics = require(CorePackages.Packages.UIBlox).App.Grid.GridMetrics
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local FFlagAEGetEditableOutfitsType = require(Modules.AvatarExperience.Flags.FFlagAEGetEditableOutfitsType)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local useAvatarEditorStores = AvatarExperienceSlotBasedEditor.Context.useAvatarEditorStores
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local useUnifiedImpressionExposer = AvatarExperienceCommon.Hooks.useUnifiedImpressionExposer
local Signal = AppCommonLib.Signal
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Constants = require(Modules.LuaApp.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local FullView = AvatarExperienceCommon.Enums.FullView
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)
local GetOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfits)
local GetUserInventoryV2 = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventoryV2)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local FFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXFixEmptyMakeupLooks = AvatarExperienceFlags.FFlagAXFixEmptyMakeupLooks
local FFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local FFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local EditorInventoryTTIMilestoneManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).EditorInventoryTTIMilestoneManager
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local v53 = FFlagAXRecommendedItemsImpressionExposureLogging and game:DefineFastFlag("AXYouMayAlsoLikeLooksExposureLogging", false)
local v54 = game:DefineFastString("AXYouMayAlsoLikeLooksExposureLayer", AppUserLayers.AvatarExperienceUACustomizeView)

require(Modules.AvatarExperience.Common.Types)

local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local function selectPageFinished(p1) -- line: 74
	return p1.AvatarExperience.AvatarEditor.PageFinished
end
local function selectScreenSize(p2) -- line: 78
	return p2.ScreenSize
end
local function selectAnalyticsMetadata(p3) -- line: 82
	return p3.AvatarExperience.AnalyticsMetadata
end
local function shouldRenderSettingsTile(s1: string) -- line: 114
	return s1 == "OUTFIT_SWITCHER_SETTINGS_TILE"
end
local function useOutfitSwitcherFrameProps(t1: {[any]: any}) -- line: 127
	-- upvalues: React (copy), Constants2 (copy), Utils (copy), PerformFetch (copy), useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useStore (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), Foundation (copy), FFlagAXInventoryDurablesSupport (copy), useSelector (copy), Utils2 (copy), FFlagAXAvatarEditorStoresContext (copy), useAvatarEditorStores (copy), useSlotBasedEditorContext (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), useNetworking (copy), useAppPolicy (copy), selectScreenSize (copy), getUseSelectorDeepEquals (copy), selectPageFinished (copy), selectIsFullView (copy), RetrievalStatus (copy), FullView (copy), GridMetrics (copy), FFlagAXTTIEditorEnableMilestones (copy), GetUserInventoryV2 (copy), GetOutfits (copy), FFlagAEGetEditableOutfitsType (copy), EditorInventoryTTIMilestoneManager (copy), selectAnalyticsMetadata (copy), Constants (copy), Signal (copy), v53 (copy), useUnifiedImpressionExposer (copy), v54 (copy), FFlagAXEnableExpiredUserLookCheckout (copy), RobloxEventReceiver (copy), NotificationService (copy), Constants3 (copy), FetchAssetOrBundleInfo (copy), Promise (copy), shouldRenderSettingsTile (copy), FFlagAXFixEmptyMakeupLooks (copy), FFlagAXOutfitPageRevamp (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy)
	local v66 = React.useCallback(function(p4) -- line: 128
		-- upvalues: t1 (copy), Constants2 (copy), Utils (copy)
		local OutfitInfos = p4.AvatarExperience.AvatarEditor.OutfitInfos
		local EquippedAssets = p4.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local AvatarType = p4.AvatarExperience.AvatarEditor.Character.AvatarType
		local BodyColor3s = p4.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local AvatarScales = p4.AvatarExperience.AvatarEditor.Character.AvatarScales
		local OwnedItemIdsBySubtype = p4.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		local t2 = {}
		local v123 = false
		local t3 = {}

		if OwnedItemIdsBySubtype then
			local v125 = OwnedItemIdsBySubtype[t1.outfitKey] or {}

			t3 = table.clone(v125)
		end

		local t4 = {}

		for _, v128 in t3 do
			local v129 = OutfitInfos[v128]

			if v129 then
				if t1.outfitType == Constants2.OutfitTypes.Makeup and v129.outfitType == Constants2.OutfitTypes.Makeup then
					table.insert(t4, v128)
				end

				local v130 = Utils.isWearingOutfitNoState(v129, AvatarType, BodyColor3s, EquippedAssets, AvatarScales)

				t2[v128] = v130

				if v130 then
					v123 = true
				end
			end
		end

		return {
			ownedItemIds = if t1.outfitType ~= Constants2.OutfitTypes.Makeup then t3 else t4,
			itemIdsToIsWearing = t2,
			hasItemEquipped = v123
		}
	end, { t1.outfitKey })
	local v67 = React.useCallback(function(p5) -- line: 174
		-- upvalues: PerformFetch (copy), t1 (copy)
		return PerformFetch.GetStatus(p5, t1.outfitKey)
	end, { t1.outfitKey })
	local v68 = useDispatch()
	local v69 = useNavigation()
	local v70 = useAvatarRoute()
	local v71 = useStore()
	local v72 = useRoactService(RoactNetworking)
	local v73 = useRoactService(Analytics)
	local v74 = Foundation.Hooks.useTokens()
	local v75 = if not FFlagAXInventoryDurablesSupport then nil else useSelector(Utils2.getAvatarEditorCategoryInfoFromState)
	local v76 = nil
	local v77 = nil

	if FFlagAXInventoryDurablesSupport then
		if FFlagAXAvatarEditorStoresContext then
			v76 = useAvatarEditorStores()
		else
			v77 = useSlotBasedEditorContext()
		end
	end

	local v78 = if not FFlagAXInventoryDurablesSupport or not v75 then nil else if not FFlagAXAvatarEditorStoresContext then v77.categoryInventoryStores[v75.NavigationKey] else v76.categoryInventoryStores[v75.NavigationKey]
	local u79 = nil

	if FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables then
		u79 = useNetworking()
	end

	local v80 = useAppPolicy(function(p6) -- line: 209
		return p6.getEnableContinuousLoad()
	end)
	local v81 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v82 = useSelector(selectPageFinished, getUseSelectorDeepEquals())
	local v83 = useSelector(function(p7) -- line: 215
		-- upvalues: selectIsFullView (copy), v70 (copy)
		return selectIsFullView(p7, v70.opaque.name)
	end, getUseSelectorDeepEquals())
	local v84 = useSelector(v66, getUseSelectorDeepEquals())
	local v85 = useSelector(v67, getUseSelectorDeepEquals())
	local itemIdsToIsWearing = v84.itemIdsToIsWearing
	local hasItemEquipped = v84.hasItemEquipped
	local v88 = not v82[t1.outfitKey]
	local v89 = not v80 and (v88 and v85 ~= RetrievalStatus.Fetching)
	local v90, v91 = React.useState(v81.X * Constants2.LandscapeNavWidth)
	local v92 = math.max(0, v90 - v74.Gap.Small * 2)
	local v93 = v83 == FullView.SceneFullView
	local v94 = v83 == FullView.UIFullView
	local XLarge = v74.Gap.XLarge
	local v96 = React.useMemo(function() -- line: 237
		-- upvalues: GridMetrics (copy), v92 (copy), XLarge (copy)
		local v134 = GridMetrics.getMetricsForFixedColumns(math.max(v92, 0), XLarge, 4)
		local v135 = GridMetrics.getMediumMetrics(math.max(v92, 0), XLarge)

		if v134.itemsPerRow > v135.itemsPerRow then
			v135 = v134
		end

		return v135
	end, { v90 })
	local v97 = React.useCallback(function(p8) -- line: 249
		-- upvalues: v91 (copy)
		v91(p8.AbsoluteSize.X)
	end, { v91 })
	local v98 = React.useMemo(function() -- line: 253
		-- upvalues: v84 (copy), t1 (copy)
		if not v84.ownedItemIds then
			return {}
		end

		local v137 = table.clone(v84.ownedItemIds)

		if t1.showSettingsTile then
			table.insert(v137, 1, "OUTFIT_SWITCHER_SETTINGS_TILE")
		end

		return v137
	end, {
		v84.ownedItemIds,
		t1.showSettingsTile
	})
	local u99 = nil
	local u100 = nil

	if FFlagAXTTIEditorEnableMilestones then
		u99 = React.useRef(false)
		u100 = React.useRef(false)
	end

	local v101 = React.useCallback(function() -- line: 277
		-- upvalues: FFlagAXTTIEditorEnableMilestones (copy), v88 (copy), v85 (copy), RetrievalStatus (copy), FFlagAXInventoryDurablesSupport (copy), u79 (ref), v78 (copy), u99 (ref), v68 (copy), GetUserInventoryV2 (copy), v75 (copy), GetOutfits (copy), t1 (copy), FFlagAEGetEditableOutfitsType (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy)
		if FFlagAXTTIEditorEnableMilestones then
			if v88 and v85 ~= RetrievalStatus.Fetching then
				if FFlagAXInventoryDurablesSupport and u79 and v78 then
					if FFlagAXTTIEditorEnableMilestones and u99 then
						u99.current = true
					end

					v68(GetUserInventoryV2(u79, v75, nil, v78, nil, not not FFlagAXTTIEditorEnableMilestones or nil))
				end

				v68(GetOutfits(t1.outfitKey, true, t1.outfitKey, if not FFlagAEGetEditableOutfitsType then nil else t1.outfitType, if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else u79, nil, nil, not not FFlagAXTTIEditorEnableMilestones or nil))

				return
			end
		elseif v88 and v85 ~= RetrievalStatus.Fetching then
			v68(GetOutfits(t1.outfitKey, true, t1.outfitKey, if not FFlagAEGetEditableOutfitsType then nil else t1.outfitType, if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else u79))

			if FFlagAXInventoryDurablesSupport and u79 and v78 then
				v68(GetUserInventoryV2(u79, v75, nil, v78))
			end
		end
	end, {
		v68,
		v88,
		v85,
		if not FFlagAXInventoryDurablesSupport then nil else u79,
		if not FFlagAXInventoryDurablesSupport then nil else v75,
		if not FFlagAXInventoryDurablesSupport then nil else v78
	})
	local v102 = React.useCallback(function() -- line: 343
		-- upvalues: v80 (copy), v101 (copy)
		if v80 then
			v101()
		end
	end, {
		v80,
		v101
	})

	React.useEffect(function() -- line: 350
		-- upvalues: v101 (copy)
		v101()
	end, { v101 })

	if FFlagAXTTIEditorEnableMilestones then
		local ownedItemIds = v84.ownedItemIds

		React.useEffect(function() -- line: 356
			-- upvalues: EditorInventoryTTIMilestoneManager (copy), u99 (ref), u100 (ref), ownedItemIds (copy)
			if EditorInventoryTTIMilestoneManager and (u99 and u99.current and u100 and not u100.current and ownedItemIds ~= nil and #ownedItemIds > 0) then
				u100.current = true
				EditorInventoryTTIMilestoneManager.endTilesTracking()
			end
		end, { ownedItemIds })
	end

	local v104 = useSelector(selectAnalyticsMetadata)
	local key = v70.current.key
	local v106 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v107 = React.useMemo(function() -- line: 379
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v108 = React.useCallback(function() -- line: 383
		-- upvalues: key (copy), v69 (copy)
		return key == v69.state.key
	end, {
		key,
		v69.state.key
	})
	local v109 = React.useCallback(function() -- line: 387
		-- upvalues: v107 (copy)
		v107:fire()
	end, { v107 })
	local v110 = nil
	local v111 = nil

	if v53 then
		v110 = React.useRef(nil)

		local v112 = useUnifiedImpressionExposer(v110, v54)

		v111 = React.useMemo(function() -- line: 401
			-- upvalues: v112 (copy)
			return { v112 }
		end, { v112 })
	end

	if FFlagAXEnableExpiredUserLookCheckout then
		local v113 = React.useMemo(function() -- line: 415
			-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
			return RobloxEventReceiver.new(NotificationService)
		end, {})
		local v114 = React.useRef(nil)

		if v113 ~= nil then
			v114.current = v113:observeEvent("AvatarAssetOwnershipNotifications", function() -- line: 423
				-- upvalues: FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), v72 (copy), v68 (copy), GetOutfits (copy), Constants3 (copy), FFlagAEGetEditableOutfitsType (copy), Constants2 (copy), v71 (copy), FetchAssetOrBundleInfo (copy), v73 (copy), Promise (copy)
				local v138 = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else v72
				local v139 = v68(GetOutfits(Constants3.EditableCharacterKey, true, Constants3.EditableCharacterKey, if not FFlagAEGetEditableOutfitsType then nil else Constants2.OutfitTypes.Avatar, v138, true, true))
				local v140 = if Constants2.OutfitTypes.Makeup == nil then nil else v68(GetOutfits(Constants3.MakeupOutfitKey, true, Constants3.MakeupOutfitKey, if not FFlagAEGetEditableOutfitsType then nil else Constants2.OutfitTypes.Makeup, v138, true, true))
				local v141 = if not v140 or typeof(v140.andThen) ~= "function" then nil else v140:andThen(function() -- line: 470
					-- upvalues: v71 (copy), Constants3 (copy), v68 (copy), FetchAssetOrBundleInfo (copy), v72 (copy), v73 (copy), Constants2 (copy)
					local v143 = v71:getState()
					local v144 = v143.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[Constants3.MakeupOutfitKey]

					if v144 == nil then
						return
					end

					local OutfitInfos = v143.AvatarExperience.AvatarEditor.OutfitInfos
					local t5 = {}

					for _, v148 in v144 do
						local v149 = OutfitInfos[v148]

						if v149 ~= nil and v149.assets ~= nil then
							for _, v151 in v149.assets do
								for v152 in v151 do
									if not t5[v152] then
										t5[v152] = true
										v68(FetchAssetOrBundleInfo(v72, v73, v152, Constants2.ItemType.Asset, true))
									end
								end
							end
						end
					end
				end)
				local t6 = {}

				if v139 and typeof(v139.andThen) == "function" then
					table.insert(t6, v139)
				end

				if v141 and typeof(v141.andThen) == "function" then
					table.insert(t6, v141)
				elseif v140 and typeof(v140.andThen) == "function" then
					table.insert(t6, v140)
				end

				if #t6 > 0 then
					Promise.all(t6)
				end
			end)
		end

		React.useEffect(function() -- line: 526
			-- upvalues: v114 (copy)
			return function() -- line: 527
				-- upvalues: v114 (copy)
				if v114.current ~= nil then
					v114.current:disconnect()
					v114.current = nil
				end
			end
		end, {})
	end

	return {
		fetchMoreOutfits = v101,
		gridMetrics = v96,
		hasItemFromCurrentPageEquipped = hasItemEquipped,
		isSceneFullView = v93,
		isUIFullView = v94,
		itemIds = v98,
		itemIdsToIsWearing = itemIdsToIsWearing,
		onAbsoluteSizeChanged = v97,
		onScrollingFrameThresholdReached = v102,
		shouldRenderSettingsTile = shouldRenderSettingsTile,
		impressionsTag = v106,
		analyticsMetadata = v104,
		requestImpressionsSignal = v107,
		impressionsPageFilter = v108,
		onCanvasPositionChanged = v109,
		searchUuid = t1.outfitKey,
		showLoadMoreButton = v89,
		outfitType = if not FFlagAXFixEmptyMakeupLooks and not FFlagAXOutfitPageRevamp then nil else t1.outfitType,
		recommendedItemsRef = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v110,
		tagBasedImpressionsDetectorExtensions = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v111
	}
end

return useOutfitSwitcherFrameProps
