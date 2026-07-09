local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local GetOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfit)
local Constants = require(Modules.LuaApp.Constants)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local PeekView = require(CorePackages.Workspace.Packages.PeekView).PeekView
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local ManageActionBar = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.ManageActionBar)
local OutfitDetailsContainer = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitDetailsContainer)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local useAvatarExperienceFocusNavigationBindings = require(Modules.AvatarExperience.Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Modules.AvatarExperience.Common.Hooks.useOverlayClosedCallback)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local SetItemDetailsExpanded = require(Modules.AvatarExperience.Common.Actions.SetItemDetailsExpanded)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local useAXAnimateScrollFrame = AvatarExperienceCommon.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame
local v46 = game:DefineFastFlag("AXMigrateOutfitDetailsPeekViewToFocusNavigation", false)
local FFlagAXFixGamepadNavigationOnOutfitManagement = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixGamepadNavigationOnOutfitManagement
local AssetManagementConstants = require(script.Parent.AssetManagementConstants)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local v53 = Images["icons/navigation/close"]
local uDim = UDim.new(1, 0)
local v55 = GuiService:IsTenFootInterface()
local Focusable = RoactGamepad.Focusable
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 98
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v70 = ReactFocusNavigation.useEventMap(t1, p1)
	local v71 = React.useMemo(function() -- line: 100
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 103
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v71, v70)
end
local function useOnScrollEffect(p4: ((...any) -> ...any), b1: boolean) -- line: 113
	-- upvalues: React (copy), RunService (copy), UserInputService (copy)
	React.useEffect(function() -- line: 117
		-- upvalues: b1 (copy), RunService (copy), p4 (copy), UserInputService (copy)
		local connection = nil
		local connection2 = nil

		if b1 then
			local u128 = nil

			connection = RunService.Heartbeat:Connect(function(dt) -- line: 123
				-- upvalues: u128 (ref), p4 (copy)
				if u128 and u128.KeyCode == Enum.KeyCode.Thumbstick2 then
					p4(u128, dt)
				end
			end)
			connection2 = UserInputService.InputChanged:Connect(function(input, _) -- line: 128
				-- upvalues: u128 (ref)
				if input.KeyCode == Enum.KeyCode.Thumbstick2 then
					if input.UserInputState == Enum.UserInputState.Change then
						u128 = input

						return
					end

					if input.UserInputState == Enum.UserInputState.End then
						u128 = nil
					end
				end
			end)
		end

		return function() -- line: 139
			-- upvalues: connection (ref), connection2 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {
		p4,
		b1
	})
end

local v60 = Roact.PureComponent:extend("OutfitDetailsPeekView")

v60.validateProps = t.strictInterface({
	outfitId = t.string,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.optional(t.table) else nil,
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
	avatarRoute = AvatarRoute.Interface,
	overlayClosedCallback = t.callback,
	peekViewContainerFocusNavigationRef = if not v46 then nil else t.callback,
	swipeScrollingFrameRef = if not v46 then nil else t.table,
	isPortrait = t.boolean,
	topBarHeight = t.number,
	itemDetailsExpanded = t.boolean,
	statusBarHeight = t.number,
	outfitInfo = t.optional(t.table),
	setItemDetailsExpanded = t.callback,
	fetchOutfitDetails = t.callback,
	avatarEditorAnalytics = t.table
})
v60.defaultProps = {
	showFullWithNoPeekView = false,
	renderBottomBar = true
}

