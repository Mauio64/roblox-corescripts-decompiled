local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local FitFrame = require(CorePackages.Packages.FitFrame)
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local React = require(CorePackages.Packages.React)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Focusable = RoactGamepad.Focusable
local FitFrameVertical = FitFrame.FitFrameVertical
local GridMetrics = UIBlox.App.Grid.GridMetrics
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useRequest = require(Modules.AvatarExperience.Common.Hooks.useRequest)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local withNavigation = RoactNavigation.withNavigation
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local GetUserInventory = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventory)
local Analytics = require(Modules.AvatarExperience.ProfilePictureEditor.Services.Analytics)
local SetEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Thunks.SetEmoteAssetId)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local v43 = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then require(Modules.AvatarExperience.ProfilePictureEditor.Components.PPEEmoteItemTile_DEPRECATED) else require(Modules.AvatarExperience.ProfilePictureEditor.Components.PPEEmoteItemTile)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local RequestStatusEnum = require(Modules.AvatarExperience.Common.Enum.RequestStatusEnum)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v48 = game:DefineFastFlag("AXEmotesScrollView3Grid", false)
local FFlagAXAdaptiveScrollingFixForward = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAdaptiveScrollingFixForward
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local withAdaptiveScrolling = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.withAdaptiveScrolling
local v52 = React.PureComponent:extend("EmotesScrollView")
local t1 = {
	[AvatarScreen.Catalog] = true,
	[AvatarScreen.AvatarEditor] = true
}

v52.validateProps = t.strictInterface({
	bottomBarHeight = t.number,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	baseRef = t.table,
	isFetchingMore = t.boolean,
	loadMoreItems = t.callback,
	profilePictureEditorAnalytics = t.table,
	navigation = t.table,
	items = t.array(t.string),
	screenSize = t.Vector2,
	hasMoreItems = t.boolean,
	emoteAssetId = t.optional(t.string),
	avatarType = t.string,
	setEmoteAssetId = t.callback,
	avatarRoute = AvatarRoute.Interface,
	adaptiveScrolling = t.optional(t.any),
	enableContinuousLoad = t.optional(t.boolean),
	focusGuiObject = t.optional(t.callback)
})

function v52.init(p1) -- line: 135
	-- upvalues: React (copy), Utils2 (copy), RoactGamepad (copy), wasLastInputGamepad (copy)
	p1:setState({
		restorePreviousChildFocus = true,
		loadableGridViewWidth = 0,
		totalHeaderHeight = 0
	})
	p1.resultsListRef = React.createRef()

	function p1.absoluteSizeChanged(p2) -- line: 143
		-- upvalues: p1 (copy)
		p1:setState({
			totalHeaderHeight = p2.AbsoluteSize.Y
		})
	end
	function p1.onFocusGained() -- line: 149
		-- upvalues: p1 (copy)
		p1:setState({
			restorePreviousChildFocus = true
		})
	end
	function p1.onLoadableGridViewAbsoluteSizeChanged(p3) -- line: 155
		-- upvalues: p1 (copy)
		if p1.state.loadableGridViewWidth ~= p3.AbsoluteSize.X then
			p1:setState({
				loadableGridViewWidth = p3.AbsoluteSize.X
			})
		end
	end

	local v60, v61, v62 = Utils2.getEmotesCategorySubcategoryAndInfo()

	p1.categoryIndex = v60
	p1.subcategoryIndex = v61
	p1.categoryInfo = v62
	p1.assetTypeKey = p1.categoryInfo.SearchUuid
	p1.loadableGridViewRef = React.createRef()
	p1.recommendedItemsRef = React.createRef()
	p1.emptyStateRef = React.createRef()
	p1.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()
	p1.loadMoreButtonRef = React.createRef()

	function p1.sendShopForMoreAnalytics() -- line: 172
		-- upvalues: p1 (copy)
		p1.props.profilePictureEditorAnalytics.clickShopForMore(p1.categoryIndex, p1.subcategoryIndex)
	end
	function p1.onLoadMoreButtonActivated() -- line: 176
		-- upvalues: wasLastInputGamepad (copy), p1 (copy)
		if wasLastInputGamepad() and (p1.props.focusGuiObject and p1.resultsListRef and p1.resultsListRef.current) then
			p1.props.focusGuiObject(p1.resultsListRef.current)
		end

		p1.props.loadMoreItems()
	end
