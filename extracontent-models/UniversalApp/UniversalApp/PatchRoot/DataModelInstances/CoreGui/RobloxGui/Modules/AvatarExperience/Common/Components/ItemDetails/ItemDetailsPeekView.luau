local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local PeekView = require(CorePackages.Workspace.Packages.PeekView).PeekView
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local GetFFlagAXItemDetailsScrollingEnabledCallback = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsScrollingEnabledCallback)
local v14 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.itemdetails")
local v15 = Images["icons/navigation/close"]
local v16 = Roact.PureComponent:extend("ItemDetailsPeekView")

function v16.init(p1) -- line: 44
	-- upvalues: Roact (copy), AvatarScreen (copy), v14 (copy), PeekViewState (copy)
	local v19, v20 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p1.closeButtonPosition = v19
	p1.updateCloseButtonPosition = v20

	local v21, v22 = Roact.createBinding(false)

	p1.closeButtonVisible = v21
	p1.updateCloseButtonVisible = v22

	local v23 = p1.props.navigation.state.routeName == AvatarScreen.TryOnItem
	local v24, v25 = Roact.createBinding(v23)

	p1.topBarNavVisible = v24
	p1.updateTopBarNavVisible = v25

	local v26 = not p1.props.mountAsFullView and 0 or 1
	local v27, v28 = Roact.createBinding(v26)

	p1.briefViewPercentBinding = v27
	p1.updateBriefViewPercentBinding = v28
	p1.desktopScrollingEnabledBinding = p1.briefViewPercentBinding:map(function(p2) -- line: 58
		return p2 == 1
	end)

	function p1.peekViewStateChanged(p3, p4) -- line: 62
		-- upvalues: v14 (copy), p1 (copy), PeekViewState (copy), AvatarScreen (copy)
		v14:debug("peekViewStateChanged: {} -> {}", p4, p3)
		p1:setState({})

		local analytics = p1.props.analytics
		local routeName = p1.props.navigation.state.routeName
		local itemId = p1.props.itemId
		local itemType = p1.props.itemType

		if p3 == PeekViewState.Closed or p3 == PeekViewState.Hidden then
			if routeName == AvatarScreen.TryOnItem then
				p1.props.closeFocusedScreen(p1.props.navigation)
			else
				p1.props.closeAllPeekViews(p1.props.navigation)
			end

			analytics.closeItemDetailPage(itemId, itemType)
		elseif p3 == PeekViewState.Full then
			analytics.expandItemDetailPage(itemId, itemType)
		end

		p1.props.setPeekViewState(p3)
	end
	function p1.briefToFullTransitionPercent(p5) -- line: 87
		-- upvalues: p1 (copy), AvatarScreen (copy)
		if p1.props.navigation.state.routeName ~= AvatarScreen.TryOnItem then
			if p5 > 0.8 then
				p1.updateTopBarNavVisible(true)
			else
				p1.updateTopBarNavVisible(false)
			end

			if p5 > 0.95 then
				p1.updateCloseButtonVisible(false)
			else
				p1.updateCloseButtonVisible(true)
			end
		end

		p1.updateBriefViewPercentBinding(p5)
	end
	function p1.peekHeaderPositionYChange(p6) -- line: 104
		-- upvalues: p1 (copy)
		local v78 = -(math.floor(p6 + 0.5) + 18 + 4)

		p1.updateCloseButtonPosition(UDim2.new(0, 15, 1, v78))
	end
end
function v16.render(p7) -- line: 110
	-- upvalues: withStyle (copy)
	return withStyle(function(p8) -- line: 111
		-- upvalues: p7 (copy)
		return p7:renderWith(p8)
	end)
