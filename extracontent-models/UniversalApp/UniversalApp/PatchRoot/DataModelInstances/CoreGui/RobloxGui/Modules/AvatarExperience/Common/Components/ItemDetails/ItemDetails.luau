local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local tutils = require(CorePackages.Packages.tutils)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local t = require(CorePackages.Packages.t)
local Constants = require(Modules.LuaApp.Constants)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local withStyle = UIBlox.Style.withStyle
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)

require(CorePackages.Packages.ReactFocusNavigation)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Display = require(CorePackages.Workspace.Packages.Display)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Common = Modules.AvatarExperience.Common
local CloseFocusedScreen = require(Common.Thunks.CloseFocusedScreen)

require(Common.AvatarExperienceState)

local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local Constants2 = require(Common.Constants)
local Utils = require(Common.Utils)
local ItemDetailsContainer = require(Common.Components.ItemDetails.ItemDetailsContainer)
local ItemDetailsContainer_DEPRECATED = require(Common.Components.ItemDetails.ItemDetailsContainer_DEPRECATED)
local PeekViewTopBar = require(Common.Components.ItemDetails.PeekViewTopBar)
local VRItemDetailsTopBar = require(Common.Components.ItemDetails.VRItemDetailsTopBar)
local NavigationUtils = require(Common.Components.RoactNavigation.NavigationUtils)
local SetSelectedTimedOption = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).State.Actions.SetSelectedTimedOption
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local withMappedNavigationParams = require(Common.Components.RoactNavigation.withMappedNavigationParams)
local ItemDataValidator = require(Common.Validators.ItemDataValidator)
local selectIsPortrait = require(Common.Selectors.selectIsPortrait)
local CloseAllPeekViews = require(Common.Thunks.CloseAllPeekViews)
local CloseAllItemDetails = require(Common.Thunks.CloseAllItemDetails)
local ToggleTryOnThunk = require(Common.Thunks.ToggleTryOnThunk)
local CloseMatchingScreens = require(Common.Thunks.CloseMatchingScreens)
local ItemData = require(Common.Selectors.ItemData)
local SetItemDetailsExpanded = require(Common.Actions.SetItemDetailsExpanded)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetItemDetailsPeekViewState = AvatarExperienceRodux.Actions.SetItemDetailsPeekViewState
local SetItemTryOnPeekViewState = AvatarExperienceRodux.Actions.SetItemTryOnPeekViewState
local ItemDetailsPeekView = require(Common.Components.ItemDetails.ItemDetailsPeekView)
local ItemDetailsModal = require(Common.Components.ItemDetails.ItemDetailsModal)
local ItemDetailsFull = require(Common.Components.ItemDetails.ItemDetailsFull)
local withLastInputGroup = require(Common.Components.withLastInputGroup)
local OpenItemPrompt = require(Common.Thunks.OpenItemPrompt)
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local getTryOnItemReducerKey = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getTryOnItemReducerKey
local useItemDetailsFocusNavigationBindings = require(Common.Components.ItemDetails.useItemDetailsFocusNavigationBindings)
local Catalog = Modules.AvatarExperience.Catalog
local Analytics = require(Catalog.Services.Analytics)
local CatalogUtils = require(Catalog.CatalogUtils)
local BuyActionBar = require(Modules.AvatarExperience.Catalog.Components.ActionBar.BuyActionBar)
local CatalogConstants = require(Catalog.CatalogConstants)
local RedeemQRCodeItem = require(Catalog.Thunks.RedeemQRCodeItem)
local OnFocusExposureLogger = require(Catalog.Components.OnFocusExposureLogger)
local Flags = Modules.AvatarExperience.Flags
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarMarketplaceBackendIXPTests = require(Flags.AvatarMarketplaceBackendIXPTests)
local FFlagQRCodeItemRedemptionEnabled = require(Flags.FFlagQRCodeItemRedemptionEnabled)
local GetFFlagAXDisableItemDetailsPageLayerExposure = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableItemDetailsPageLayerExposure)
local GetFFlagAXItemDetailsScrollingEnabledCallback = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsScrollingEnabledCallback)
local AXItemDetails3DPreviewIXP = require(Modules.AvatarExperience.Experiments.AXItemDetails3DPreviewIXP)
local FFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXMigrateItemDetailsContainerInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateItemDetailsContainerInputBindingsToFocusNavigation
local v89 = game:DefineFastFlag("AXFixItemDataNilWhenTryOnSecondary", false)
local v90 = game:DefineFastFlag("AXExternalItemDetailsOverlay", false)
local v91 = game:DefineFastFlag("AXItemDetailsShouldNotHaveQuickMenuButton", false)
local v92 = game:DefineFastFlag("AXPeekViewContentShouldNotBeSelectable", false)
local FFlagAXDurablesForMIS = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXDurablesForMIS
local FFlagAXDurablesSupportWithPostPurchaseFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXDurablesSupportWithPostPurchaseFix
local FFlagAXTryOnScreenImprovements = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXTryOnScreenImprovements
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local n1 = nil

if FFlagAXMISEnableMultiShopping then
	n1 = 4
end

