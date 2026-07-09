local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local CategoryContent = require(Modules.AvatarExperience.AvatarEditor.Components.CategoryContent)
local v20 = if not require(Modules.AvatarExperience.Flags.GetFFlagAXMigrateAENavigationToFunctionalReact)() then require(Modules.AvatarExperience.AvatarEditor.Components.Navigation_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.Navigation)
local selectHasOwnedOrRecommendedAssetsData = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectHasOwnedOrRecommendedAssetsData)
local GetDataStatusForCategory = require(Modules.AvatarExperience.AvatarEditor.Selectors.GetDataStatusForCategory)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local SlotsContainer = require(Modules.AvatarExperience.SlotBasedEditor.Components.Slots.SlotsContainer)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXCatalogHeadCategoryCombineIXP = require(Modules.AvatarExperience.Experiments.AXCatalogHeadCategoryCombineIXP)
local FFlagAXItemsViewContentSizeBinding = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXItemsViewContentSizeBinding
local FFlagAXSlotsPeekViewScrollFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsPeekViewScrollFix
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXSlotsDesktopRedesign = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDesktopRedesign
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local SubNavigationBar = require(Modules.AvatarExperience.SlotBasedEditor.Components.SubNavigationBar.SubNavigationBar)
local v41 = Roact.PureComponent:extend("NavigationItemsView")
local t1 = {
	[AvatarScreen.Catalog] = true,
	[AvatarScreen.ProfilePictureEditorEmotes] = true
}

v41.defaultProps = {
	swipeNavigationEnabled = false
}

function v41.init(p1) -- line: 80
	-- upvalues: Roact (copy), FFlagAXItemsViewContentSizeBinding (copy), Signal (copy), FFlagAXRootSlotBasedEditorFlag (copy), GetAvatarEditorCategories (copy), FFlagAXSlotsPeekViewScrollFix (copy)
	p1.navBarRef = Roact.createRef()
	p1.contentRef = Roact.createRef()

	if FFlagAXItemsViewContentSizeBinding then
		local v48, v49 = Roact.createBinding(UDim2.fromScale(1, 1))

		p1.contentSize = v48
		p1.updateContentSize = v49
	end

	p1.backToTopSignal = Signal.new()
	p1.lastScrollStartPosition = 0
	p1.pivotPosition = 0
	p1.scrollingDown = true
	p1.changedPage = not FFlagAXRootSlotBasedEditorFlag and nil
	p1:setState({
		restorePreviousChildFocus = true,
		lastScrollStartPosition = 0,
		scrollingDown = true,
		pivotPosition = 0,
		scrollAwayValue = if not FFlagAXRootSlotBasedEditorFlag then nil else 1
	})

	function p1.setCategory(p2) -- line: 102
		-- upvalues: p1 (copy)
		local analytics = p1.props.analytics

		p1.props.setCategoryAndSubcategory(p2, nil, analytics)

		local axAnalytics = p1.props.axAnalytics
		local navigation = p1.props.navigation

		p1.props.exit3DFullView(axAnalytics, navigation.state.routeName)
	end
	function p1.setSubcategory(p3) -- line: 109
		-- upvalues: p1 (copy)
		local analytics = p1.props.analytics

		p1.props.setCategoryAndSubcategory(nil, p3, analytics)

		local axAnalytics = p1.props.axAnalytics
		local navigation = p1.props.navigation

		p1.props.exit3DFullView(axAnalytics, navigation.state.routeName)
	end
	function p1.navigate(p4) -- line: 117
		-- upvalues: p1 (copy), GetAvatarEditorCategories (copy)
		if not p1.props.swipeNavigationEnabled then
			return
		end

		local v75 = GetAvatarEditorCategories()
		local categoryIndex = p1.props.categoryIndex
		local subcategoryIndex = p1.props.subcategoryIndex
		local Subcategories = v75[categoryIndex].Subcategories

		if Subcategories and subcategoryIndex ~= 0 then
			local v79 = subcategoryIndex + p4

			if v79 > 0 and v79 <= #Subcategories then
				p1.setSubcategory(v79)

				return
			end
		end

		local v80 = categoryIndex + p4

		if v80 > 0 and v80 <= #v75 then
			p1.setCategory(v80)
		end
	end
	function p1.onNavBarSizeChanged(p5) -- line: 143
		-- upvalues: FFlagAXItemsViewContentSizeBinding (copy), p1 (copy)
		if FFlagAXItemsViewContentSizeBinding then
			p1.updateContentSize(UDim2.new(1, 0, 1, -p5.Y))

			return
		end

		if p1.contentRef.current then
			p1.contentRef.current.Size = UDim2.new(1, 0, 1, -p5.Y)
		end
	end
	function p1.navigateLeft() -- line: 151
		-- upvalues: p1 (copy)
		p1.navigate(-1)
	end
	function p1.navigateRight() -- line: 155
		-- upvalues: p1 (copy)
		p1.navigate(1)
	end

	p1.onInputBegan = if not FFlagAXSlotsPeekViewScrollFix then nil else function(_, p7) -- line: 160
		-- upvalues: p1 (copy)
		if p7.UserInputState == Enum.UserInputState.Begin then
			p1.props.updateDisableScrollView(true)
		end
	end
	p1.onInputEnded = if not FFlagAXSlotsPeekViewScrollFix then nil else function(_, p9) -- line: 170
		-- upvalues: p1 (copy)
		if p9.UserInputState == Enum.UserInputState.End then
			p1.props.updateDisableScrollView(false)
		end
	end

	function p1.onContentScroll(p10) -- line: 187
		-- upvalues: p1 (copy)
		if p1.changedPage then
			p1.lastScrollStartPosition = 0
			p1.pivotPosition = 0
			p1.scrollingDown = true
			p1.changedPage = false
			p1:setState({
				scrollAwayValue = 1
			})

			return
		end

		local lastScrollStartPosition = p1.lastScrollStartPosition
		local scrollingDown = p1.scrollingDown
		local pivotPosition = p1.pivotPosition
		local n1

		if p10.CanvasPosition.Y < 0 then
			n1 = 1
		elseif p10.CanvasPosition.Y + p10.AbsoluteWindowSize.Y > p10.AbsoluteCanvasSize.Y then
			n1 = 0
		elseif lastScrollStartPosition - p10.CanvasPosition.Y > 0 then
			if not scrollingDown then
				scrollingDown = true
				pivotPosition = p10.CanvasPosition.Y
			end

			n1 = math.min(math.max(0, 280 * p1.state.scrollAwayValue + math.abs(pivotPosition - p10.CanvasPosition.Y)) / 280, 1)
		else
			if scrollingDown then
				scrollingDown = false
				pivotPosition = p10.CanvasPosition.Y
			end

			n1 = math.min(math.max(0, 280 * p1.state.scrollAwayValue - math.abs(pivotPosition - p10.CanvasPosition.Y)) / 280, 1)
		end

		p1.lastScrollStartPosition = p10.CanvasPosition.Y
		p1.pivotPosition = pivotPosition
		p1.scrollingDown = scrollingDown
		p1:setState({
			scrollAwayValue = n1
		})
	end
