local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Cryo = require(CorePackages.Packages.Cryo)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useAXAnimateScrollFrame = AvatarExperienceCommon.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame
local selectTryOnsLookId = AvatarExperienceCommon.State.Selectors.selectTryOnsLookId
local PeekView = require(CorePackages.Workspace.Packages.PeekView).PeekView
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState

require(Modules.AvatarExperience.Common.Types)

local getShouldShowPeekViewShadow = require(Modules.AvatarExperience.Common.Util.getShouldShowPeekViewShadow)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants2 = require(Modules.LuaApp.Constants)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local RemoveLookItemsFromTryOn = AvatarExperienceRodux.Actions.RemoveLookItemsFromTryOn
local RemoveUnselectedItemsFromTryOn = AvatarExperienceRodux.Actions.RemoveUnselectedItemsFromTryOn
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local SetLookDetailsPeekViewSelectedTab = AvatarExperienceRodux.Actions.SetLookDetailsPeekViewSelectedTab
local LookDetailsTryOnElement = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsTryOnElement)
local LookDetailsBottomBar = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsBottomBar)
local DraftLookBottomBar = require(Modules.AvatarExperience.Catalog.Components.LookDetails.DraftLookBottomBar)
local FullView = AvatarExperienceCommon.Enums.FullView
local withNamedRefs = require(Modules.AvatarExperience.Common.Context.withNamedRefs)
local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local TabBarUnderlined = require(Modules.AvatarExperience.Common.Components.NavBar.TabBar.TabBarUnderlined)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local LookDetailsContainerInnards = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetails.LookDetailsContainerInnards)
local CloseFocusedScreen = require(Modules.AvatarExperience.Common.Thunks.CloseFocusedScreen)
local withStyle = UIBlox.Style.withStyle
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local GetFFlagLooksAvatarPDPImageDimensions = require(Modules.AvatarExperience.Flags.GetFFlagLooksAvatarPDPImageDimensions)
local GetFFlagAXLooksTranslationAudit = require(Modules.AvatarExperience.Flags.GetFFlagAXLooksTranslationAudit)
local v63 = game:DefineFastFlag("AXDisableNonFullviewAnimation", false)
local FFlagAXMigrateLookDetailsPeekViewToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateLookDetailsPeekViewToFocusNavigation
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local FFlagStackedBottomNavMarketplaceCTA = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStackedBottomNavMarketplaceCTA
local VisibilityControl = require(CorePackages.Workspace.Packages.AppNavBar).VisibilityControl
local FFlagAXCatalogMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport
local ActionBarHeight = CatalogConstants.ActionBar.ActionBarHeight
local ActionBarGradientHeight = CatalogConstants.ActionBar.ActionBarGradientHeight
local v72 = Images["icons/navigation/close"]
local v73 = Images["icons/actions/truncationExpand"]
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local LookDetailsTryOnTopContent = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsTryOnTopContent)
local v76 = Roact.PureComponent:extend("LookDetailsPeekView")
local v77 = if not FFlagAXMISEnableMultiShopping or not FFlagAXCatalogMakeupSupport then nil else function(p1) -- line: 129
	-- upvalues: Constants (copy)
	if p1.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledLookType == Constants.LookType.Makeup then
		return p1.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
	end

	return p1.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local function v78(p2) -- line: 140
	return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end
local function v79(p3) -- line: 143
	return p3.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end
local function v80(p4) -- line: 146
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy), v77 (copy)
	local v93 = if not FFlagAXMISEnableMultiShopping or not FFlagAXCatalogMakeupSupport then p4.AvatarExperience.AvatarScene.OutfitTryOn.LookId else v77(p4)
	local Looks = p4.AvatarExperience.AvatarScene.Looks

	if Looks and (v93 and Looks[v93]) then
		return Looks[v93]
	end

	return nil
end

local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.ToggleTryOnManager
}

local function useFocusNavigationBindings(p5, p6: ((...any) -> ...any), p7: ((...any) -> ...any)) -- line: 165
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v98 = ReactFocusNavigation.useEventMap(t1, p5)
	local v99 = React.useMemo(function() -- line: 167
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p6 (copy), p7 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p8) -- line: 170
					-- upvalues: p6 (copy)
					p8.cancelled = true
					p6()
				end)
			},
			[FocusNavigationEventNameEnum.ToggleTryOnManager] = {
				handler = InputHandlers.onRelease(p7)
			}
		}
	end, {
		p6,
		p7
	})

	return ReactFocusNavigation.useEventHandlerMap(v99, v98)
end

v76.validateProps = t.interface({
	focusGuiObject = t.optional(t.callback),
	isTryOn = t.optional(t.boolean),
	is10ftUI = t.boolean,
	initialPeekViewState = t.optional(t.valueOf(PeekViewState)),
	showPeekViewInSuperBrief = t.optional(t.boolean),
	resolvedFocusNavigationRef = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then nil else t.table,
	resolvedActionBarRef = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then nil else t.table,
	scrollingFrameRef = if not FFlagAXScrollingFramesShouldAnimateOnFocus then nil else t.table,
	navigation = t.table,
	avatarRoute = t.table,
	isPortrait = t.boolean,
	topBarHeight = t.number,
	tryOnItems = t.optional(t.table),
	lookId = t.optional(t.string),
	lookDetails = t.optional(t.table),
	globalGuiInset = t.table,
	screenSize = t.Vector2,
	fullView = t.optional(t.userdata),
	boundInputs = t.optional(t.table),
	peekViewState = t.optional(t.valueOf(PeekViewState)),
	selectedTab = t.optional(t.number),
	removeUnselectedItemsFromTryOn = t.callback,
	removeLookItemsFromTryOn = t.callback,
	setTryOnManagerPeekViewState = t.callback,
	setSelectedTab = t.callback,
	closeFocusedScreen = t.callback,
	catalogAnalytics = t.table,
	namedRefs = t.table,
	lastInputGroup = t.string
})