local t1 = {
	toastMessage = "Feature.Avatar.Message.InvalidItem",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local v99 = GuiService:IsTenFootInterface()

local function v100(p1) -- line: 165
	return p1.AvatarExperience.Common.ItemDetailsExpanded
end
local function v101(p2) -- line: 169
	-- upvalues: FormFactor (copy)
	return p2.FormFactor == FormFactor.WIDE
end

local v102 = Roact.PureComponent:extend("ItemDetails")

v102.validateProps = t.strictInterface({
	itemId = t.string,
	itemType = t.string,
	itemSubType = t.optional(t.string),
	isFirstItemDetails = t.optional(t.boolean),
	fromContentFeed = t.optional(t.boolean),
	fromProfile = t.optional(t.boolean),
	showDropDownTopBar = t.optional(t.boolean),
	showRobuxBalance = t.optional(t.boolean),
	fromHome = if not FFlagAXTryOnScreenImprovements then t.optional(t.boolean) else nil,
	simpleView = if not FFlagAXTryOnScreenImprovements then nil else t.optional(t.boolean),
	hideTab = if not FFlagAXTryOnScreenImprovements then nil else t.optional(t.boolean),
	shouldNavigateDown = if not FFlagAXTryOnScreenImprovements then nil else t.optional(t.boolean),
	fromSurface = t.optional(t.number),
	itemSubTypeName = t.optional(t.string),
	mountAsFullView = t.optional(t.boolean),
	assetType = t.optional(t.string),
	mountAnimation = t.optional(t.boolean),
	itemDetailsPeekViewRefs = t.optional(t.table),
	resultsListRef = t.optional(t.table),
	detail = t.optional(t.string),
	prevNavPage = t.optional(t.string),
	prevNavHistory = t.optional(t.table),
	showFullWithNoPeekView = t.optional(t.boolean),
	widgetInfo = t.optional(t.table),
	onItemDetailsClosed = t.optional(t.callback),
	itemDetailsExpanded = t.boolean,
	actionBarContainerRef = t.table,
	contentFrameRef = t.table,
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	isSceneFullView = t.boolean,
	itemData = t.optional(ItemDataValidator),
	peekViewShowing = t.boolean,
	topBarHeight = t.number,
	playerMembership = t.optional(t.enum(Enum.MembershipType)),
	lastInputGroup = t.string,
	itemDetailsTryOnViewState = t.any,
	itemDetailsViewState = t.any,
	screenSize = t.Vector2,
	globalGuiInset = t.table,
	wideMode = t.boolean,
	numberOfTryOnItems = if not FFlagAXDurablesForMIS then nil else t.number,
	isCurrentItemInTryOns = if not FFlagAXDurablesForMIS then nil else t.boolean,
	isAvatarEditorOpaqueRoute = if not FFlagAXDurablesForMIS then nil else t.boolean,
	closeAllPeekViews = t.callback,
	closeFiltersAndItemDetails = t.callback,
	closeFocusedScreen = t.callback,
	setItemDetailsExpanded = t.callback,
	setCurrentToastMessage = t.callback,
	openItemPrompt = t.callback,
	redeemQRCodeItemPrompt = t.callback,
	setItemDetailsPeekViewState = t.callback,
	setItemTryOnPeekViewState = t.callback,
	isPortrait = t.optional(t.boolean),
	setSelectedTimedOption = if not FFlagAXDurablesForMIS then nil else t.callback,
	toggleTryOnThunk = if not FFlagAXDurablesForMIS then nil else t.callback,
	closeMatchingScreens = if not FFlagAXDurablesForMIS then nil else t.callback,
	networking = t.callback,
	analytics = t.table,
	peekViewFullViewEnabled = t.boolean,
	showPremiumContent = t.boolean,
	overlayClosedCallback = t.callback,
	localization = if not FFlagAXDurablesForMIS then nil else t.table,
	deviceSafePadding = if not FFlagEnableLeftNavOnConsole then nil else t.table
})

function v102.init(p3) -- line: 254
	-- upvalues: Roact (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), FFlagAXDurablesForMIS (copy), Cryo (copy), NavigationUtils (copy), t1 (copy), memoize (copy), PeekViewState (copy), CatalogUtils (copy), v89 (copy), AvatarScreen (copy)
	p3.actionBarHeaderRef = Roact.createRef()
	p3.backButtonRef = Roact.createRef()

	local v112 = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else {
		scrollingEnabled = true
	}

	if p3.props.itemData and p3.props.itemData.timedOptions then
		for _, v114 in p3.props.itemData.timedOptions do
			if v114.selected then
				local days = v114.days

				if days == 0 then
					days = nil
				end

				v112.selectedTimedOptionDays = days

				break
			end
		end
	end

	p3.state = v112

	if p3.props.showRobuxBalance then
		p3.robuxBalanceRef = Roact.createRef()
	end

	p3.timedOptionDeeplinkUpdated = false

	function p3.onTimedOptionSelected(p4) -- line: 283
		-- upvalues: p3 (copy), Roact (copy), FFlagAXDurablesForMIS (copy)
		local v239 = p3.props.itemData.timedOptions[p4] and p3.props.itemData.timedOptions[p4].days or 0

		if v239 == 0 then
			v239 = Roact.None
		end

		p3:setState({
			selectedTimedOptionDays = v239
		})

		if FFlagAXDurablesForMIS then
			p3.timedOptionDeeplinkUpdated = true
		end
	end

	if FFlagAXDurablesForMIS then
		function p3.updateTimedOptionSelection() -- line: 298
			-- upvalues: Cryo (copy), p3 (copy), NavigationUtils (copy)
			local v240 = Cryo.List.findWhere(p3.props.itemData.timedOptions, function(p5) -- line: 299
				-- upvalues: p3 (copy)
				return p5.days == p3.state.selectedTimedOptionDays
			end) or #p3.props.itemData.timedOptions

			p3.props.setSelectedTimedOption(p3.props.itemId, p3.props.itemType, v240)
			NavigationUtils.closeFocusedScreen(p3.props.navigation)
		end
	end

	function p3.closeBriefView() -- line: 312
		-- upvalues: p3 (copy)
		local analytics = p3.props.analytics
		local itemId = p3.props.itemId
		local itemType = p3.props.itemType

		analytics.closeItemDetailPage(itemId, itemType)
		p3.props.closeFiltersAndItemDetails(p3.props.navigation)
	end
	function p3.onItemInvalid() -- line: 323
		-- upvalues: p3 (copy), t1 (copy)
		if p3.isMounted then
			p3.closeBriefView()
			p3.props.setCurrentToastMessage(t1)
		end
	end
	function p3.renderContentCallback() -- line: 330
		-- upvalues: p3 (copy)
		return p3:renderContent()
	end

	p3.getRenderTopBarCallback = memoize(function(p6) -- line: 334
		-- upvalues: p3 (copy)
		return function() -- line: 335
			-- upvalues: p3 (copy), p6 (copy)
			return p3:renderTopBar(p6)
		end
	end)
	p3.getRenderActionBarCallback = memoize(function(p7, p8, p9, p10, p11) -- line: 341
		-- upvalues: p3 (copy)
		return function() -- line: 342
			-- upvalues: p3 (copy), p7 (copy), p8 (copy), p9 (copy), p10 (copy), p11 (copy)
			return p3:renderActionBar(p7, p8, p9, p10, p11)
		end
	end)

	function p3.setPeekViewState(p12) -- line: 354
		-- upvalues: p3 (copy)
		if p3:getIsTryOnPage() then
			p3.props.setItemTryOnPeekViewState(p12)

			return
		end

		p3.props.setItemDetailsPeekViewState(p12)
	end
	function p3.closePeekView() -- line: 364
		-- upvalues: p3 (copy), PeekViewState (copy)
		p3.setPeekViewState(PeekViewState.Brief)
	end

	if FFlagAXDurablesForMIS then
		function p3.getShouldShowSecondaryButton() -- line: 369
			-- upvalues: p3 (copy)
			if p3.props.fromProfile or p3.props.isAvatarEditorOpaqueRoute then
				return false
			end

			if p3.props.itemData and p3.props.itemData.timedOptions and p3.props.numberOfTryOnItems > 1 then
				return true
			end

			if not p3.props.isCurrentItemInTryOns then
				return true
			end

			return false
		end
		function p3.onTryOnSecondaryButtonActivated() -- line: 382
			-- upvalues: CatalogUtils (copy), p3 (copy), v89 (copy), Cryo (copy), AvatarScreen (copy)
			local v251 = CatalogUtils.GetItemSubType(p3.props.itemType, p3.props.itemData)
			local v252 = nil

			if (not v89 or p3.props.itemData) and p3.props.itemData.timedOptions then
				v252 = Cryo.List.findWhere(p3.props.itemData.timedOptions, function(p13) -- line: 390
					-- upvalues: p3 (copy)
					return p13.days == p3.state.selectedTimedOptionDays
				end) or #p3.props.itemData.timedOptions
			end

			p3.props.toggleTryOnThunk(p3.props.networking, p3.props.analytics, p3.props.itemType, v251, p3.props.itemId, true, p3.props.avatarRoute, p3.props.navigation, v252)
			p3.props.closeMatchingScreens(p3.props.navigation, {
				AvatarScreen.Checkout,
				AvatarScreen.ItemDetails
			})
		end
	end

	if GetFFlagAXItemDetailsScrollingEnabledCallback() then
		function p3.setItemDetailsScrollingEnabled(p14) -- line: 419
			-- upvalues: p3 (copy)
			p3:setState({
				scrollingEnabled = p14
			})
		end
	end
end
function v102.getBriefViewHeight(p15) -- line: 427
	-- upvalues: Constants (copy), v99 (copy), FFlagEnableLeftNavOnConsole (copy), CatalogConstants (copy)
	local n2 = 0

	if p15.props.lastInputGroup == Constants.InputType.Gamepad and (v99 and not FFlagEnableLeftNavOnConsole) then
		n2 = Constants.GAMEPAD_BOTTOM_BAR_SIZE
	end

	return CatalogConstants.ActionBar.ActionBarHeight + CatalogConstants.ActionBar.ActionBarGradientHeight + n2 + 20
end
function v102.renderTopBar(p16, p17) -- line: 443
	-- upvalues: PeekViewState (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagEnableLeftNavOnConsole (copy), Roact (copy), IsVRAppBuild (copy), VRItemDetailsTopBar (copy), PeekViewTopBar (copy), v92 (copy)
	local Theme = p17.Theme
	local fromProfile = p16.props.fromProfile
	local topBarHeight = p16.props.topBarHeight
	local name = nil

	if p16.props.itemData then
		name = p16.props.itemData.name
	end

	local v124 = p16:getIsTryOnPage()
	local v125 = if not v124 then p16.props.itemDetailsViewState else p16.props.itemDetailsTryOnViewState
	local v126 = if not fromProfile then not (not not p16.props.showDropDownTopBar and (v125 == PeekViewState.Full or not not FFlagAXEnableHomeTryOnComplexView and v125 == PeekViewState.Extended)) and (not FFlagEnableLeftNavOnConsole or p16.props.isPortrait) and 1 or 0 else 0

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 2,
		BackgroundTransparency = v126,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		Position = if not FFlagEnableLeftNavOnConsole or p16.props.isPortrait then UDim2.fromScale(0, 0) else UDim2.new(0, 0, 0, -p16.props.deviceSafePadding.top),
		Size = UDim2.new(1, (not FFlagEnableLeftNavOnConsole or (p16.props.isPortrait or (p16.props.fromProfile or v124))) and 0 or p16.props.deviceSafePadding.right, 0, topBarHeight + ((not FFlagEnableLeftNavOnConsole or p16.props.isPortrait) and 0 or p16.props.deviceSafePadding.top)),
		Visible = p16.topBarNavVisible
	}, {
		UIPadding = if not FFlagEnableLeftNavOnConsole or p16.props.isPortrait then nil else Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, p16.props.deviceSafePadding.top)
		}),
		TopBar = if not IsVRAppBuild() then Roact.createElement(PeekViewTopBar, {
			[Roact.Ref] = p16.backButtonRef,
			NextSelectionDown = if not v92 then p16.props.contentFrameRef else nil,
			itemId = p16.props.itemId,
			itemType = p16.props.itemType,
			itemData = p16.props.itemData,
			dropDownTopBar = p16.props.showDropDownTopBar,
			peekViewState = v125,
			closePeekView = p16.closePeekView,
			showRobuxBalance = p16.props.showRobuxBalance
		}) else Roact.createElement(VRItemDetailsTopBar, {
			topBarHeight = topBarHeight,
			title = name,
			closeFocusedScreen = p16.props.closeFocusedScreen,
			navigation = p16.props.navigation
		})
	})
