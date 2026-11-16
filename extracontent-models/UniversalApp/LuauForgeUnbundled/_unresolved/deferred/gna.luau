local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module = require("@luauforge/bundled/fwb")

local module2 = require("@luauforge/bundled/dwA")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
require("@luauforge/bundled/dHK")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute

local peekView = require("@luauforge/bundled/dzD").PeekView
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local gamepadUtils = require("@luauforge/bundled/fuE").Gamepad.GamepadUtils

local module4 = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module5 = require("@luauforge/deferred/gnb")

local module6 = require("@luauforge/deferred/gnd")
local module7 = require("@luauforge/bundled/geT")

local module8 = require("@luauforge/deferred/gmi")
local module9 = require("@luauforge/deferred/gml")

local module10 = require("@luauforge/deferred/gfb")
local module11 = require("@luauforge/bundled/dTM")
local module12 = require("@luauforge/bundled/dNA")
local module13 = require("@luauforge/bundled/fuD")

local module14 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module14.FocusNavigationEventNameEnum
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local useAXAnimateScrollFrame = AvatarExperienceCommon.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame

local module16 = require("@luauforge/deferred/gnc")

local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local iconsnavigationclose = images["icons/navigation/close"]

local udim = UDim.new(1, 0)

local tenFootInterface = isTenFootInterface()

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p2, callback)
	local v6 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local function useOnScrollEffect(callback, p2)
	React.useEffect(function()
		local heartbeatConnection, inputChangedConnection

		if p2 then
			local v6 = nil
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				if v6 and v6.KeyCode == Enum.KeyCode.Thumbstick2 then
					callback(v6, dt)
				end
			end)
			inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
				if input.KeyCode == Enum.KeyCode.Thumbstick2 then
					if input.UserInputState == Enum.UserInputState.Change then
						v6 = input
					elseif input.UserInputState == Enum.UserInputState.End then
						v6 = nil
					end
				end
			end)
		else
			heartbeatConnection = nil
			inputChangedConnection = nil
		end

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end

			if inputChangedConnection then
				inputChangedConnection:Disconnect()
			end
		end
	end, { callback, p2 })
end

local extended = Roact.PureComponent:extend("OutfitDetailsPeekView")

extended.validateProps = t.strictInterface({
	outfitId = t.string,
	ZIndex = t.optional(t.integer),
	onPeekViewClosed = t.optional(t.callback),
	exitButtonPosition = t.optional(t.Vector2),
	deleteOutfit = t.optional(t.callback),
	renameOutfit = t.optional(t.callback),
	showFullWithNoPeekView = t.optional(t.boolean),
	renderBottomBar = t.optional(t.boolean),
	NextSelectionLeft = t.optional(t.table),
	outfitDetailsPeekViewRefs = t.optional(t.table),
	navigation = t.table,
	avatarRoute = avatarRoute.Interface,
	overlayClosedCallback = t.callback,
	peekViewContainerFocusNavigationRef = t.callback,
	swipeScrollingFrameRef = t.table,
	isPortrait = t.boolean,
	topBarHeight = t.number,
	itemDetailsExpanded = t.boolean,
	statusBarHeight = t.number,
	outfitInfo = t.optional(t.table),
	setItemDetailsExpanded = t.callback,
	fetchOutfitDetails = t.callback,
	avatarEditorAnalytics = t.table
})

extended.defaultProps = { showFullWithNoPeekView = false, renderBottomBar = true }

