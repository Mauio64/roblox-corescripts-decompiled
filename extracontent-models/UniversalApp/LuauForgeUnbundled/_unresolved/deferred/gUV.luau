local CorePackages = game:GetService("CorePackages")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = SharedFlags.FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local fFlagAXScrollTelemetryIntegration2 = SharedFlags.FFlagAXScrollTelemetryIntegration2

local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local FitFrame = require(CorePackages.Packages.FitFrame)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local React = require(CorePackages.Packages.React)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad

require("@luauforge/bundled/dHK")
local module2 = require("@luauforge/deferred/gnq")

local focusable = RoactGamepad.Focusable
local fitFrameVertical = FitFrame.FitFrameVertical

local gridMetrics = UIBlox.App.Grid.GridMetrics
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

local module3 = require("@luauforge/deferred/gnr")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module4 = require("@luauforge/deferred/gnw")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute

local withNavigation = RoactNavigation.withNavigation
local module6 = require("@luauforge/bundled/fuD")
local module7 = require("@luauforge/bundled/fvu")
local module8 = require("@luauforge/bundled/dNQ")
local module9 = require("@luauforge/bundled/dMx")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module11 = require("@luauforge/deferred/gQy")
local module12 = require("@luauforge/deferred/fws")
local module13 = require("@luauforge/deferred/gUW")
local module14 = require("@luauforge/bundled/fsK")
local v5

if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
	v5 = require("@luauforge/deferred/gUX")
else
	v5 = require("@luauforge/deferred/gUZ")
end

local module15 = require("@luauforge/deferred/gPt")
local module16 = require("@luauforge/deferred/gnp")
local module17 = require("@luauforge/bundled/edh")
local module18 = require("@luauforge/bundled/dOc")
local defineFastFlag = game:DefineFastFlag("AXEmotesScrollView3Grid", false)

local fFlagAXAdaptiveScrollingFixForward = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAdaptiveScrollingFixForward

local withAdaptiveScrolling = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.withAdaptiveScrolling

local extended = React.PureComponent:extend("EmotesScrollView")

local set = { [avatarScreen.Catalog] = true, [avatarScreen.AvatarEditor] = true }

extended.validateProps = t.strictInterface({
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
	avatarRoute = avatarRoute.Interface,
	adaptiveScrolling = t.optional(t.any),
	enableContinuousLoad = t.optional(t.boolean),
	focusGuiObject = t.optional(t.callback)
})

function extended:init()
	self:setState({
		restorePreviousChildFocus = true,
		loadableGridViewWidth = 0,
		totalHeaderHeight = 0
	})

	self.resultsListRef = React.createRef()
	function self.absoluteSizeChanged(p2)
		self:setState({ totalHeaderHeight = p2.AbsoluteSize.Y })
	end

	function self.onFocusGained()
		self:setState({ restorePreviousChildFocus = true })
	end

	function self.onLoadableGridViewAbsoluteSizeChanged(p2)
		if self.state.loadableGridViewWidth ~= p2.AbsoluteSize.X then
			self:setState({ loadableGridViewWidth = p2.AbsoluteSize.X })
		end
	end

	local emotesCategorySubcategoryAndInfo, v6, v7 = module7.getEmotesCategorySubcategoryAndInfo()
	self.categoryIndex = emotesCategorySubcategoryAndInfo
	self.subcategoryIndex = v6
	self.categoryInfo = v7
	self.assetTypeKey = self.categoryInfo.SearchUuid

	self.loadableGridViewRef = React.createRef()
	self.recommendedItemsRef = React.createRef()
	self.emptyStateRef = React.createRef()
	self.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()
	self.loadMoreButtonRef = React.createRef()

	function self.sendShopForMoreAnalytics()
		self.props.profilePictureEditorAnalytics.clickShopForMore(self.categoryIndex, self.subcategoryIndex)
	end

	function self.onLoadMoreButtonActivated()
		if
			wasLastInputGamepad()
			and self.props.focusGuiObject
			and self.resultsListRef
			and self.resultsListRef.current
		then
			self.props.focusGuiObject(self.resultsListRef.current)
		end

		self.props.loadMoreItems()
	end
end