end
function v102.renderActionBar(p18, _, p20, p21, p22, p23) -- line: 524
	-- upvalues: FFlagAXDurablesSupportWithPostPurchaseFix (copy), Roact (copy), FFlagEnableLeftNavOnConsole (copy), BuyActionBar (copy), FFlagAXDurablesForMIS (copy), FFlagAXMISEnableMultiShopping (copy), n1 (ref), Skeleton (copy)
	local itemId = p18.props.itemId
	local itemType = p18.props.itemType
	local Theme = p20.Theme
	local p20Font = p20.Font
	local v137 = p20Font.BaseSize * p20Font.Header1.RelativeSize
	local v138 = p22 and p22.name
	local Header1Font = p20Font.Header1.Font
	local v140 = if not FFlagAXDurablesSupportWithPostPurchaseFix then p23 else p18.state.selectedTimedOptionDays

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, (not FFlagEnableLeftNavOnConsole or (p18.props.isPortrait or (p18.props.fromProfile or p18:getIsTryOnPage()))) and 0 or p18.props.deviceSafePadding.right, 0, p21),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 3,
		[Roact.Ref] = p18.props.actionBarContainerRef
	}, {
		BuyActionBar = Roact.createElement(BuyActionBar, {
			headerPadding = 24,
			leftPadding = 20,
			bottomPadding = 20,
			rightPadding = 20,
			ZIndex = 1,
			itemId = itemId,
			itemType = itemType,
			showTimedOptionInBuyButton = p22 and not not p22.timedOptions or nil,
			hidePrice = p22 and not not p22.timedOptions or nil,
			selectedTimedOptionDays = if not p18.state then nil else v140,
			setSelectedTimedOptionDays = p18.onTimedOptionSelected,
			showSecondaryButton = if not FFlagAXDurablesForMIS then nil else p18:getShouldShowSecondaryButton(),
			secondaryButtonText = if not FFlagAXDurablesForMIS then nil else if not p18.props.isCurrentItemInTryOns then p18.props.localization.tryOnSecondaryButtonText else p18.props.localization.updateSecondaryButtonText,
			onSecondaryButtonActivated = if not FFlagAXDurablesForMIS then nil else if not p18.props.isCurrentItemInTryOns then p18.onTryOnSecondaryButtonActivated else p18.updateTimedOptionSelection,
			topPadding = if not FFlagAXMISEnableMultiShopping then nil else n1
		}),
		ActionBarHeader = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -48, 0, v137),
			Position = UDim2.new(0, 24, 0, 5),
			ZIndex = 2,
			[Roact.Ref] = p18.actionBarHeaderRef
		}, {
			NameLabel = v138 and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 0),
				Font = Header1Font,
				Size = UDim2.new(1, 0, 0, v137),
				Text = v138,
				TextSize = v137,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTruncate = Enum.TextTruncate.AtEnd
			}) or Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v137)
			})
		})
	})