local function isMouseAndKeyboard(p9) -- line: 232
	-- upvalues: Constants2 (copy)
	return Constants2.InputTypeMap[p9] == Constants2.InputType.MouseAndKeyboard
end

function v76.init(p10) -- line: 236
	-- upvalues: UserInputService (copy), Constants2 (copy), AvatarScreen (copy), FFlagAXMigrateLookDetailsPeekViewToFocusNavigation (copy), Roact (copy), RoactGamepad (copy), FFlagStackedBottomNavMarketplaceCTA (copy), VisibilityControl (copy), PeekViewState (copy), FFlagAXMISEnableMultiShopping (copy), Constants (copy)
	local t2 = {}
	local LastInputType = UserInputService:GetLastInputType()

	t2.isMouseAndKeyboard = Constants2.InputTypeMap[LastInputType] == Constants2.InputType.MouseAndKeyboard
	p10:setState(t2)
	p10.frameRef = p10.props.namedRefs[AvatarScreen.LookDetails]
	p10.actionBarRef = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then Roact.createRef() else nil
	p10.itemsListRef = Roact.createRef()
	p10.closeButtonRef = Roact.createRef()
	p10.tryOnElementRefCache = RoactGamepad.createRefCache()
	p10.contentFrameRef = Roact.createRef()
	p10.robuxBalanceRef = Roact.createRef()

	if FFlagStackedBottomNavMarketplaceCTA then
		p10.footerVisibilityBinding = VisibilityControl.getFooterBinding()
	end

	function p10.onPeekViewClosed() -- line: 259
		-- upvalues: p10 (copy)
		if p10.props.lookId ~= nil then
			p10.props.removeLookItemsFromTryOn(p10.props.lookId, p10.props.lookDetails)

			return
		end

		p10.props.removeUnselectedItemsFromTryOn()
	end
	function p10.navigateBack() -- line: 267
		-- upvalues: p10 (copy)
		p10.onPeekViewClosed()
		p10.props.closeFocusedScreen(p10.props.navigation)
	end
	function p10.viewStateChanged(p11, p12) -- line: 272
		-- upvalues: p10 (copy), PeekViewState (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy)
		p10.props.setTryOnManagerPeekViewState(p11)

		local catalogAnalytics = p10.props.catalogAnalytics

		if p11 == PeekViewState.Closed then
			if FFlagAXMISEnableMultiShopping then
				p10.props.closeFocusedScreen(p10.props.navigation)
			else
				p10.onPeekViewClosed()
			end
		end

		local v226 = p10.props.avatarRoute.opaque.name == AvatarScreen.MySharedAvatars

		if FFlagAXMISEnableMultiShopping and p11 == PeekViewState.SuperBrief and not p10.props.isTryOn and not v226 then
			p10.props.closeFocusedScreen(p10.props.navigation)
		end

		if p11 == PeekViewState.Brief then
			if p12 == PeekViewState.Full or p12 == PeekViewState.Extended then
				catalogAnalytics.resizeOutfitScreen("minimize")

				return
			end
		elseif p11 == PeekViewState.Full and p12 == PeekViewState.Brief then
			catalogAnalytics.resizeOutfitScreen("expand")
		end
	end
	function p10.onCloseButtonPressed() -- line: 307
		-- upvalues: p10 (copy), Constants (copy), FFlagAXMISEnableMultiShopping (copy), PeekViewState (copy)
		if p10.props.lookId ~= Constants.DraftLookId then
			if FFlagAXMISEnableMultiShopping then
				p10.props.closeFocusedScreen(p10.props.navigation)
				p10.props.setTryOnManagerPeekViewState(PeekViewState.SuperBrief)

				return
			end

			p10.props.setTryOnManagerPeekViewState(PeekViewState.SuperBrief)

			return
		end

		p10.onPeekViewClosed()
		p10.props.setTryOnManagerPeekViewState(PeekViewState.Closed)
	end
end
function v76.getActionBarTotalHeight(p13, p14) -- line: 323
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), ActionBarHeight (copy), Constants2 (copy), Cryo (copy), PeekViewState (copy)
	local v106 = not p14 and 20 or if not FFlagRenameDeprecatedUIBloxTokens then p14.Tokens.Global.Size_250 else p14.Tokens.Size.Size_500
	local v107 = ActionBarHeight
	local n1 = 0
	local n2 = 0

	if p13.props.is10ftUI and (p13.props.lastInputGroup == Constants2.InputType.Gamepad and not Cryo.isEmpty(p13.props.boundInputs)) then
		n1 = Constants2.GAMEPAD_BOTTOM_BAR_SIZE
	elseif p13.props.lookId ~= nil then
		n2 = v106
	end

	local v110 = if p13.props.peekViewState ~= PeekViewState.SuperBrief then -if not FFlagRenameDeprecatedUIBloxTokens then p14.Tokens.Global.Space_100 else p14.Tokens.Size.Size_200 else if not FFlagRenameDeprecatedUIBloxTokens then p14.Tokens.Global.Space_200 else p14.Tokens.Size.Size_400

	if p13.props.showPeekViewInSuperBrief then
		v110 = 0
	end

	return v107 + n1 + n2 - v110