function extended.renderItem(props, p2, p3)
	if typeof(p2) == "table" then
		p2 = nil
	end

	local v6 = p2 == props.props.emoteAssetId

	return React.createElement(v5, {
		itemId = p2,
		isSelected = v6,
		titleFontStyle = p3,
		itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
		resultsListRef = props.resultsListRef
	})
end

function extended:renderWithProviders(props2, props3, p2)
	local v6 = self.props.hasMoreItems and #self.props.items == 0
	local categoryInfo = self.categoryInfo

	local items = if not v6 then self.props.items or nil else nil
	local shimmerCardsToDisplay = module9.ShimmerCardsToDisplay
	local v7 = items and (#items or shimmerCardsToDisplay) or shimmerCardsToDisplay
	local v8 = v7 > 0
	local enableContinuousLoad = self.props.enableContinuousLoad
	local isFetchingMore = self.props.isFetchingMore or v6
	local hasMoreItems = not isFetchingMore and self.props.hasMoreItems
	local loadMoreItems = if hasMoreItems and enableContinuousLoad then self.props.loadMoreItems else nil
	local v9 = hasMoreItems and not enableContinuousLoad
	local bottomBarHeight = self.props.bottomBarHeight

	local font = props2.Font
	local theme = props2.Theme
	local font2 = font.Header2.Font
	local v10 = font.BaseSize * font.Header2.RelativeSize

	local v11 = font.Header2
	local v12 = v11.RelativeSize * font.BaseSize

	local v13 = gridMetrics.makeCustomMetricsGetter(module8.ItemsGridMetrics)

	if defineFastFlag and module18() then
		v13 = gridMetrics.getSmallMetrics
	end

	if v13(self.state.loadableGridViewWidth, module9.LoadableGridViewCellPadding).itemWidth / v12 < module9.MinTileWidthToFontHeightRatio then
		v11 = font.CaptionBody
		v12 = v11.RelativeSize * font.BaseSize
	end

	local v14 = v12 + p2

	local gridItemHeightGetter = module6.GridItemHeightGetter(module9.ItemTileType.AvatarEditorTile, v14)

	local v15 = if v8 then self.loadableGridViewRef else self.emptyStateRef

	local v16 = props3.noItemsLabel:gsub("({itemType})", props3.itemType)

	local createElement = React.createElement
	local absoluteSizeChangedsByAbsoluteSize = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 2,
		[React.Change.AbsoluteSize] = self.absoluteSizeChanged
	}

	local createElement2 = React.createElement
	local v20 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = if not foundationFontFaceMigration then font2 else nil,
		FontFace = 0,
		TextColor3 = 0,
		Text = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = true
	}

	local v22 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
	v20.FontFace = v22

	v20.TextColor3 = theme.TextDefault.Color
	v20.Text = props3.selectEmote
	v20.TextSize = v10
	v20.TextXAlignment = Enum.TextXAlignment.Center
	v20.TextYAlignment = Enum.TextYAlignment.Center
	local element = createElement("Frame", absoluteSizeChangedsByAbsoluteSize, {
		SelectEmoteTextLabel = createElement2("TextLabel", v20, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 18),
				PaddingBottom = UDim.new(0, 18)
			})
		})
	})

	local totalHeaderHeight = self.state.totalHeaderHeight

	local onFocusGained = if not self.state.restorePreviousChildFocus then self.onFocusGained or nil else nil
	local restorePreviousChildFocus = self.state.restorePreviousChildFocus
	local key = self.props.avatarRoute.current.key
	local v23 = key and self.itemDetailsPeekViewRefs[key]

	local adaptiveScrolling = self.props.adaptiveScrolling or {}

	local createElement3 = React.createElement
	local frame = focusable.Frame
	local v24 = {
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		Size = UDim2.new(1, 0, 1, -bottomBarHeight),
		BorderSizePixel = 0,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionDown = self.props.NextSelectionDown,
		NextSelectionUp = self.props.NextSelectionUp,
		ref = self.props.baseRef,
		defaultChild = v15,
		restorePreviousChildFocus = self.state.restorePreviousChildFocus
	}
	local v26

	if totalHeaderHeight ~= 0 then
		local createElement4 = React.createElement
		local v28 = {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, totalHeaderHeight),
			Size = UDim2.new(1, 0, 1, -totalHeaderHeight),
			createEndOfScrollElement = false,
			parentAppPage = avatarScreen.ProfilePictureEditorEmotes,
			scrollPerformanceIntervalName = 0,
			ScrollingEnabled = 0,
			shouldExtendIntoSafeArea = 0,
			onCanvasPositionChanged = 0,
			onThresholdReached = 0
		}

		local v29 = if fFlagAXScrollTelemetryIntegration2 then module2.ProfileEmotes else nil
		v28.scrollPerformanceIntervalName = v29
		local v30

		if adaptiveScrolling.scrollingEnabledBinding then
			v30 = adaptiveScrolling.scrollingEnabledBinding:map(function(p3)
				return p3
			end)
		else
			v30 = fFlagAXAdaptiveScrollingFixForward and true or adaptiveScrolling.scrollingEnabled
		end

		v28.ScrollingEnabled = v30

		v28.shouldExtendIntoSafeArea = { bottom = true }

		function v28.onCanvasPositionChanged(p3)
			local y = p3.CanvasPosition.Y

			if adaptiveScrolling.onCanvasYChanged then
				adaptiveScrolling.onCanvasYChanged(y)
			end
		end
		v28.onThresholdReached = loadMoreItems
		local v31 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, props2.Tokens.Size.Size_600)
			}),
			ListWrapper = 0,
			NoEmotesLabel = 0,
			LoadMoreButtonFrame = 0,
			LoadingBar = 0,
			RecommendedItems = 0
		}
		local v32

		if v8 then
			local createElement5 = React.createElement
			local v33 = focusable[fitFrameVertical]
			local v34 = {
				width = UDim.new(1, 0),
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				margin = {
					top = 0,
					bottom = module8.ItemsGridBottomPadding,
					left = module8.ItemsGridSidePadding / 2,
					right = module8.ItemsGridSidePadding / 2
				},
				NextSelectionDown = 0,
				ref = 0
			}

			local v35 = if v9 then self.loadMoreButtonRef else self.recommendedItemsRef
			v34.NextSelectionDown = v35

			v34.ref = self.loadableGridViewRef

			local createElement6 = React.createElement

			if not defineFastFlag then
				v13 = gridMetrics.makeCustomMetricsGetter(module8.ItemsGridMetrics)
			end

			v32 = createElement5(v33, v34, {
				LoadableGridView = createElement6(DefaultMetricsGridView, {
					getItemMetrics = v13,
					items = items,
					totalNumItems = v7,
					renderItem = function(p3)
						return self:renderItem(p3, v11)
					end,
					getItemHeight = gridItemHeightGetter,
					windowHeight = self.props.screenSize.Y,
					onAbsoluteSizeChanged = self.onLoadableGridViewAbsoluteSizeChanged,
					onFocusGained = onFocusGained,
					restorePreviousChildFocus = restorePreviousChildFocus,
					NextSelectionRight = v23,
					ref = self.resultsListRef
				})
			})
		else
			v32 = v8
		end

		v31.ListWrapper = v32

		local v33 = not v8

		if v33 then
			local createElement5 = React.createElement
			local v35 = {
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundTransparency = 1,
				Font = 0,
				FontFace = 0,
				TextColor3 = 0,
				Text = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextYAlignment = 0
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v35.Font = font2

			local v36 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
			v35.FontFace = v36

			v35.TextColor3 = theme.TextDefault.Color
			v35.Text = v16
			v35.TextSize = v10
			v35.TextXAlignment = Enum.TextXAlignment.Center
			v35.TextYAlignment = Enum.TextYAlignment.Center
			v33 = createElement5("TextLabel", v35)
		end

		v31.NoEmotesLabel = v33

		v31.LoadMoreButtonFrame = v9 and React.createElement(focusable[fitFrameVertical], {
			BackgroundTransparency = 1,
			ref = self.loadMoreButtonRef,
			NextSelectionUp = self.loadableGridViewRef,
			NextSelectionDown = self.recommendedItemsRef,
			LayoutOrder = 3,
			width = UDim.new(1, 0),
			margin = {
				top = 0,
				bottom = module8.ItemsGridBottomPadding,
				left = module8.ItemsGridSidePadding / 2,
				right = module8.ItemsGridSidePadding / 2
			},
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}, {
			LoadMoreButton = React.createElement(button, {
				onActivated = self.onLoadMoreButtonActivated,
				text = props3.loadMore,
				standardSize = standardButtonSize.Regular,
				buttonType = buttonType.Secondary,
				size = UDim2.fromScale(1, 1),
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5)
			})
		})

		local v34 = if isFetchingMore then React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, props2.Tokens.Size.Size_1400),
				LayoutOrder = 4
			},
			{ LoadingBar = React.createElement(module17) }
		) else nil
		v31.LoadingBar = v34

		local createElement5 = React.createElement
		local v36 = {
			LayoutOrder = 5,
			categoryInfo = categoryInfo,
			sendShopForMoreAnalytics = self.sendShopForMoreAnalytics,
			itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
			listFrameRef = self.props.baseRef,
			baseRef = self.recommendedItemsRef,
			NextSelectionUp = 0,
			NextSelectionDown = 0
		}
		local v37 = if v9 then self.loadMoreButtonRef else self.loadableGridViewRef
		v36.NextSelectionUp = v37
		v36.NextSelectionDown = self.props.NextSelectionDown
		v31.RecommendedItems = createElement5(module15, v36)
		v26 = createElement4(module4, v28, v31)
	end

	return createElement3(frame, v24, {
		EmoteLabels = element,
		RefreshScrollingFrameWithLoadMore = v26
	})