end
function v102.renderContent(p24) -- line: 615
	-- upvalues: FFlagAXMigrateItemDetailsContainerInputBindingsToFocusNavigation (copy), ItemDetailsContainer (copy), ItemDetailsContainer_DEPRECATED (copy), Roact (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), FFlagAXTryOnScreenImprovements (copy), FFlagAXEnableHomeTryOnComplexView (copy)
	local itemId = p24.props.itemId
	local itemType = p24.props.itemType
	local itemSubType = p24.props.itemSubType
	local itemDetailsPeekViewRefs = p24.props.itemDetailsPeekViewRefs
	local resultsListRef = p24.props.resultsListRef
	local peekViewFullViewEnabled = p24.props.peekViewFullViewEnabled
	local assetType = p24.props.assetType
	local v149 = p24:getIsTryOnPage()

	if not itemId then
		return nil
	end

	local v150 = if not FFlagAXMigrateItemDetailsContainerInputBindingsToFocusNavigation then ItemDetailsContainer_DEPRECATED else ItemDetailsContainer

	return Roact.createElement(v150, {
		actionBarHeaderRef = p24.actionBarHeaderRef,
		clipDetails = not peekViewFullViewEnabled,
		itemId = itemId,
		itemType = itemType,
		itemSubType = itemSubType,
		assetType = assetType,
		onItemInvalid = p24.onItemInvalid,
		showFullWithNoPeekView = p24.props.showFullWithNoPeekView,
		bottomDockedContainerHeight = p24:getBriefViewHeight(),
		resultsListRef = resultsListRef,
		itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
		ref = if not p24.props.showFullWithNoPeekView then nil else p24.props.contentFrameRef,
		setItemDetailsScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else p24.setItemDetailsScrollingEnabled,
		simpleView = if not FFlagAXTryOnScreenImprovements then if not FFlagAXEnableHomeTryOnComplexView then nil else v149 and not p24.props.fromHome else p24.props.simpleView,
		onWearTimeSelection = p24.onTimedOptionSelected
	})
