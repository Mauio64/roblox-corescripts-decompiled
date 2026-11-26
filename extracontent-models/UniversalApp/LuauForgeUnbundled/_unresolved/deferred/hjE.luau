local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local fFlagFontFaceAX = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFaceAX
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput

local fitTextLabel = FitFrame.FitTextLabel

local module = require("@luauforge/bundled/dzD")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module3 = require("@luauforge/bundled/eie")

local module4 = require("@luauforge/bundled/ehL")
require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = module4.FocusNavigationEventNameEnum
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = module4.useFocusNavigableSurfaceRegistryConnection

local useFocusOnMountEffect = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useFocusOnMountEffect

local module5 = require("@luauforge/deferred/gRz")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module6 = require("@luauforge/bundled/gJz")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed

local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics

local module7 = require("@luauforge/deferred/hjB")

local module8 = require("@luauforge/deferred/hjC")
local module9 = require("@luauforge/deferred/gRF")
local module10 = require("@luauforge/bundled/dXh")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local module11 = require("@luauforge/deferred/hjF")

local fFlagAXAddManageOutfitClickTracking = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAddManageOutfitClickTracking

local defineFastFlag = game:DefineFastFlag("AXFocusOnMountManageOutfitPage", false)

local module12 = require("@luauforge/bundled/dFs")

local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local iconsnavigationclose = images["icons/navigation/close"]

local tenFootInterface = isTenFootInterface()

local extended = Roact.PureComponent:extend("ManageOutfitPage")

extended.validateProps = t.strictInterface({
	navigateWithLock = t.callback,
	navigation = t.table,
	avatarRoute = t.table,
	showCustomOutfitNames = t.boolean,
	avatarEditorAnalytics = t.table,
	multiSelectionEnabled = t.boolean,
	setMultiSelectionEnabled = t.callback,
	outfitGridCanScroll = t.boolean,
	setOutfitGridCanScroll = t.callback,
	selectedOutfits = t.table,
	setSelectedOutfits = t.callback,
	exitButtonPosition = t.Vector2,
	setExitButtonPosition = t.callback,
	isGamepad = t.boolean,
	setIsGamepad = t.callback,
	focusNavigationRef = t.union(t.callback, t.table)
})

function extended:init()
	self.exitButtonRef = Roact.createRef()
	self.selectButtonRef = Roact.createRef()
	self.gridViewRef = Roact.createRef()
	self.actionBarRef = Roact.createRef()
	self.outfitDetailsPeekViewRefs = RoactGamepad.createRefCache()

	function self.navigateBack()
		self.props.navigation.goBack()
	end

	function self.selectedOutfitUpdated(options)
		if typeof(options) == "string" then
			self.props.setSelectedOutfits({ options })
		else
			self.props.setSelectedOutfits(options or {})
		end
	end

	function self.exitButtonPositionChanged(p2)
		if p2.AbsolutePosition ~= self.props.exitButtonPosition then
			self.props.setExitButtonPosition(p2.AbsolutePosition)
		end
	end

	function self.renderExitButton()
		return withStyle(function(p2)
			local theme = p2.Theme

			return Roact.createElement(iconButton, {
				size = UDim2.new(0, 44, 1, 0),
				icon = iconsnavigationclose,
				iconSize = iconSize.Medium,
				iconColor3 = theme.SystemPrimaryDefault.Color,
				iconTransparency = theme.SystemPrimaryDefault.Transparency,
				onActivated = self.navigateBack,
				buttonRef = self.exitButtonRef,
				onAbsolutePositionChanged = self.exitButtonPositionChanged
			})
		end)
	end

	function self.selectButtonPressed()
		self.props.setMultiSelectionEnabled(not self.props.multiSelectionEnabled)
		module10.closeFiltersAndItemDetails(self.props.navigation)
	end

	function self.outfitGridCanScrollUpdated(p2)
		if self.props.outfitGridCanScroll ~= p2 then
			self.props.setOutfitGridCanScroll(p2)
		end
	end

	function self.onPeekViewClosed()
		self.props.setSelectedOutfits({})
	end

	function self.onOverlayClosed()
		logOnOverlayClosed("ManageOutfitPage", self.props.isGamepad)
	end

	function self.deleteOutfit()
		if fFlagAXAddManageOutfitClickTracking then
			slotBasedEditorAnalytics.trackDeleteAvatarAttemptClick(self.state.multiSelectionEnabled)
		end

		local function onDeleteOverlayClosed()
			if self.props.multiSelectionEnabled then
				self.props.setMultiSelectionEnabled(false)
			end

			self.onOverlayClosed()
		end

		self.props.navigation.navigate(avatarScreen.DeleteOutfitPrompt, {
			outfitIds = self.props.selectedOutfits,
			onOverlayClosed = onDeleteOverlayClosed
		})
	end

	function self.renameOutfit()
		if self.props.selectedOutfits and self.props.selectedOutfits[1] then
			self.props.navigation.navigate(avatarScreen.RenameOutfitPrompt, {
				costumeId = self.props.selectedOutfits[1],
				onOverlayClosed = self.onOverlayClosed
			})
		else
			module12("Tried to rename an outfit with no outfit selected", self.props.selectedOutfits)
		end
	end

	function self.lastInputTypeChangedCallback()
		local gamepadInput = isGamepadInput((UserInputService:GetLastInputType()))

		if gamepadInput ~= self.props.isGamepad then
			self.props.setIsGamepad(gamepadInput)
		end
	end

	function self.onToggleOutfitCard(p2, p3)
		local navigation = self.props.navigation

		if not p2 then
			module10.closeFiltersAndItemDetails(navigation)

			return
		end

		local v5 = {
			outfitId = p3,
			ZIndex = 2,
			onPeekViewClosed = self.onPeekViewClosed,
			exitButtonPosition = self.props.exitButtonPosition,
			deleteOutfit = self.deleteOutfit,
			renameOutfit = self.renameOutfit,
			outfitDetailsPeekViewRefs = self.outfitDetailsPeekViewRefs
		}

		local function fn()
			module10.closeFiltersAndItemDetails(navigation)

			module10.closeTryOnManager(navigation)
			navigation.navigate(avatarScreen.OutfitDetails, v5)
		end
		self.props.navigateWithLock(fn)
	end