end
function v76.getBriefViewHeight(p15, p16) -- line: 363
	-- upvalues: getSafeAreaSize (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Constants (copy)
	local YOffset = getSafeAreaSize(p15.props.screenSize, p15.props.globalGuiInset).Y.Offset
	local v114 = if not FFlagRenameDeprecatedUIBloxTokens then p16.Tokens.Global.Size_300 else p16.Tokens.Size.Size_600

	if p15.props.isPortrait then
		local v115 = YOffset * Constants.PortraitSceneHeight

		return YOffset - p15.props.topBarHeight - v115 - v114
	end

	return (YOffset - p15.props.topBarHeight - v114) * 0.5
end
function v76.renderActionBar(p17, p18) -- line: 383
	-- upvalues: PeekViewState (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Constants (copy), Roact (copy), FFlagAXMigrateLookDetailsPeekViewToFocusNavigation (copy), DraftLookBottomBar (copy), LookDetailsBottomBar (copy), FFlagAXMISEnableMultiShopping (copy), ActionBarGradientHeight (copy)
	local Theme = p18.Theme
	local v119 = p17:getActionBarTotalHeight(p18)
	local v120 = p17.props.peekViewState == PeekViewState.SuperBrief
	local v121 = if not v120 or p17.props.showPeekViewInSuperBrief then UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p18.Tokens.Global.Space_125 else p18.Tokens.Size.Size_250) else UDim.new(0, -if not FFlagRenameDeprecatedUIBloxTokens then p18.Tokens.Global.Space_175 else p18.Tokens.Size.Size_350)
	local v122 = if not FFlagRenameDeprecatedUIBloxTokens then p18.Tokens.Global.Size_50 else p18.Tokens.Size.Size_100
	local v123 = p17.props.lookId == Constants.DraftLookId

	return Roact.createFragment({
		BottomContainer = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			ZIndex = 2,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, v119),
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			ref = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then p17.actionBarRef else p17.props.resolvedActionBarRef
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = v121
			}),
			DraftLookBottomBar = v123 and Roact.createElement(DraftLookBottomBar),
			LookDetailsBottomBar = not v123 and Roact.createElement(LookDetailsBottomBar, {
				hideDescriptor = true,
				centered = not not p17.props.isTryOn or nil,
				isTryOnFromOutsideAX = p17.props.isTryOn,
				alwaysBuyAll = not not FFlagAXMISEnableMultiShopping and (not p17.props.isTryOn or false)
			})
		}),
		TopFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, v122),
			Position = UDim2.new(0, 0, 1, -v119),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Theme.BackgroundDefault.Color
		}),
		Gradient = if not v120 or not p17.props.showPeekViewInSuperBrief then Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
			Size = UDim2.new(1, 0, 0, ActionBarGradientHeight),
			Position = UDim2.new(0, 0, 1, -v119 - v122),
			AnchorPoint = Vector2.new(0, 1),
			ImageColor3 = Theme.BackgroundDefault.Color
		}) else nil
	})
end
function v76.renderTopContent(p19, p20, p21, p22) -- line: 465
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), Constants (copy), Roact (copy), IconButton (copy), IconSize (copy), Images (copy), ImageSetButton (copy), v72 (copy), CursorKind (copy), GetFFlagAXLooksTranslationAudit (copy)
	local Theme = p20.Theme
	local p20Font = p20.Font
	local v130 = if not FFlagRenameDeprecatedUIBloxTokens then p20.Tokens.Global.Size_450 else p20.Tokens.Size.Size_900
	local v131 = if not FFlagRenameDeprecatedUIBloxTokens then p20.Tokens.Global.Space_175 else p20.Tokens.Size.Size_350
	local v132 = if not FFlagRenameDeprecatedUIBloxTokens then p20.Tokens.Global.Space_50 else p20.Tokens.Size.Size_100
	local v133 = p19.props.lookId == Constants.DraftLookId
	local v134 = if not v133 or not p19.props.isPortrait then if not FFlagRenameDeprecatedUIBloxTokens then p20.Tokens.Global.Space_300 else p20.Tokens.Size.Size_600 else if not FFlagRenameDeprecatedUIBloxTokens then p20.Tokens.Global.Space_500 else p20.Tokens.Size.Size_1000
	local v135 = if not v133 then nil else Roact.createElement(IconButton, {
		size = UDim2.fromOffset(0, 0),
		iconSize = IconSize.Medium,
		icon = Images["icons/navigation/close"],
		position = UDim2.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p20.Tokens.Global.Space_300 else p20.Tokens.Size.Size_600, 0.5, 0),
		onActivated = p19.onCloseButtonPressed,
		anchorPoint = Vector2.new(0, 0.5)
	})

	return Roact.createFragment({
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v134)
		}),
		CloseButton = if not v133 then Roact.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v131, 0.5, 0),
			Size = UDim2.fromOffset(v130 + v132, v130 + v132),
			Image = v72,
			ImageColor3 = Theme.SystemPrimaryDefault.Color,
			ImageTransparency = Theme.SystemPrimaryDefault.Transparency,
			[Roact.Event.Activated] = p19.onCloseButtonPressed,
			ref = p19.closeButtonRef,
			SelectionImageObject = p22(CursorKind.RoundedRectNoInset)
		}) else v135,
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v130),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Text = not v133 and "" or (not GetFFlagAXLooksTranslationAudit() and "Preview" or p21.previewHeader),
			TextSize = p20Font.BaseSize * p20Font.Header1.RelativeSize,
			Font = p20Font.Header1.Font,
			TextColor3 = Theme.IconEmphasis.Color,
			TextTransparency = Theme.IconEmphasis.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end
