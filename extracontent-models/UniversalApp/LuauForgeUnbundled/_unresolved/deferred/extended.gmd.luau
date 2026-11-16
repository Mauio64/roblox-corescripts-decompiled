local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Style.withStyle

local module = require("@luauforge/bundled/dwA")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local peekView = require("@luauforge/bundled/dzD").PeekView
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState

local module2 = require("@luauforge/deferred/glj")
local fFlagAXItemDetailsSdui = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsSdui
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.itemdetails")

local iconsnavigationclose = images["icons/navigation/close"]

local extended = Roact.PureComponent:extend("ItemDetailsPeekView")

function extended:init()
	local binding, v5 = Roact.createBinding(UDim2.new(0, 0, 0, 0))
	self.closeButtonPosition = binding
	self.updateCloseButtonPosition = v5
	local binding2, v6 = Roact.createBinding(false)
	self.closeButtonVisible = binding2
	self.updateCloseButtonVisible = v6

	local v7 = self.props.navigation.state.routeName == avatarScreen.TryOnItem

	local binding3, v8 = Roact.createBinding(v7)
	self.topBarNavVisible = binding3
	self.updateTopBarNavVisible = v8

	local v9 = self.props.mountAsFullView and 1 or 0

	local binding4, v10 = Roact.createBinding(v9)
	self.briefViewPercentBinding = binding4
	self.updateBriefViewPercentBinding = v10

	self.desktopScrollingEnabledBinding = self.briefViewPercentBinding:map(function(p2): boolean
		return p2 == 1
	end)

	function self.peekViewStateChanged(p2, p3)
		logger:debug("peekViewStateChanged: {} -> {}", p3, p2)

		self:setState({})

		local analytics = self.props.analytics
		local routeName = self.props.navigation.state.routeName

		local itemId = self.props.itemId
		local itemType = self.props.itemType

		if p2 == peekViewState.Closed or p2 == peekViewState.Hidden then
			if routeName == avatarScreen.TryOnItem then
				self.props.closeFocusedScreen(self.props.navigation)
			else
				self.props.closeAllPeekViews(self.props.navigation)
			end

			analytics.closeItemDetailPage(itemId, itemType)
		elseif p2 == peekViewState.Full then
			analytics.expandItemDetailPage(itemId, itemType)
		end

		self.props.setPeekViewState(p2)
	end

	function self.briefToFullTransitionPercent(p2)
		if self.props.navigation.state.routeName ~= avatarScreen.TryOnItem then
			if p2 > 0.8 then
				self.updateTopBarNavVisible(true)
			else
				self.updateTopBarNavVisible(false)
			end

			if p2 > 0.95 then
				self.updateCloseButtonVisible(false)
			else
				self.updateCloseButtonVisible(true)
			end
		end

		self.updateBriefViewPercentBinding(p2)
	end

	function self.peekHeaderPositionYChange(p2)
		local v11 = -(math.floor(p2 + 0.5) + 18 + 4)
		self.updateCloseButtonPosition(UDim2.new(0, 15, 1, v11))
	end
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWith(p2)
	end)
end

