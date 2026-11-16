local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFaceAX
	and Foundation.Utility.Flags.FoundationFontFaceMigration
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput

local fitTextLabel = FitFrame.FitTextLabel

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/dwA")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module2 = require("@luauforge/deferred/gmV")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module3 = require("@luauforge/bundled/geT")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed

local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics

local module4 = require("@luauforge/deferred/gXp")

local module5 = require("@luauforge/deferred/gXq")
local module6 = require("@luauforge/deferred/gnb")
local module7 = require("@luauforge/bundled/dTM")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local module8 = require("@luauforge/bundled/dCn")

local fFlagAXAddManageOutfitClickTracking = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAddManageOutfitClickTracking
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local focusable = RoactGamepad.Focusable

local iconsnavigationclose = images["icons/navigation/close"]

local tenFootInterface = isTenFootInterface()

local extended = Roact.PureComponent:extend("ManageOutfitPage")

extended.validateProps = t.strictInterface({
	navigateWithLock = t.callback,
	navigation = t.table,
	avatarRoute = t.table,
	showCustomOutfitNames = t.boolean,
	avatarEditorAnalytics = t.table
})

function extended:init()
	local gamepadInput = isGamepadInput((UserInputService:GetLastInputType()))

	self:setState({
		multiSelectionEnabled = false,
		outfitGridCanScroll = false,
		selectedOutfits = {},
		exitButtonPosition = Vector2.new(0, 0),
		isGamepad = gamepadInput
	})

	self.exitButtonRef = Roact.createRef()
	self.selectButtonRef = Roact.createRef()
	self.gridViewRef = Roact.createRef()
	self.actionBarRef = Roact.createRef()
	self.peekViewRef = Roact.createRef()
	self.outfitDetailsPeekViewRefs = RoactGamepad.createRefCache()

	function self.navigateBack()
		self.props.navigation.goBack()
	end

	function self.selectedOutfitUpdated(options)
		if typeof(options) == "string" then
			self:setState({
				selectedOutfits = { options }
			})
		else
			self:setState({
				selectedOutfits = options or {}
			})
		end
	end

	function self.exitButtonPositionChanged(p2)
		if p2.AbsolutePosition ~= self.state.exitButtonPosition then
			self:setState({ exitButtonPosition = p2.AbsolutePosition })
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
				NextSelectionDown = self.gridViewRef,
				NextSelectionRight = self.selectButtonRef,
				onAbsolutePositionChanged = self.exitButtonPositionChanged
			})
		end)
	end

	function self.selectButtonPressed()
		self:setState({
			multiSelectionEnabled = not self.state.multiSelectionEnabled
		})

		module7.closeFiltersAndItemDetails(self.props.navigation)
	end

	function self.outfitGridCanScrollUpdated(p2)
		if self.state.outfitGridCanScroll ~= p2 then
			self:setState({ outfitGridCanScroll = p2 })
		end
	end

	function self.onPeekViewClosed()
		self:setState({ selectedOutfits = {} })
	end

	function self.onOverlayClosed()
		logOnOverlayClosed("ManageOutfitPage", self.state.isGamepad)
	end

	function self.deleteOutfit()
		if fFlagAXAddManageOutfitClickTracking then
			slotBasedEditorAnalytics.trackDeleteAvatarAttemptClick(self.state.multiSelectionEnabled)
		end

		local function onDeleteOverlayClosed()
			if self.state.multiSelectionEnabled then
				self:setState({ multiSelectionEnabled = false })
			end

			self.onOverlayClosed()
		end

		self.props.navigation.navigate(avatarScreen.DeleteOutfitPrompt, {
			outfitIds = self.state.selectedOutfits,
			onOverlayClosed = onDeleteOverlayClosed
		})
	end

	function self.renameOutfit()
		if self.state.selectedOutfits and self.state.selectedOutfits[1] then
			self.props.navigation.navigate(avatarScreen.RenameOutfitPrompt, {
				costumeId = self.state.selectedOutfits[1],
				onOverlayClosed = self.onOverlayClosed
			})
		else
			module8("Tried to rename an outfit with no outfit selected", self.state.selectedOutfits)
		end
	end

	function self.lastInputTypeChangedCallback()
		local gamepadInput2 = isGamepadInput((UserInputService:GetLastInputType()))

		if gamepadInput2 ~= self.state.isGamepad then
			self:setState({ isGamepad = gamepadInput2 })
		end
	end

	function self.onToggleOutfitCard(p2, p3)
		local navigation = self.props.navigation

		if not p2 then
			module7.closeFiltersAndItemDetails(navigation)

			return
		end

		local v5 = {
			outfitId = p3,
			ZIndex = 2,
			onPeekViewClosed = self.onPeekViewClosed,
			exitButtonPosition = self.state.exitButtonPosition,
			deleteOutfit = self.deleteOutfit,
			renameOutfit = self.renameOutfit,
			NextSelectionLeft = 0,
			outfitDetailsPeekViewRefs = 0
		}
		local v6 = if not self.props.isPortrait then self.gridViewRef or nil else nil
		v5.NextSelectionLeft = v6
		v5.outfitDetailsPeekViewRefs = self.outfitDetailsPeekViewRefs

		local function fn()
			module7.closeFiltersAndItemDetails(navigation)

			module7.closeTryOnManager(navigation)
			navigation.navigate(avatarScreen.OutfitDetails, v5)
		end
		self.props.navigateWithLock(fn)
	end