end
function v41.render(p11) -- line: 246
	-- upvalues: RetrievalStatus (copy), FFlagAXSlotsDesktopRedesign (copy), FFlagAXRootSlotBasedEditorFlag (copy), withStyle (copy), FFlagAXSlotsPeekViewScrollFix (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), RoactGamepad (copy), React (copy), SlotsContainer (copy), v20 (copy), Constants (copy), FFlagAXCustomizeMakeupSupport (copy), SubNavigationBar (copy), CategoryContent (copy), FFlagAXItemsViewContentSizeBinding (copy), FFlagLuaAppsDefaultSelection (copy), FullView (copy)
	local analytics = p11.props.analytics
	local axAnalytics = p11.props.axAnalytics
	local v53 = p11.props.hasOwnedOrRecommendedAssets or p11.props.dataStatus == RetrievalStatus.Failed
	local v54 = if not FFlagAXSlotsDesktopRedesign then if not FFlagAXRootSlotBasedEditorFlag then nil else p11.props.isPortrait else nil

	return withStyle(function(p12) -- line: 256
		-- upvalues: p11 (copy), FFlagAXSlotsPeekViewScrollFix (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), RoactGamepad (copy), React (copy), FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXSlotsDesktopRedesign (copy), v54 (copy), SlotsContainer (copy), v20 (copy), analytics (copy), axAnalytics (copy), Constants (copy), v53 (copy), FFlagAXCustomizeMakeupSupport (copy), SubNavigationBar (copy), CategoryContent (copy), FFlagAXItemsViewContentSizeBinding (copy), FFlagLuaAppsDefaultSelection (copy), FullView (copy)
		local Theme = p12.Theme
		local defaultChildRef = p11.props.defaultChildRef
		local navBarRef = p11.navBarRef
		local v95 = not FFlagAXSlotsPeekViewScrollFix and 0 or if not FFlagRenameDeprecatedUIBloxTokens then p12.Tokens.Global.Space_500 else p12.Tokens.Size.Size_1000

		return Roact.createElement(RoactGamepad.Focusable.Frame, {
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			[Roact.Ref] = defaultChildRef,
			restorePreviousChildFocus = p11.state.restorePreviousChildFocus,
			defaultChild = p11.navBarRef,
			NextSelectionRight = p11.props.NextSelectionRight
		}, if not FFlagAXSlotsPeekViewScrollFix then {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			SlotsContainer = if not FFlagAXRootSlotBasedEditorFlag or not (not not FFlagAXSlotsDesktopRedesign or v54) then nil else React.createElement(SlotsContainer, {
				slotSubNavigationFill = p11.state.scrollAwayValue,
				absoluteSizeChanged = p11.onNavBarSizeChanged
			}),
			NavBar = if not not (not not FFlagAXSlotsDesktopRedesign or v54) and FFlagAXRootSlotBasedEditorFlag then nil else Roact.createElement(v20, {
				layoutOrderMain = 1,
				layoutOrderSub = 2,
				analytics = analytics,
				axAnalytics = axAnalytics,
				navHeightMain = Constants.MainNavHeight,
				navHeightSub = Constants.SubNavHeight,
				absoluteSizeChanged = p11.onNavBarSizeChanged,
				backToTopSignal = p11.backToTopSignal,
				navBarRef = p11.navBarRef,
				NextSelectionDown = v53 and p11.contentRef or nil,
				NextSelectionUp = p11.props.NextSelectionUp
			}),
			CategoryContent = Roact.createElement(CategoryContent, {
				LayoutOrder = not FFlagAXRootSlotBasedEditorFlag and 2 or 3,
				Size = if not FFlagAXItemsViewContentSizeBinding then UDim2.new(1, 0, 1, 0) else p11.contentSize,
				frameRef = p11.contentRef,
				defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p11.props.defaultFocusRef,
				backToTopSignal = p11.backToTopSignal,
				onContentScroll = if not FFlagAXRootSlotBasedEditorFlag then nil else p11.onContentScroll,
				navigateLeft = p11.navigateLeft,
				navigateRight = p11.navigateRight,
				NextSelectionUp = navBarRef,
				restorePreviousChildFocus = p11.state.restorePreviousChildFocus
			})
		} else {
			ContainerFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				SlotsContainer = if not FFlagAXRootSlotBasedEditorFlag or not (not not FFlagAXSlotsDesktopRedesign or v54) then nil else React.createElement(SlotsContainer, {
					slotSubNavigationFill = p11.state.scrollAwayValue,
					absoluteSizeChanged = p11.onNavBarSizeChanged
				}),
				NavBar = if not not (not not FFlagAXSlotsDesktopRedesign or v54) and FFlagAXRootSlotBasedEditorFlag then nil else Roact.createElement(v20, {
					layoutOrderMain = 1,
					layoutOrderSub = 2,
					analytics = analytics,
					axAnalytics = axAnalytics,
					navHeightMain = Constants.MainNavHeight,
					navHeightSub = Constants.SubNavHeight,
					absoluteSizeChanged = p11.onNavBarSizeChanged,
					backToTopSignal = p11.backToTopSignal,
					navBarRef = p11.navBarRef,
					NextSelectionDown = v53 and p11.contentRef or nil,
					NextSelectionUp = p11.props.NextSelectionUp
				}),
				SubNavBar = if not FFlagAXCustomizeMakeupSupport then nil else React.createElement(SubNavigationBar, {
					LayoutOrder = 3
				}),
				CategoryContent = Roact.createElement(CategoryContent, {
					LayoutOrder = not FFlagAXRootSlotBasedEditorFlag and 2 or (not FFlagAXCustomizeMakeupSupport and 3 or 4),
					Size = if not FFlagAXItemsViewContentSizeBinding then UDim2.new(1, 0, 1, 0) else p11.contentSize,
					frameRef = p11.contentRef,
					defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p11.props.defaultFocusRef,
					backToTopSignal = p11.backToTopSignal,
					onContentScroll = if not FFlagAXRootSlotBasedEditorFlag then nil else p11.onContentScroll,
					navigateLeft = p11.navigateLeft,
					navigateRight = p11.navigateRight,
					NextSelectionUp = navBarRef,
					restorePreviousChildFocus = p11.state.restorePreviousChildFocus
				})
			}),
			CoverFrame = if p11.props.peekViewState == FullView.SceneFullView then nil else React.createElement("Frame", {
				Position = UDim2.fromOffset(if not FFlagRenameDeprecatedUIBloxTokens then p12.Tokens.Global.Size_50 else p12.Tokens.Size.Size_100, v95),
				Size = UDim2.new(1, ((if not FFlagRenameDeprecatedUIBloxTokens then p12.Tokens.Global.Size_50 else p12.Tokens.Size.Size_100)) / 2, 1, -v95 * 2),
				BackgroundTransparency = 1,
				[Roact.Event.InputBegan] = p11.onInputBegan,
				[Roact.Event.InputEnded] = p11.onInputEnded
			})
		})
	end)