end
function v52.renderItem(p4, p5, p6) -- line: 187
	-- upvalues: React (copy), v43 (copy)
	if typeof(p5) == "table" then
		p5 = nil
	end

	local v66 = p5 == p4.props.emoteAssetId

	return React.createElement(v43, {
		itemId = p5,
		isSelected = v66,
		titleFontStyle = p6,
		itemDetailsPeekViewRefs = p4.itemDetailsPeekViewRefs,
		resultsListRef = p4.resultsListRef
	})
end
function v52.renderWithProviders(p7, p8, p9, p10) -- line: 203
	-- upvalues: Constants2 (copy), GridMetrics (copy), Constants (copy), v48 (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), React (copy), Focusable (copy), AXRefreshScrollingFrameWithLoadMore (copy), AvatarScreen (copy), FFlagAXAdaptiveScrollingFixForward (copy), FFlagEnableLeftNavOnConsole (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FitFrameVertical (copy), LoadableGridView (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy), LoadingBarWithTheme (copy), RecommendedItems (copy)
	local v71 = p7.props.hasMoreItems and #p7.props.items == 0
	local categoryInfo = p7.categoryInfo
	local v73 = not v71 and p7.props.items or nil
	local ShimmerCardsToDisplay = Constants2.ShimmerCardsToDisplay
	local v75 = v73 and #v73 or ShimmerCardsToDisplay
	local v76 = v75 > 0
	local enableContinuousLoad = p7.props.enableContinuousLoad
	local v78 = p7.props.isFetchingMore or v71
	local v79 = not v78 and p7.props.hasMoreItems
	local v80 = if not v79 or not enableContinuousLoad then nil else p7.props.loadMoreItems
	local v81 = v79 and not enableContinuousLoad
	local bottomBarHeight = p7.props.bottomBarHeight
	local p8Font = p8.Font
	local Theme = p8.Theme
	local Header2Font = p8Font.Header2.Font
	local v86 = p8Font.BaseSize * p8Font.Header2.RelativeSize
	local Header2 = p8Font.Header2
	local v88 = Header2.RelativeSize * p8Font.BaseSize
	local v89 = GridMetrics.makeCustomMetricsGetter(Constants.ItemsGridMetrics)

	if v48 and GetFFlagAXEnableSlotBasedEditor() then
		v89 = GridMetrics.getSmallMetrics
	end

	if v89(p7.state.loadableGridViewWidth, Constants2.LoadableGridViewCellPadding).itemWidth / v88 < Constants2.MinTileWidthToFontHeightRatio then
		Header2 = p8Font.CaptionBody
		v88 = Header2.RelativeSize * p8Font.BaseSize
	end

	local v90 = v88 + p10
	local v91 = Utils.GridItemHeightGetter(Constants2.ItemTileType.AvatarEditorTile, v90)
	local v92 = if not v76 then p7.emptyStateRef else p7.loadableGridViewRef
	local v93 = p9.noItemsLabel:gsub("({itemType})", p9.itemType)
	local v94 = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 2,
		[React.Change.AbsoluteSize] = p7.absoluteSizeChanged
	}, {
		SelectEmoteTextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Header2Font,
			TextColor3 = Theme.TextDefault.Color,
			Text = p9.selectEmote,
			TextSize = v86,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 18),
				PaddingBottom = UDim.new(0, 18)
			})
		})
	})
	local totalHeaderHeight = p7.state.totalHeaderHeight
	local v96 = not p7.state.restorePreviousChildFocus and p7.onFocusGained or nil
	local restorePreviousChildFocus = p7.state.restorePreviousChildFocus
	local key = p7.props.avatarRoute.current.key
	local v99 = key and p7.itemDetailsPeekViewRefs[key]
	local v100 = p7.props.adaptiveScrolling or {}

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		Size = UDim2.new(1, 0, 1, -bottomBarHeight),
		NextSelectionLeft = p7.props.NextSelectionLeft,
		NextSelectionRight = p7.props.NextSelectionRight,
		NextSelectionDown = p7.props.NextSelectionDown,
		NextSelectionUp = p7.props.NextSelectionUp,
		ref = p7.props.baseRef,
		defaultChild = v92,
		restorePreviousChildFocus = p7.state.restorePreviousChildFocus
	}, {
		EmoteLabels = v94,
		RefreshScrollingFrameWithLoadMore = if totalHeaderHeight ~= 0 then React.createElement(AXRefreshScrollingFrameWithLoadMore, {
			BackgroundTransparency = 1,
			createEndOfScrollElement = false,
			Position = UDim2.fromOffset(0, totalHeaderHeight),
			Size = UDim2.new(1, 0, 1, -totalHeaderHeight),
			parentAppPage = AvatarScreen.ProfilePictureEditorEmotes,
			ScrollingEnabled = if not v100.scrollingEnabledBinding then FFlagAXAdaptiveScrollingFixForward and true or v100.scrollingEnabled else v100.scrollingEnabledBinding:map(function(p11) -- line: 315
				return p11
			end),
			shouldExtendIntoSafeArea = if not FFlagEnableLeftNavOnConsole then nil else {
				bottom = true
			},
			onCanvasPositionChanged = function(p12) -- line: 328
				-- upvalues: v100 (copy)
				local CanvasPositionY = p12.CanvasPosition.Y

				if v100.onCanvasYChanged then
					v100.onCanvasYChanged(CanvasPositionY)
				end
			end,
			onThresholdReached = v80
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p8.Tokens.Global.Space_300 else p8.Tokens.Size.Size_600)
			}),
			ListWrapper = v76 and React.createElement(Focusable[FitFrameVertical], {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				margin = {
					top = 0,
					bottom = Constants.ItemsGridBottomPadding,
					left = Constants.ItemsGridSidePadding / 2,
					right = Constants.ItemsGridSidePadding / 2
				},
				NextSelectionDown = if not v81 then p7.recommendedItemsRef else p7.loadMoreButtonRef,
				ref = p7.loadableGridViewRef
			}, {
				LoadableGridView = React.createElement(LoadableGridView, {
					getItemMetrics = if not v48 then GridMetrics.makeCustomMetricsGetter(Constants.ItemsGridMetrics) else v89,
					items = v73,
					totalNumItems = v75,
					renderItem = function(p13) -- line: 377
						-- upvalues: p7 (copy), Header2 (ref)
						return p7:renderItem(p13, Header2)
					end,
					getItemHeight = v91,
					windowHeight = p7.props.screenSize.Y,
					onAbsoluteSizeChanged = p7.onLoadableGridViewAbsoluteSizeChanged,
					onFocusGained = v96,
					restorePreviousChildFocus = restorePreviousChildFocus,
					NextSelectionRight = v99,
					ref = p7.resultsListRef
				})
			}),
			NoEmotesLabel = not v76 and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 48),
				Font = Header2Font,
				TextColor3 = Theme.TextDefault.Color,
				Text = v93,
				TextSize = v86,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			LoadMoreButtonFrame = v81 and React.createElement(Focusable[FitFrameVertical], {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				ref = p7.loadMoreButtonRef,
				NextSelectionUp = p7.loadableGridViewRef,
				NextSelectionDown = p7.recommendedItemsRef,
				width = UDim.new(1, 0),
				margin = {
					top = 0,
					bottom = Constants.ItemsGridBottomPadding,
					left = Constants.ItemsGridSidePadding / 2,
					right = Constants.ItemsGridSidePadding / 2
				},
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}, {
				LoadMoreButton = React.createElement(Button, {
					onActivated = p7.onLoadMoreButtonActivated,
					text = p9.loadMore,
					standardSize = StandardButtonSize.Regular,
					buttonType = ButtonType.Secondary,
					size = UDim2.fromScale(1, 1),
					anchorPoint = Vector2.new(0.5, 0.5),
					position = UDim2.fromScale(0.5, 0.5)
				})
			}),
			LoadingBar = if not v78 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then p8.Tokens.Global.Size_700 else p8.Tokens.Size.Size_1400)
			}, {
				LoadingBar = React.createElement(LoadingBarWithTheme)
			}),
			RecommendedItems = React.createElement(RecommendedItems, {
				LayoutOrder = 5,
				categoryInfo = categoryInfo,
				sendShopForMoreAnalytics = p7.sendShopForMoreAnalytics,
				itemDetailsPeekViewRefs = p7.itemDetailsPeekViewRefs,
				listFrameRef = p7.props.baseRef,
				baseRef = p7.recommendedItemsRef,
				NextSelectionUp = if not v81 then p7.loadableGridViewRef else p7.loadMoreButtonRef,
				NextSelectionDown = p7.props.NextSelectionDown
			})
		}) else nil
	})