end

function extended:renderRightTopBarButton(p2, props2, callback)
	local v5 = p2.select

	if self.state.multiSelectionEnabled then
		v5 = p2.cancel
	end

	local v6 = props2.Font.Header2.Font
	local v7 = props2.Font.BaseSize * props2.Font.Header2.RelativeSize

	local createElement = Roact.createElement
	local v8 = focusable[fitTextLabel]
	local selectButtonRefsByRef = {}
	selectButtonRefsByRef.width = fitTextLabel.Width.FitToText
	selectButtonRefsByRef.onActivated = self.selectButtonPressed
	selectButtonRefsByRef.BackgroundTransparency = 1
	selectButtonRefsByRef.Text = v5

	if foundationFontFaceMigration then
		v6 = normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font)
	end

	selectButtonRefsByRef.Font = v6
	selectButtonRefsByRef.LayoutOrder = 1
	selectButtonRefsByRef.TextColor3 = props2.Theme.TextEmphasis.Color
	selectButtonRefsByRef.TextSize = v7

	selectButtonRefsByRef.SelectionImageObject = callback(cursorKind.RoundedRect)
	selectButtonRefsByRef.NextSelectionLeft = self.exitButtonRef
	selectButtonRefsByRef.NextSelectionDown = self.gridViewRef
	selectButtonRefsByRef[Roact.Ref] = self.selectButtonRef
	return createElement(v8, selectButtonRefsByRef)
end

