local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
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
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local Signal = AppCommonLib.Signal
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Constants = require(Modules.LuaApp.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local FullView = AvatarExperienceCommon.Enums.FullView
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)
local GetOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfits)
local GetUserInventoryV2 = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventoryV2)
local FFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local EditableCharacterKey = Constants2.EditableCharacterKey

local function selectPageFinished(p1) -- line: 50
	return p1.AvatarExperience.AvatarEditor.PageFinished
end
local function selectOwnedItemIdsWearing(p2) -- line: 54
	-- upvalues: EditableCharacterKey (copy), Utils (copy)
	local OutfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	local EquippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AvatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	local BodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local AvatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
	local OwnedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local t1 = {}
	local v55 = false
	local t2 = {}

	if OwnedItemIdsBySubtype then
		local v57 = OwnedItemIdsBySubtype[EditableCharacterKey] or {}

		t2 = table.clone(v57)
	end

	for _, v59 in t2 do
		local v60 = OutfitInfos[v59]

		if v60 then
			local v61 = Utils.isWearingOutfitNoState(v60, AvatarType, BodyColor3s, EquippedAssets, AvatarScales)

			t1[v59] = v61

			if v61 then
				v55 = true
			end
		end
	end

	return {
		ownedItemIds = t2,
		itemIdsToIsWearing = t1,
		hasItemEquipped = v55
	}
end
local function selectScreenSize(p3) -- line: 90
	return p3.ScreenSize
end
local function selectAnalyticsMetadata(p4) -- line: 94
	return p4.AvatarExperience.AnalyticsMetadata
end
local function selectFetchStatus(p5) -- line: 98
	-- upvalues: PerformFetch (copy), EditableCharacterKey (copy)
	return PerformFetch.GetStatus(p5, EditableCharacterKey)
end
local function shouldRenderSettingsTile(s1: string) -- line: 125
	return s1 == "AVATAR_SWITCHER_SETTINGS_TILE"
