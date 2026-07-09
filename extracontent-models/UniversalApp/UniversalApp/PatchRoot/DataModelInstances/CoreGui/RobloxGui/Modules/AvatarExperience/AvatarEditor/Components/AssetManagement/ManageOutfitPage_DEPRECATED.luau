local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local FitTextLabel = FitFrame.FitTextLabel
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Constants = require(Modules.LuaApp.Constants)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local SlotBasedEditorAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics
local NavOverlayPageContainer = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.NavOverlayPageContainer)
local OutfitSelectionGrid = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitSelectionGrid)
local ManageActionBar = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.ManageActionBar)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local mutedError = require(Modules.LuaApp.mutedError)
local FFlagAXAddManageOutfitClickTracking = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAddManageOutfitClickTracking
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXFixDeselectOutfitInManage = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixDeselectOutfitInManage
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Focusable = RoactGamepad.Focusable
local v40 = Images["icons/navigation/close"]
local v41 = GuiService:IsTenFootInterface()
local v42 = Roact.PureComponent:extend("ManageOutfitPage")

v42.validateProps = t.strictInterface({
	navigateWithLock = t.callback,
	navigation = t.table,
	avatarRoute = t.table,
	showCustomOutfitNames = t.boolean,
	avatarEditorAnalytics = t.table
})

function v42.init(p1) -- line: 82
	-- upvalues: UserInputService (copy), isGamepadInput (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), Roact (copy), withStyle (copy), IconButton (copy), v40 (copy), IconSize (copy), NavigationUtils (copy), logOnOverlayClosed (copy), FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), AvatarScreen (copy), FFlagAXFixDeselectOutfitInManage (copy), mutedError (copy)
	local LastInputType = UserInputService:GetLastInputType()
	local v48 = isGamepadInput(LastInputType)

	p1:setState({
		multiSelectionEnabled = false,
		outfitGridCanScroll = false,
		selectedOutfits = {},
		exitButtonPosition = Vector2.new(0, 0),
		isGamepad = v48
	})
	p1.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.createFocusController() else nil
	p1.exitButtonRef = Roact.createRef()
	p1.selectButtonRef = Roact.createRef()
	p1.gridViewRef = Roact.createRef()
	p1.actionBarRef = Roact.createRef()
	p1.peekViewRef = Roact.createRef()
	p1.outfitDetailsPeekViewRefs = RoactGamepad.createRefCache()

	function p1.navigateBack() -- line: 103
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
	function p1.selectedOutfitUpdated(p2) -- line: 107
		-- upvalues: p1 (copy)
		if typeof(p2) == "string" then
			p1:setState({
				selectedOutfits = { p2 }
			})

			return
		end

		p1:setState({
			selectedOutfits = p2 or {}
		})
	end
	function p1.exitButtonPositionChanged(p3) -- line: 119
		-- upvalues: p1 (copy)
		if p3.AbsolutePosition ~= p1.state.exitButtonPosition then
			p1:setState({
				exitButtonPosition = p3.AbsolutePosition
			})
		end
	end
	function p1.renderExitButton() -- line: 127
		-- upvalues: withStyle (copy), Roact (copy), IconButton (copy), v40 (copy), IconSize (copy), p1 (copy)
		return withStyle(function(p4) -- line: 128
			-- upvalues: Roact (copy), IconButton (copy), v40 (copy), IconSize (copy), p1 (copy)
			local Theme = p4.Theme

			return Roact.createElement(IconButton, {
				size = UDim2.new(0, 44, 1, 0),
				icon = v40,
				iconSize = IconSize.Medium,
				iconColor3 = Theme.SystemPrimaryDefault.Color,
				iconTransparency = Theme.SystemPrimaryDefault.Transparency,
				onActivated = p1.navigateBack,
				buttonRef = p1.exitButtonRef,
				NextSelectionDown = p1.gridViewRef,
				NextSelectionRight = p1.selectButtonRef,
				onAbsolutePositionChanged = p1.exitButtonPositionChanged
			})
		end)
	end
	function p1.selectButtonPressed() -- line: 147
		-- upvalues: p1 (copy), NavigationUtils (copy)
		p1:setState({
			multiSelectionEnabled = not p1.state.multiSelectionEnabled
		})
		NavigationUtils.closeFiltersAndItemDetails(p1.props.navigation)
	end
	function p1.outfitGridCanScrollUpdated(p5) -- line: 155
		-- upvalues: p1 (copy)
		if p5 ~= p1.state.outfitGridCanScroll then
			p1:setState({
				outfitGridCanScroll = p5
			})
		end
	end
	function p1.onPeekViewClosed() -- line: 163
		-- upvalues: p1 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		p1:setState({
			selectedOutfits = {}
		})

		if not FFlagAXMigrateAXToGlobalAutofocus and p1.state.isGamepad then
			p1.focusController.captureFocus()
		end
	end
	function p1.onOverlayClosed() -- line: 174
		-- upvalues: p1 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		local isGamepad = p1.state.isGamepad

		logOnOverlayClosed("ManageOutfitPage", isGamepad)

		if not FFlagAXMigrateAXToGlobalAutofocus and isGamepad then
			p1.focusController.captureFocus()
		end
	end
	function p1.deleteOutfit() -- line: 184
		-- upvalues: FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), p1 (copy), AvatarScreen (copy)
		if FFlagAXAddManageOutfitClickTracking then
			SlotBasedEditorAnalytics.trackDeleteAvatarAttemptClick(p1.state.multiSelectionEnabled)
		end

		local function onDeleteOverlayClosed() -- line: 189
			-- upvalues: p1 (copy)
			if p1.state.multiSelectionEnabled then
				p1:setState({
					multiSelectionEnabled = false
				})
			end

			p1.onOverlayClosed()
		end

		p1.props.navigation.navigate(AvatarScreen.DeleteOutfitPrompt, {
			outfitIds = p1.state.selectedOutfits,
			onOverlayClosed = onDeleteOverlayClosed
		})
	end
	function p1.renameOutfit() -- line: 208
		-- upvalues: FFlagAXFixDeselectOutfitInManage (copy), p1 (copy), mutedError (copy), AvatarScreen (copy)
		if FFlagAXFixDeselectOutfitInManage and (not p1.state.selectedOutfits or not p1.state.selectedOutfits[1]) then
			mutedError("Tried to rename an outfit with no outfit selected", p1.state.selectedOutfits)

			return
		end

		p1.props.navigation.navigate(AvatarScreen.RenameOutfitPrompt, {
			costumeId = p1.state.selectedOutfits[1],
			onOverlayClosed = p1.onOverlayClosed
		})
	end
	function p1.lastInputTypeChangedCallback() -- line: 220
		-- upvalues: UserInputService (copy), isGamepadInput (copy), p1 (copy)
		local LastInputType2 = UserInputService:GetLastInputType()
		local v79 = isGamepadInput(LastInputType2)

		if v79 ~= p1.state.isGamepad then
			p1:setState({
				isGamepad = v79
			})
		end
	end
	function p1.onToggleOutfitCard(p6, p7) -- line: 230
		-- upvalues: p1 (copy), NavigationUtils (copy), AvatarScreen (copy)
		local navigation = p1.props.navigation

		if p6 then
			local t1 = {
				ZIndex = 2,
				outfitId = p7,
				onPeekViewClosed = p1.onPeekViewClosed,
				exitButtonPosition = p1.state.exitButtonPosition,
				deleteOutfit = p1.deleteOutfit,
				renameOutfit = p1.renameOutfit,
				NextSelectionLeft = not p1.props.isPortrait and p1.gridViewRef or nil,
				outfitDetailsPeekViewRefs = p1.outfitDetailsPeekViewRefs
			}

			p1.props.navigateWithLock(function() -- line: 244
				-- upvalues: NavigationUtils (copy), navigation (copy), AvatarScreen (copy), t1 (copy)
				NavigationUtils.closeFiltersAndItemDetails(navigation)
				NavigationUtils.closeTryOnManager(navigation)
				navigation.navigate(AvatarScreen.OutfitDetails, t1)
			end)

			return
		end

		NavigationUtils.closeFiltersAndItemDetails(navigation)
	end
