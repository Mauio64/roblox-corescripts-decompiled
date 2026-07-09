local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local FitTextLabel = FitFrame.FitTextLabel
local Constants = require(Modules.LuaApp.Constants)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)

require(CorePackages.Packages.ReactFocusNavigation)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local useFocusOnMountEffect = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useFocusOnMountEffect
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
local useManageOutfitPageFocusNavigationBindings = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.useManageOutfitPageFocusNavigationBindings)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXAddManageOutfitClickTracking = AvatarExperienceFlags.FFlagAXAddManageOutfitClickTracking
local FFlagAXFixDeselectOutfitInManage = AvatarExperienceFlags.FFlagAXFixDeselectOutfitInManage
local FFlagAXFixGamepadNavigationOnOutfitManagement = AvatarExperienceFlags.FFlagAXFixGamepadNavigationOnOutfitManagement
local v42 = game:DefineFastFlag("AXFocusOnMountManageOutfitPage", false)
local mutedError = require(Modules.LuaApp.mutedError)
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Focusable = RoactGamepad.Focusable
local v51 = Images["icons/navigation/close"]
local v52 = GuiService:IsTenFootInterface()
local v53 = Roact.PureComponent:extend("ManageOutfitPage")

v53.validateProps = t.strictInterface({
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
	focusNavigationRef = t.union(t.callback, t.table),
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil
})