function v76.orderTryOns(p23, p24) -- line: 549
	-- upvalues: Constants (copy), FFlagAXCatalogMakeupSupport (copy)
	local t3 = {}

	for _, v140 in p24 do
		table.insert(t3, v140)
	end

	if p23.props.lookId and p23.props.lookDetails then
		local lookDetails = p23.props.lookDetails

		if lookDetails and (lookDetails.lookType == Constants.LookType.Avatar or FFlagAXCatalogMakeupSupport and lookDetails.lookType == Constants.LookType.Makeup) then
			table.sort(t3, function(p25, p26) -- line: 565
				if p25.itemRecency and p26.itemRecency then
					return p25.itemRecency < p26.itemRecency
				end

				return false
			end)
		end
	end

	return t3
end
function v76.renderTryOnManagerContents(p27, p28, _, p30) -- line: 578
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), Constants (copy), Roact (copy), FFlagAXMigrateLookDetailsPeekViewToFocusNavigation (copy), Utils (copy), LookDetailsTryOnElement (copy)
	local Theme = p28.Theme
	local v147 = if not FFlagRenameDeprecatedUIBloxTokens then p28.Tokens.Global.Space_200 else p28.Tokens.Size.Size_400
	local v148 = p27.props.lookId == Constants.DraftLookId
	local t4 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 20)
		})
	}

	if p27.props.lookDetails == nil then
		return t4
	end

	local n3 = 1

	t4["list-header-padding"] = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 5),
		LayoutOrder = n3
	})

	local v151 = n3 + 1
	local v152 = p27:orderTryOns(p27.props.tryOnItems)
	local v153 = false
	local v154 = v151

	for v155, v156 in v152 do
		local v157 = nil

		if v151 < v154 then
			v157 = p27.tryOnElementRefCache[v152[v155 - 1].itemId]
		elseif p30 then
			v157 = p27.closeButtonRef
		end

		local v158 = if not (v154 < #v152 and v152[v155 + 1]) then if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then p27.actionBarRef else p27.props.resolvedActionBarRef else p27.tryOnElementRefCache[v152[v155 + 1].itemId]
		local v159

		if v156.itemType == Constants.ItemType.Asset then
			v159 = p27.props.lookDetails.lookAssetInfos[v156.itemId]
		else
			if v156.itemType ~= Constants.ItemType.Bundle then
				continue
			end

			v159 = p27.props.lookDetails.lookBundleInfos[v156.itemId]
		end

		local v160 = Utils.isItemSelectable(v159)

		if v155 > 1 and v153 ~= v160 then
			t4["divider-" .. v154] = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Divider.Color,
				BackgroundTransparency = Theme.Divider.Transparency,
				Size = UDim2.new(1, -(v147 * 2), 0, 1),
				Position = UDim2.new(0, 0, 1, -1),
				LayoutOrder = v154
			})
			v154 += 1
		end

		if v159 then
			t4[v156.itemId] = Roact.createElement(LookDetailsTryOnElement, {
				tryOnItem = v156,
				itemInfo = v159,
				layoutOrder = v154,
				allowAutomaticPeekViewStateChanges = p27.props.lookId == nil,
				disableInteractions = v148,
				forceShowPrice = v148,
				horizontalPadding = v147,
				elementRef = p27.tryOnElementRefCache[v156.itemId],
				NextSelectionUp = v157,
				NextSelectionDown = v158
			})
			v154 += 1
		end

		v153 = Utils.isItemSelectable(v159)
	end

	return t4
end
function v76.renderDetailsContents(p31) -- line: 686
	-- upvalues: Roact (copy), LookDetailsContainerInnards (copy), GetFFlagLooksAvatarPDPImageDimensions (copy)
	return {
		LookDetails = Roact.createElement(LookDetailsContainerInnards, {
			lookId = p31.props.lookId,
			width = not GetFFlagLooksAvatarPDPImageDimensions() and 500 or nil,
			listPadding = p31.props.listPadding,
			lookDetails = p31.props.lookDetails,
			isTryOn = p31.props.isTryOn
		})
	}
