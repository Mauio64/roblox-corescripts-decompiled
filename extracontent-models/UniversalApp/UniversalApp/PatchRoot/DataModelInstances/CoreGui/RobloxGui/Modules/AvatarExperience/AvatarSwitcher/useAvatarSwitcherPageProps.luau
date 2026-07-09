local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Foundation = require(CorePackages.Packages.Foundation)
local GridMetrics = require(CorePackages.Packages.UIBlox).App.Grid.GridMetrics
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local FFlagAEGetEditableOutfitsType = require(Modules.AvatarExperience.Flags.FFlagAEGetEditableOutfitsType)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local Signal = AppCommonLib.Signal
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Constants = require(Modules.LuaApp.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local FullView = AvatarExperienceCommon.Enums.FullView
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local GetOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfits)
local EditableCharacterKey = Constants2.EditableCharacterKey

local function selectPageFinished(p1) -- line: 36
	return p1.AvatarExperience.AvatarEditor.PageFinished
end
local function selectOwnedItemIdsWearing(p2) -- line: 40
	-- upvalues: EditableCharacterKey (copy), Utils (copy)
	local OutfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	local EquippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AvatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	local BodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local AvatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
	local OwnedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local t1 = {}
	local v43 = false
	local t2 = {}

	if OwnedItemIdsBySubtype then
		local v45 = OwnedItemIdsBySubtype[EditableCharacterKey] or {}

		t2 = table.clone(v45)
	end

	for _, v47 in t2 do
		local v48 = OutfitInfos[v47]

		if v48 then
			local v49 = Utils.isWearingOutfitNoState(v48, AvatarType, BodyColor3s, EquippedAssets, AvatarScales)

			t1[v47] = v49

			if v49 then
				v43 = true
			end
		end
	end

	return {
		ownedItemIds = t2,
		itemIdsToIsWearing = t1,
		hasItemEquipped = v43
	}
end
local function selectScreenSize(p3) -- line: 76
	return p3.ScreenSize
end
local function selectAnalyticsMetadata(p4) -- line: 80
	return p4.AvatarExperience.AnalyticsMetadata
end
local function selectFetchStatus(p5) -- line: 84
	-- upvalues: PerformFetch (copy), EditableCharacterKey (copy)
	return PerformFetch.GetStatus(p5, EditableCharacterKey)
end
local function useAvatarSwitcherPageProps() -- line: 111
	-- upvalues: useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), Foundation (copy), useAppPolicy (copy), useSelector (copy), selectScreenSize (copy), getUseSelectorDeepEquals (copy), selectPageFinished (copy), selectIsFullView (copy), selectOwnedItemIdsWearing (copy), selectFetchStatus (copy), EditableCharacterKey (copy), RetrievalStatus (copy), React (copy), Constants3 (copy), FullView (copy), GridMetrics (copy), GetOutfits (copy), Constants2 (copy), FFlagAEGetEditableOutfitsType (copy), selectAnalyticsMetadata (copy), Constants (copy), Signal (copy)
	local v53 = useDispatch()
	local v54 = useNavigation()
	local v55 = useAvatarRoute()
	local v56 = Foundation.Hooks.useTokens()
	local v57 = useAppPolicy(function(p6) -- line: 117
		return p6.getEnableContinuousLoad()
	end)
	local v58 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v59 = useSelector(selectPageFinished, getUseSelectorDeepEquals())
	local v60 = useSelector(function(p7) -- line: 123
		-- upvalues: selectIsFullView (copy), v55 (copy)
		return selectIsFullView(p7, v55.opaque.name)
	end, getUseSelectorDeepEquals())
	local v61 = useSelector(selectOwnedItemIdsWearing, getUseSelectorDeepEquals())
	local v62 = useSelector(selectFetchStatus, getUseSelectorDeepEquals())
	local itemIdsToIsWearing = v61.itemIdsToIsWearing
	local hasItemEquipped = v61.hasItemEquipped
	local v65 = not v59[EditableCharacterKey]
	local v66 = not v57 and (v65 and v62 ~= RetrievalStatus.Fetching)
	local v67, v68 = React.useState(v58.X * Constants3.LandscapeNavWidth)
	local v69 = v60 == FullView.SceneFullView
	local v70 = v60 == FullView.UIFullView
	local v71 = React.useMemo(function() -- line: 142
		-- upvalues: GridMetrics (copy), v67 (copy), v56 (copy)
		return GridMetrics.getSmallMetrics(math.max(v67 - v56.Size.Size_400 * 2, 0), v56.Size.Size_300)
	end, { v67 })
	local v72 = React.useCallback(function(p8) -- line: 146
		-- upvalues: v68 (copy)
		v68(p8.AbsoluteSize.X)
	end, {})
	local v73 = React.useMemo(function() -- line: 150
		-- upvalues: v61 (copy)
		if not v61.ownedItemIds then
			return {}
		end

		local v87 = table.clone(v61.ownedItemIds)

		table.insert(v87, 1, "AVATAR_SWITCHER_SETTINGS_TILE")

		return v87
	end, { v61.ownedItemIds })
	local v74 = React.useCallback(function(s1: string) -- line: 159
		return s1 == "AVATAR_SWITCHER_SETTINGS_TILE"
	end, {})
	local v75 = React.useCallback(function() -- line: 163
		-- upvalues: v65 (copy), v62 (copy), RetrievalStatus (copy), v53 (copy), GetOutfits (copy), Constants2 (copy), EditableCharacterKey (copy), FFlagAEGetEditableOutfitsType (copy), Constants3 (copy)
		if v65 and v62 ~= RetrievalStatus.Fetching then
			v53(GetOutfits(Constants2.EditableCharacterKey, true, EditableCharacterKey, if not FFlagAEGetEditableOutfitsType then nil else Constants3.OutfitTypes.Avatar))
		end
	end, {
		v53,
		v65,
		v62
	})
	local v76 = React.useCallback(function() -- line: 176
		-- upvalues: v57 (copy), v75 (copy)
		if v57 then
			v75()
		end
	end, {
		v57,
		v75
	})
	local v77 = React.useCallback(function() -- line: 182
		-- upvalues: v54 (copy)
		v54.pop()
	end, { v54 })

	React.useEffect(function() -- line: 187
		-- upvalues: v75 (copy)
		v75()
	end, {})

	local v78 = useSelector(selectAnalyticsMetadata)
	local key = v55.current.key
	local v80 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v81 = React.useMemo(function() -- line: 198
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v82 = React.useCallback(function() -- line: 202
		-- upvalues: key (copy), v54 (copy)
		return key == v54.state.key
	end, {
		key,
		v54.state.key
	})
	local v83 = React.useCallback(function() -- line: 206
		-- upvalues: v81 (copy)
		v81:fire()
	end, { v81 })

	return {
		fetchMoreOutfits = v75,
		gridMetrics = v71,
		hasItemFromCurrentPageEquipped = hasItemEquipped,
		isSceneFullView = v69,
		isUIFullView = v70,
		itemIds = v73,
		itemIdsToIsWearing = itemIdsToIsWearing,
		onAbsoluteSizeChanged = v72,
		onBackButtonPressed = v77,
		onScrollingFrameThresholdReached = v76,
		shouldRenderSettingsTile = v74,
		impressionsTag = v80,
		analyticsMetadata = v78,
		requestImpressionsSignal = v81,
		impressionsPageFilter = v82,
		onCanvasPositionChanged = v83,
		searchUuid = EditableCharacterKey,
		showLoadMoreButton = v66
	}
end

return useAvatarSwitcherPageProps