end
function v42.renderRightTopBarButton(p8, p9, p10, p11) -- line: 260
	-- upvalues: Roact (copy), Focusable (copy), FitTextLabel (copy), CursorKind (copy)
	local select = p9.select

	if p8.state.multiSelectionEnabled then
		select = p9.cancel
	end

	local Header2Font = p10.Font.Header2.Font
	local v55 = p10.Font.BaseSize * p10.Font.Header2.RelativeSize

	return Roact.createElement(Focusable[FitTextLabel], {
		width = FitTextLabel.Width.FitToText,
		onActivated = p8.selectButtonPressed,
		BackgroundTransparency = 1,
		Text = select,
		Font = Header2Font,
		LayoutOrder = 1,
		TextColor3 = p10.Theme.TextEmphasis.Color,
		TextSize = v55,
		SelectionImageObject = p11(CursorKind.RoundedRect),
		NextSelectionLeft = p8.exitButtonRef,
		NextSelectionDown = p8.gridViewRef,
		[Roact.Ref] = p8.selectButtonRef
	})
end
function v42.renderWithProviders(p12, p13, p14, p15) -- line: 287
	-- upvalues: v41 (copy), Constants (copy), Roact (copy), Focusable (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), ExternalEventConnection (copy), UserInputService (copy), BoundInputsUpdater (copy), NavOverlayPageContainer (copy), OutfitSelectionGrid (copy), AvatarScreen (copy), ManageActionBar (copy)
	local v60 = false

	if not p12.state.multiSelectionEnabled and #p12.state.selectedOutfits == 1 then
		v60 = true
	end

	local v61 = not p12.state.multiSelectionEnabled and (p12.props.showCustomOutfitNames and #p12.state.selectedOutfits == 1)
	local GAMEPAD_BOTTOM_BAR_SIZE = nil

	if p12.state.isGamepad and v41 then
		GAMEPAD_BOTTOM_BAR_SIZE = Constants.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local v63 = if not v60 then nil else p12.peekViewRef

	if v60 then
		local key = p12.props.avatarRoute.current.key

		v63 = p12.outfitDetailsPeekViewRefs[key]
	end

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		restorePreviousChildFocus = true,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p12.focusController else nil,
		defaultChild = p12.gridViewRef,
		inputBindings = {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p12.navigateBack),
			ToggleMultiSelect = if v60 then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, p12.selectButtonPressed, {
				key = not p12.state.multiSelectionEnabled and "Feature.Avatar.Action.SelectMultipleItems" or "Feature.Avatar.Action.CancelSelection"
			}),
			Delete = if not (#p12.state.selectedOutfits > 0) then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, p12.deleteOutfit, {
				key = "Feature.Avatar.Action.Delete"
			}),
			Rename = if not v61 then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, p12.renameOutfit, {
				key = "Feature.Avatar.Action.Rename"
			})
		}
	}, {
		LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = p12.lastInputTypeChangedCallback
		}),
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil,
		NavOverlayPageContainer = Roact.createElement(NavOverlayPageContainer, {
			ZIndex = 1,
			headerBarProps = {
				title = p13.manage,
				renderLeft = p12.renderExitButton,
				renderRight = function() -- line: 349
					-- upvalues: p12 (copy), p13 (copy), p14 (copy), p15 (copy)
					return p12:renderRightTopBarButton(p13, p14, p15)
				end
			},
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p12.focusController else nil,
			onDismiss = p12.navigateBack
		}, {
			OutfitSelectionGrid = Roact.createElement(OutfitSelectionGrid, {
				onToggleOutfitCard = p12.onToggleOutfitCard,
				selectedOutfits = p12.state.selectedOutfits,
				selectionUpdated = p12.selectedOutfitUpdated,
				canScrollUpdated = p12.outfitGridCanScrollUpdated,
				multiSelect = p12.state.multiSelectionEnabled,
				goBack = p12.navigateBack,
				pageOwner = AvatarScreen.ManageOutfitPage,
				NextSelectionUp = p12.exitButtonRef,
				NextSelectionDown = if not p12.state.multiSelectionEnabled then nil else p12.actionBarRef,
				NextSelectionRight = v63,
				[Roact.Ref] = p12.gridViewRef
			}),
			ManageActionBar = p12.state.multiSelectionEnabled and Roact.createElement(ManageActionBar, {
				gradientFade = p12.state.outfitGridCanScroll,
				multiSelect = true,
				selectedOutfits = p12.state.selectedOutfits,
				bottomPadding = GAMEPAD_BOTTOM_BAR_SIZE,
				deleteOutfit = p12.deleteOutfit,
				renameOutfit = p12.renameOutfit,
				ZIndex = 2,
				NextSelectionUp = p12.gridViewRef,
				[Roact.Ref] = p12.actionBarRef
			}) or nil
		})
	})
