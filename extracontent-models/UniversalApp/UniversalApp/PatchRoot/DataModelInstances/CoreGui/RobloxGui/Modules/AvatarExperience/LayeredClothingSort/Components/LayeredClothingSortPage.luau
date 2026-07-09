local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local t = require(CorePackages.Packages.t)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Modules = CoreGui.RobloxGui.Modules
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local VerticalClothingList = require(Modules.AvatarExperience.LayeredClothingSort.Components.VerticalClothingList)
local ResetButton = require(Modules.AvatarExperience.LayeredClothingSort.Components.ResetButton)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local makeAvatarBackButton = require(Modules.AvatarExperience.Common.Components.TopBar.makeAvatarBackButton)
local SetLastSavedSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetLastSavedSort)
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local ClearRemovedItems = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearRemovedItems)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local FullView = AvatarExperienceCommon.Enums.FullView
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local VRAvatarRotateHandler = require(Modules.AvatarExperience.Common.Components.Scene.VRAvatarRotateHandler)
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local selectEquippedLCAccessoriesOrdered = require(Modules.AvatarExperience.LayeredClothingSort.Selectors.selectEquippedLCAccessoriesOrdered)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local hasClassicAccessories = require(Modules.AvatarExperience.LayeredClothingSort.Selectors.hasClassicAccessories)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local UnlockCharacterUpdates = require(Modules.AvatarExperience.LayeredClothingSort.Actions.UnlockCharacterUpdates)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)
local RefinementNavBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementNavBar)
local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local v56 = if not require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSceneGamepadHandlerInputBindings then require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler_DEPRECATED) else require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local t1 = {
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?) -- line: 99
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v80 = ReactFocusNavigation.useEventMap(t1, p1)
	local v81 = React.useMemo(function() -- line: 101
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy), p3 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4) -- line: 104
					-- upvalues: p2 (copy)
					p4.cancelled = true
					p2()
				end)
			},
			[FocusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = if not p3 then nil else {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, {
		p2,
		p3
	})

	return ReactFocusNavigation.useEventHandlerMap(v81, v80)
end

local t2 = {
	toastMessage = "Feature.Avatar.Message.LCSortClassicWarning",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local v70 = Images["icons/menu/about_large"]
local uDim = UDim.new(0, 10)
local v72 = Roact.PureComponent:extend("LayeredClothingSortPage")

v72.validateProps = t.strictInterface({
	wrappedFrameRef = t.table,
	setWrapperIsGamepad = t.callback,
	tokens = t.table,
	isPortrait = t.boolean,
	topBarHeight = t.number,
	equippedLCAssetIdsOrdered = t.table,
	equippedAssets = t.table,
	hasClassicAccessories = t.boolean,
	removedList = t.optional(t.table),
	isLocalUserSoothSayer = t.optional(t.boolean),
	setLastSavedSort = t.callback,
	setCurrentToastMessage = t.callback,
	setFullView = t.callback,
	setCurrentSort = t.callback,
	sendAnalytics = t.callback,
	setEntryPage = t.callback,
	clearRemovedItems = t.callback,
	unlockCharacterUpdates = t.callback,
	navigation = t.table,
	avatarRoute = t.table,
	avatarExperienceAnalytics = t.table,
	analytics = t.table
})

function v72.init(p5) -- line: 166
	-- upvalues: Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), IsVRAppBuild (copy), isGamepadInput (copy), UserInputService (copy), AvatarScreen (copy), logOnOverlayClosed (copy), makeAvatarBackButton (copy)
	p5.numAssetsUponPageEntry = nil
	p5.verticalClothingListRef = Roact.createRef()
	p5.topBarRef = Roact.createRef()
	p5.refinementNavBarRef = Roact.createRef()
	p5.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.createFocusController() else nil
	p5:setState({
		isDragging = false,
		lastInputIsGamepad = not IsVRAppBuild() and isGamepadInput(UserInputService:GetLastInputType())
	})
	p5.props.setWrapperIsGamepad(not IsVRAppBuild() and isGamepadInput(UserInputService:GetLastInputType()))

	function p5.onBackFromTopBar() -- line: 182
		-- upvalues: p5 (copy), AvatarScreen (copy)
		p5.props.unlockCharacterUpdates()
		p5.props.navigation.pop()
		p5.props.sendAnalytics(p5.props.analytics.avatarRefineGoBack)
		p5.props.setEntryPage(AvatarScreen.None)
	end
	function p5.lastInputTypeChangedCallback(p6) -- line: 201
		-- upvalues: isGamepadInput (copy), p5 (copy)
		local v125 = isGamepadInput(p6)

		if v125 ~= p5.state.lastInputIsGamepad then
			p5:setState({
				lastInputIsGamepad = v125
			})
			p5.props.setWrapperIsGamepad(v125)
		end
	end
	function p5.onOverlayClosed() -- line: 211
		-- upvalues: p5 (copy), AvatarScreen (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		return function() -- line: 212
			-- upvalues: p5 (copy), AvatarScreen (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
			if p5.state.lastInputIsGamepad and p5.props.avatarRoute.opaque.name == AvatarScreen.LayeredClothingSort then
				logOnOverlayClosed("LayeredClothingSort")

				if not FFlagAXMigrateAXToGlobalAutofocus then
					p5.focusController.captureFocus()
				end
			end
		end
	end
	function p5.onDragChange(p7) -- line: 225
		-- upvalues: p5 (copy)
		p5:setState({
			isDragging = p7
		})
	end

	p5.backButton = makeAvatarBackButton(p5.onBackFromTopBar)
end
function v72.saveSortOnPageEnter(p8) -- line: 234
	local t3 = {}

	for _, v86 in p8.props.equippedLCAssetIdsOrdered do
		if p8.props.equippedAssets[v86.typeId] and p8.props.equippedAssets[v86.typeId][v86.id] then
			v86.equipped = true
		end

		table.insert(t3, v86)
	end

	p8.props.setLastSavedSort(t3)
	p8.props.setCurrentSort(p8.props.equippedLCAssetIdsOrdered)
	p8.numAssetsUponPageEntry = #p8.props.equippedLCAssetIdsOrdered
end
function v72.onPageEntry(p9) -- line: 260
	-- upvalues: FullView (copy), t2 (copy)
	p9:saveSortOnPageEnter()
	p9.props.setFullView(p9.props.avatarExperienceAnalytics, FullView.SceneFullView)

	if p9.props.hasClassicAccessories then
		p9.props.setCurrentToastMessage(t2)
	end
end
function v72.renderTopBar(p10) -- line: 269
	-- upvalues: withLocalization (copy), Roact (copy), TopBar (copy)
	return withLocalization({
		clothingSorting = "Feature.Avatar.Title.LCSortPage"
	})(function(p11) -- line: 272
		-- upvalues: Roact (copy), TopBar (copy), p10 (copy)
		return Roact.createElement(TopBar.Container, {
			titleText = p11.clothingSorting,
			transparentBackground = true,
			hideSiteMessageBanner = p10.props.isPortrait,
			leftItem = p10.backButton,
			ZIndex = 1,
			[Roact.Ref] = p10.topBarRef,
			NextSelectionRight = p10.verticalClothingListRef,
			NextSelectionDown = p10.refinementNavBarRef
		})
	end)
end
function v72.render(p12) -- line: 286
	-- upvalues: withStyle (copy), withLocalization (copy)
	return withStyle(function(p13) -- line: 287
		-- upvalues: withLocalization (copy), p12 (copy)
		return withLocalization({
			noItemText = "Feature.Avatar.Message.LCSortNoEquipped"
		})(function(p14) -- line: 290
			-- upvalues: p12 (copy), p13 (copy)
			return p12:renderWithProviders(p13, p14)
		end)
	end)
end
function v72.renderWithProviders(p15, p16, p17) -- line: 296
	-- upvalues: Roact (copy), SceneInteractionFrame (copy), RoactGamepad (copy), VerticalClothingList (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ResetButton (copy), IsVRAppBuild (copy), VRAvatarRotateHandler (copy), Constants (copy), uDim (copy), ImageSetLabel (copy), v70 (copy), GetFFlagAXEnableSlotBasedEditor (copy), React (copy), RefinementControlBar (copy), RefinementNavBar (copy), GamepadFocusHandlerForPage (copy), ExternalEventConnection (copy), UserInputService (copy), BoundInputsUpdater (copy), v56 (copy)
	local p16Font = p16.Font
	local Theme = p16.Theme
	local v95 = #p15.props.equippedLCAssetIdsOrdered > 0
	local v96 = not v95 and p15.numAssetsUponPageEntry == 0
	local v97 = if not v95 then p15.topBarRef else p15.verticalClothingListRef
	local v98 = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 1, -p15.props.topBarHeight),
		Position = UDim2.fromOffset(0, p15.props.topBarHeight)
	}, {
		SceneInteractionFrame = Roact.createElement(SceneInteractionFrame),
		VerticalClothingList = not v96 and Roact.createElement(RoactGamepad.Focusable[VerticalClothingList], {
			[Roact.Ref] = p15.verticalClothingListRef,
			NextSelectionLeft = p15.refinementNavBarRef,
			lastInputIsGamepad = p15.state.lastInputIsGamepad,
			topBarRef = p15.topBarRef,
			focusControllerProp = if not FFlagAXMigrateAXToGlobalAutofocus then p15.focusController else nil,
			onDragChange = p15.onDragChange
		}),
		ResetButton = not v96 and Roact.createElement(ResetButton, {
			lastInputIsGamepad = p15.state.lastInputIsGamepad,
			isDragging = p15.state.isDragging
		}),
		VRAvatarRotateHandler = if not IsVRAppBuild() then nil else Roact.createElement(VRAvatarRotateHandler),
		NoItemsMessage = v96 and Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, Constants.NoItem.BottomPadding),
			Size = if not IsVRAppBuild() then UDim2.new(1, 0, 0, 100) else UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = not IsVRAppBuild() and 1 or 0
		}, {
			UICorner = if not IsVRAppBuild() then nil else Roact.createElement("UICorner", {
				CornerRadius = uDim
			}),
			NoItemsTextLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0, 0),
				Text = p17.noItemText,
				Font = p16Font.CaptionHeader.Font,
				TextSize = p15.props.tokens.Typography.BodyMedium.FontSize,
				TextColor3 = Theme.IconEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				NoItemsIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v70,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(0, -2, 0.5, 0),
					Size = UDim2.fromOffset(Constants.NoItem.IconSize, Constants.NoItem.IconSize),
					ImageColor3 = Theme.IconEmphasis.Color
				})
			})
		})
	})
	local t4 = {
		TopBar = p15:renderTopBar(p17),
		RefinementControlBar = if not GetFFlagAXEnableSlotBasedEditor() then nil else React.createElement(RefinementControlBar, {
			hideUndoRedo = true,
			ref = p15.refinementNavBarRef,
			NextSelectionUp = p15.topBarRef,
			NextSelectionRight = p15.verticalClothingListRef
		}),
		RefinementNavBar = if not GetFFlagAXEnableSlotBasedEditor() then Roact.createElement(RefinementNavBar, {
			defaultChildRef = p15.refinementNavBarRef,
			NextSelectionUp = p15.topBarRef,
			NextSelectionRight = p15.verticalClothingListRef
		}) else nil,
		LayeredClothingSortPageFrame = v98,
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = p15.focusController
		}) else nil,
		LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = p15.lastInputTypeChangedCallback
		}),
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil
	}

	if IsVRAppBuild() then
		return v98
	end

	return Roact.createElement(RoactGamepad.Focusable.Frame, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p15.focusController else nil,
		[Roact.Ref] = p15.props.wrappedFrameRef,
		defaultChild = v97
	}, {
		SceneGamepadHandler = Roact.createElement(v56, nil, t4)
	})