end
function v76.renderWithProviders(p32, p33, p34, p35) -- line: 701
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), Constants (copy), FFlagStackedBottomNavMarketplaceCTA (copy), Constants2 (copy), PeekViewState (copy), AvatarScreen (copy), v63 (copy), FFlagAXMigrateLookDetailsPeekViewToFocusNavigation (copy), Roact (copy), FullView (copy), LookDetailsTryOnTopContent (copy), ImageSetButton (copy), v73 (copy), v72 (copy), PeekView (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), getShouldShowPeekViewShadow (copy), FFlagAXMISEnableMultiShopping (copy), TabBarUnderlined (copy), ExternalEventConnection (copy), UserInputService (copy)
	local Theme = p33.Theme
	local v167 = if not FFlagRenameDeprecatedUIBloxTokens then p33.Tokens.Global.Size_450 else p33.Tokens.Size.Size_900
	local v168 = if not FFlagRenameDeprecatedUIBloxTokens then p33.Tokens.Global.Space_175 else p33.Tokens.Size.Size_350
	local Size_6000 = p33.Tokens.Global.Size_6000
	local v170 = if not FFlagRenameDeprecatedUIBloxTokens then p33.Tokens.Global.Size_600 else p33.Tokens.Size.Size_1200
	local v171 = if not FFlagRenameDeprecatedUIBloxTokens then p33.Tokens.Global.Space_400 else p33.Tokens.Size.Size_800
	local isTryOn = p32.props.isTryOn
	local v173 = if not isTryOn then UDim2.fromOffset(0, p32.props.topBarHeight) else UDim2.new(0.5, 0, 0, p32.props.topBarHeight)
	local uDim2 = UDim2.new(1, 0, 1, -p32.props.topBarHeight)

	if not p32.props.isPortrait then
		if not isTryOn then
			v173 = UDim2.new(Constants.LandscapeNavWidth, 0, 0, p32.props.topBarHeight)
		end

		uDim2 = UDim2.new(Constants.LandscapeSceneWidth, 0, 1, -p32.props.topBarHeight)
	end

	local v175 = if not FFlagStackedBottomNavMarketplaceCTA or not p32.footerVisibilityBinding then uDim2 else p32.footerVisibilityBinding:map(function(p36) -- line: 740
		-- upvalues: uDim2 (ref), Constants2 (copy)
		return uDim2 + UDim2.new(0, 0, 0, -(Constants2.BOTTOM_BAR_SIZE - 8) * p36)
	end)
	local v176 = p32:getBriefViewHeight(p33)
	local v177 = if p32.props.lookId == nil then nil else p32:getActionBarTotalHeight(p33)
	local v178 = p32:getActionBarTotalHeight(p33)
	local v179 = p32.props.screenSize.Y - p32.props.topBarHeight - p32.props.globalGuiInset.bottom
	local s1 = "none"

	if p32.props.peekViewState == PeekViewState.Full or p32.props.peekViewState == PeekViewState.Extended then
		s1 = "regular"
	end

	local v181 = p32.state.isMouseAndKeyboard and p32.props.peekViewState == PeekViewState.Brief
	local v182 = true
	local v183 = p32.props.peekViewState == PeekViewState.SuperBrief
	local v184 = p32.props.lookId == Constants.DraftLookId
	local v185 = p32.props.avatarRoute.opaque.name == AvatarScreen.MySharedAvatars

	if v184 and p32.props.peekViewState ~= PeekViewState.Closed then
		s1 = "regular"
	end

	local v186 = p32.props.peekViewState == PeekViewState.Full or p32.props.peekViewState == PeekViewState.Extended

	if p32.props.isTryOn then
		s1 = "tryOn"
	end

	if v182 and not p32.props.showPeekViewInSuperBrief then
		v182 = not v183
	end

	if v184 then
		v181 = false
	end

	local v187 = not v63 or p32.props.peekViewState == PeekViewState.Full

	if v184 then
		v187 = false
	end

	if p32.props.isTryOn then
		v187 = false
	end

	local function v188(n4: number) -- line: 799
		-- upvalues: p32 (copy)
		p32.props.setSelectedTab(n4)
	end

	local detailsTabTitle = p34.detailsTabTitle
	local n5 = 0

	if p32.props.tryOnItems then
		for _, _ in pairs(p32.props.tryOnItems) do
			n5 += 1
		end
	end

	local v193 = p34.tryOnTabTitle:gsub("{numItems}", n5)
	local t5 = {
		{
			Name = "Details",
			Title = detailsTabTitle
		},
		{
			Name = "TryOns",
			Title = v193
		}
	}

	if FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			SelectionGroup = true,
			Size = v175,
			Position = v173,
			AnchorPoint = if not isTryOn then nil else Vector2.new(0.5, 0),
			Visible = p32.props.fullView ~= FullView.SceneFullView,
			ref = p32.frameRef
		}, {
			LookDetailsTryOnTopBar = s1 == "tryOn" and Roact.createElement("Frame", {
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = not v186 and 1 or 0,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				Size = UDim2.new(1, 0, 0, p32.props.topBarHeight),
				Position = UDim2.fromOffset(0, -p32.props.topBarHeight)
			}, {
				TopContent = Roact.createElement(LookDetailsTryOnTopContent, {
					stylePalette = p33,
					showDropDownButton = v186,
					navigateBack = p32.navigateBack,
					onCloseButtonPressed = p32.onCloseButtonPressed,
					robuxBalanceRef = p32.robuxBalanceRef
				})
			}),
			LookDetailsTopBar = s1 == "regular" and Roact.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Active = true,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				Size = UDim2.new(1, 0, 0, p32.props.topBarHeight),
				Position = UDim2.fromOffset(0, -p32.props.topBarHeight)
			}, {
				TopContent = p32:renderTopContent(p33, p34, p35)
			}),
			CloseButton = v181 and Roact.createElement(ImageSetButton, {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, v168, 1, -p32:getBriefViewHeight(p33) - if not p32.props.isTryOn then v167 else v171),
				Size = UDim2.new(0, if not p32.props.isTryOn then v167 else Size_6000, 0, if not p32.props.isTryOn then v167 else v170),
				Image = if not p32.props.isTryOn then v72 else v73,
				ImageColor3 = Theme.SystemPrimaryDefault.Color,
				[Roact.Event.Activated] = p32.onCloseButtonPressed
			}),
			PeekViewContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 3,
				ClipsDescendants = true,
				Size = UDim2.fromScale(1, 1)
			}, {
				PeekView = Roact.createElement(PeekView, {
					shouldCaptureFocus = false,
					mountAsFullView = false,
					canDragFullViewToBrief = true,
					showDraggerInClosedState = false,
					returnToFullView = true,
					thumbstickScrollEnabled = true,
					peekHeaderClose = false,
					scrollingFrameRef = if not FFlagAXScrollingFramesShouldAnimateOnFocus then nil else p32.props.scrollingFrameRef,
					briefViewContentHeight = UDim.new(0, v176),
					mountAnimation = v187,
					viewStateChanged = p32.viewStateChanged,
					showDropShadow = not p32.props.isTryOn and getShouldShowPeekViewShadow(p32.props.peekViewState),
					superBriefViewContentHeight = if p32.props.lookId == nil then nil else UDim.new(0, v177),
					stateOnMount = if not p32.props.initialPeekViewState then if not p32.props.lookId then nil else p32.props.peekViewState else p32.props.initialPeekViewState,
					bottomDockedContainerHeight = v178,
					bottomDockedContainerContent = p32:renderActionBar(p33),
					backgroundColor3 = Theme.BackgroundDefault.Color,
					backgroundTransparency = Theme.BackgroundUIDefault.Transparency,
					isScrollingEnabled = v182,
					peekViewState = p32.props.peekViewState,
					hideDraggerInSuperBrief = not p32.props.showPeekViewInSuperBrief,
					customBackground = Theme.BackgroundDefault.Color,
					minimizeToSuperBrief = p32.props.lookId ~= Constants.DraftLookId
				}, Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ClipsDescendants = true,
					[Roact.Ref] = p32.props.resolvedFocusNavigationRef
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 0)
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 0),
						PaddingBottom = UDim.new(0, 8)
					}),
					NavBar = if not FFlagAXMISEnableMultiShopping or (v184 or (v185 or p32.props.isTryOn)) then Roact.createElement(TabBarUnderlined, {
						layoutOrderMain = 1,
						navHeightMain = Constants.LooksDetailsTabBarHeight,
						tabs = t5,
						selectedTabIndex = p32.props.selectedTab,
						selectTab = v188,
						NextSelectionUp = p32.props.NextSelectionUp,
						NextSelectionDown = p32.props.NextSelectionDown
					}) else nil,
					DetailsContainer = if p32.props.selectedTab ~= 1 then nil else Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v179),
						AutomaticSize = Enum.AutomaticSize.Y
					}, p32:renderDetailsContents()),
					TryOnManagerContainer = if p32.props.selectedTab ~= 2 then nil else Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v179),
						AutomaticSize = Enum.AutomaticSize.Y,
						ref = p32.itemsListRef
					}, p32:renderTryOnManagerContents(p33, p34, s1 == "regular"))
				}))
			}),
			LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = function(p37) -- line: 985
					-- upvalues: Constants2 (copy), p32 (copy)
					if p37 then
						local v232 = Constants2.InputTypeMap[p37] == Constants2.InputType.MouseAndKeyboard

						if v232 ~= p32.state.isMouseAndKeyboard then
							p32:setState({
								isMouseAndKeyboard = v232
							})
						end
					end
				end
			})
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v175,
		Position = v173,
		AnchorPoint = if not isTryOn then nil else Vector2.new(0.5, 0),
		Visible = p32.props.fullView ~= FullView.SceneFullView,
		ref = p32.frameRef
	}, {
		LookDetailsTryOnTopBar = s1 == "tryOn" and Roact.createElement("Frame", {
			ZIndex = 3,
			BorderSizePixel = 0,
			BackgroundTransparency = not v186 and 1 or 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, p32.props.topBarHeight),
			Position = UDim2.fromOffset(0, -p32.props.topBarHeight)
		}, {
			TopContent = Roact.createElement(LookDetailsTryOnTopContent, {
				stylePalette = p33,
				showDropDownButton = v186,
				navigateBack = p32.navigateBack,
				onCloseButtonPressed = p32.onCloseButtonPressed,
				robuxBalanceRef = p32.robuxBalanceRef
			})
		}),
		LookDetailsTopBar = s1 == "regular" and Roact.createElement("Frame", {
			ZIndex = 3,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Active = true,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, p32.props.topBarHeight),
			Position = UDim2.fromOffset(0, -p32.props.topBarHeight)
		}, {
			TopContent = p32:renderTopContent(p33, p34, p35)
		}),
		CloseButton = v181 and Roact.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, v168, 1, -p32:getBriefViewHeight(p33) - if not p32.props.isTryOn then v167 else v171),
			Size = UDim2.new(0, if not p32.props.isTryOn then v167 else Size_6000, 0, if not p32.props.isTryOn then v167 else v170),
			Image = if not p32.props.isTryOn then v72 else v73,
			ImageColor3 = Theme.SystemPrimaryDefault.Color,
			[Roact.Event.Activated] = p32.onCloseButtonPressed
		}),
		PeekViewContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 3,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1)
		}, {
			PeekView = Roact.createElement(PeekView, {
				mountAsFullView = false,
				canDragFullViewToBrief = true,
				showDraggerInClosedState = false,
				returnToFullView = true,
				thumbstickScrollEnabled = true,
				shouldCaptureFocus = false,
				peekHeaderClose = false,
				scrollingFrameRef = if not FFlagAXScrollingFramesShouldAnimateOnFocus then nil else p32.props.scrollingFrameRef,
				briefViewContentHeight = UDim.new(0, v176),
				mountAnimation = v187,
				viewStateChanged = p32.viewStateChanged,
				showDropShadow = not p32.props.isTryOn and getShouldShowPeekViewShadow(p32.props.peekViewState),
				superBriefViewContentHeight = if p32.props.lookId == nil then nil else UDim.new(0, v177),
				stateOnMount = if not p32.props.initialPeekViewState then if not p32.props.lookId then nil else p32.props.peekViewState else p32.props.initialPeekViewState,
				bottomDockedContainerHeight = v178,
				bottomDockedContainerContent = p32:renderActionBar(p33),
				backgroundColor3 = Theme.BackgroundDefault.Color,
				backgroundTransparency = Theme.BackgroundUIDefault.Transparency,
				isScrollingEnabled = v182,
				peekViewState = p32.props.peekViewState,
				hideDraggerInSuperBrief = not p32.props.showPeekViewInSuperBrief,
				customBackground = Theme.BackgroundDefault.Color,
				minimizeToSuperBrief = p32.props.lookId ~= Constants.DraftLookId
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, 0)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 0),
					PaddingBottom = UDim.new(0, 8)
				}),
				NavBar = if not FFlagAXMISEnableMultiShopping or (v184 or (v185 or p32.props.isTryOn)) then Roact.createElement(TabBarUnderlined, {
					layoutOrderMain = 1,
					navHeightMain = Constants.LooksDetailsTabBarHeight,
					tabs = t5,
					selectedTabIndex = p32.props.selectedTab,
					selectTab = v188,
					NextSelectionUp = p32.props.NextSelectionUp,
					NextSelectionDown = p32.props.NextSelectionDown
				}) else nil,
				DetailsContainer = if p32.props.selectedTab ~= 1 then nil else Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v179),
					AutomaticSize = Enum.AutomaticSize.Y
				}, p32:renderDetailsContents()),
				TryOnManagerContainer = if p32.props.selectedTab ~= 2 then nil else Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v179),
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = p32.itemsListRef
				}, p32:renderTryOnManagerContents(p33, p34, s1 == "regular"))
			})
		}),
		LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p38) -- line: 1152
				-- upvalues: Constants2 (copy), p32 (copy)
				if p38 then
					local v234 = Constants2.InputTypeMap[p38] == Constants2.InputType.MouseAndKeyboard

					if v234 ~= p32.state.isMouseAndKeyboard then
						p32:setState({
							isMouseAndKeyboard = v234
						})
					end
				end
			end
		})
	})