function extended:init()
	self.actionBarRef = Roact.createRef()
	self.exitButtonRef = Roact.createRef()
	self.itemsGridRef = Roact.createRef()

	self:setState({
		isGamepad = isGamepadInput((UserInputService:GetLastInputType()))
	})

	function self.viewStateChanged(p2, p3)
		if p2 == peekViewState.Closed then
			if self.props.onPeekViewClosed then
				self.props.onPeekViewClosed()
			end

			module11.closeFiltersAndItemDetails(self.props.navigation)
		end

		if p2 == peekViewState.Full or p2 == peekViewState.Extended then
			self.props.setItemDetailsExpanded(true)
		else
			self.props.setItemDetailsExpanded(false)
		end
	end

	function self.lastInputTypeChangedCallback()
		local gamepadInput = isGamepadInput((UserInputService:GetLastInputType()))

		if gamepadInput ~= self.state.isGamepad then
			self:setState({ isGamepad = gamepadInput })
		end
	end

	function self.onExitButtonPressed()
		if self.props.onPeekViewClosed then
			self.props.onPeekViewClosed()
		end

		module11.closeFiltersAndItemDetails(self.props.navigation)
	end

	local binding, v6 = Roact.createBinding(Vector2.new(0, 0))
	self.absolutePositionBinding = binding
	self.updateAbsolutePositionBinding = v6

	function self.containerPositionChanged(p2)
		self.updateAbsolutePositionBinding(p2.AbsolutePosition)
	end

	function self.getExitButtonUDim2Pos()
		if self.props.isPortrait then
			return UDim2.fromScale(15, self.props.statusBarHeight)
		end

		return UDim2.new(0, 15, 0, -44 - (self.props.topBarHeight - 44) / 2)
	end

	function self.getRef()
		local key = self.props.navigation.state.key
		local outfitDetailsPeekViewRefs = self:getOutfitDetailsPeekViewRefs()

		if outfitDetailsPeekViewRefs and key then
			return outfitDetailsPeekViewRefs[key]
		end

		return nil
	end

	function self.shouldRenderFullScreen()
		return self.props.showFullWithNoPeekView or isVRAppBuild()
	end
end

function extended:getOutfitDetailsPeekViewRefs()
	if self.props.outfitDetailsPeekViewRefs then
		return self.props.outfitDetailsPeekViewRefs
	end

	if not self.outfitDetailsPeekViewRefs then
		self.outfitDetailsPeekViewRefs = RoactGamepad.createRefCache()
	end

	return self.outfitDetailsPeekViewRefs
end