end
function v52.render(p14) -- line: 460
	-- upvalues: withTextSizeOffset (copy), withStyle (copy), withLocalization (copy)
	return withTextSizeOffset(function(p15) -- line: 461
		-- upvalues: withStyle (copy), withLocalization (copy), p14 (copy)
		return withStyle(function(p16) -- line: 462
			-- upvalues: withLocalization (copy), p14 (copy), p15 (copy)
			return withLocalization({
				itemType = "Feature.Catalog.Label.Emotes",
				noItemsLabel = "Feature.Avatar.Label.NoItems",
				selectEmote = "Feature.Avatar.Message.SelectEmote",
				loadMore = "Feature.Catalog.Action.LoadMore"
			})(function(p17) -- line: 468
				-- upvalues: p14 (copy), p16 (copy), p15 (copy)
				return p14:renderWithProviders(p16, p17, p15)
			end)
		end)
	end)
end
function v52.didUpdate(p18, p19) -- line: 475
	-- upvalues: AvatarScreen (copy), t1 (copy)
	local name = p18.props.avatarRoute.current.name
	local name2 = p19.avatarRoute.current.name

	if name == AvatarScreen.ProfilePictureEditorEmotes then
		if not p18.state.restorePreviousChildFocus then
			p18:setState({
				restorePreviousChildFocus = true
			})

			return
		end
	elseif t1[name] and name2 == AvatarScreen.ProfilePictureEditorEmotes and p18.state.restorePreviousChildFocus then
		p18:setState({
			restorePreviousChildFocus = false
		})
	end