end

function extended:render()
	return withTextSizeOffset(function(p2)
		return withStyle(function(p3)
			return withLocalization({
				itemType = "Feature.Catalog.Label.Emotes",
				noItemsLabel = "Feature.Avatar.Label.NoItems",
				selectEmote = "Feature.Avatar.Message.SelectEmote",
				loadMore = "Feature.Catalog.Action.LoadMore"
			})(function(p4)
				return self:renderWithProviders(p3, p4, p2)
			end)
		end)
	end)
end

function extended.didUpdate(object, p2)
	local name = object.props.avatarRoute.current.name
	local name2 = p2.avatarRoute.current.name

	if name == avatarScreen.ProfilePictureEditorEmotes then
		if not object.state.restorePreviousChildFocus then
			object:setState({ restorePreviousChildFocus = true })
		end
	elseif
		set[name]
		and name2 == avatarScreen.ProfilePictureEditorEmotes
		and object.state.restorePreviousChildFocus
	then
		object:setState({ restorePreviousChildFocus = false })
	end
end

function extended.didMount(p2)
	if p2.props.hasMoreItems then
		p2.props.loadMoreItems()
	end
end

local v6 = withNavigation(
	roactServices.connect({ profilePictureEditorAnalytics = module12 })(extended),
	nil
)