end
function v102.getIsTryOnPage(p25) -- line: 656
	-- upvalues: AvatarScreen (copy)
	return p25.props.navigation.state.routeName == AvatarScreen.TryOnItem
end
function v102.getItemDetailsComponent(p26, p27) -- line: 660
	-- upvalues: IsVRAppBuild (copy), ItemDetailsFull (copy), ItemDetailsModal (copy), ItemDetailsPeekView (copy)
	if IsVRAppBuild() then
		return ItemDetailsFull
	end

	if p27 then
		return ItemDetailsModal
	end

	if p26.props.showFullWithNoPeekView then
		return ItemDetailsFull
	end

	return ItemDetailsPeekView
end
function v102.render(p28) -- line: 674
	-- upvalues: withSelectionCursorProvider (copy), withStyle (copy)
	return withSelectionCursorProvider(function(p29) -- line: 675
		-- upvalues: withStyle (copy), p28 (copy)
		return withStyle(function(p30) -- line: 676
			-- upvalues: p28 (copy), p29 (copy)
			return p28:renderWithProviders(p29, p30)
		end)
	end)
end
function v102.renderWithProviders(p31, p32, p33) -- line: 682
	-- upvalues: getSafeAreaSize (copy), Constants2 (copy), Roact (copy), GetFFlagAXDisableItemDetailsPageLayerExposure (copy), OnFocusExposureLogger (copy), AvatarMarketplaceBackendIXPTests (copy), AXItemDetails3DPreviewIXP (copy), NavigationEventsLogger (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy)
	local isSceneFullView = p31.props.isSceneFullView
	local itemId = p31.props.itemId
	local key = p31.props.navigation.state.key
	local itemDetailsPeekViewRefs = p31.props.itemDetailsPeekViewRefs
	local v162 = p31:getIsTryOnPage()
	local wideMode = p31.props.wideMode
	local v164 = if not v162 then p31.props.itemDetailsViewState else p31.props.itemDetailsTryOnViewState

	if not itemId then
		return
	end

	local fromProfile = p31.props.fromProfile
	local v166 = wideMode and (fromProfile and not v162)
	local isPortrait = p31.props.isPortrait
	local v168 = true
	local uDim2 = UDim2.fromScale(0, 0)
	local uDim2_2 = UDim2.fromScale(1, 1)

	if not isPortrait then
		if fromProfile or v162 then
			local screenSize = p31.props.screenSize
			local globalGuiInset = p31.props.globalGuiInset
			local XOffset = getSafeAreaSize(screenSize, globalGuiInset).X.Offset
			local v174 = math.min(XOffset, 640)

			if v162 and v174 < XOffset then
				v168 = false
			end

			uDim2 = UDim2.fromOffset((XOffset - v174) / 2, 0)
			uDim2_2 = UDim2.new(0, v174, 1, 0)
		else
			uDim2 = UDim2.fromScale(Constants2.LandscapeNavWidth, 0)
			uDim2_2 = UDim2.fromScale(Constants2.LandscapeSceneWidth, 1)
		end
	end

	local v175 = p31:getBriefViewHeight()
	local v176 = p31:getItemDetailsComponent(v166)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not isSceneFullView,
		[Roact.Ref] = itemDetailsPeekViewRefs and itemDetailsPeekViewRefs[key] or nil
	}, {
		ItemDetailsExposure = if not GetFFlagAXDisableItemDetailsPageLayerExposure() then Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.ItemDetailsPage
		}) else nil,
		ItemDetails3DPreviewExposure = if not AXItemDetails3DPreviewIXP.isEnabled() then nil else Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AXItemDetails3DPreviewIXP
		}),
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "ItemDetails:" .. key
		}),
		ItemDetailsContent = Roact.createElement(v176, {
			renderBottomBar = p31.getRenderActionBarCallback(p32, p33, v175, p31.props.itemData, if not p31.state then nil else p31.state.selectedTimedOptionDays),
			renderContent = p31.renderContentCallback,
			renderTopBar = p31.getRenderTopBarCallback(p33),
			isTryOnPage = v162,
			peekViewState = v164,
			setPeekViewState = p31.setPeekViewState,
			actionBarContainerRef = p31.props.actionBarContainerRef,
			contentFrameRef = p31.props.contentFrameRef,
			closeBriefView = p31.closeBriefView,
			viewPosition = uDim2,
			viewSize = uDim2_2,
			briefViewHeight = v175,
			showDropShadow = v168,
			analytics = p31.props.analytics,
			avatarRoute = p31.props.avatarRoute,
			closeAllPeekViews = p31.props.closeAllPeekViews,
			closeFocusedScreen = p31.props.closeFocusedScreen,
			fromProfile = p31.props.fromProfile,
			itemDetailsExpanded = p31.props.itemDetailsExpanded,
			itemId = p31.props.itemId,
			itemType = p31.props.itemType,
			lastInputGroup = p31.props.lastInputGroup,
			mountAnimation = p31.props.mountAnimation,
			mountAsFullView = p31.props.mountAsFullView,
			navigation = p31.props.navigation,
			peekViewFullViewEnabled = p31.props.peekViewFullViewEnabled,
			peekViewShowing = p31.props.peekViewShowing,
			setItemDetailsExpanded = p31.props.setItemDetailsExpanded,
			topBarHeight = p31.props.topBarHeight,
			scrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else p31.state.scrollingEnabled
		})
	})