end
function v72.didMount(p18) -- line: 408
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), AvatarScreen (copy)
	if FFlagAXCustomizeMakeupSupport then
		if p18.props.avatarRoute.opaque.name == AvatarScreen.LayeredClothingSort then
			p18:onPageEntry()

			return
		end
	else
		p18:onPageEntry()
	end
end
function v72.didUpdate(p19, p20, _) -- line: 418
	-- upvalues: AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	if p19.props.avatarRoute.opaque.name ~= p20.avatarRoute.opaque.name and p19.props.avatarRoute.opaque.name == AvatarScreen.LayeredClothingSort then
		p19:onPageEntry()
	end

	if p19.props.avatarRoute.opaque.name == AvatarScreen.LayeredClothingSort and p19.props.avatarRoute.isVisible and not p20.avatarRoute.isVisible then
		p19:onPageEntry()
	end

	if not FFlagAXMigrateAXToGlobalAutofocus and p19.state.lastInputIsGamepad and #p19.props.equippedLCAssetIdsOrdered == 0 and #p20.equippedLCAssetIdsOrdered > 0 then
		p19.focusController.moveFocusTo(p19.topBarRef)
	end
end
function v72.willUnmount(p22) -- line: 453
	p22.props.unlockCharacterUpdates()
end

local function mapStateToProps(p23, _) -- line: 457
	-- upvalues: selectIsPortrait (copy), IsVRAppBuild (copy), selectEquippedLCAccessoriesOrdered (copy), hasClassicAccessories (copy)
	local v107 = selectIsPortrait(p23)
	local v108 = if not IsVRAppBuild() then p23.TopBar.topBarHeight else 0

	return {
		isPortrait = v107,
		topBarHeight = v108,
		equippedLCAssetIdsOrdered = selectEquippedLCAccessoriesOrdered(p23),
		equippedAssets = p23.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		hasClassicAccessories = hasClassicAccessories(p23),
		removedList = p23.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList,
		isLocalUserSoothSayer = p23.IsLocalUserSoothsayer
	}
