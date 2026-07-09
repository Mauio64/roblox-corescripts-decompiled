local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Foundation = require(CorePackages.Packages.Foundation)
local GridMetrics = require(CorePackages.Packages.UIBlox).App.Grid.GridMetrics
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local Signal = AppCommonLib.Signal
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Constants = require(Modules.LuaApp.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local FullView = AvatarExperienceCommon.Enums.FullView
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local getEmotesCategory = require(Modules.AvatarExperience.Common.getEmotesCategory)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local GetUserInventoryV2 = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventoryV2)
local SetSelectedEmoteSlot = require(Modules.AvatarExperience.AvatarEditor.Actions.SetSelectedEmoteSlot)
local SendShopForMoreAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendShopForMoreAnalytics)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v34 = getEmotesCategory()
local SearchUuid = v34.SearchUuid

local function selectPageFinished(p1) -- line: 46
	return p1.AvatarExperience.AvatarEditor.PageFinished
end
local function selectOwnedItemIds(p2) -- line: 50
	-- upvalues: v34 (copy)
	return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v34.SearchUuid] or {}
end
local function selectScreenSize(p3) -- line: 55
	return p3.ScreenSize
end
local function selectAvatarType(p4) -- line: 59
	return p4.AvatarExperience.AvatarEditor.Character.AvatarType
end
local function selectAnalyticsMetadata(p5) -- line: 63
	return p5.AvatarExperience.AnalyticsMetadata
end
local function selectFetchStatus(p6) -- line: 67
	-- upvalues: PerformFetch (copy), SearchUuid (copy)
	return PerformFetch.GetStatus(p6, SearchUuid)
end
local function useEditEmotesPageProps() -- line: 97
	-- upvalues: useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), Foundation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), Responsive (copy), useAppPolicy (copy), useSelector (copy), selectScreenSize (copy), selectPageFinished (copy), selectIsFullView (copy), selectOwnedItemIds (copy), selectAvatarType (copy), selectFetchStatus (copy), SearchUuid (copy), RetrievalStatus (copy), React (copy), Constants2 (copy), FullView (copy), GridMetrics (copy), AvatarScreen (copy), SetSelectedEmoteSlot (copy), GetUserInventoryV2 (copy), v34 (copy), ClearTryOns (copy), selectAnalyticsMetadata (copy), Constants (copy), Signal (copy), SendShopForMoreAnalytics (copy)
	local v49 = useDispatch()
	local v50 = useNavigation()
	local v51 = useAvatarRoute()
	local v52 = useRoactService(RoactNetworking)
	local v53 = useRoactService(Analytics)
	local v54 = Foundation.Hooks.useTokens()
	local v55 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
	local v56 = Responsive.usePreferredInput()
	local v57 = useAppPolicy(function(p7) -- line: 107
		return p7.getEnableContinuousLoad()
	end)
	local v58 = useSelector(selectScreenSize)
	local v59 = useSelector(selectPageFinished)
	local v60 = useSelector(function(p8) -- line: 113
		-- upvalues: selectIsFullView (copy), v51 (copy)
		return selectIsFullView(p8, v51.opaque.name)
	end)
	local v61 = useSelector(selectOwnedItemIds)
	local v62 = useSelector(selectAvatarType)
	local v63 = useSelector(selectFetchStatus)
	local v64 = not v59[SearchUuid]
	local v65 = not v57 and (v64 and v63 ~= RetrievalStatus.Fetching)
	local v66, v67 = React.useState(v58.X * Constants2.LandscapeNavWidth)
	local v68 = v60 == FullView.SceneFullView
	local v69 = v60 == FullView.UIFullView
	local v70 = React.useMemo(function() -- line: 132
		-- upvalues: GridMetrics (copy), v66 (copy), v54 (copy)
		return GridMetrics.getSmallMetrics(math.max(v66 - v54.Size.Size_400 * 2, 0), v54.Size.Size_300)
	end, {
		v66,
		v54
	})
	local v71 = React.useCallback(function(p9) -- line: 136
		-- upvalues: v67 (copy)
		v67(p9.AbsoluteSize.X)
	end, {})
	local v72 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useCallback(function() -- line: 142
		-- upvalues: v56 (copy), Responsive (copy), v55 (copy)
		if v56 == Responsive.Input.Directional then
			v55.captureFocus()
		end
	end, {
		v56,
		v55
	}) else nil
	local v73 = React.useCallback(function(n1: number) -- line: 148
		-- upvalues: v62 (copy), Constants2 (copy), v50 (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v72 (copy), v49 (copy), SetSelectedEmoteSlot (copy)
		if v62 == Constants2.AvatarType.R6 then
			v50.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt",
				onOverlayClosed = if not FFlagAXMigrateAXToGlobalAutofocus then v72 else nil
			})
		end

		v49(SetSelectedEmoteSlot(n1))
	end, {
		v49,
		v62,
		v50,
		v72
	})
	local v74 = React.useCallback(function() -- line: 158
		-- upvalues: v64 (copy), v63 (copy), RetrievalStatus (copy), v49 (copy), GetUserInventoryV2 (copy), v52 (copy), v34 (copy), SearchUuid (copy)
		if v64 and v63 ~= RetrievalStatus.Fetching then
			v49(GetUserInventoryV2(v52, v34, SearchUuid))
		end
	end, {
		v49,
		v64,
		v52,
		v63
	})
	local v75 = React.useCallback(function() -- line: 164
		-- upvalues: v57 (copy), v74 (copy)
		if v57 then
			v74()
		end
	end, {
		v57,
		v74
	})
	local v76 = React.useCallback(function() -- line: 170
		-- upvalues: v50 (copy)
		v50.pop()
	end, { v50 })

	React.useEffect(function() -- line: 175
		-- upvalues: v74 (copy)
		v74()
	end, {})
	React.useEffect(function() -- line: 180
		-- upvalues: v49 (copy), ClearTryOns (copy)
		return function() -- line: 181
			-- upvalues: v49 (copy), ClearTryOns (copy)
			v49(ClearTryOns())
		end
	end, {})

	local v77 = useSelector(selectAnalyticsMetadata)
	local key = v51.current.key
	local v79 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v80 = React.useMemo(function() -- line: 193
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v81 = React.useCallback(function() -- line: 197
		-- upvalues: key (copy), v50 (copy)
		return key == v50.state.key
	end, {
		key,
		v50.state.key
	})
	local v82 = React.useCallback(function() -- line: 201
		-- upvalues: v80 (copy)
		v80:fire()
	end, { v80 })
	local v83 = React.useCallback(function() -- line: 205
		-- upvalues: v49 (copy), SendShopForMoreAnalytics (copy), v53 (copy)
		v49(SendShopForMoreAnalytics(v53))
	end, {
		v49,
		v53
	})

	return {
		fetchMoreItems = v74,
		gridMetrics = v70,
		isSceneFullView = v68,
		isUIFullView = v69,
		itemIds = v61,
		onAbsoluteSizeChanged = v71,
		onBackButtonPressed = v76,
		onScrollingFrameThresholdReached = v75,
		onSlotActivated = v73,
		impressionsTag = v79,
		analyticsMetadata = v77,
		requestImpressionsSignal = v80,
		impressionsPageFilter = v81,
		onCanvasPositionChanged = v82,
		searchUuid = SearchUuid,
		emotesCategory = v34,
		showLoadMoreButton = v65,
		showRecommendedItems = not v64,
		sendShopForMoreAnalytics = v83
	}
end

return useEditEmotesPageProps