end
function v102.didUpdate(p34, p35, _) -- line: 801
	-- upvalues: FFlagAXDurablesForMIS (copy), FFlagAXDurablesSupportWithPostPurchaseFix (copy)
	if not p34.timedOptionDeeplinkUpdated and (p34.props.itemData and p34.props.itemData.timedOptions) then
		for v180, v181 in p34.props.itemData.timedOptions do
			if v181.selected then
				if v181.days == 0 then
				end

				p34.onTimedOptionSelected(v180)

				if FFlagAXDurablesForMIS then
					break
				end

				p34.timedOptionDeeplinkUpdated = true

				break
			end
		end
	end

	if FFlagAXDurablesSupportWithPostPurchaseFix and p34.props.itemData and p34.props.itemData.timedOptions and p34.props.itemData.isOwned and (not p35.itemData or not p35.itemData.isOwned) then
		for v182, v183 in p34.props.itemData.timedOptions do
			if v183.selected then
				p34.onTimedOptionSelected(v182)

				return
			end
		end
	end
end
function v102.didMount(p37) -- line: 834
	-- upvalues: FFlagQRCodeItemRedemptionEnabled (copy), PeekViewState (copy)
	if p37.props.redeemQRCodeItem and FFlagQRCodeItemRedemptionEnabled then
		p37.props.redeemQRCodeItemPrompt(p37.props.networking, p37.props.analytics, p37.props.itemId, p37.props.itemType)
	end

	if p37.props.showFullWithNoPeekView then
		p37.setPeekViewState(PeekViewState.Full)
	end

	p37.isMounted = true
end
function v102.willUnmount(p38) -- line: 853
	-- upvalues: AvatarScreen (copy), NavigationUtils (copy), PeekViewState (copy)
	p38.isMounted = false

	local v186 = p38.props.avatarRoute.current.name == AvatarScreen.ItemDetails
	local v187 = p38.props.navigation.state.routeName == AvatarScreen.ItemDetails
	local v188 = v186 and v187

	if NavigationUtils.isFirstItemDetailsPage(p38.props.navigation) and not v188 then
		p38.props.setItemDetailsPeekViewState(PeekViewState.Closed)

		if p38.props.onItemDetailsClosed ~= nil then
			p38.props.onItemDetailsClosed()
		end
	end
end

local function mapStateToProps(p39, p40) -- line: 875
	-- upvalues: ItemData (copy), FFlagAXDurablesForMIS (copy), getTryOnItemReducerKey (copy), AvatarScreen (copy), Utils (copy), FormFactor (copy), selectIsPortrait (copy), tutils (copy)
	local itemId = p40.itemId
	local itemType = p40.itemType
	local v193 = ItemData(p39.AvatarExperience.Common, itemId, itemType)
	local v194 = if not FFlagAXDurablesForMIS then nil else p39.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v195 = if not FFlagAXDurablesForMIS then nil else v194 and v194[getTryOnItemReducerKey(itemId, itemType)] ~= nil
	local key = p40.navigation.state.key
	local avatarRoute = p40.avatarRoute
	local key2 = avatarRoute.current.key
	local v199 = p40.navigation.state.routeName == AvatarScreen.TryOnItem
	local v200 = FFlagAXDurablesForMIS and (p40.avatarRoute.opaque and p40.avatarRoute.opaque.name == AvatarScreen.AvatarEditor)

	if v199 and v193 ~= nil and v193.name == nil then
		v193 = nil
	end

	return {
		isSceneFullView = Utils.getIsSceneFullViewFromState(p39, avatarRoute),
		itemData = if not v199 or (v193 == nil or v193.name ~= nil) then v193 else nil,
		wideMode = p39.FormFactor == FormFactor.WIDE,
		peekViewShowing = key2 == key,
		topBarHeight = Utils.getTopBarHeightAvatarScene(p39),
		itemDetailsExpanded = p39.AvatarExperience.Common.ItemDetailsExpanded,
		playerMembership = p39.Users[p39.LocalUserId] and p39.Users[p39.LocalUserId].membership or Enum.MembershipType.None,
		itemDetailsTryOnViewState = p39.AvatarExperience.Common.ItemDetailsPeekView.tryOnViewState,
		itemDetailsViewState = p39.AvatarExperience.Common.ItemDetailsPeekView.viewState,
		screenSize = p39.ScreenSize,
		globalGuiInset = p39.GlobalGuiInset,
		isPortrait = selectIsPortrait(p39),
		numberOfTryOnItems = if not FFlagAXDurablesForMIS then nil else tutils.fieldCount(v194),
		isCurrentItemInTryOns = if not FFlagAXDurablesForMIS then nil else v195,
		isAvatarEditorOpaqueRoute = if not FFlagAXDurablesForMIS then nil else v200
	}