end

function extended:renderRightTopBarButton(p2, props2, callback)
	local v5 = p2.select

	if self.props.multiSelectionEnabled then
		v5 = p2.cancel
	end

	local v6 = props2.Font.Header2.Font
	local v7 = props2.Font.BaseSize * props2.Font.Header2.RelativeSize

	local createElement = Roact.createElement
	local selectButtonRefsByRef = {}
	selectButtonRefsByRef.width = fitTextLabel.Width.FitToText
	selectButtonRefsByRef.onActivated = self.selectButtonPressed
	selectButtonRefsByRef.BackgroundTransparency = 1
	selectButtonRefsByRef.Text = v5

	if fFlagFontFaceAX then
		v6 = normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font)
	end

	selectButtonRefsByRef.Font = v6
	selectButtonRefsByRef.LayoutOrder = 1
	selectButtonRefsByRef.TextColor3 = props2.Theme.TextEmphasis.Color
	selectButtonRefsByRef.TextSize = v7

	selectButtonRefsByRef.SelectionImageObject = callback(cursorKind.RoundedRect)
	selectButtonRefsByRef[Roact.Ref] = self.selectButtonRef
	return createElement(fitTextLabel, selectButtonRefsByRef)
end

function extended:renderWithProviders(p2, p3, p4)
	local GAMEPAD_BOTTOM_BAR_SIZE = if self.props.isGamepad and tenFootInterface then module.GAMEPAD_BOTTOM_BAR_SIZE else nil

	local createElement = Roact.createElement
	local v6 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
	local v7 = {
		LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = self.lastInputTypeChangedCallback
		}),
		NavOverlayPageContainer = 0
	}

	local createElement2 = Roact.createElement
	local v9 = {
		headerBarProps = {
			title = p2.manage,
			renderLeft = self.renderExitButton,
			renderRight = function()
				return self:renderRightTopBarButton(p2, p3, p4)
			end
		},
		forwardRef = self.props.focusNavigationRef,
		ZIndex = 1
	}

	local v10 = {
		OutfitSelectionGrid = Roact.createElement(module8, {
			onToggleOutfitCard = self.onToggleOutfitCard,
			selectedOutfits = self.props.selectedOutfits,
			selectionUpdated = self.selectedOutfitUpdated,
			canScrollUpdated = self.outfitGridCanScrollUpdated,
			multiSelect = self.props.multiSelectionEnabled,
			goBack = self.navigateBack,
			pageOwner = avatarScreen.ManageOutfitPage,
			[Roact.Ref] = self.gridViewRef
		}),
		ManageActionBar = 0
	}
	local v12

	if self.props.multiSelectionEnabled then
		local createElement4 = Roact.createElement
		local actionBarRefsByRef = {
			gradientFade = self.props.outfitGridCanScroll,
			multiSelect = true,
			selectedOutfits = self.props.selectedOutfits,
			bottomPadding = GAMEPAD_BOTTOM_BAR_SIZE,
			deleteOutfit = self.deleteOutfit,
			renameOutfit = self.renameOutfit,
			ZIndex = 2,
			[Roact.Ref] = self.actionBarRef
		}
		v12 = createElement4(module9, actionBarRefsByRef) or nil
	end

	v10.ManageActionBar = v12
	v7.NavOverlayPageContainer = createElement2(module7, v9, v10)
	return createElement("Frame", v6, v7)