function v53.init(p1) -- line: 114
	-- upvalues: Roact (copy), RoactGamepad (copy), withStyle (copy), IconButton (copy), v51 (copy), IconSize (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), NavigationUtils (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), logOnOverlayClosed (copy), FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), AvatarScreen (copy), FFlagAXFixDeselectOutfitInManage (copy), mutedError (copy), UserInputService (copy), isGamepadInput (copy)
	p1.exitButtonRef = Roact.createRef()
	p1.selectButtonRef = Roact.createRef()
	p1.gridViewRef = Roact.createRef()
	p1.actionBarRef = Roact.createRef()
	p1.peekViewRef = Roact.createRef()
	p1.outfitDetailsPeekViewRefs = RoactGamepad.createRefCache()

	function p1.navigateBack() -- line: 122
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
	function p1.selectedOutfitUpdated(p2) -- line: 126
		-- upvalues: p1 (copy)
		if typeof(p2) == "string" then
			p1.props.setSelectedOutfits({ p2 })

			return
		end

		p1.props.setSelectedOutfits(p2 or {})
	end
	function p1.exitButtonPositionChanged(p3) -- line: 134
		-- upvalues: p1 (copy)
		if p3.AbsolutePosition ~= p1.props.exitButtonPosition then
			p1.props.setExitButtonPosition(p3.AbsolutePosition)
		end
	end
	function p1.renderExitButton() -- line: 140
		-- upvalues: withStyle (copy), Roact (copy), IconButton (copy), v51 (copy), IconSize (copy), p1 (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy)
		return withStyle(function(p4) -- line: 141
			-- upvalues: Roact (copy), IconButton (copy), v51 (copy), IconSize (copy), p1 (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy)
			local Theme = p4.Theme

			return Roact.createElement(IconButton, {
				size = UDim2.new(0, 44, 1, 0),
				icon = v51,
				iconSize = IconSize.Medium,
				iconColor3 = Theme.SystemPrimaryDefault.Color,
				iconTransparency = Theme.SystemPrimaryDefault.Transparency,
				onActivated = p1.navigateBack,
				buttonRef = p1.exitButtonRef,
				NextSelectionDown = if not FFlagAXFixGamepadNavigationOnOutfitManagement then p1.gridViewRef else nil,
				NextSelectionRight = if not FFlagAXFixGamepadNavigationOnOutfitManagement then p1.selectButtonRef else nil,
				onAbsolutePositionChanged = p1.exitButtonPositionChanged
			})
		end)
	end
	function p1.selectButtonPressed() -- line: 162
		-- upvalues: p1 (copy), NavigationUtils (copy)
		p1.props.setMultiSelectionEnabled(not p1.props.multiSelectionEnabled)
		NavigationUtils.closeFiltersAndItemDetails(p1.props.navigation)
	end
	function p1.outfitGridCanScrollUpdated(p5) -- line: 167
		-- upvalues: p1 (copy)
		if p5 ~= p1.props.outfitGridCanScroll then
			p1.props.setOutfitGridCanScroll(p5)
		end
	end
	function p1.onPeekViewClosed() -- line: 173
		-- upvalues: p1 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		p1.props.setSelectedOutfits({})

		if not FFlagAXMigrateAXToGlobalAutofocus and p1.props.isGamepad then
			p1.props.focusController.captureFocus()
		end
	end
	function p1.onOverlayClosed() -- line: 182
		-- upvalues: p1 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		local isGamepad = p1.props.isGamepad

		logOnOverlayClosed("ManageOutfitPage", isGamepad)

		if not FFlagAXMigrateAXToGlobalAutofocus and isGamepad then
			p1.props.focusController.captureFocus()
		end
	end
	function p1.deleteOutfit() -- line: 192
		-- upvalues: FFlagAXAddManageOutfitClickTracking (copy), SlotBasedEditorAnalytics (copy), p1 (copy), AvatarScreen (copy)
		if FFlagAXAddManageOutfitClickTracking then
			SlotBasedEditorAnalytics.trackDeleteAvatarAttemptClick(p1.state.multiSelectionEnabled)
		end

		local function onDeleteOverlayClosed() -- line: 197
			-- upvalues: p1 (copy)
			if p1.props.multiSelectionEnabled then
				p1.props.setMultiSelectionEnabled(false)
			end

			p1.onOverlayClosed()
		end

		p1.props.navigation.navigate(AvatarScreen.DeleteOutfitPrompt, {
			outfitIds = p1.props.selectedOutfits,
			onOverlayClosed = onDeleteOverlayClosed
		})
	end
	function p1.renameOutfit() -- line: 214
		-- upvalues: FFlagAXFixDeselectOutfitInManage (copy), p1 (copy), mutedError (copy), AvatarScreen (copy)
		if FFlagAXFixDeselectOutfitInManage and (not p1.props.selectedOutfits or not p1.props.selectedOutfits[1]) then
			mutedError("Tried to rename an outfit with no outfit selected", p1.props.selectedOutfits)

			return
		end

		p1.props.navigation.navigate(AvatarScreen.RenameOutfitPrompt, {
			costumeId = p1.props.selectedOutfits[1],
			onOverlayClosed = p1.onOverlayClosed
		})
	end
	function p1.lastInputTypeChangedCallback() -- line: 226
		-- upvalues: UserInputService (copy), isGamepadInput (copy), p1 (copy)
		local LastInputType = UserInputService:GetLastInputType()
		local v111 = isGamepadInput(LastInputType)

		if v111 ~= p1.props.isGamepad then
			p1.props.setIsGamepad(v111)
		end
	end
	function p1.onToggleOutfitCard(p6, p7) -- line: 234
		-- upvalues: p1 (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), NavigationUtils (copy), AvatarScreen (copy)
		local navigation = p1.props.navigation

		if p6 then
			local t1 = {
				ZIndex = 2,
				outfitId = p7,
				onPeekViewClosed = p1.onPeekViewClosed,
				exitButtonPosition = p1.props.exitButtonPosition,
				deleteOutfit = p1.deleteOutfit,
				renameOutfit = p1.renameOutfit,
				NextSelectionLeft = if not FFlagAXFixGamepadNavigationOnOutfitManagement then not p1.props.isPortrait and p1.gridViewRef or nil else nil,
				outfitDetailsPeekViewRefs = p1.outfitDetailsPeekViewRefs
			}

			p1.props.navigateWithLock(function() -- line: 250
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
function v53.renderRightTopBarButton(p8, p9, p10, p11) -- line: 266
	-- upvalues: Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FitTextLabel (copy), Focusable (copy), CursorKind (copy)
	local select = p9.select

	if p8.props.multiSelectionEnabled then
		select = p9.cancel
	end

	local Header2Font = p10.Font.Header2.Font
	local v63 = p10.Font.BaseSize * p10.Font.Header2.RelativeSize

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[FitTextLabel] else FitTextLabel, {
		width = FitTextLabel.Width.FitToText,
		onActivated = p8.selectButtonPressed,
		BackgroundTransparency = 1,
		Text = select,
		Font = Header2Font,
		LayoutOrder = 1,
		TextColor3 = p10.Theme.TextEmphasis.Color,
		TextSize = v63,
		SelectionImageObject = p11(CursorKind.RoundedRect),
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then p8.exitButtonRef else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p8.gridViewRef else nil,
		[Roact.Ref] = p8.selectButtonRef
	})