end
function v42.render(p16) -- line: 394
	-- upvalues: withLocalization (copy), withStyle (copy), withSelectionCursorProvider (copy)
	return withLocalization({
		manage = "Feature.Avatar.Heading.Manage",
		select = "Feature.Avatar.Action.Select",
		cancel = "Feature.Avatar.Action.Cancel"
	})(function(p17) -- line: 399
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), p16 (copy)
		return withStyle(function(p18) -- line: 400
			-- upvalues: withSelectionCursorProvider (copy), p16 (copy), p17 (copy)
			return withSelectionCursorProvider(function(p19) -- line: 401
				-- upvalues: p16 (copy), p17 (copy), p18 (copy)
				return p16:renderWithProviders(p17, p18, p19)
			end)
		end)
	end)
end
function v42.didUpdate(p20, _, p22) -- line: 408
	-- upvalues: FFlagAXFixDeselectOutfitInManage (copy), NavigationUtils (copy)
	local v69 = #p20.state.selectedOutfits ~= 1 and #p22.selectedOutfits == 1

	if not p20.state.multiSelectionEnabled and v69 then
		if FFlagAXFixDeselectOutfitInManage then
			NavigationUtils.closeAllDialogs(p20.props.navigation)
		end

		NavigationUtils.closeFiltersAndItemDetails(p20.props.navigation)
	end
end

local function mapDispatchToProps(p23) -- line: 418
	-- upvalues: NavigateWithLock (copy)
	return {
		navigateWithLock = function(p24) -- line: 420
			-- upvalues: p23 (copy), NavigateWithLock (copy)
			p23(NavigateWithLock(p24))
		end
	}
end

local v44 = RoactRodux.connect(nil, mapDispatchToProps)(v42)
local v45 = RoactServices.connect({
	avatarEditorAnalytics = Analytics
})(v44)

return (withStackVisibilityWrapper((RoactAppPolicy.connect(function(p25, _) -- line: 432
	return {
		showCustomOutfitNames = p25.getCustomOutfitNames()
	}
end)(v45))))