end
function v52.didMount(p20) -- line: 496
	if p20.props.hasMoreItems then
		p20.props.loadMoreItems()
	end
end

local v54 = withNavigation(RoactServices.connect({
	profilePictureEditorAnalytics = Analytics
})(v52), nil)

local function mapStateToProps(p21, _) -- line: 508
	-- upvalues: Utils2 (copy)
	local _, _, v111 = Utils2.getEmotesCategorySubcategoryAndInfo()

	assert(v111.SearchUuid, "categoryInfo.SearchUuid is not nil: silences type checker")

	local SearchUuid = v111.SearchUuid
	local v113 = p21.AvatarExperience.AvatarEditor.PageFinished[SearchUuid]
	local v114 = p21.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[SearchUuid] or {}
	local emoteAssetId = p21.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	local AvatarType = p21.AvatarExperience.AvatarEditor.Character.AvatarType

	return {
		items = v114,
		screenSize = p21.ScreenSize,
		hasMoreItems = not v113,
		emoteAssetId = emoteAssetId,
		avatarType = AvatarType
	}
end
local function mapDispatchToProps(p23) -- line: 531
	-- upvalues: SetEmoteAssetId (copy)
	return {
		setEmoteAssetId = function(p24, p25) -- line: 533
			-- upvalues: p23 (copy), SetEmoteAssetId (copy)
			return p23(SetEmoteAssetId(p24, p25))
		end
	}
end

local v57 = withAdaptiveScrolling((withAvatarRoute((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v54)))))
local u58 = RoactAppPolicy.connect(function(p26, _) -- line: 545
	return {
		enableContinuousLoad = p26.getEnableContinuousLoad()
	}
end)(v57)

return function(p28) -- line: 551
	-- upvalues: useDispatch (copy), Utils2 (copy), React (copy), GetUserInventory (copy), useRequest (copy), RequestStatusEnum (copy), useFocusGuiObject (copy), u58 (ref), Cryo (copy)
	local v121 = useDispatch()
	local _, _, v124 = Utils2.getEmotesCategorySubcategoryAndInfo()
	local v125 = React.useCallback(function() -- line: 555
		-- upvalues: v121 (copy), GetUserInventory (copy), v124 (copy)
		return v121(GetUserInventory(v124))
	end, { v124 })
	local v126, v127 = useRequest(v125)
	local v128 = v126.status == RequestStatusEnum.Pending
	local v129 = useFocusGuiObject()

	return React.createElement(u58, Cryo.Dictionary.join(p28, {
		loadMoreItems = v127,
		isFetchingMore = v128,
		focusGuiObject = v129
	}))
end