function extended:renderWith(p2)
	local theme = p2.Theme
	local v5 = self.props.lastInputGroup == module.InputType.MouseAndKeyboard
	local isTryOnPage = self.props.isTryOnPage

	local viewPosition = self.props.viewPosition
	local viewSize = self.props.viewSize

	local briefViewHeight = self.props.briefViewHeight

	local showDropShadow = self.props.showDropShadow

	local mountAnimation = self.props.mountAnimation
	local mountAsFullView = self.props.mountAsFullView
	local topBarHeight = self.props.topBarHeight
	local fromProfile = self.props.fromProfile
	local peekViewFullViewEnabled = self.props.peekViewFullViewEnabled
	local peekViewState2 = self.props.peekViewState

	local udim = UDim2.fromOffset(0, topBarHeight - (fromProfile and 6 or 0))

	local renderContent = self.props.renderContent
	local renderTopBar = self.props.renderTopBar
	local renderBottomBar = self.props.renderBottomBar

	local v6 = peekViewState2 == peekViewState.Full
		or peekViewState2 == peekViewState.Extended
		or (v5 or isTryOnPage)

	local desktopScrollingEnabledBinding = self.desktopScrollingEnabledBinding

	local never = if not peekViewFullViewEnabled then Enum.ElasticBehavior.Never else nil

	local mapped = self.briefViewPercentBinding:map(function(p3)
		return 1 - (1 - theme.Overlay.Transparency) * p3
	end)

	local createElement = Roact.createElement

	local v9 = {
		Overlay = Roact.createElement("Frame", {
			BackgroundTransparency = isTryOnPage and 1 or mapped,
			BackgroundColor3 = theme.Overlay.Color,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1
		}),
		TopBar = 0,
		CloseButton = 0,
		PeekViewContainer = 0
	}

	local v10 = if v6 then renderTopBar() else nil
	v9.TopBar = v10

	local v11 = v5 and not isTryOnPage

	if v11 then
		v11 = Roact.createElement(imageSetButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = self.closeButtonPosition,
			Size = UDim2.new(0, 36, 0, 36),
			Image = iconsnavigationclose,
			ImageColor3 = theme.SystemPrimaryDefault.Color,
			Visible = self.closeButtonVisible,
			[Roact.Event.Activated] = self.props.closeBriefView
		})
	end

	v9.CloseButton = v11

	local createElement2 = Roact.createElement
	local v13 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = udim,
		Size = UDim2.new(1, 0, 1, -udim.Y.Offset),
		ZIndex = 2
	}

	local createElement3 = Roact.createElement
	local v16 = {
		briefViewContentHeight = UDim.new(0, briefViewHeight),
		viewStateChanged = self.peekViewStateChanged,
		mountAnimation = mountAnimation,
		mountAsFullView = mountAsFullView,
		canDragFullViewToBrief = not fromProfile,
		showDraggerInClosedState = false,
		returnToFullView = true,
		thumbstickScrollEnabled = true,
		shouldCaptureFocus = false,
		bottomDockedContainerHeight = briefViewHeight,
		bottomDockedContainerContent = { ActionBarContainer = renderBottomBar() },
		showDropShadow = showDropShadow,
		elasticBehavior = never,
		backgroundColor3 = theme.BackgroundDefault.Color,
		backgroundTransparency = theme.BackgroundUIDefault.Transparency,
		briefToFullTransitionPercent = self.briefToFullTransitionPercent,
		peekHeaderClose = fromProfile or false,
		peekHeaderPositionYChange = self.peekHeaderPositionYChange,
		isScrollingEnabled = 0,
		contentFrameRef = 0,
		scrollingFrameRef = 0,
		peekViewState = 0,
		customBackground = 0
	}

	local v17 = if module2() then self.props.scrollingEnabled and (not v5 or desktopScrollingEnabledBinding) else not v5 or desktopScrollingEnabledBinding
	v16.isScrollingEnabled = v17

	v16.contentFrameRef = self.props.contentFrameRef
	local v18 = if fFlagAXItemDetailsSdui then self.props.scrollingFrameRef else nil
	v16.scrollingFrameRef = v18
	v16.peekViewState = peekViewState2
	v16.customBackground = theme.BackgroundDefault.Color
	v9.PeekViewContainer = createElement2("Frame", v13, {
		PeekView = createElement3(peekView, v16, { ItemDetails = renderContent() })
	})
	return createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = viewSize,
			Position = viewPosition
		},
		v9
	)
end

local function isPeekViewExpanded(p2): boolean
	local peekViewState2 = p2.peekViewState
	return peekViewState2 == peekViewState.Full or peekViewState2 == peekViewState.Extended
end

function extended.didUpdate(p2, p3, p4)
	local name = p2.props.avatarRoute.current.name

	if p2.props.peekViewShowing then
		local peekViewState2 = p2.props.peekViewState
		local v5 = peekViewState2 == peekViewState.Full or peekViewState2 == peekViewState.Extended

		if p2.props.itemDetailsExpanded ~= v5 then
			p2.props.setItemDetailsExpanded(v5)
		end
	elseif p3.peekViewShowing and name ~= avatarScreen.ItemDetails and p2.props.itemDetailsExpanded then
		p2.props.setItemDetailsExpanded(false)
	end
end

function extended.didMount(p2)
	if not p2.props.mountAnimation then
		p2.peekHeaderPositionYChange(p2.props.briefViewHeight + 25)
	end

	if p2.props.peekViewShowing then
		local peekViewState2 = p2.props.peekViewState
		local v5 = peekViewState2 == peekViewState.Full or peekViewState2 == peekViewState.Extended

		if p2.props.itemDetailsExpanded ~= v5 then
			p2.props.setItemDetailsExpanded(v5)
		end
	end
end

function extended.willUnmount(p2)
	if p2.props.peekViewShowing and p2.props.itemDetailsExpanded then
		p2.props.setItemDetailsExpanded(false)
	end
end

return extended