function v60.init(p6) -- line: 199
	-- upvalues: Roact (copy), v46 (copy), UserInputService (copy), isGamepadInput (copy), PeekViewState (copy), NavigationUtils (copy), IsVRAppBuild (copy)
	p6.actionBarRef = Roact.createRef()
	p6.exitButtonRef = Roact.createRef()

	if not v46 then
		p6.swipeScrollingFrameRef = Roact.createRef()
	end

	p6.itemsGridRef = Roact.createRef()

	local LastInputType = UserInputService:GetLastInputType()

	p6:setState({
		isGamepad = isGamepadInput(LastInputType)
	})

	function p6.viewStateChanged(p7, _) -- line: 215
		-- upvalues: PeekViewState (copy), p6 (copy), NavigationUtils (copy)
		if p7 == PeekViewState.Closed then
			if p6.props.onPeekViewClosed then
				p6.props.onPeekViewClosed()
			end

			NavigationUtils.closeFiltersAndItemDetails(p6.props.navigation)
		end

		if p7 == PeekViewState.Full or p7 == PeekViewState.Extended then
			p6.props.setItemDetailsExpanded(true)

			return
		end

		p6.props.setItemDetailsExpanded(false)
	end
	function p6.lastInputTypeChangedCallback() -- line: 231
		-- upvalues: UserInputService (copy), isGamepadInput (copy), p6 (copy)
		local LastInputType2 = UserInputService:GetLastInputType()
		local v132 = isGamepadInput(LastInputType2)

		if v132 ~= p6.state.isGamepad then
			p6:setState({
				isGamepad = v132
			})
		end
	end
	function p6.onExitButtonPressed() -- line: 241
		-- upvalues: p6 (copy), NavigationUtils (copy)
		if p6.props.onPeekViewClosed then
			p6.props.onPeekViewClosed()
		end

		NavigationUtils.closeFiltersAndItemDetails(p6.props.navigation)
	end

	local v76, v77 = Roact.createBinding(Vector2.new(0, 0))

	p6.absolutePositionBinding = v76
	p6.updateAbsolutePositionBinding = v77

	function p6.containerPositionChanged(p9) -- line: 250
		-- upvalues: p6 (copy)
		p6.updateAbsolutePositionBinding(p9.AbsolutePosition)
	end
	function p6.getExitButtonUDim2Pos() -- line: 254
		-- upvalues: p6 (copy)
		if p6.props.isPortrait then
			return UDim2.fromScale(15, p6.props.statusBarHeight)
		end

		return UDim2.new(0, 15, 0, -44 - (p6.props.topBarHeight - 44) / 2)
	end
	function p6.getRef() -- line: 268
		-- upvalues: p6 (copy)
		local key = p6.props.navigation.state.key
		local v135 = p6:getOutfitDetailsPeekViewRefs()

		if v135 and key then
			return v135[key]
		end

		return nil
	end
	function p6.shouldRenderFullScreen() -- line: 278
		-- upvalues: p6 (copy), IsVRAppBuild (copy)
		return p6.props.showFullWithNoPeekView or IsVRAppBuild()
	end
end
function v60.getOutfitDetailsPeekViewRefs(p10) -- line: 283
	-- upvalues: RoactGamepad (copy)
	if p10.props.outfitDetailsPeekViewRefs then
		return p10.props.outfitDetailsPeekViewRefs
	end

	if not p10.outfitDetailsPeekViewRefs then
		p10.outfitDetailsPeekViewRefs = RoactGamepad.createRefCache()
	end

	return p10.outfitDetailsPeekViewRefs
end
function v60.renderActionBar(p11, p12) -- line: 294
	-- upvalues: Roact (copy), ManageActionBar (copy)
	return Roact.createElement(ManageActionBar, {
		gradientFade = true,
		multiSelect = false,
		selectedOutfits = { p11.props.outfitId },
		ZIndex = 2,
		bottomPadding = p12,
		deleteOutfit = p11.props.deleteOutfit,
		renameOutfit = p11.props.renameOutfit,
		NextSelectionUp = p11.props.isPortrait and p11.exitButtonRef or nil,
		[Roact.Ref] = p11.actionBarRef
	})