end
local function mapDispatchToProps(p25) -- line: 476
	-- upvalues: SetLastSavedSort (copy), SetCurrentSort (copy), SetCurrentToastMessage (copy), SetFullView (copy), AvatarScreen (copy), SendRefinementAnalytics (copy), SetEntryPage (copy), ClearRemovedItems (copy), UnlockCharacterUpdates (copy)
	return {
		setLastSavedSort = function(p26) -- line: 478
			-- upvalues: p25 (copy), SetLastSavedSort (copy)
			p25(SetLastSavedSort(p26))
		end,
		setCurrentSort = function(p27) -- line: 481
			-- upvalues: p25 (copy), SetCurrentSort (copy)
			p25(SetCurrentSort(p27))
		end,
		setCurrentToastMessage = function(p28) -- line: 484
			-- upvalues: p25 (copy), SetCurrentToastMessage (copy)
			p25(SetCurrentToastMessage(p28))
		end,
		setFullView = function(p29, p30) -- line: 487
			-- upvalues: p25 (copy), SetFullView (copy), AvatarScreen (copy)
			p25(SetFullView(p29, AvatarScreen.LayeredClothingSort, p30))
		end,
		sendAnalytics = function(p31) -- line: 490
			-- upvalues: p25 (copy), SendRefinementAnalytics (copy)
			p25(SendRefinementAnalytics(p31))
		end,
		setEntryPage = function(p32) -- line: 493
			-- upvalues: p25 (copy), SetEntryPage (copy)
			p25(SetEntryPage(p32))
		end,
		clearRemovedItems = function() -- line: 496
			-- upvalues: p25 (copy), ClearRemovedItems (copy)
			p25(ClearRemovedItems())
		end,
		unlockCharacterUpdates = function() -- line: 499
			-- upvalues: p25 (copy), UnlockCharacterUpdates (copy)
			p25(UnlockCharacterUpdates())
		end
	}