end

function extended:render()
	return withLocalization({
		manage = "Feature.Avatar.Heading.Manage",
		select = "Feature.Avatar.Action.Select",
		cancel = "Feature.Avatar.Action.Cancel"
	})(function(p2)
		return withStyle(function(p3)
			return withSelectionCursorProvider(function(p4)
				return self:renderWithProviders(p2, p3, p4)
			end)
		end)
	end)
end

function extended.didUpdate(p2, p3, p4)
	local v5 = not (#p2.props.selectedOutfits == 1) and #p3.selectedOutfits == 1

	if not p2.props.multiSelectionEnabled and v5 then
		module10.closeAllDialogs(p2.props.navigation)
		module10.closeFiltersAndItemDetails(p2.props.navigation)
	end
end

local function mapDispatchToProps(callback)
	return {
		navigateWithLock = function(p2)
			callback(navigateWithLock(p2))
		end
	}
end

local v5 = module5((RoactRodux.connect(nil, mapDispatchToProps)(extended)))

return function(p2)
	local v6 = module3(module6)
	local v7 = useAppPolicy(function(p3)
		return p3.getCustomOutfitNames()
	end)

	local gamepadInput = isGamepadInput((UserInputService:GetLastInputType()))

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(Vector2.new(0, 0))
	local state5, setState5 = React.useState(gamepadInput)

	local ref = React.useRef(nil)

	local v8 = React.useMemo(function()
		local v9 = {
			[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
		}
		local buttonL3 = Enum.KeyCode.ButtonL3
		local v10 = if state then focusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect else focusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect
		v9[buttonL3] = v10

		v9[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.ManageOutfitsDelete
		v9[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.ManageOutfitsRename
		return v9
	end, { state })

	local v9 = React.useCallback(function()
		p2.navigation.goBack()
	end, { p2.navigation.goBack })

	local v10 = React.useCallback(function()
		setState(true)
		module10.closeFiltersAndItemDetails(p2.navigation)
	end, { p2.navigation })

	local v11 = React.useCallback(function()
		setState(false)
		module10.closeFiltersAndItemDetails(p2.navigation)
	end, { p2.navigation })

	local v12 = React.useCallback(function()
		local function onDeleteOverlayClosed()
			if state then
				setState(false)
			end

			logOnOverlayClosed("ManageOutfitPage", state5)
		end

		p2.navigation.navigate(avatarScreen.DeleteOutfitPrompt, {
			outfitIds = state3,
			onOverlayClosed = onDeleteOverlayClosed
		})
	end, { state3, state, state5, p2.navigation })

	local v13 = React.useCallback(function()
		if state3 and state3[1] then
			local function onOverlayClosed()
				logOnOverlayClosed("ManageOutfitPage", state5)
			end

			p2.navigation.navigate(avatarScreen.RenameOutfitPrompt, {
				costumeId = state3[1],
				onOverlayClosed = onOverlayClosed
			})
		else
			module12("Tried to rename an outfit with no outfit selected", state3)
		end
	end, { p2.navigation, state3, state5 })

	local v14 = not state and #state3 == 1
	local v15 = not state and v7 and #state3 == 1

	if v14 or state then
		v10 = nil
	end

	if v14 or not state then
		v11 = nil
	end

	if not (#state3 > 0) then
		v12 = nil
	end

	if not v15 then
		v13 = nil
	end

	local v18 = module11(ref, v8, {
		onGoBack = v9,
		onToggleMultiselect = v10,
		onCancelMultiselect = v11,
		onDelete = v12,
		onRename = v13
	})

	useFocusNavigableSurfaceRegistryConnection(
		ref and ref.current,
		focusNavigableSurfaceIdentifierEnum.SubRouterView
	)

	if defineFastFlag then
		useFocusOnMountEffect(ref)
	end

	return React.createElement(v5, Cryo.Dictionary.join(p2, {
		multiSelectionEnabled = state,
		setMultiSelectionEnabled = setState,
		outfitGridCanScroll = state2,
		setOutfitGridCanScroll = setState2,
		selectedOutfits = state3,
		setSelectedOutfits = setState3,
		exitButtonPosition = state4,
		setExitButtonPosition = setState4,
		isGamepad = state5,
		setIsGamepad = setState5,
		focusNavigationRef = v18,
		avatarEditorAnalytics = v6,
		showCustomOutfitNames = v7
	}))
end
