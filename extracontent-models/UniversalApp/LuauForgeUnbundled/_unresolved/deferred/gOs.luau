local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/goe")
local fullView = AvatarExperienceCommon.Enums.FullView

local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module3 = require("@luauforge/bundled/geT")

local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/fsK")
local module6 = require("@luauforge/bundled/dOj")
local module7 = require("@luauforge/deferred/gOt")
local module8 = require("@luauforge/deferred/gSu")

local module9 = require("@luauforge/deferred/gSP")
local module10 = require("@luauforge/deferred/gSQ")
local module11 = require("@luauforge/deferred/gft")
local module12 = require("@luauforge/bundled/dxy")
require("@luauforge/bundled/dHK")

local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local module13 = require("@luauforge/deferred/gSy")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module14 = require("@luauforge/bundled/fuD")
local module15 = require("@luauforge/deferred/gSR")
local module16 = require("@luauforge/bundled/gfm")

local module17 = require("@luauforge/bundled/dMB")
local module18 = require("@luauforge/bundled/dOp")

local fFlagAXUseSignalsForBodyColorPickerSettings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForBodyColorPickerSettings
local v5

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v5 = require("@luauforge/bundled/gOv")
else
	v5 = nil
end

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXItemsViewContentSizeBinding = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemsViewContentSizeBinding

local fFlagAXSlotsPeekViewScrollFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsPeekViewScrollFix

local fFlagAXSlotsDesktopRedesign = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsDesktopRedesign

local module19 = require("@luauforge/deferred/gTd")

local extended = Roact.PureComponent:extend("NavigationItemsView")

local set = {
	[avatarScreen.Catalog] = true,
	[avatarScreen.ProfilePictureEditorEmotes] = true
}

extended.defaultProps = { swipeNavigationEnabled = false }

function extended:init()
	self.navBarRef = Roact.createRef()
	self.contentRef = Roact.createRef()

	if fFlagAXItemsViewContentSizeBinding then
		local binding, v6 = Roact.createBinding(UDim2.fromScale(1, 1))
		self.contentSize = binding
		self.updateContentSize = v6
	end

	self.backToTopSignal = signal.new()

	self.lastScrollStartPosition = 0
	self.pivotPosition = 0
	self.scrollingDown = true
	self.changedPage = false

	self:setState({
		restorePreviousChildFocus = true,
		scrollAwayValue = 1,
		lastScrollStartPosition = 0,
		scrollingDown = true,
		pivotPosition = 0
	})

	function self.setCategory(p2)
		local analytics = self.props.analytics
		self.props.setCategoryAndSubcategory(p2, nil, analytics)
		local axAnalytics = self.props.axAnalytics
		local navigation = self.props.navigation
		self.props.exit3DFullView(axAnalytics, navigation.state.routeName)
	end
	function self.setSubcategory(p2)
		local analytics = self.props.analytics
		self.props.setCategoryAndSubcategory(nil, p2, analytics)
		local axAnalytics = self.props.axAnalytics
		local navigation = self.props.navigation
		self.props.exit3DFullView(axAnalytics, navigation.state.routeName)
	end

	function self.navigate(p2)
		if not self.props.swipeNavigationEnabled then
			return
		end

		local v6 = module6()
		local categoryIndex = self.props.categoryIndex
		local subcategoryIndex = self.props.subcategoryIndex

		local subcategories = v6[categoryIndex].Subcategories

		if subcategories and subcategoryIndex ~= 0 then
			local v7 = subcategoryIndex + p2

			if v7 > 0 and v7 <= #subcategories then
				self.setSubcategory(v7)
				return
			end
		end

		local v7 = categoryIndex + p2

		if v7 > 0 and v7 <= #v6 then
			self.setCategory(v7)
		end
	end

	function self.onNavBarSizeChanged(p2)
		if fFlagAXItemsViewContentSizeBinding then
			self.updateContentSize(UDim2.new(1, 0, 1, -p2.Y))
		elseif self.contentRef.current then
			self.contentRef.current.Size = UDim2.new(1, 0, 1, -p2.Y)
		end
	end

	function self.navigateLeft()
		self.navigate(-1)
	end

	function self.navigateRight()
		self.navigate(1)
	end

	self.onInputBegan = fFlagAXSlotsPeekViewScrollFix and function(p2, p3)
		if p3.UserInputState == Enum.UserInputState.Begin then
			self.props.updateDisableScrollView(true)
		end
	end or nil

	self.onInputEnded = fFlagAXSlotsPeekViewScrollFix and function(p2, p3)
		if p3.UserInputState == Enum.UserInputState.End then
			self.props.updateDisableScrollView(false)
		end
	end or nil

	function self.onContentScroll(data)
		if self.changedPage then
			self.lastScrollStartPosition = 0
			self.pivotPosition = 0
			self.scrollingDown = true
			self.changedPage = false
			self:setState({ scrollAwayValue = 1 })
		else
			local lastScrollStartPosition = self.lastScrollStartPosition
			local v6 = self.scrollingDown
			local v7 = self.pivotPosition
			local v8

			if data.CanvasPosition.Y < 0 then
				v8 = 1
			elseif data.CanvasPosition.Y + data.AbsoluteWindowSize.Y > data.AbsoluteCanvasSize.Y then
				v8 = 0
			elseif lastScrollStartPosition - data.CanvasPosition.Y > 0 then
				if not v6 then
					v7 = data.CanvasPosition.Y
					v6 = true
				end

				v8 = math.min(
					math.max(0, 280 * self.state.scrollAwayValue + math.abs(v7 - data.CanvasPosition.Y)) / 280,
					1
				)
			else
				if v6 then
					v7 = data.CanvasPosition.Y
					v6 = false
				end

				v8 = math.min(
					math.max(0, 280 * self.state.scrollAwayValue - math.abs(v7 - data.CanvasPosition.Y)) / 280,
					1
				)
			end

			self.lastScrollStartPosition = data.CanvasPosition.Y
			self.pivotPosition = v7
			self.scrollingDown = v6

			self:setState({ scrollAwayValue = v8 })
		end
	end