end

local v75 = RoactServices.connect({
	analytics = Analytics2,
	avatarExperienceAnalytics = Analytics
})(v72)
local u76 = withStackVisibilityWrapper((withAvatarRoute((withMappedNavigationParams((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v75)))))))

return function(p33) -- line: 516
	-- upvalues: React (copy), useSelector (copy), selectEquippedLCAccessoriesOrdered (copy), useDispatch (copy), useRoactService (copy), Analytics2 (copy), useAvatarRoute (copy), useTokens (copy), UnlockCharacterUpdates (copy), FFlagAXCustomizeMakeupSupport (copy), SendRefinementAnalytics (copy), SetEntryPage (copy), AvatarScreen (copy), logOnOverlayClosed (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Cryo (copy), u76 (ref)
	local v111, v112 = React.useState(false)
	local v113 = React.useRef(nil)
	local v114 = useSelector(selectEquippedLCAccessoriesOrdered)
	local v115 = useDispatch()
	local v116 = useRoactService(Analytics2)
	local v117 = useAvatarRoute()
	local v118 = useTokens()
	local v119 = React.useCallback(function() -- line: 527
		-- upvalues: v115 (copy), UnlockCharacterUpdates (copy), FFlagAXCustomizeMakeupSupport (copy), p33 (copy), SendRefinementAnalytics (copy), v116 (copy), SetEntryPage (copy), AvatarScreen (copy)
		v115(UnlockCharacterUpdates())

		if FFlagAXCustomizeMakeupSupport then
			p33.navigation.popToTop()
		else
			p33.navigation.pop()
		end

		v115(SendRefinementAnalytics(v116.avatarRefineGoBack))
		v115(SetEntryPage(AvatarScreen.None))
	end, {
		v115,
		p33.navigation,
		v116
	})
	local v120 = React.useCallback(function() -- line: 549
		-- upvalues: v111 (copy), v117 (copy), AvatarScreen (copy), logOnOverlayClosed (copy), p33 (copy)
		p33.navigation.navigate(AvatarScreen.ResetLayeredItemsSortPrompt, {
			onOverlayClosed = function() -- line: 550
				-- upvalues: v111 (copy), v117 (copy), AvatarScreen (copy), logOnOverlayClosed (copy)
				if v111 and v117.opaque.name == AvatarScreen.LayeredClothingSort then
					logOnOverlayClosed("LayeredClothingSort")
				end
			end
		})
	end, {
		p33.navigation,
		v111,
		v117
	})
	local v121 = useFocusNavigationBindings(v113, v119, if not (#v114 > 0) then nil else v120)
	local v122 = useTableWrappedCallbackRef(v121)
	local v123 = Cryo.Dictionary.join(p33, {
		wrappedFrameRef = v122,
		setWrapperIsGamepad = v112,
		tokens = v118
	})

	return React.createElement(u76, v123)
end