end
local function mapDispatchToProps(p41) -- line: 922
	-- upvalues: CloseAllPeekViews (copy), CloseAllItemDetails (copy), CloseFocusedScreen (copy), SetItemDetailsExpanded (copy), SetCurrentToastMessage (copy), OpenItemPrompt (copy), RedeemQRCodeItem (copy), SetItemDetailsPeekViewState (copy), SetItemTryOnPeekViewState (copy), FFlagAXDurablesForMIS (copy), SetSelectedTimedOption (copy), CloseMatchingScreens (copy), ToggleTryOnThunk (copy)
	return {
		closeAllPeekViews = function(p42) -- line: 924
			-- upvalues: p41 (copy), CloseAllPeekViews (copy)
			p41(CloseAllPeekViews(p42))
		end,
		closeFiltersAndItemDetails = function(p43) -- line: 928
			-- upvalues: p41 (copy), CloseAllItemDetails (copy)
			p41(CloseAllItemDetails(p43))
		end,
		closeFocusedScreen = function(p44) -- line: 932
			-- upvalues: p41 (copy), CloseFocusedScreen (copy)
			p41(CloseFocusedScreen(p44))
		end,
		setItemDetailsExpanded = function(p45) -- line: 936
			-- upvalues: p41 (copy), SetItemDetailsExpanded (copy)
			p41(SetItemDetailsExpanded(p45))
		end,
		setCurrentToastMessage = function(p46) -- line: 940
			-- upvalues: p41 (copy), SetCurrentToastMessage (copy)
			p41(SetCurrentToastMessage(p46))
		end,
		openItemPrompt = function(p47, p48, p49, p50, p51) -- line: 944
			-- upvalues: p41 (copy), OpenItemPrompt (copy)
			p41(OpenItemPrompt(p47, p48, p49, p50, p51))
		end,
		redeemQRCodeItemPrompt = function(p52, p53, p54, p55) -- line: 948
			-- upvalues: p41 (copy), RedeemQRCodeItem (copy)
			p41(RedeemQRCodeItem(p52, p53, p54, p55))
		end,
		setItemDetailsPeekViewState = function(p56) -- line: 952
			-- upvalues: p41 (copy), SetItemDetailsPeekViewState (copy)
			p41(SetItemDetailsPeekViewState(p56))
		end,
		setItemTryOnPeekViewState = function(p57) -- line: 956
			-- upvalues: p41 (copy), SetItemTryOnPeekViewState (copy)
			p41(SetItemTryOnPeekViewState(p57))
		end,
		setSelectedTimedOption = if not FFlagAXDurablesForMIS then nil else function(p58, p59, p60) -- line: 961
			-- upvalues: p41 (copy), SetSelectedTimedOption (copy)
			p41(SetSelectedTimedOption({
				itemId = p58,
				itemType = p59,
				selectedTimedOptionIndex = p60
			}))
		end,
		closeMatchingScreens = if not FFlagAXDurablesForMIS then nil else function(p61, p62) -- line: 971
			-- upvalues: p41 (copy), CloseMatchingScreens (copy)
			p41(CloseMatchingScreens(p61, p62))
		end,
		toggleTryOnThunk = if not FFlagAXDurablesForMIS then nil else function(p63, p64, p65, p66, p67, p68, p69, p70, p71) -- line: 977
			-- upvalues: p41 (copy), ToggleTryOnThunk (copy)
			p41(ToggleTryOnThunk(p63, p64, p65, p66, p67, p68, p69, p70, nil, false, false, p71))
		end
	}
end

local v105 = withLastInputGroup(v102)
local v106 = withMappedNavigationParams((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v105)))
local u107 = RoactAppPolicy.connect(function(p72, _) -- line: 1015
	return {
		peekViewFullViewEnabled = p72.getItemDetailsFullView(),
		showPremiumContent = p72.getShowCatalogPremiumContent()
	}
end)(v106)