end
function v16.renderWith(p9, p10) -- line: 116
	-- upvalues: Constants (copy), PeekViewState (copy), Roact (copy), ImageSetButton (copy), v15 (copy), PeekView (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy)
	local Theme = p10.Theme
	local v33 = p9.props.lastInputGroup == Constants.InputType.MouseAndKeyboard
	local isTryOnPage = p9.props.isTryOnPage
	local viewPosition = p9.props.viewPosition
	local viewSize = p9.props.viewSize
	local briefViewHeight = p9.props.briefViewHeight
	local showDropShadow = p9.props.showDropShadow
	local mountAnimation = p9.props.mountAnimation
	local mountAsFullView = p9.props.mountAsFullView
	local topBarHeight = p9.props.topBarHeight
	local fromProfile = p9.props.fromProfile
	local peekViewFullViewEnabled = p9.props.peekViewFullViewEnabled
	local peekViewState = p9.props.peekViewState
	local v45 = not fromProfile and 0 or 6
	local uDim2 = UDim2.fromOffset(0, topBarHeight - v45)
	local renderContent = p9.props.renderContent
	local renderTopBar = p9.props.renderTopBar
	local renderBottomBar = p9.props.renderBottomBar
	local v50 = peekViewState == PeekViewState.Full or (peekViewState == PeekViewState.Extended or (v33 or isTryOnPage))
	local desktopScrollingEnabledBinding = p9.desktopScrollingEnabledBinding
	local Never = nil

	if not peekViewFullViewEnabled then
		Never = Enum.ElasticBehavior.Never
	end

	local v53 = p9.briefViewPercentBinding:map(function(p11) -- line: 154
		-- upvalues: Theme (copy)
		return 1 - (1 - Theme.Overlay.Transparency) * p11
	end)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = viewSize,
		Position = viewPosition
	}, {
		Overlay = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 1,
			BackgroundTransparency = if not isTryOnPage then v53 else 1,
			BackgroundColor3 = Theme.Overlay.Color,
			Size = UDim2.fromScale(1, 1)
		}),
		TopBar = if not v50 then nil else renderTopBar(),
		CloseButton = v33 and (not isTryOnPage and Roact.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = p9.closeButtonPosition,
			Size = UDim2.new(0, 36, 0, 36),
			Image = v15,
			ImageColor3 = Theme.SystemPrimaryDefault.Color,
			Visible = p9.closeButtonVisible,
			[Roact.Event.Activated] = p9.props.closeBriefView
		})),
		PeekViewContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			ZIndex = 2,
			Position = uDim2,
			Size = UDim2.new(1, 0, 1, -uDim2.Y.Offset)
		}, {
			PeekView = Roact.createElement(PeekView, {
				showDraggerInClosedState = false,
				returnToFullView = true,
				thumbstickScrollEnabled = true,
				shouldCaptureFocus = false,
				briefViewContentHeight = UDim.new(0, briefViewHeight),
				viewStateChanged = p9.peekViewStateChanged,
				mountAnimation = mountAnimation,
				mountAsFullView = mountAsFullView,
				canDragFullViewToBrief = not fromProfile,
				bottomDockedContainerHeight = briefViewHeight,
				bottomDockedContainerContent = {
					ActionBarContainer = renderBottomBar()
				},
				showDropShadow = showDropShadow,
				elasticBehavior = Never,
				backgroundColor3 = Theme.BackgroundDefault.Color,
				backgroundTransparency = Theme.BackgroundUIDefault.Transparency,
				briefToFullTransitionPercent = p9.briefToFullTransitionPercent,
				peekHeaderClose = fromProfile or false,
				peekHeaderPositionYChange = p9.peekHeaderPositionYChange,
				isScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then not v33 or desktopScrollingEnabledBinding else p9.props.scrollingEnabled and (not v33 or desktopScrollingEnabledBinding),
				contentFrameRef = p9.props.contentFrameRef,
				peekViewState = peekViewState,
				customBackground = Theme.BackgroundDefault.Color
			}, {
				ItemDetails = renderContent()
			})
		})
	})
end

local function isPeekViewExpanded(p12) -- line: 229
	-- upvalues: PeekViewState (copy)
	local peekViewState = p12.peekViewState

	return peekViewState == PeekViewState.Full or peekViewState == PeekViewState.Extended
end

function v16.didUpdate(p13, p14, _) -- line: 234
	-- upvalues: PeekViewState (copy), AvatarScreen (copy)
	local current = p13.props.avatarRoute.current
	local name = current.name
	local _ = current.key
	local _ = p13.props.navigation.state.key

	if p13.props.peekViewShowing then
		local peekViewState = p13.props.peekViewState
		local v64 = peekViewState == PeekViewState.Full or peekViewState == PeekViewState.Extended

		if v64 ~= p13.props.itemDetailsExpanded then
			p13.props.setItemDetailsExpanded(v64)

			return
		end
	elseif p14.peekViewShowing and name ~= AvatarScreen.ItemDetails and p13.props.itemDetailsExpanded then
		p13.props.setItemDetailsExpanded(false)
	end
end
function v16.didMount(p16) -- line: 271
	-- upvalues: PeekViewState (copy)
	if not p16.props.mountAnimation then
		p16.peekHeaderPositionYChange(p16.props.briefViewHeight + 25)
	end

	if p16.props.peekViewShowing then
		local peekViewState = p16.props.peekViewState
		local v67 = peekViewState == PeekViewState.Full or peekViewState == PeekViewState.Extended

		if v67 ~= p16.props.itemDetailsExpanded then
			p16.props.setItemDetailsExpanded(v67)
		end
	end
end
function v16.willUnmount(p17) -- line: 284
	if p17.props.peekViewShowing and p17.props.itemDetailsExpanded then
		p17.props.setItemDetailsExpanded(false)
	end
end

return v16