end

function extended.render(data)
	local analytics = data.props.analytics
	local axAnalytics = data.props.axAnalytics
	local hasOwnedOrRecommendedAssets = data.props.hasOwnedOrRecommendedAssets
		or data.props.dataStatus == module12.Failed

	local isPortrait = if not fFlagAXSlotsDesktopRedesign then data.props.isPortrait else nil

	return withStyle(function(p2)
		local theme = p2.Theme
		local defaultChildRef = data.props.defaultChildRef
		local navBarRef = data.navBarRef

		local v6 = not fFlagAXSlotsPeekViewScrollFix and 0 or p2.Tokens.Size.Size_1000
		local createElement = Roact.createElement
		local frame = RoactGamepad.Focusable.Frame
		local defaultChildRefsByRef = {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			[Roact.Ref] = defaultChildRef,
			restorePreviousChildFocus = data.state.restorePreviousChildFocus,
			defaultChild = data.navBarRef,
			NextSelectionRight = data.props.NextSelectionRight
		}
		local children

		if fFlagAXSlotsPeekViewScrollFix then
			children = { ContainerFrame = 0, CoverFrame = 0 }
			local createElement2 = React.createElement
			local v8 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

			local children2 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				SlotsContainer = 0,
				NavBar = 0,
				SubNavBar = 0,
				CategoryContent = 0
			}

			local v9 = if fFlagAXSlotsDesktopRedesign and true or isPortrait then React.createElement(module15, {
				slotSubNavigationFill = data.state.scrollAwayValue,
				absoluteSizeChanged = data.onNavBarSizeChanged
			}) else nil
			children2.SlotsContainer = v9

			local v10 = if not (fFlagAXSlotsDesktopRedesign and true or isPortrait) then Roact.createElement(module8, {
				analytics = analytics,
				axAnalytics = axAnalytics,
				layoutOrderMain = 1,
				layoutOrderSub = 2,
				navHeightMain = module4.MainNavHeight,
				navHeightSub = module4.SubNavHeight,
				absoluteSizeChanged = data.onNavBarSizeChanged,
				backToTopSignal = data.backToTopSignal,
				navBarRef = data.navBarRef,
				NextSelectionDown = hasOwnedOrRecommendedAssets and data.contentRef or nil,
				NextSelectionUp = data.props.NextSelectionUp
			}) else nil
			children2.NavBar = v10

			children2.SubNavBar = React.createElement(module19, { LayoutOrder = 3 })

			local createElement3 = Roact.createElement

			local v13 = if fFlagAXItemsViewContentSizeBinding then data.contentSize else UDim2.new(1, 0, 1, 0)
			children2.CategoryContent = createElement3(module7, {
				LayoutOrder = 4,
				Size = v13,
				frameRef = data.contentRef,
				defaultFocusRef = data.props.defaultFocusRef,
				backToTopSignal = data.backToTopSignal,
				onContentScroll = data.onContentScroll,
				navigateLeft = data.navigateLeft,
				navigateRight = data.navigateRight,
				NextSelectionUp = navBarRef,
				restorePreviousChildFocus = data.state.restorePreviousChildFocus
			})
			children.ContainerFrame = createElement2("Frame", v8, children2)
			local v14

			if data.props.peekViewState ~= fullView.SceneFullView then
				v14 = React.createElement("Frame", {
					Position = UDim2.fromOffset(p2.Tokens.Size.Size_100, v6),
					Size = UDim2.new(1, p2.Tokens.Size.Size_100 / 2, 1, -v6 * 2),
					BackgroundTransparency = 1,
					[Roact.Event.InputBegan] = data.onInputBegan,
					[Roact.Event.InputEnded] = data.onInputEnded
				})
			end

			children.CoverFrame = v14
		else
			children = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				SlotsContainer = 0,
				NavBar = 0,
				CategoryContent = 0
			}

			local v7 = if fFlagAXSlotsDesktopRedesign and true or isPortrait then React.createElement(module15, {
				slotSubNavigationFill = data.state.scrollAwayValue,
				absoluteSizeChanged = data.onNavBarSizeChanged
			}) else nil
			children.SlotsContainer = v7

			local v8 = if not (fFlagAXSlotsDesktopRedesign and true or isPortrait) then Roact.createElement(module8, {
				analytics = analytics,
				axAnalytics = axAnalytics,
				layoutOrderMain = 1,
				layoutOrderSub = 2,
				navHeightMain = module4.MainNavHeight,
				navHeightSub = module4.SubNavHeight,
				absoluteSizeChanged = data.onNavBarSizeChanged,
				backToTopSignal = data.backToTopSignal,
				navBarRef = data.navBarRef,
				NextSelectionDown = hasOwnedOrRecommendedAssets and data.contentRef or nil,
				NextSelectionUp = data.props.NextSelectionUp
			}) else nil
			children.NavBar = v8

			local createElement2 = Roact.createElement

			local v11 = if fFlagAXItemsViewContentSizeBinding then data.contentSize else UDim2.new(1, 0, 1, 0)
			children.CategoryContent = createElement2(module7, {
				LayoutOrder = 3,
				Size = v11,
				frameRef = data.contentRef,
				defaultFocusRef = data.props.defaultFocusRef,
				backToTopSignal = data.backToTopSignal,
				onContentScroll = data.onContentScroll,
				navigateLeft = data.navigateLeft,
				navigateRight = data.navigateRight,
				NextSelectionUp = navBarRef,
				restorePreviousChildFocus = data.state.restorePreviousChildFocus
			})
		end

		return createElement(frame, defaultChildRefsByRef, children)
	end)