end
function v53.renderWithProviders(p12, p13, p14, p15) -- line: 293
	-- upvalues: v52 (copy), Constants (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), ExternalEventConnection (copy), UserInputService (copy), BoundInputsUpdater (copy), NavOverlayPageContainer (copy), OutfitSelectionGrid (copy), AvatarScreen (copy), ManageActionBar (copy)
	local v68 = false

	if not p12.props.multiSelectionEnabled and #p12.props.selectedOutfits == 1 then
		v68 = true
	end

	local GAMEPAD_BOTTOM_BAR_SIZE = nil

	if p12.props.isGamepad and v52 then
		GAMEPAD_BOTTOM_BAR_SIZE = Constants.GAMEPAD_BOTTOM_BAR_SIZE
	end

	if v68 then
		local _ = p12.peekViewRef
	end

	if v68 then
		local key = p12.props.avatarRoute.current.key

		if FFlagAXFixGamepadNavigationOnOutfitManagement then
		else
			local _ = p12.outfitDetailsPeekViewRefs[key]
		end
	end

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p12.props.focusController else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p12.gridViewRef else nil,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil
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
				renderRight = function() -- line: 329
					-- upvalues: p12 (copy), p13 (copy), p14 (copy), p15 (copy)
					return p12:renderRightTopBarButton(p13, p14, p15)
				end
			},
			forwardRef = p12.props.focusNavigationRef,
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p12.props.focusController else nil,
			onDismiss = if not FFlagAXFixGamepadNavigationOnOutfitManagement then p12.navigateBack else nil
		}, {
			OutfitSelectionGrid = Roact.createElement(OutfitSelectionGrid, {
				onToggleOutfitCard = p12.onToggleOutfitCard,
				selectedOutfits = p12.props.selectedOutfits,
				selectionUpdated = p12.selectedOutfitUpdated,
				canScrollUpdated = p12.outfitGridCanScrollUpdated,
				multiSelect = p12.props.multiSelectionEnabled,
				goBack = p12.navigateBack,
				pageOwner = AvatarScreen.ManageOutfitPage,
				NextSelectionUp = if not FFlagAXFixGamepadNavigationOnOutfitManagement then p12.exitButtonRef else nil,
				NextSelectionDown = if not FFlagAXFixGamepadNavigationOnOutfitManagement then if not p12.props.multiSelectionEnabled then nil else p12.actionBarRef else nil,
				NextSelectionRight = nil,
				[Roact.Ref] = p12.gridViewRef
			}),
			ManageActionBar = p12.props.multiSelectionEnabled and Roact.createElement(ManageActionBar, {
				gradientFade = p12.props.outfitGridCanScroll,
				multiSelect = true,
				selectedOutfits = p12.props.selectedOutfits,
				bottomPadding = GAMEPAD_BOTTOM_BAR_SIZE,
				deleteOutfit = p12.deleteOutfit,
				renameOutfit = p12.renameOutfit,
				ZIndex = 2,
				NextSelectionUp = if not FFlagAXFixGamepadNavigationOnOutfitManagement then p12.gridViewRef else nil,
				[Roact.Ref] = p12.actionBarRef
			}) or nil
		})
	})
end
function v53.render(p16) -- line: 378
	-- upvalues: withLocalization (copy), withStyle (copy), withSelectionCursorProvider (copy)
	return withLocalization({
		manage = "Feature.Avatar.Heading.Manage",
		select = "Feature.Avatar.Action.Select",
		cancel = "Feature.Avatar.Action.Cancel"
	})(function(p17) -- line: 383
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), p16 (copy)
		return withStyle(function(p18) -- line: 384
			-- upvalues: withSelectionCursorProvider (copy), p16 (copy), p17 (copy)
			return withSelectionCursorProvider(function(p19) -- line: 385
				-- upvalues: p16 (copy), p17 (copy), p18 (copy)
				return p16:renderWithProviders(p17, p18, p19)
			end)
		end)
	end)
end
function v53.didUpdate(p20, p21, _) -- line: 392
	-- upvalues: FFlagAXFixDeselectOutfitInManage (copy), NavigationUtils (copy)
	local v77 = #p20.props.selectedOutfits ~= 1 and #p21.selectedOutfits == 1

	if not p20.props.multiSelectionEnabled and v77 then
		if FFlagAXFixDeselectOutfitInManage then
			NavigationUtils.closeAllDialogs(p20.props.navigation)
		end

		NavigationUtils.closeFiltersAndItemDetails(p20.props.navigation)
	end
end

local function mapDispatchToProps(p23) -- line: 402
	-- upvalues: NavigateWithLock (copy)
	return {
		navigateWithLock = function(p24) -- line: 404
			-- upvalues: p23 (copy), NavigateWithLock (copy)
			p23(NavigateWithLock(p24))
		end
	}
end

local u55 = withStackVisibilityWrapper((RoactRodux.connect(nil, mapDispatchToProps)(v53)))