end
function v41.didUpdate(p13, p14) -- line: 429
	-- upvalues: AXCatalogHeadCategoryCombineIXP (copy), IxpUtils (copy), FFlagAXRootSlotBasedEditorFlag (copy), AvatarScreen (copy), t1 (copy)
	if AXCatalogHeadCategoryCombineIXP.isEnabled() and p13.props.categoryInfo and ((p13.props.categoryInfo.Name == "Style" or p13.props.categoryInfo.Name == "HeadAndBody") and IxpUtils.logExperimentExposure) then
		IxpUtils.logExperimentExposure(AXCatalogHeadCategoryCombineIXP)
	end

	if FFlagAXRootSlotBasedEditorFlag and p13.state.scrollAwayValue and (p14.categoryInfo.Name ~= p13.props.categoryInfo.Name or p14.bodyColorViewSetting ~= p13.props.bodyColorViewSetting) then
		p13.changedPage = true
		p13:setState({
			scrollAwayValue = 1
		})
	end

	local name = p13.props.avatarRoute.current.name
	local name2 = p14.avatarRoute.current.name

	if name == AvatarScreen.AvatarEditor then
		if not p13.state.restorePreviousChildFocus then
			p13:setState({
				restorePreviousChildFocus = true
			})

			return
		end
	elseif t1[name] and name2 == AvatarScreen.AvatarEditor and p13.state.restorePreviousChildFocus then
		p13:setState({
			restorePreviousChildFocus = false
		})
	end