end
function v60.renderWithProviders(p13, p14) -- line: 311
	-- upvalues: IsVRAppBuild (copy), Constants2 (copy), AssetManagementConstants (copy), v55 (copy), Constants (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), v46 (copy), RoactGamepad (copy), NavigationUtils (copy), GamepadUtils (copy), uDim (copy), GamepadFocusHandlerForPage (copy), BoundInputsUpdater (copy), ExternalEventConnection (copy), UserInputService (copy), IconButton (copy), v53 (copy), IconSize (copy), PeekView (copy), OutfitDetailsContainer (copy)
	local Theme = p14.Theme
	local uDim2 = UDim2.fromOffset(0, p13.props.topBarHeight)
	local uDim2_2 = UDim2.new(1, 0, 1, -p13.props.topBarHeight)
	local v86 = not p13.props.isPortrait and not IsVRAppBuild()

	if v86 then
		uDim2 = UDim2.new(Constants2.LandscapeNavWidth, 0, 0, p13.props.topBarHeight)
		uDim2_2 = UDim2.new(Constants2.LandscapeSceneWidth, 0, 1, -p13.props.topBarHeight)
	end

	local ActionBarHeight = AssetManagementConstants.ActionBarHeight

	if not v86 then
		ActionBarHeight += 24
	end

	local GAMEPAD_BOTTOM_BAR_SIZE = nil

	if p13.state.isGamepad and v55 then
		GAMEPAD_BOTTOM_BAR_SIZE = Constants.GAMEPAD_BOTTOM_BAR_SIZE
		ActionBarHeight += Constants.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local exitButtonPosition = p13.props.exitButtonPosition
	local v90 = nil

	if exitButtonPosition then
		v90 = p13.absolutePositionBinding:map(function(p15) -- line: 336
			-- upvalues: exitButtonPosition (copy)
			return UDim2.fromOffset(exitButtonPosition.X - p15.X, exitButtonPosition.Y - p15.Y)
		end)
	end

	local v91 = nil

	if not exitButtonPosition then
		v91 = p13.getExitButtonUDim2Pos()
	end

	local v92 = p13.props.itemDetailsExpanded and (p13.props.isPortrait or p13.shouldRenderFullScreen())
	local v93 = p13.getRef()

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		ZIndex = p13.props.ZIndex,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = uDim2_2,
		Position = uDim2,
		SelectionGroup = not not FFlagAXFixGamepadNavigationOnOutfitManagement or nil,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then p13.props.NextSelectionLeft else nil,
		[Roact.Ref] = v93,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p13.props.focusController else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then if not p13.props.renderBottomBar then nil else p13.actionBarRef else nil,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not v46 then {
			Close = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 373
				-- upvalues: NavigationUtils (copy), p13 (copy)
				NavigationUtils.closeFiltersAndItemDetails(p13.props.navigation)

				if p13.props.onPeekViewClosed then
					p13.props.onPeekViewClosed()
				end
			end),
			ScrollPeekView = if not p13.swipeScrollingFrameRef or p13.swipeScrollingFrameRef.current == nil then nil else RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick2, function(p16, n1: number) -- line: 381
				-- upvalues: p13 (copy), GamepadUtils (copy), uDim (copy)
				local p16Position = p16.Position
				local current = p13.swipeScrollingFrameRef.current
				local v141 = current.CanvasPosition.Y + n1 * -GamepadUtils.normalizeStickByDeadzone(p16Position).Y * 1000

				if v141 <= current.AbsoluteCanvasSize.Y * uDim.Scale + uDim.Offset then
					current.CanvasPosition = Vector2.new(0, v141)
				end
			end)
		} else nil,
		[Roact.Change.AbsolutePosition] = p13.containerPositionChanged
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
			focusController = p13.props.focusController
		}) else nil,
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil,
		LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = p13.lastInputTypeChangedCallback
		}),
		Background = if not p13.props.itemDetailsExpanded then nil else Roact.createElement("TextButton", {
			ZIndex = 1,
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = p13.props.isPortrait and Theme.Overlay.Transparency or 1,
			BackgroundColor3 = Theme.Overlay.Color,
			Size = UDim2.new(1, 0, 1, p13.props.topBarHeight),
			Position = UDim2.fromOffset(0, -p13.props.topBarHeight)
		}),
		ExitButton = v92 and Roact.createElement(IconButton, {
			position = if not exitButtonPosition then v91 else v90,
			size = UDim2.fromOffset(44, 44),
			icon = v53,
			iconSize = IconSize.Medium,
			iconColor3 = Theme.SystemPrimaryDefault.Color,
			iconTransparency = Theme.SystemPrimaryDefault.Transparency,
			onActivated = p13.onExitButtonPressed,
			buttonRef = p13.exitButtonRef,
			NextSelectionDown = if not p13.props.renderBottomBar then p13.itemsGridRef else p13.actionBarRef
		}),
		PeekViewContainer = if p13.shouldRenderFullScreen() then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			ZIndex = 3,
			[Roact.Ref] = if not v46 then nil else p13.props.peekViewContainerFocusNavigationRef
		}, {
			PeekView = Roact.createElement(PeekView, {
				mountAnimation = true,
				mountAsFullView = true,
				canDragFullViewToBrief = true,
				showDraggerInClosedState = false,
				returnToFullView = true,
				thumbstickScrollEnabled = true,
				peekHeaderClose = true,
				isScrollingEnabled = true,
				briefViewContentHeight = UDim.new(0, ActionBarHeight),
				viewStateChanged = p13.viewStateChanged,
				bottomDockedContainerHeight = ActionBarHeight,
				bottomDockedContainerContent = if not p13.props.renderBottomBar then nil else p13:renderActionBar(GAMEPAD_BOTTOM_BAR_SIZE),
				backgroundColor3 = Theme.BackgroundDefault.Color,
				backgroundTransparency = Theme.BackgroundUIDefault.Transparency,
				shouldCaptureFocus = not FFlagAXMigrateAXToGlobalAutofocus and nil,
				scrollingFrameRef = if not FFlagAXFixGamepadNavigationOnOutfitManagement then nil else p13.props.swipeScrollingFrameRef
			}, {
				OutfitDetailsContainer = Roact.createElement(OutfitDetailsContainer, {
					outfitId = p13.props.outfitId,
					itemsGridRef = p13.itemsGridRef,
					NextSelectionUp = if not FFlagAXFixGamepadNavigationOnOutfitManagement then p13.exitButtonRef else nil,
					bottomPadding = if not FFlagAXFixGamepadNavigationOnOutfitManagement then nil else AssetManagementConstants.ActionBarHeight + (GAMEPAD_BOTTOM_BAR_SIZE or 0)
				})
			})
		}),
		ScrollingContent = if not p13.shouldRenderFullScreen() then nil else Roact.createElement("ScrollingFrame", {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			ScrollBarThickness = 0,
			CanvasSize = UDim2.fromScale(1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			ZIndex = 3,
			[Roact.Ref] = if not v46 then p13.swipeScrollingFrameRef else p13.props.swipeScrollingFrameRef
		}, {
			OutfitDetailsContainer = Roact.createElement(OutfitDetailsContainer, {
				outfitId = p13.props.outfitId,
				itemsGridRef = p13.itemsGridRef,
				NextSelectionUp = p13.exitButtonRef
			})
		})
	})
