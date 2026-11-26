local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local gridMetrics = UIBlox.App.Grid.GridMetrics
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local fFlagAXBackgroundsOutfitHighlight = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundsOutfitHighlight

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local signal = AppCommonLib.Signal
local module6 = require("@luauforge/bundled/dAB")
local module7 = require("@luauforge/bundled/dzD")
local module8 = require("@luauforge/bundled/dRg")
local module9 = require("@luauforge/bundled/fCI")
local module10 = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local fullView = AvatarExperienceCommon.Enums.FullView
local module11 = require("@luauforge/bundled/gSI")

local module12 = require("@luauforge/bundled/gLD")

local editableCharacterKey = module8.EditableCharacterKey

local function selectPageFinished(p2)
	return p2.AvatarExperience.AvatarEditor.PageFinished
end

local function selectOwnedItemIdsWearing(p2)
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	local bodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
	local ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local v6

	if fFlagAXBackgroundsOutfitHighlight then
		v6 = AvatarExperienceCommon.Backgrounds.selectActiveBackground(p2)
	end

	local wearingOutfitNoStates = {}
	local v7 = false
	local v8

	if ownedItemIdsBySubtype then
		local v9 = ownedItemIdsBySubtype[editableCharacterKey] or {}

		v8 = table.clone(v9)
	else
		v8 = {}
	end

	for k, v9 in v8 do
		local outfitInfo = outfitInfos[v9]

		if not outfitInfo then
			continue
		end

		local wearingOutfitNoState = module9.isWearingOutfitNoState(
			outfitInfo,
			avatarType,
			bodyColor3s,
			equippedAssets,
			avatarScales,
			nil,
			nil,
			v6
		)

		wearingOutfitNoStates[v9] = wearingOutfitNoState

		if wearingOutfitNoState then
			v7 = true
		end
	end

	return {
		ownedItemIds = v8,
		itemIdsToIsWearing = wearingOutfitNoStates,
		hasItemEquipped = v7
	}
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectAnalyticsMetadata(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function selectFetchStatus(p2)
	return performFetch.GetStatus(p2, editableCharacterKey)
end

local function useAvatarSwitcherPageProps()
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = useAvatarRoute()
	local v9 = Foundation.Hooks.useTokens()

	local v10 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local v11 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v12 = useSelector(selectPageFinished, getUseSelectorDeepEquals())
	local v13 = useSelector(function(p2)
		return module11(p2, v8.opaque.name)
	end, getUseSelectorDeepEquals())
	local v14 = useSelector(selectOwnedItemIdsWearing, getUseSelectorDeepEquals())
	local v15 = useSelector(selectFetchStatus, getUseSelectorDeepEquals())
	local itemIdsToIsWearing = v14.itemIdsToIsWearing
	local hasItemEquipped = v14.hasItemEquipped
	local v16 = not v12[editableCharacterKey]

	local v17 = not v10 and v16 and v15 ~= module6.Fetching

	local useState = React.useState
	local x = v11.X
	local v18 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth
	local state, setState = useState(x * v18)

	local v19 = v13 == fullView.SceneFullView
	local v20 = v13 == fullView.UIFullView

	local v21 = React.useMemo(function()
		return gridMetrics.getSmallMetrics(math.max(state - v9.Size.Size_400 * 2, 0), v9.Size.Size_300)
	end, { state })

	local v22 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
	end, {})

	local v23 = React.useMemo(function()
		if not v14.ownedItemIds then
			return {}
		end

		local clone = table.clone(v14.ownedItemIds)
		table.insert(clone, 1, "AVATAR_SWITCHER_SETTINGS_TILE")
		return clone
	end, { v14.ownedItemIds })

	local v24 = React.useCallback(function(p2): boolean
		return p2 == "AVATAR_SWITCHER_SETTINGS_TILE"
	end, {})

	local v25 = React.useCallback(function()
		if v16 and v15 ~= module6.Fetching then
			v6(module12(
				module8.EditableCharacterKey,
				true,
				editableCharacterKey,
				module10.OutfitTypes.Avatar
			))
		end
	end, { v6, v16, v15 })

	local v26 = React.useCallback(function()
		if v10 then
			v25()
		end
	end, { v10, v25 })

	local v27 = React.useCallback(function()
		v7.pop()
	end, { v7 })

	React.useEffect(function()
		v25()
	end, {})

	local v28 = useSelector(selectAnalyticsMetadata)

	local key = v8.current.key
	local v29 = module7.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local v30 = React.useMemo(function()
		return signal.new()
	end, {})

	return {
		fetchMoreOutfits = v25,
		gridMetrics = v21,
		hasItemFromCurrentPageEquipped = hasItemEquipped,
		isSceneFullView = v19,
		isUIFullView = v20,
		itemIds = v23,
		itemIdsToIsWearing = itemIdsToIsWearing,
		onAbsoluteSizeChanged = v22,
		onBackButtonPressed = v27,
		onScrollingFrameThresholdReached = v26,
		shouldRenderSettingsTile = v24,
		impressionsTag = v29,
		analyticsMetadata = v28,
		requestImpressionsSignal = v30,
		impressionsPageFilter = React.useCallback(function(): boolean
			return key == v7.state.key
		end, { key, v7.state.key }),
		onCanvasPositionChanged = React.useCallback(function()
			v30:fire()
		end, { v30 }),
		searchUuid = editableCharacterKey,
		showLoadMoreButton = v17
	}
end

return useAvatarSwitcherPageProps