local function ItemDetailsPageContainer(p74) -- line: 1022
	-- upvalues: useSelector (copy), v100 (copy), v101 (copy), AvatarScreen (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useDispatch (copy), FFlagAXDurablesForMIS (copy), useLocalization (copy), React (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), FocusNavigationEventNameEnum (copy), SetItemTryOnPeekViewState (copy), SetItemDetailsPeekViewState (copy), NavigationUtils (copy), OpenItemPrompt (copy), PeekViewState (copy), useItemDetailsFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), Cryo (copy), useNavigation (copy), useAvatarRoute (copy), v90 (copy), Roact (copy), v91 (copy), u107 (ref)
	local v205 = useSelector(v100)
	local v206 = useSelector(v101)
	local fromProfile = p74.navigation.state.params.fromProfile
	local v208 = p74.navigation.state.routeName == AvatarScreen.TryOnItem
	local v209 = v206 and (fromProfile and not v208)
	local showFullWithNoPeekView = p74.navigation.state.params.showFullWithNoPeekView
	local itemId = p74.navigation.state.params.itemId
	local itemType = p74.navigation.state.params.itemType
	local v213 = useRoactService(RoactNetworking)
	local v214 = useRoactService(Analytics)
	local v215 = useDispatch()
	local v216 = if not FFlagAXDurablesForMIS then nil else useLocalization({
		updateSecondaryButtonText = "Feature.Avatar.Action.Update",
		tryOnSecondaryButtonText = "Feature.Avatar.Action.TryOn"
	})
	local v217 = React.useRef(nil)
	local v218 = React.useRef(nil)
	local v219 = useOverlayClosedCallback()
	local v220 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v219
	})
	local v221 = React.useMemo(function() -- line: 1050
		-- upvalues: FocusNavigationEventNameEnum (copy), v205 (copy)
		return {
			[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.OpenItemDetailsPrompt,
			[Enum.KeyCode.ButtonY] = if not v205 then FocusNavigationEventNameEnum.OpenItemDetailsPeekView else FocusNavigationEventNameEnum.CloseItemDetailsPeekView,
			[Enum.KeyCode.ButtonL3] = FocusNavigationEventNameEnum.OpenCatalogContextMenu,
			[Enum.KeyCode.ButtonL2] = FocusNavigationEventNameEnum.MoveToItemDetails
		}
	end, { v205 })
	local v222 = React.useCallback(function(p75) -- line: 1062
		-- upvalues: v208 (copy), v215 (copy), SetItemTryOnPeekViewState (copy), SetItemDetailsPeekViewState (copy)
		if v208 then
			v215(SetItemTryOnPeekViewState(p75))

			return
		end

		v215(SetItemDetailsPeekViewState(p75))
	end, {
		v215,
		v208
	})
	local v223 = React.useCallback(function() -- line: 1070
		-- upvalues: NavigationUtils (copy), p74 (copy)
		NavigationUtils.closeFocusedScreen(p74.navigation)
	end, { p74.navigation })
	local v224 = React.useCallback(function() -- line: 1075
		-- upvalues: v215 (copy), OpenItemPrompt (copy), v213 (copy), v214 (copy), v219 (copy), p74 (copy)
		v215(OpenItemPrompt(v213, v214, v219, p74.navigation, p74.avatarRoute))
	end, {
		v215,
		v213,
		v214,
		v219,
		p74.navigation,
		p74.avatarRoute
	})
	local v225 = React.useCallback(function() -- line: 1088
		-- upvalues: v222 (copy), PeekViewState (copy)
		v222(PeekViewState.Full)
	end, { v222 })
	local v226 = React.useCallback(function() -- line: 1092
		-- upvalues: v222 (copy), PeekViewState (copy)
		v222(PeekViewState.Brief)
	end, { v222 })
	local v227 = React.useCallback(function() -- line: 1096
		-- upvalues: p74 (copy), AvatarScreen (copy), itemId (copy), itemType (copy), v219 (copy), fromProfile (copy), v208 (copy)
		p74.navigation.navigate(AvatarScreen.CatalogContextMenu, {
			itemId = itemId,
			itemType = itemType,
			onOverlayClosed = v219,
			centered = fromProfile or v208
		})
	end, {
		p74.navigation,
		itemId,
		itemType,
		v219,
		fromProfile,
		v208
	})
	local t2 = {
		onGoBack = v223,
		onOpenItemPrompt = v224,
		onOpenPeekView = if v209 or (showFullWithNoPeekView or v205) then nil else v225,
		onClosePeekView = if v209 or (showFullWithNoPeekView or not v205) then nil else v226,
		onOpenCatalogContextMenu = if showFullWithNoPeekView then nil else v227
	}
	local v229 = useItemDetailsFocusNavigationBindings(v218, v221, t2)
	local v230 = useTableWrappedCallbackRef(v229)
	local v231 = useItemDetailsFocusNavigationBindings(v217, v221, t2)
	local v232 = useTableWrappedCallbackRef(v231)
	local v233 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v234 = Cryo.Dictionary.join(p74, {
		actionBarContainerRef = v232,
		contentFrameRef = v230,
		overlayClosedCallback = v219,
		networking = v213,
		analytics = v214,
		itemDetailsExpanded = v205,
		localization = if not FFlagAXDurablesForMIS then nil else v216,
		deviceSafePadding = if not FFlagEnableLeftNavOnConsole then nil else v233
	})
	local v235 = useNavigation()
	local v236 = useAvatarRoute()
	local v237 = v235.state.rnKey == v236.current.key or v90 and v235.state.key == v236.current.key

	return Roact.createElement("Frame", {
		[Roact.Ref] = if not v91 then v220 else nil,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		SelectionGroup = true,
		Visible = v237
	}, {
		ItemDetails = React.createElement(u107, v234)
	})
end

return ItemDetailsPageContainer