end
function v76.render(p39) -- line: 1167
	-- upvalues: withStyle (copy), withLocalization (copy), GetFFlagAXLooksTranslationAudit (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p40) -- line: 1168
		-- upvalues: withLocalization (copy), GetFFlagAXLooksTranslationAudit (copy), withSelectionCursorProvider (copy), p39 (copy)
		return withLocalization({
			detailsTabTitle = "Feature.Catalog.Label.Details",
			tryOnTabTitle = "Feature.Catalog.Label.TryOnsMultiple",
			previewHeader = if not GetFFlagAXLooksTranslationAudit() then nil else "Feature.Avatar.Title.Preview"
		})(function(p41) -- line: 1173
			-- upvalues: withSelectionCursorProvider (copy), p39 (copy), p40 (copy)
			return withSelectionCursorProvider(function(p42) -- line: 1174
				-- upvalues: p39 (copy), p40 (copy), p41 (copy)
				return p39:renderWithProviders(p40, p41, p42)
			end)
		end)
	end)
end
function v76.didUpdate(p43, p44, _) -- line: 1181
	-- upvalues: PeekViewState (copy), wasLastInputGamepad (copy), FFlagAXMigrateLookDetailsPeekViewToFocusNavigation (copy)
	if p44.lookId and not p43.props.lookId then
		p43.onPeekViewClosed()
		p43.props.setTryOnManagerPeekViewState(PeekViewState.Closed)
	end

	if not wasLastInputGamepad() then
		return
	end

	if p43.props.peekViewState ~= p44.peekViewState and p43.props.peekViewState ~= PeekViewState.Closed and p43.props.peekViewState == PeekViewState.Brief then
		local v199 = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then p43.actionBarRef.current else p43.props.resolvedActionBarRef.current

		if p43.props.focusGuiObject and v199 then
			p43.props.focusGuiObject(v199)
		end
	end