end

local function mapStateToProps(p15) -- line: 478
	-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXSlotsDesktopRedesign (copy), selectIsPortrait (copy), AXCatalogHeadCategoryCombineIXP (copy), Utils (copy), FFlagAXSlotsPeekViewScrollFix (copy), selectIsFullView (copy), AvatarScreen (copy), selectHasOwnedOrRecommendedAssetsData (copy), GetDataStatusForCategory (copy)
	local category = p15.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p15.AvatarExperience.AvatarEditor.Categories.subcategory
	local v62 = if not FFlagAXRootSlotBasedEditorFlag then nil else p15.AvatarExperience.AvatarEditor.BodyColorPickerSettings.viewSetting
	local v63 = if not FFlagAXSlotsDesktopRedesign then if not FFlagAXRootSlotBasedEditorFlag then nil else selectIsPortrait(p15) else nil
	local v64 = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else Utils.getAvatarEditorCategoryInfoFromState(p15)

	return {
		categoryInfo = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else v64,
		categoryIndex = category,
		subcategoryIndex = subcategory,
		bodyColorViewSetting = if not FFlagAXRootSlotBasedEditorFlag then nil else v62,
		peekViewState = if not FFlagAXSlotsPeekViewScrollFix then nil else selectIsFullView(p15, AvatarScreen.AvatarEditor),
		hasOwnedOrRecommendedAssets = selectHasOwnedOrRecommendedAssetsData(p15),
		dataStatus = GetDataStatusForCategory(p15),
		isPortrait = v63
	}
end
local function mapDispatchToProps(p16) -- line: 506
	-- upvalues: SetCategoryAndSubcategory (copy), Exit3DFullView (copy)
	return {
		setCategoryAndSubcategory = function(p17, p18, p19) -- line: 508
			-- upvalues: p16 (copy), SetCategoryAndSubcategory (copy)
			p16(SetCategoryAndSubcategory(p17, p18, p19))
		end,
		exit3DFullView = function(p20, p21) -- line: 512
			-- upvalues: p16 (copy), Exit3DFullView (copy)
			p16(Exit3DFullView(p20, p21))
		end
	}
end

local v45 = withAvatarRoute((RoactServices.connect({
	analytics = Analytics,
	axAnalytics = Analytics2
})(v41)))
local v46 = RoactNavigation.withNavigation(v45)

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v46)