return function(p25) -- line: 414
	-- upvalues: useRoactService (copy), Analytics (copy), useAppPolicy (copy), UserInputService (copy), isGamepadInput (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), FocusNavigationEventNameEnum (copy), NavigationUtils (copy), logOnOverlayClosed (copy), AvatarScreen (copy), FFlagAXFixDeselectOutfitInManage (copy), mutedError (copy), useManageOutfitPageFocusNavigationBindings (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), v42 (copy), useFocusOnMountEffect (copy), u55 (ref), Cryo (copy)
	local v80 = useRoactService(Analytics)
	local v81 = useAppPolicy(function(p26) -- line: 416
		return p26.getCustomOutfitNames()
	end)
	local LastInputType = UserInputService:GetLastInputType()
	local v83 = isGamepadInput(LastInputType)
	local v84 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useMemo(function() -- line: 423
		-- upvalues: RoactGamepad (copy)
		return RoactGamepad.createFocusController()
	end, {}) else nil
	local v85, v86 = React.useState(false)
	local v87, v88 = React.useState(false)
	local v89, v90 = React.useState({})
	local v91, v92 = React.useState(Vector2.new(0, 0))
	local v93, v94 = React.useState(v83)
	local v95 = React.useRef(nil)
	local v96 = React.useMemo(function() -- line: 435
		-- upvalues: FocusNavigationEventNameEnum (copy), v85 (copy)
		return {
			[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonL3] = if not v85 then FocusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect else FocusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect,
			[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.ManageOutfitsDelete,
			[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.ManageOutfitsRename
		}
	end, { v85 })
	local v97 = React.useCallback(function() -- line: 449
		-- upvalues: p25 (copy)
		p25.navigation.goBack()
	end, { p25.navigation.goBack })
	local v98 = React.useCallback(function() -- line: 453
		-- upvalues: v86 (copy), NavigationUtils (copy), p25 (copy)
		v86(true)
		NavigationUtils.closeFiltersAndItemDetails(p25.navigation)
	end, { p25.navigation })
	local v99 = React.useCallback(function() -- line: 458
		-- upvalues: v86 (copy), NavigationUtils (copy), p25 (copy)
		v86(false)
		NavigationUtils.closeFiltersAndItemDetails(p25.navigation)
	end, { p25.navigation })
	local v100 = React.useCallback(function() -- line: 464
		-- upvalues: v85 (copy), v86 (copy), v93 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v84 (copy), p25 (copy), AvatarScreen (copy), v89 (copy)
		local function onDeleteOverlayClosed() -- line: 465
			-- upvalues: v85 (copy), v86 (copy), v93 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v84 (copy)
			if v85 then
				v86(false)
			end

			local v123 = v93

			logOnOverlayClosed("ManageOutfitPage", v123)

			if not FFlagAXMigrateAXToGlobalAutofocus and v123 then
				v84.captureFocus()
			end
		end

		p25.navigation.navigate(AvatarScreen.DeleteOutfitPrompt, {
			outfitIds = v89,
			onOverlayClosed = onDeleteOverlayClosed
		})
	end, {
		v89,
		v85,
		v93,
		p25.navigation,
		if not FFlagAXMigrateAXToGlobalAutofocus then v84 else nil
	})
	local v101 = React.useCallback(function() -- line: 494
		-- upvalues: FFlagAXFixDeselectOutfitInManage (copy), v89 (copy), mutedError (copy), v93 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v84 (copy), p25 (copy), AvatarScreen (copy)
		if FFlagAXFixDeselectOutfitInManage and (not v89 or not v89[1]) then
			mutedError("Tried to rename an outfit with no outfit selected", v89)

			return
		end

		p25.navigation.navigate(AvatarScreen.RenameOutfitPrompt, {
			costumeId = v89[1],
			onOverlayClosed = function() -- line: 499
				-- upvalues: v93 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v84 (copy)
				local v124 = v93

				logOnOverlayClosed("ManageOutfitPage", v124)

				if not FFlagAXMigrateAXToGlobalAutofocus and v124 then
					v84.captureFocus()
				end
			end
		})
	end, {
		p25.navigation,
		v89,
		v93,
		if not FFlagAXMigrateAXToGlobalAutofocus then v84 else nil
	})
	local v102 = not v85 and #v89 == 1
	local v103 = not v85 and (v81 and #v89 == 1)
	local v104 = useManageOutfitPageFocusNavigationBindings(v95, v96, {
		onGoBack = v97,
		onToggleMultiselect = if v102 or v85 then nil else v98,
		onCancelMultiselect = if v102 or not v85 then nil else v99,
		onDelete = if not (#v89 > 0) then nil else v100,
		onRename = if not v103 then nil else v101
	})

	useFocusNavigableSurfaceRegistryConnection(v95 and v95.current, FocusNavigableSurfaceIdentifierEnum.SubRouterView)

	if v42 then
		useFocusOnMountEffect(v95)
	end

	return React.createElement(u55, Cryo.Dictionary.join(p25, {
		multiSelectionEnabled = v85,
		setMultiSelectionEnabled = v86,
		outfitGridCanScroll = v87,
		setOutfitGridCanScroll = v88,
		selectedOutfits = v89,
		setSelectedOutfits = v90,
		exitButtonPosition = v91,
		setExitButtonPosition = v92,
		isGamepad = v93,
		setIsGamepad = v94,
		focusNavigationRef = v104,
		avatarEditorAnalytics = v80,
		showCustomOutfitNames = v81,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v84 else nil
	}))
end
