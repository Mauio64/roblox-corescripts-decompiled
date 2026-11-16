local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local gridMetrics = UIBlox.App.Grid.GridMetrics
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module5 = require("@luauforge/bundled/eeH")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module7 = require("@luauforge/deferred/gVq")

local signal = AppCommonLib.Signal
local module8 = require("@luauforge/bundled/dxy")
local module9 = require("@luauforge/bundled/dwA")
local module10 = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module11 = require("@luauforge/deferred/gVs")
local fullView = AvatarExperienceCommon.Enums.FullView
local module12 = require("@luauforge/bundled/goe")
local module13 = require("@luauforge/bundled/eda")
local module14 = require("@luauforge/bundled/dOo")
local module15 = require("@luauforge/bundled/geT")

local module16 = require("@luauforge/deferred/gOP")
local module17 = require("@luauforge/bundled/dOR")
local module18 = require("@luauforge/deferred/gQA")
local clearTryOns = require("@luauforge/bundled/dHL").Actions.ClearTryOns

local v6 = module14()
local searchUuid = v6.SearchUuid

local function selectPageFinished(p2)
	return p2.AvatarExperience.AvatarEditor.PageFinished
end

local function selectOwnedItemIds(p2)
	return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v6.SearchUuid] or {}
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectAvatarType(p2)
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local function selectAnalyticsMetadata(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function selectFetchStatus(p2)
	return performFetch.GetStatus(p2, searchUuid)
end

local function useEditEmotesPageProps()
	local v7 = useDispatch()
	local v8 = useNavigation()
	local v9 = useAvatarRoute()
	local v10 = module5(module13)
	local v11 = module5(module15)
	local v12 = Foundation.Hooks.useTokens()

	local v13 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local v14 = useSelector(selectScreenSize)
	local v15 = useSelector(selectPageFinished)
	local v16 = useSelector(function(p2)
		return module12(p2, v9.opaque.name)
	end)

	local v17 = useSelector(selectOwnedItemIds)
	local v18 = useSelector(selectAvatarType)
	local v19 = useSelector(selectFetchStatus)
	local v20 = not v15[searchUuid]

	local v21 = not v13 and v20 and v19 ~= module8.Fetching

	local useState = React.useState
	local x = v14.X
	local v23 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth
	local state, setState = useState(x * v23)

	local v24 = v16 == fullView.SceneFullView
	local v25 = v16 == fullView.UIFullView

	local v26 = if module11 then module7() else nil

	local v27 = React.useMemo(function()
		return gridMetrics.getSmallMetrics(math.max(state - v12.Size.Size_400 * 2, 0), v12.Size.Size_300)
	end, { state, v12 })

	local v28 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
	end, {})

	local v29 = React.useCallback(function(p2)
		if v18 == module10.AvatarType.R6 then
			v8.navigate(avatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt"
			})
		end

		v7(module17(p2))
	end, { v7, v18, v8 })

	local v30 = React.useCallback(function()
		if v20 and v19 ~= module8.Fetching then
			v7(module16(v10, v6, searchUuid))
		end
	end, { v7, v20, v10, v19 })

	local v31 = React.useCallback(function()
		if v13 then
			v30()
		end
	end, { v13, v30 })

	local v32 = React.useCallback(function()
		v8.pop()
	end, { v8 })

	React.useEffect(function()
		v30()
	end, {})

	React.useEffect(function()
		return function()
			v7(clearTryOns())
		end
	end, {})

	local v33 = useSelector(selectAnalyticsMetadata)

	local key = v9.current.key
	local v34 = module9.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local v35 = React.useMemo(function()
		return signal.new()
	end, {})

	return {
		exitSceneFullView = v26,
		fetchMoreItems = v30,
		gridMetrics = v27,
		isSceneFullView = v24,
		isUIFullView = v25,
		itemIds = v17,
		onAbsoluteSizeChanged = v28,
		onBackButtonPressed = v32,
		onScrollingFrameThresholdReached = v31,
		onSlotActivated = v29,
		impressionsTag = v34,
		analyticsMetadata = v33,
		requestImpressionsSignal = v35,
		impressionsPageFilter = React.useCallback(function(): boolean
			return key == v8.state.key
		end, { key, v8.state.key }),
		onCanvasPositionChanged = React.useCallback(function()
			v35:fire()
		end, { v35 }),
		searchUuid = searchUuid,
		emotesCategory = v6,
		showLoadMoreButton = v21,
		showRecommendedItems = not v20,
		sendShopForMoreAnalytics = React.useCallback(function()
			v7(module18(v11))
		end, { v7, v11 })
	}
end

return useEditEmotesPageProps