end

function extended:didUpdate(data)
	if
		module18.isEnabled()
		and self.props.categoryInfo
		and (self.props.categoryInfo.Name == "Style" or self.props.categoryInfo.Name == "HeadAndBody")
		and module17.logExperimentExposure
	then
		module17.logExperimentExposure(module18)
	end

	if
		self.state.scrollAwayValue
		and (data.categoryInfo.Name ~= self.props.categoryInfo.Name or data.bodyColorViewSetting ~= self.props.bodyColorViewSetting)
	then
		self.changedPage = true
		self:setState({ scrollAwayValue = 1 })
	end

	local name = self.props.avatarRoute.current.name
	local name2 = data.avatarRoute.current.name

	if name == avatarScreen.AvatarEditor then
		if not self.state.restorePreviousChildFocus then
			self:setState({ restorePreviousChildFocus = true })
		end
	elseif set[name] and name2 == avatarScreen.AvatarEditor and self.state.restorePreviousChildFocus then
		self:setState({ restorePreviousChildFocus = false })
	end
end

local function mapStateToProps(p2)
	local category = p2.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory
	local viewSetting

	if not fFlagAXUseSignalsForBodyColorPickerSettings then
		viewSetting = p2.AvatarExperience.AvatarEditor.BodyColorPickerSettings.viewSetting
	end

	local v6 = if not fFlagAXSlotsDesktopRedesign then module16(p2) else nil
	local v7 = if module18.isEnabled() then module14.getAvatarEditorCategoryInfoFromState(p2) else nil

	if not module18.isEnabled() then
		v7 = nil
	end

	local v9 = if fFlagAXSlotsPeekViewScrollFix then module2(p2, avatarScreen.AvatarEditor) else nil
	return {
		categoryInfo = v7,
		categoryIndex = category,
		subcategoryIndex = subcategory,
		bodyColorViewSetting = viewSetting,
		peekViewState = v9,
		hasOwnedOrRecommendedAssets = module9(p2),
		dataStatus = module10(p2),
		isPortrait = v6
	}
end

local function mapDispatchToProps(callback)
	return {
		setCategoryAndSubcategory = function(p2, p3, p4)
			callback(module11(p2, p3, p4))
		end,
		exit3DFullView = function(p2, p3)
			callback(module13(p2, p3))
		end
	}
end

local v6 = module5((roactServices.connect({
	analytics = module3,
	axAnalytics = avatarExperienceAnalyticsService
})(extended)))

local v7 = RoactNavigation.withNavigation(v6)

local v8 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v7)

local function NavigationItemsViewWithSignals(p2)
	local v9 = useSignalState(v5(false).getViewSetting)
	return React.createElement(v8, Cryo.Dictionary.union(p2, {
		bodyColorViewSetting = v9
	}))
end

if fFlagAXUseSignalsForBodyColorPickerSettings then
	return React.memo(NavigationItemsViewWithSignals)
end

return v8