end
function v60.render(p17) -- line: 513
	-- upvalues: withStyle (copy)
	return withStyle(function(p18) -- line: 514
		-- upvalues: p17 (copy)
		return p17:renderWithProviders(p18)
	end)
end

local function isOutfitInfoEmpty(p19) -- line: 519
	return not p19 or (not p19.assets or #p19.assets == 0)
end

function v60.didMount(p20) -- line: 523
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy)
	local v97 = p20.getRef()

	if not FFlagAXMigrateAXToGlobalAutofocus and (p20.state.isGamepad and p20.props.isPortrait) then
		p20.props.focusController.moveFocusTo(v97)
	end

	if v97:getValue() then
		p20.containerPositionChanged(v97:getValue())
	end

	p20.props.setItemDetailsExpanded(true)

	local outfitInfo = p20.props.outfitInfo

	if not outfitInfo or (not outfitInfo.assets or #outfitInfo.assets == 0) then
		p20.props.fetchOutfitDetails(p20.props.outfitId)
	end
end
function v60.didUpdate(p21, p22, p23) -- line: 542
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy)
	if not FFlagAXMigrateAXToGlobalAutofocus then
		local v102 = p21.getRef()

		if p21.state.isGamepad and not p23.isGamepad and p21.props.isPortrait then
			p21.props.focusController.moveFocusTo(v102)
		end

		if p21.props.isPortrait and p22.isPortrait and p21.state.isGamepad then
			p21.props.focusController.moveFocusTo(v102)
		end
	end

	if p21.props.outfitId ~= p22.outfitId then
		local outfitInfo = p21.props.outfitInfo

		if not outfitInfo or (not outfitInfo.assets or #outfitInfo.assets == 0) then
			p21.props.fetchOutfitDetails(p21.props.outfitId)
		end
	end
end
function v60.willUnmount(p24) -- line: 563
	-- upvalues: AvatarScreen (copy)
	if p24.props.avatarRoute.current.name ~= AvatarScreen.OutfitDetails or p24.props.avatarRoute.current.key == p24.props.navigation.state.key then
		p24.props.setItemDetailsExpanded(false)
	end
end

local function mapStateToProps(p25, p26) -- line: 572
	-- upvalues: DeviceOrientationMode (copy), Utils (copy)
	local v107 = p25.DeviceOrientation == DeviceOrientationMode.Portrait

	return {
		outfitInfo = p25.AvatarExperience.AvatarEditor.OutfitInfos[p26.outfitId],
		isPortrait = v107,
		topBarHeight = Utils.getTopBarHeightAvatarScene(p25),
		itemDetailsExpanded = p25.AvatarExperience.Common.ItemDetailsExpanded,
		statusBarHeight = p25.TopBar.statusBarHeight
	}
end
local function mapDispatchToProps(p27) -- line: 587
	-- upvalues: SetItemDetailsExpanded (copy), GetOutfit (copy)
	return {
		setItemDetailsExpanded = function(p28) -- line: 589
			-- upvalues: p27 (copy), SetItemDetailsExpanded (copy)
			p27(SetItemDetailsExpanded(p28))
		end,
		fetchOutfitDetails = function(p29) -- line: 592
			-- upvalues: p27 (copy), GetOutfit (copy)
			p27(GetOutfit(p29))
		end
	}
end

local v64 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v60)