function extended:renderWithProviders(p2, p3, p4)
	local v5 = not self.state.multiSelectionEnabled and #self.state.selectedOutfits == 1

	local v6 = not self.state.multiSelectionEnabled
		and self.props.showCustomOutfitNames
		and #self.state.selectedOutfits == 1

	local GAMEPAD_BOTTOM_BAR_SIZE = if self.state.isGamepad and tenFootInterface then module.GAMEPAD_BOTTOM_BAR_SIZE else nil

	local v7 = if v5 then self.peekViewRef else nil

	if v5 then
		local key = self.props.avatarRoute.current.key
		v7 = self.outfitDetailsPeekViewRefs[key]
	end

	local createElement = Roact.createElement
	local frame = focusable.Frame
	local v8 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		defaultChild = self.gridViewRef,
		restorePreviousChildFocus = true,
		inputBindings = 0
	}

	local v9 = {
		NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.navigateBack),
		ToggleMultiSelect = 0,
		Delete = 0,
		Rename = 0
	}

	local v10 = if not v5 then RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, self.selectButtonPressed, {
		key = self.state.multiSelectionEnabled and "Feature.Avatar.Action.CancelSelection" or "Feature.Avatar.Action.SelectMultipleItems"
	}) else nil
	v9.ToggleMultiSelect = v10

	local v11 = if #self.state.selectedOutfits > 0 then RoactGamepad.Input.onBegin(
		Enum.KeyCode.ButtonX,
		self.deleteOutfit,
		{ key = "Feature.Avatar.Action.Delete" }
	) else nil
	v9.Delete = v11

	local v12 = if v6 then RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, self.renameOutfit, {
		key = "Feature.Avatar.Action.Rename"
	}) else nil
	v9.Rename = v12
	v8.inputBindings = v9

	local v13 = {
		LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = self.lastInputTypeChangedCallback
		}),
		NavOverlayPageContainer = 0
	}

	local createElement2 = Roact.createElement
	local v15 = {
		headerBarProps = {
			title = p2.manage,
			renderLeft = self.renderExitButton,
			renderRight = function()
				return self:renderRightTopBarButton(p2, p3, p4)
			end
		},
		ZIndex = 1,
		onDismiss = self.navigateBack
	}

	local createElement3 = Roact.createElement
	local gridViewRefsByRef = {}
	gridViewRefsByRef.onToggleOutfitCard = self.onToggleOutfitCard
	gridViewRefsByRef.selectedOutfits = self.state.selectedOutfits
	gridViewRefsByRef.selectionUpdated = self.selectedOutfitUpdated
	gridViewRefsByRef.canScrollUpdated = self.outfitGridCanScrollUpdated
	gridViewRefsByRef.multiSelect = self.state.multiSelectionEnabled
	gridViewRefsByRef.goBack = self.navigateBack
	gridViewRefsByRef.pageOwner = avatarScreen.ManageOutfitPage

	gridViewRefsByRef.NextSelectionUp = self.exitButtonRef

	local v18 = if self.state.multiSelectionEnabled then self.actionBarRef else nil
	gridViewRefsByRef.NextSelectionDown = v18

	gridViewRefsByRef.NextSelectionRight = v7
	gridViewRefsByRef[Roact.Ref] = self.gridViewRef
	local v16 = {
		OutfitSelectionGrid = createElement3(module5, gridViewRefsByRef),
		ManageActionBar = 0
	}
	local v19

	if self.state.multiSelectionEnabled then
		local createElement4 = Roact.createElement
		local actionBarRefsByRef = {
			gradientFade = self.state.outfitGridCanScroll,
			multiSelect = true,
			selectedOutfits = self.state.selectedOutfits,
			bottomPadding = GAMEPAD_BOTTOM_BAR_SIZE,
			deleteOutfit = self.deleteOutfit,
			renameOutfit = self.renameOutfit,
			ZIndex = 2,
			NextSelectionUp = self.gridViewRef,
			[Roact.Ref] = self.actionBarRef
		}
		v19 = createElement4(module6, actionBarRefsByRef) or nil
	end

	v16.ManageActionBar = v19
	v13.NavOverlayPageContainer = createElement2(module4, v15, v16)
	return createElement(frame, v8, v13)
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
	local v5 = not (#p2.state.selectedOutfits == 1) and #p4.selectedOutfits == 1

	if not p2.state.multiSelectionEnabled and v5 then
		module7.closeAllDialogs(p2.props.navigation)
		module7.closeFiltersAndItemDetails(p2.props.navigation)
	end
end

local function mapDispatchToProps(callback)
	return {
		navigateWithLock = function(p2)
			callback(navigateWithLock(p2))
		end
	}
end

local v5 = RoactRodux.connect(nil, mapDispatchToProps)(extended)

local v6 = roactServices.connect({ avatarEditorAnalytics = module3 })(v5)

return (module2((roactAppPolicy.connect(function(p2, p3)
	return { showCustomOutfitNames = p2.getCustomOutfitNames() }
end)(v6))))