end

local function mapStateToProps(p46, p47) -- line: 1211
	-- upvalues: selectIsPortrait (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy), v77 (copy), selectIsFullView (copy)
	local v202 = selectIsPortrait(p46)
	local name = p47.avatarRoute.opaque.name
	local v204 = if not FFlagAXMISEnableMultiShopping or not FFlagAXCatalogMakeupSupport then p46.AvatarExperience.AvatarScene.OutfitTryOn.LookId else v77(p46)
	local Looks = p46.AvatarExperience.AvatarScene.Looks
	local v206 = Looks and (v204 and Looks[v204])
	local TryOnItems = p46.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return {
		isPortrait = v202,
		topBarHeight = p46.TopBar.topBarHeight,
		tryOnItems = TryOnItems,
		lookId = v204,
		lookDetails = v206,
		globalGuiInset = p46.GlobalGuiInset,
		screenSize = p46.ScreenSize,
		fullView = selectIsFullView(p46, name),
		boundInputs = p46.GamepadBottomBar.boundInputs,
		peekViewState = p46.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState,
		selectedTab = p46.AvatarExperience.Common.ItemDetailsPeekView.lookDetailsSelectedTab
	}
end
local function mapDispatchToProps(p48: ((...any) -> ...any)) -- line: 1237
	-- upvalues: RemoveUnselectedItemsFromTryOn (copy), RemoveLookItemsFromTryOn (copy), SetTryOnManagerPeekViewState (copy), SetLookDetailsPeekViewSelectedTab (copy), CloseFocusedScreen (copy)
	return {
		removeUnselectedItemsFromTryOn = function() -- line: 1239
			-- upvalues: p48 (copy), RemoveUnselectedItemsFromTryOn (copy)
			return p48(RemoveUnselectedItemsFromTryOn())
		end,
		removeLookItemsFromTryOn = function(p49, p50) -- line: 1243
			-- upvalues: p48 (copy), RemoveLookItemsFromTryOn (copy)
			if p49 and p50 then
				local t6 = {}

				for v239 in p50.lookAssetInfos do
					table.insert(t6, v239)
				end

				local t7 = {}

				for v241 in p50.lookBundleInfos do
					table.insert(t7, v241)
				end

				return p48(RemoveLookItemsFromTryOn(p49, t6, t7))
			end
		end,
		setTryOnManagerPeekViewState = function(p51) -- line: 1259
			-- upvalues: p48 (copy), SetTryOnManagerPeekViewState (copy)
			p48(SetTryOnManagerPeekViewState(p51))
		end,
		setSelectedTab = function(p52) -- line: 1263
			-- upvalues: p48 (copy), SetLookDetailsPeekViewSelectedTab (copy)
			return p48(SetLookDetailsPeekViewSelectedTab(p52))
		end,
		closeFocusedScreen = function(p53) -- line: 1267
			-- upvalues: p48 (copy), CloseFocusedScreen (copy)
			p48(CloseFocusedScreen(p53))
		end
	}