local function mapStateToProps(p2, p3)
	local emotesCategorySubcategoryAndInfo, v7, v8 = module7.getEmotesCategorySubcategoryAndInfo()
	assert(v8.SearchUuid, "categoryInfo.SearchUuid is not nil: silences type checker")
	local searchUuid = v8.SearchUuid

	local v9 = not p2.AvatarExperience.AvatarEditor.PageFinished[searchUuid]

	local v10 = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[searchUuid] or {}

	local emoteAssetId = p2.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType

	return {
		items = v10,
		screenSize = p2.ScreenSize,
		hasMoreItems = v9,
		emoteAssetId = emoteAssetId,
		avatarType = avatarType
	}
end

local function mapDispatchToProps(callback)
	return {
		setEmoteAssetId = function(p2, p3)
			return callback(module13(p2, p3))
		end
	}
end

local v7 = withAdaptiveScrolling((module14((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v6)))))

local v8 = roactAppPolicy.connect(function(p2, p3)
	return { enableContinuousLoad = p2.getEnableContinuousLoad() }
end)(v7)

return function(p2)
	local v9 = useDispatch()
	local emotesCategorySubcategoryAndInfo, v10, v11 = module7.getEmotesCategorySubcategoryAndInfo()

	local v12, v13 = module3((React.useCallback(function()
		return v9(module11(v11))
	end, { v11 })))
	local v14 = v12.status == module16.Pending

	local v15 = useFocusGuiObject()

	return React.createElement(
		v8,
		Cryo.Dictionary.join(p2, {
			loadMoreItems = v13,
			isFetchingMore = v14,
			focusGuiObject = v15
		})
	)
end