end
local function useAvatarSwitcherPageProps() -- line: 132
	-- upvalues: useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), Foundation (copy), FFlagAXInventoryDurablesSupport (copy), useSelector (copy), Utils2 (copy), FFlagAXAvatarEditorStoresContext (copy), useAvatarEditorStores (copy), useSlotBasedEditorContext (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), useNetworking (copy), useAppPolicy (copy), selectScreenSize (copy), getUseSelectorDeepEquals (copy), selectPageFinished (copy), selectIsFullView (copy), selectOwnedItemIdsWearing (copy), selectFetchStatus (copy), EditableCharacterKey (copy), RetrievalStatus (copy), React (copy), Constants3 (copy), FullView (copy), GridMetrics (copy), GetOutfits (copy), Constants2 (copy), FFlagAEGetEditableOutfitsType (copy), GetUserInventoryV2 (copy), selectAnalyticsMetadata (copy), Constants (copy), Signal (copy), shouldRenderSettingsTile (copy)
	local v66 = useDispatch()
	local v67 = useNavigation()
	local v68 = useAvatarRoute()
	local v69 = Foundation.Hooks.useTokens()
	local v70 = if not FFlagAXInventoryDurablesSupport then nil else useSelector(Utils2.getAvatarEditorCategoryInfoFromState)
	local v71 = nil
	local v72 = nil

	if FFlagAXInventoryDurablesSupport then
		if FFlagAXAvatarEditorStoresContext then
			v71 = useAvatarEditorStores()
		else
			v72 = useSlotBasedEditorContext()
		end
	end

	local v73 = if not FFlagAXInventoryDurablesSupport or not v70 then nil else if not FFlagAXAvatarEditorStoresContext then v72.categoryInventoryStores[v70.NavigationKey] else v71.categoryInventoryStores[v70.NavigationKey]
	local u74 = nil

	if FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables then
		u74 = useNetworking()
	end

	local v75 = useAppPolicy(function(p6) -- line: 161
		return p6.getEnableContinuousLoad()
	end)
	local v76 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v77 = useSelector(selectPageFinished, getUseSelectorDeepEquals())
	local v78 = useSelector(function(p7) -- line: 167
		-- upvalues: selectIsFullView (copy), v68 (copy)
		return selectIsFullView(p7, v68.opaque.name)
	end, getUseSelectorDeepEquals())
	local v79 = useSelector(selectOwnedItemIdsWearing, getUseSelectorDeepEquals())
	local v80 = useSelector(selectFetchStatus, getUseSelectorDeepEquals())
	local itemIdsToIsWearing = v79.itemIdsToIsWearing
	local hasItemEquipped = v79.hasItemEquipped
	local v83 = not v77[EditableCharacterKey]
	local v84 = not v75 and (v83 and v80 ~= RetrievalStatus.Fetching)
	local v85, v86 = React.useState(v76.X * Constants3.LandscapeNavWidth)
	local v87 = math.max(0, v85 - v69.Gap.Small * 2)
	local v88 = v78 == FullView.SceneFullView
	local v89 = v78 == FullView.UIFullView
	local XLarge = v69.Gap.XLarge
	local v91 = React.useMemo(function() -- line: 189
		-- upvalues: GridMetrics (copy), v87 (copy), XLarge (copy)
		local v104 = GridMetrics.getMetricsForFixedColumns(math.max(v87, 0), XLarge, 4)
		local v105 = GridMetrics.getMediumMetrics(math.max(v87, 0), XLarge)

		if v104.itemsPerRow > v105.itemsPerRow then
			v105 = v104
		end

		return v105
	end, { v85 })
	local v92 = React.useCallback(function(p8) -- line: 201
		-- upvalues: v86 (copy)
		v86(p8.AbsoluteSize.X)
	end, { v86 })
	local v93 = React.useMemo(function() -- line: 205
		-- upvalues: v79 (copy)
		if not v79.ownedItemIds then
			return {}
		end

		local v107 = table.clone(v79.ownedItemIds)

		table.insert(v107, 1, "AVATAR_SWITCHER_SETTINGS_TILE")

		return v107
	end, { v79.ownedItemIds })
	local v94 = React.useCallback(function() -- line: 215
		-- upvalues: v83 (copy), v80 (copy), RetrievalStatus (copy), v66 (copy), GetOutfits (copy), Constants2 (copy), EditableCharacterKey (copy), FFlagAEGetEditableOutfitsType (copy), Constants3 (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), u74 (ref), FFlagAXInventoryDurablesSupport (copy), v73 (copy), GetUserInventoryV2 (copy), v70 (copy)
		if v83 and v80 ~= RetrievalStatus.Fetching then
			v66(GetOutfits(Constants2.EditableCharacterKey, true, EditableCharacterKey, if not FFlagAEGetEditableOutfitsType then nil else Constants3.OutfitTypes.Avatar, if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else u74))

			if FFlagAXInventoryDurablesSupport and u74 and v73 then
				v66(GetUserInventoryV2(u74, v70, nil, v73))
			end
		end
	end, {
		v66,
		v83,
		v80,
		if not FFlagAXInventoryDurablesSupport then nil else u74,
		if not FFlagAXInventoryDurablesSupport then nil else v70,
		if not FFlagAXInventoryDurablesSupport then nil else v73
	})
	local v95 = React.useCallback(function() -- line: 243
		-- upvalues: v75 (copy), v94 (copy)
		if v75 then
			v94()
		end
	end, {
		v75,
		v94
	})

	React.useEffect(function() -- line: 250
		-- upvalues: v94 (copy)
		v94()
	end, { if not FFlagAXInventoryDurablesSupport then nil else v94 })

	local v96 = useSelector(selectAnalyticsMetadata)
	local key = v68.current.key
	local v98 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v99 = React.useMemo(function() -- line: 261
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v100 = React.useCallback(function() -- line: 265
		-- upvalues: key (copy), v67 (copy)
		return key == v67.state.key
	end, {
		key,
		v67.state.key
	})
	local v101 = React.useCallback(function() -- line: 269
		-- upvalues: v99 (copy)
		v99:fire()
	end, { v99 })

	return {
		fetchMoreOutfits = v94,
		gridMetrics = v91,
		hasItemFromCurrentPageEquipped = hasItemEquipped,
		isSceneFullView = v88,
		isUIFullView = v89,
		itemIds = v93,
		itemIdsToIsWearing = itemIdsToIsWearing,
		onAbsoluteSizeChanged = v92,
		onScrollingFrameThresholdReached = v95,
		shouldRenderSettingsTile = shouldRenderSettingsTile,
		impressionsTag = v98,
		analyticsMetadata = v96,
		requestImpressionsSignal = v99,
		impressionsPageFilter = v100,
		onCanvasPositionChanged = v101,
		searchUuid = EditableCharacterKey,
		showLoadMoreButton = v84
	}
end

return useAvatarSwitcherPageProps