function extended:renderActionBar(p2)
	local createElement = Roact.createElement
	local actionBarRefsByRef = {
		["gradientFade"] = nil,
		["gradientFade"] = nil,
		gradientFade = true,
		multiSelect = false,
		selectedOutfits = { self.props.outfitId },
		ZIndex = 2,
		bottomPadding = p2,
		deleteOutfit = self.props.deleteOutfit,
		renameOutfit = self.props.renameOutfit
	}

	local v7 = if self.props.isPortrait then self.exitButtonRef or nil else nil
	actionBarRefsByRef.NextSelectionUp = v7
	actionBarRefsByRef[Roact.Ref] = self.actionBarRef
	return createElement(module5, actionBarRefsByRef)
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme

	local udim2 = UDim2.fromOffset(0, self.props.topBarHeight)
	local udim3 = UDim2.new(1, 0, 1, -self.props.topBarHeight)
	local v6 = not (self.props.isPortrait or isVRAppBuild())

	if v6 then
		local newUDim2 = UDim2.new
		local v7 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module4.LandscapeNavWidth
		udim2 = newUDim2(v7, 0, 0, self.props.topBarHeight)

		local newUDim2_2 = UDim2.new
		local v8 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module4.LandscapeSceneWidth
		udim3 = newUDim2_2(v8, 0, 1, -self.props.topBarHeight)
	end

	local actionBarHeight = module16.ActionBarHeight

	if not v6 then
		actionBarHeight += 24
	end

	local GAMEPAD_BOTTOM_BAR_SIZE

	if self.state.isGamepad and tenFootInterface then
		GAMEPAD_BOTTOM_BAR_SIZE = module2.GAMEPAD_BOTTOM_BAR_SIZE
		actionBarHeight += module2.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local exitButtonPosition = self.props.exitButtonPosition
	local v7

	if exitButtonPosition then
		v7 = self.absolutePositionBinding:map(function(p3)
			return UDim2.fromOffset(exitButtonPosition.X - p3.X, exitButtonPosition.Y - p3.Y)
		end)
	end

	local v8 = if not exitButtonPosition then self.getExitButtonUDim2Pos() else nil

	local v9 = self.props.itemDetailsExpanded and (self.props.isPortrait or self.shouldRenderFullScreen())

	local ref = self.getRef()

	local createElement = Roact.createElement
	local v11 = {
		ZIndex = self.props.ZIndex,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = udim3,
		Position = udim2,
		SelectionGroup = true,
		[Roact.Ref] = ref,
		[Roact.Change.AbsolutePosition] = self.containerPositionChanged
	}
	local v12 = {
		LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = self.lastInputTypeChangedCallback
		}),
		Background = 0,
		ExitButton = 0,
		PeekViewContainer = 0,
		ScrollingContent = 0
	}

	local v13 = if self.props.itemDetailsExpanded then Roact.createElement("TextButton", {
		BackgroundTransparency = self.props.isPortrait and theme.Overlay.Transparency or 1,
		BackgroundColor3 = theme.Overlay.Color,
		Size = UDim2.new(1, 0, 1, self.props.topBarHeight),
		Position = UDim2.fromOffset(0, -self.props.topBarHeight),
		ZIndex = 1,
		Text = "",
		AutoButtonColor = false
	}) else nil
	v12.Background = v13

	if v9 then
		local createElement2 = Roact.createElement

		if exitButtonPosition then
			v8 = v7
		end

		local v15 = {
			position = v8,
			size = UDim2.fromOffset(44, 44),
			icon = iconsnavigationclose,
			iconSize = iconSize.Medium,
			iconColor3 = theme.SystemPrimaryDefault.Color,
			iconTransparency = theme.SystemPrimaryDefault.Transparency,
			onActivated = self.onExitButtonPressed,
			buttonRef = self.exitButtonRef,
			NextSelectionDown = 0
		}
		local v16 = if self.props.renderBottomBar then self.actionBarRef else self.itemsGridRef
		v15.NextSelectionDown = v16
		v9 = createElement2(iconButton, v15)
	end

	v12.ExitButton = v9
	local v14

	if not self.shouldRenderFullScreen() then
		local createElement2 = Roact.createElement
		local peekViewContainerFocusNavigationRefsByRef = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			ZIndex = 3,
			[Roact.Ref] = self.props.peekViewContainerFocusNavigationRef
		}

		local createElement3 = Roact.createElement
		local v18 = {
			briefViewContentHeight = UDim.new(0, actionBarHeight),
			mountAnimation = true,
			mountAsFullView = true,
			canDragFullViewToBrief = true,
			showDraggerInClosedState = false,
			returnToFullView = true,
			thumbstickScrollEnabled = true,
			viewStateChanged = self.viewStateChanged,
			bottomDockedContainerHeight = actionBarHeight,
			bottomDockedContainerContent = 0,
			backgroundColor3 = 0,
			backgroundTransparency = 0,
			peekHeaderClose = true,
			isScrollingEnabled = true,
			shouldCaptureFocus = false,
			scrollingFrameRef = 0
		}

		local v19 = if self.props.renderBottomBar then self:renderActionBar(GAMEPAD_BOTTOM_BAR_SIZE) else nil
		v18.bottomDockedContainerContent = v19

		v18.backgroundColor3 = theme.BackgroundDefault.Color
		v18.backgroundTransparency = theme.BackgroundUIDefault.Transparency

		v18.scrollingFrameRef = self.props.swipeScrollingFrameRef
		v14 = createElement2("Frame", peekViewContainerFocusNavigationRefsByRef, {
			PeekView = createElement3(peekView, v18, {
				OutfitDetailsContainer = Roact.createElement(module6, {
					outfitId = self.props.outfitId,
					itemsGridRef = self.itemsGridRef,
					bottomPadding = module16.ActionBarHeight + (GAMEPAD_BOTTOM_BAR_SIZE or 0)
				})
			})
		})
	end

	v12.PeekViewContainer = v14
	local v15

	if self.shouldRenderFullScreen() then
		v15 = Roact.createElement("ScrollingFrame", {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			ScrollBarThickness = 0,
			CanvasSize = UDim2.fromScale(1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			ZIndex = 3,
			[Roact.Ref] = self.props.swipeScrollingFrameRef
		}, {
			OutfitDetailsContainer = Roact.createElement(module6, {
				outfitId = self.props.outfitId,
				itemsGridRef = self.itemsGridRef,
				NextSelectionUp = self.exitButtonRef
			})
		})
	end

	v12.ScrollingContent = v15
	return createElement("Frame", v11, v12)
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

local function isOutfitInfoEmpty(p2): boolean
	return not (p2 and p2.assets) or #p2.assets == 0
end

function extended.didMount(data)
	local ref = data.getRef()

	if ref:getValue() then
		data.containerPositionChanged(ref:getValue())
	end

	data.props.setItemDetailsExpanded(true)

	local outfitInfo = data.props.outfitInfo

	if not outfitInfo or not outfitInfo.assets or #outfitInfo.assets == 0 then
		data.props.fetchOutfitDetails(data.props.outfitId)
	end
end

function extended.didUpdate(p2, p3, p4)
	if p2.props.outfitId ~= p3.outfitId then
		local outfitInfo = p2.props.outfitInfo

		if not outfitInfo or not outfitInfo.assets or #outfitInfo.assets == 0 then
			p2.props.fetchOutfitDetails(p2.props.outfitId)
		end
	end
end

function extended.willUnmount(p2)
	if
		p2.props.avatarRoute.current.name ~= avatarScreen.OutfitDetails
		or p2.props.avatarRoute.current.key == p2.props.navigation.state.key
	then
		p2.props.setItemDetailsExpanded(false)
	end
end

local function mapStateToProps(data, p2)
	local v6 = data.DeviceOrientation == deviceOrientationMode.Portrait

	return {
		outfitInfo = data.AvatarExperience.AvatarEditor.OutfitInfos[p2.outfitId],
		isPortrait = v6,
		topBarHeight = module13.getTopBarHeightAvatarScene(data),
		itemDetailsExpanded = data.AvatarExperience.Common.ItemDetailsExpanded,
		statusBarHeight = data.TopBar.statusBarHeight
	}
end

local function mapDispatchToProps(callback)
	return {
		setItemDetailsExpanded = function(p2)
			callback(module12(p2))
		end,
		fetchOutfitDetails = function(p2)
			callback(module(p2))
		end
	}
end

local v6 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

local v7 = roactServices.connect({ avatarEditorAnalytics = module7 })(v6)

local function OutfitDetailsPageContainer(props)
	local v8 = module9()
	local v9 = module8({ overlayClosedCallback = v8 })

	local ref = React.useRef(nil)
	useAXAnimateScrollFrame(ref)

	local v10 = React.useCallback(function()
		module11.closeFiltersAndItemDetails(props.navigation)

		if props.onPeekViewClosed then
			props.onPeekViewClosed()
		end
	end, { props.navigation, props.onPeekViewClosed })

	local v11 = React.useCallback(function(p2, p3)
		local vector2 = Vector2.new(p2.Position.X, p2.Position.Y)

		if ref.current then
			local v12 = ref.current.CanvasPosition.Y + p3 * -gamepadUtils.normalizeStickByDeadzone(vector2).Y * 1000

			if v12 <= ref.current.AbsoluteCanvasSize.Y * udim.Scale + udim.Offset then
				ref.current.CanvasPosition = Vector2.new(0, v12)
			end
		end
	end, {})

	local showFullWithNoPeekView = props.showFullWithNoPeekView or isVRAppBuild()
	React.useEffect(function()
		local heartbeatConnection, inputChangedConnection

		if showFullWithNoPeekView then
			local v12 = nil
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				if v12 and v12.KeyCode == Enum.KeyCode.Thumbstick2 then
					v11(v12, dt)
				end
			end)
			inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
				if input.KeyCode == Enum.KeyCode.Thumbstick2 then
					if input.UserInputState == Enum.UserInputState.Change then
						v12 = input
					elseif input.UserInputState == Enum.UserInputState.End then
						v12 = nil
					end
				end
			end)
		else
			heartbeatConnection = nil
			inputChangedConnection = nil
		end

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end

			if inputChangedConnection then
				inputChangedConnection:Disconnect()
			end
		end
	end, { v11, showFullWithNoPeekView })

	local v12 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, v10)))

	local v13 = useFocusNavigationBindings(nil, v10)

	local joined = Cryo.Dictionary.join(props, {
		overlayClosedCallback = v8,
		peekViewContainerFocusNavigationRef = v13,
		swipeScrollingFrameRef = v12
	})

	return Roact.createElement(
		"Frame",
		{ [Roact.Ref] = v9, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		{
			OutfitDetailsPeekView = React.createElement(v7, joined)
		}
	)
end

return module10(OutfitDetailsPageContainer)