end

local v86 = withLastInputGroup((withNamedRefs((RoactServices.connect({
	catalogAnalytics = Analytics
})(v76)))))
local u87 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v86)

local function LookDetailsPeekViewContainer(p54) -- line: 1282
	-- upvalues: useUiModeInfo (copy), UiMode (copy), FFlagAXMigrateLookDetailsPeekViewToFocusNavigation (copy), useDispatch (copy), useSelector (copy), FFlagAXCatalogMakeupSupport (copy), FFlagAXMISEnableMultiShopping (copy), selectTryOnsLookId (copy), v79 (copy), v80 (copy), v78 (copy), React (copy), RemoveLookItemsFromTryOn (copy), RemoveUnselectedItemsFromTryOn (copy), PeekViewState (copy), SetTryOnManagerPeekViewState (copy), useFocusNavigationBindings (copy), AvatarScreen (copy), useTableWrappedCallbackRef (copy), useFocusGuiObject (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), useAXAnimateScrollFrame (copy), Roact (copy), u87 (ref), Cryo (copy)
	local v210 = useUiModeInfo().uiMode == UiMode.TenFoot
	local v211 = nil
	local v212 = nil

	if FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
		local v213 = useDispatch()
		local v214 = useSelector(if not FFlagAXCatalogMakeupSupport or not FFlagAXMISEnableMultiShopping then v79 else selectTryOnsLookId)
		local v215 = useSelector(v80)
		local v216 = useSelector(v78)
		local v217 = React.useCallback(function() -- line: 1298
			-- upvalues: FFlagAXMISEnableMultiShopping (copy), p54 (copy), v214 (copy), v215 (copy), v213 (copy), RemoveLookItemsFromTryOn (copy), RemoveUnselectedItemsFromTryOn (copy)
			if not FFlagAXMISEnableMultiShopping or p54.isTryOn then
				if v214 ~= nil and v215 then
					local t8 = {}

					for v246 in v215.lookAssetInfos do
						table.insert(t8, v246)
					end

					local t9 = {}

					if v215.lookBundleInfos then
						for v248 in v215.lookBundleInfos do
							table.insert(t9, v248)
						end
					end

					v213(RemoveLookItemsFromTryOn(v214, t8, t9))
				else
					v213(RemoveUnselectedItemsFromTryOn())
				end
			end

			p54.navigation.goBack()
		end, {
			p54.navigation,
			v213,
			v214,
			v215
		})
		local v218 = React.useCallback(function() -- line: 1320
			-- upvalues: v216 (copy), PeekViewState (copy), v213 (copy), SetTryOnManagerPeekViewState (copy)
			if v216 == PeekViewState.Full or v216 == PeekViewState.Extended then
				v213(SetTryOnManagerPeekViewState(PeekViewState.Brief))

				return
			end

			v213(SetTryOnManagerPeekViewState(PeekViewState.Full))
		end, {
			v216,
			v213
		})
		local v219 = useFocusNavigationBindings(p54.namedRefs[AvatarScreen.LookDetails], v217, v218)

		v211 = useTableWrappedCallbackRef(v219)

		local v220 = useFocusNavigationBindings(nil, v217, v218)

		v212 = useTableWrappedCallbackRef(v220)
	end

	local v221 = useFocusGuiObject()
	local v222 = nil

	if FFlagAXScrollingFramesShouldAnimateOnFocus then
		v222 = React.useRef(nil)
		useAXAnimateScrollFrame(v222)
	end

	return Roact.createElement(u87, Cryo.Dictionary.join({
		is10ftUI = v210,
		resolvedFocusNavigationRef = v211,
		resolvedActionBarRef = v212,
		focusGuiObject = v221,
		scrollingFrameRef = if not FFlagAXScrollingFramesShouldAnimateOnFocus then nil else v222
	}, p54))
end

if FFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
	return withNamedRefs(LookDetailsPeekViewContainer)
end

return LookDetailsPeekViewContainer