if not v46 then
	v64 = withMappedNavigationParams(v64)
end

local u65 = RoactServices.connect({
	avatarEditorAnalytics = Analytics
})(v64)

local function OutfitDetailsPageContainer(p30) -- line: 608
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), Cryo (copy), Roact (copy), u65 (ref)
	local v110 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil

	if not FFlagAXMigrateAXToGlobalAutofocus and p30.focusController then
		v110 = p30.focusController
	end

	local v111 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v110 else nil)
	local v112 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v111
	})
	local v113 = Cryo.Dictionary.join(p30, {
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v110 else nil,
		overlayClosedCallback = v111
	})

	return Roact.createElement("Frame", {
		[Roact.Ref] = v112,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		OutfitDetailsPeekView = React.createElement(u65, v113)
	})
end
local function OutfitDetailsPageContainerNew(p31) -- line: 635
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), useAXAnimateScrollFrame (copy), NavigationUtils (copy), GamepadUtils (copy), uDim (copy), IsVRAppBuild (copy), RunService (copy), UserInputService (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Cryo (copy), Roact (copy), u65 (ref)
	local v115 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil

	if not FFlagAXMigrateAXToGlobalAutofocus and p31.focusController then
		v115 = p31.focusController
	end

	local v116 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v115 else nil)
	local v117 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v116
	})
	local v118 = React.useRef(nil)

	if FFlagAXFixGamepadNavigationOnOutfitManagement then
		useAXAnimateScrollFrame(v118)
	end

	local v119 = React.useCallback(function() -- line: 653
		-- upvalues: NavigationUtils (copy), p31 (copy)
		NavigationUtils.closeFiltersAndItemDetails(p31.navigation)

		if p31.onPeekViewClosed then
			p31.onPeekViewClosed()
		end
	end, {
		p31.navigation,
		p31.onPeekViewClosed
	})
	local v120 = React.useCallback(function(p32, n2: number) -- line: 660
		-- upvalues: v118 (copy), GamepadUtils (copy), uDim (copy)
		local vector2 = Vector2.new(p32.Position.X, p32.Position.Y)

		if v118.current then
			local v148 = v118.current.CanvasPosition.Y + n2 * -GamepadUtils.normalizeStickByDeadzone(vector2).Y * 1000

			if v148 <= v118.current.AbsoluteCanvasSize.Y * uDim.Scale + uDim.Offset then
				v118.current.CanvasPosition = Vector2.new(0, v148)
			end
		end
	end, {})
	local v121 = p31.showFullWithNoPeekView or IsVRAppBuild()

	React.useEffect(function() -- line: 117
		-- upvalues: v121 (copy), RunService (copy), v120 (copy), UserInputService (copy)
		local connection = nil
		local connection3 = nil

		if v121 then
			local u151 = nil

			connection = RunService.Heartbeat:Connect(function(dt) -- line: 123
				-- upvalues: u151 (ref), v120 (copy)
				if u151 and u151.KeyCode == Enum.KeyCode.Thumbstick2 then
					v120(u151, dt)
				end
			end)
			connection3 = UserInputService.InputChanged:Connect(function(input, _) -- line: 128
				-- upvalues: u151 (ref)
				if input.KeyCode == Enum.KeyCode.Thumbstick2 then
					if input.UserInputState == Enum.UserInputState.Change then
						u151 = input

						return
					end

					if input.UserInputState == Enum.UserInputState.End then
						u151 = nil
					end
				end
			end)
		end

		return function() -- line: 139
			-- upvalues: connection (ref), connection3 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end
		end
	end, {
		v120,
		v121
	})

	local v122 = useFocusNavigationBindings(v118, v119)
	local v123 = useTableWrappedCallbackRef(v122)
	local v124 = useFocusNavigationBindings(nil, v119)
	local v125 = Cryo.Dictionary.join(p31, {
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v115 else nil,
		overlayClosedCallback = v116,
		peekViewContainerFocusNavigationRef = v124,
		swipeScrollingFrameRef = v123
	})

	return Roact.createElement("Frame", {
		[Roact.Ref] = v117,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		OutfitDetailsPeekView = React.createElement(u65, v125)
	})
end

if v46 then
	return withMappedNavigationParams(OutfitDetailsPageContainerNew)
end

return OutfitDetailsPageContainer
