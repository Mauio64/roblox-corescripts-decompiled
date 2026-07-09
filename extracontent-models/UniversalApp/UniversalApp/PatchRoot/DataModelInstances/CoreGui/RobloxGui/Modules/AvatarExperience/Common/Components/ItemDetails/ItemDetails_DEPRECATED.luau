local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local tutils = require(CorePackages.Packages.tutils)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local t = require(CorePackages.Packages.t)
local Constants = require(Modules.LuaApp.Constants)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local withStyle = UIBlox.Style.withStyle
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local Common = Modules.AvatarExperience.Common
local CloseFocusedScreen = require(Common.Thunks.CloseFocusedScreen)

require(Common.AvatarExperienceState)

local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local Constants2 = require(Common.Constants)
local Utils = require(Common.Utils)
local BoundInputsUpdater = require(Common.Components.BoundInputsUpdater)
local ItemDetailsContainer = require(Common.Components.ItemDetails.ItemDetailsContainer)
local ItemDetailsContainer_DEPRECATED = require(Common.Components.ItemDetails.ItemDetailsContainer_DEPRECATED)
local PeekViewTopBar = require(Common.Components.ItemDetails.PeekViewTopBar)
local VRItemDetailsTopBar = require(Common.Components.ItemDetails.VRItemDetailsTopBar)
local GamepadFocusHandlerForPage = require(Common.Components.GamepadFocusHandlerForPage)
local NavigationUtils = require(Common.Components.RoactNavigation.NavigationUtils)
local SetSelectedTimedOption = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).State.Actions.SetSelectedTimedOption
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
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
local v61 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.itemdetails")
local OpenItemPrompt = require(Common.Thunks.OpenItemPrompt)
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local getTryOnItemReducerKey = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getTryOnItemReducerKey
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
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXDurablesForMIS = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXDurablesForMIS
local FFlagAXDurablesSupportForRFYMigration = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXDurablesSupportForRFYMigration
local FFlagAXDurablesSupportWithPostPurchaseFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXDurablesSupportWithPostPurchaseFix
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local n1 = nil

if FFlagAXMISEnableMultiShopping then
	n1 = 4
end

local t1 = {
	toastMessage = "Feature.Avatar.Message.InvalidItem",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local v92 = GuiService:IsTenFootInterface()
local v93 = Roact.PureComponent:extend("ItemDetails")

v93.validateProps = t.strictInterface({
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
	fromSurface = if not FFlagAXFixPurchaseSurfaceLogging then nil else t.optional(t.number),
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
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	isSceneFullView = t.boolean,
	itemData = t.optional(ItemDataValidator),
	peekViewShowing = t.boolean,
	topBarHeight = t.number,
	itemDetailsExpanded = t.boolean,
	playerMembership = t.optional(t.enum(Enum.MembershipType)),
	lastInputGroup = t.string,
	itemDetailsTryOnViewState = t.any,
	itemDetailsViewState = t.any,
	screenSize = t.Vector2,
	globalGuiInset = t.table,
	wideMode = t.boolean,
	numberOfTryOnItems = if not FFlagAXDurablesForMIS then nil else t.number,
	isCurrentItemInTryOns = if not FFlagAXDurablesForMIS then nil else t.boolean,
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
	isAvatarEditorOpaqueRoute = if not FFlagAXDurablesForMIS then nil else t.boolean,
	networking = t.callback,
	analytics = t.table,
	peekViewFullViewEnabled = t.boolean,
	showPremiumContent = t.boolean,
	overlayClosedCallback = t.callback,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	localization = if not FFlagAXDurablesForMIS then nil else t.table
})

function v93.init(p1) -- line: 233
	-- upvalues: Roact (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), FFlagAXDurablesSupportForRFYMigration (copy), FFlagAXDurablesForMIS (copy), Cryo (copy), NavigationUtils (copy), t1 (copy), memoize (copy), PeekViewState (copy), CatalogUtils (copy), AvatarScreen (copy)
	p1.contentFrameRef = Roact.createRef()
	p1.actionBarContainerRef = Roact.createRef()
	p1.actionBarHeaderRef = Roact.createRef()
	p1.backButtonRef = Roact.createRef()

	local v102 = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else {
		scrollingEnabled = true
	}

	if p1.props.itemData and p1.props.itemData.timedOptions then
		for _, v104 in p1.props.itemData.timedOptions do
			if v104.selected then
				local days = v104.days

				if days == 0 then
					days = nil
				end

				v102.selectedTimedOptionDays = days

				break
			end
		end
	end

	p1.state = v102

	if p1.props.showRobuxBalance then
		p1.robuxBalanceRef = Roact.createRef()
	end

	if FFlagAXDurablesSupportForRFYMigration then
		p1.timedOptionDeeplinkUpdated = false

		function p1.onTimedOptionSelected(p2) -- line: 265
			-- upvalues: p1 (copy), Roact (copy), FFlagAXDurablesForMIS (copy)
			local days = p1.props.itemData.timedOptions[p2].days

			if days == 0 then
				days = Roact.None
			end

			p1:setState({
				selectedTimedOptionDays = days
			})

			if FFlagAXDurablesForMIS then
				p1.timedOptionDeeplinkUpdated = true
			end
		end
	end

	if FFlagAXDurablesForMIS then
		function p1.updateTimedOptionSelection() -- line: 281
			-- upvalues: Cryo (copy), p1 (copy), NavigationUtils (copy)
			local v214 = Cryo.List.findWhere(p1.props.itemData.timedOptions, function(p3) -- line: 282
				-- upvalues: p1 (copy)
				return p3.days == p1.state.selectedTimedOptionDays
			end) or #p1.props.itemData.timedOptions

			p1.props.setSelectedTimedOption(p1.props.itemId, p1.props.itemType, v214)
			NavigationUtils.closeFocusedScreen(p1.props.navigation)
		end
	end

	function p1.closeBriefView() -- line: 295
		-- upvalues: p1 (copy)
		local analytics = p1.props.analytics
		local itemId = p1.props.itemId
		local itemType = p1.props.itemType

		analytics.closeItemDetailPage(itemId, itemType)
		p1.props.closeFiltersAndItemDetails(p1.props.navigation)
	end
	function p1.onItemInvalid() -- line: 306
		-- upvalues: p1 (copy), t1 (copy)
		if p1.isMounted then
			p1.closeBriefView()
			p1.props.setCurrentToastMessage(t1)
		end
	end
	function p1.renderContentCallback() -- line: 313
		-- upvalues: p1 (copy)
		return p1:renderContent()
	end

	p1.getRenderTopBarCallback = memoize(function(p4) -- line: 317
		-- upvalues: p1 (copy)
		return function() -- line: 318
			-- upvalues: p1 (copy), p4 (copy)
			return p1:renderTopBar(p4)
		end
	end)
	p1.getRenderActionBarCallback = memoize(function(p5, p6, p7, p8, p9) -- line: 324
		-- upvalues: p1 (copy)
		return function() -- line: 325
			-- upvalues: p1 (copy), p5 (copy), p6 (copy), p7 (copy), p8 (copy), p9 (copy)
			return p1:renderActionBar(p5, p6, p7, p8, p9)
		end
	end)

	function p1.setPeekViewState(p10) -- line: 337
		-- upvalues: p1 (copy)
		if p1:getIsTryOnPage() then
			p1.props.setItemTryOnPeekViewState(p10)

			return
		end

		p1.props.setItemDetailsPeekViewState(p10)
	end
	function p1.closePeekView() -- line: 347
		-- upvalues: p1 (copy), PeekViewState (copy)
		p1.setPeekViewState(PeekViewState.Brief)
	end

	if FFlagAXDurablesForMIS then
		function p1.getShouldShowSecondaryButton() -- line: 352
			-- upvalues: p1 (copy)
			if p1.props.fromProfile or p1.props.isAvatarEditorOpaqueRoute then
				return false
			end

			if p1.props.itemData and p1.props.itemData.timedOptions and p1.props.numberOfTryOnItems > 1 then
				return true
			end

			if not p1.props.isCurrentItemInTryOns then
				return true
			end

			return false
		end
		function p1.onTryOnSecondaryButtonActivated() -- line: 365
			-- upvalues: CatalogUtils (copy), p1 (copy), Cryo (copy), AvatarScreen (copy)
			local v225 = CatalogUtils.GetItemSubType(p1.props.itemType, p1.props.itemData)
			local v226 = nil

			if p1.props.itemData.timedOptions then
				v226 = Cryo.List.findWhere(p1.props.itemData.timedOptions, function(p11) -- line: 370
					-- upvalues: p1 (copy)
					return p11.days == p1.state.selectedTimedOptionDays
				end) or #p1.props.itemData.timedOptions
			end

			p1.props.toggleTryOnThunk(p1.props.networking, p1.props.analytics, p1.props.itemType, v225, p1.props.itemId, true, p1.props.avatarRoute, p1.props.navigation, v226)
			p1.props.closeMatchingScreens(p1.props.navigation, {
				AvatarScreen.Checkout,
				AvatarScreen.ItemDetails
			})
		end
	end

	if GetFFlagAXItemDetailsScrollingEnabledCallback() then
		function p1.setItemDetailsScrollingEnabled(p12) -- line: 399
			-- upvalues: p1 (copy)
			p1:setState({
				scrollingEnabled = p12
			})
		end
	end
end
function v93.getBriefViewHeight(p13) -- line: 407
	-- upvalues: Constants (copy), v92 (copy), CatalogConstants (copy)
	local n2 = 0

	if p13.props.lastInputGroup == Constants.InputType.Gamepad and v92 then
		n2 = Constants.GAMEPAD_BOTTOM_BAR_SIZE
	end

	return CatalogConstants.ActionBar.ActionBarHeight + CatalogConstants.ActionBar.ActionBarGradientHeight + n2 + 20
end
function v93.renderTopBar(p14, p15) -- line: 419
	-- upvalues: PeekViewState (copy), FFlagAXEnableHomeTryOnComplexView (copy), Roact (copy), IsVRAppBuild (copy), VRItemDetailsTopBar (copy), PeekViewTopBar (copy)
	local Theme = p15.Theme
	local fromProfile = p14.props.fromProfile
	local topBarHeight = p14.props.topBarHeight
	local name = nil

	if p14.props.itemData then
		name = p14.props.itemData.name
	end

	local v114 = if not p14:getIsTryOnPage() then p14.props.itemDetailsViewState else p14.props.itemDetailsTryOnViewState
	local v115 = if not fromProfile then (not p14.props.showDropDownTopBar or v114 ~= PeekViewState.Full and (not FFlagAXEnableHomeTryOnComplexView or v114 ~= PeekViewState.Extended)) and 1 or 0 else 0

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 2,
		BackgroundTransparency = v115,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.new(1, 0, 0, topBarHeight),
		Visible = p14.topBarNavVisible
	}, {
		TopBar = if not IsVRAppBuild() then Roact.createElement(PeekViewTopBar, {
			[Roact.Ref] = p14.backButtonRef,
			NextSelectionDown = p14.contentFrameRef,
			itemId = p14.props.itemId,
			itemType = p14.props.itemType,
			itemData = p14.props.itemData,
			dropDownTopBar = p14.props.showDropDownTopBar,
			peekViewState = v114,
			closePeekView = p14.closePeekView,
			showRobuxBalance = p14.props.showRobuxBalance
		}) else Roact.createElement(VRItemDetailsTopBar, {
			topBarHeight = topBarHeight,
			title = name,
			closeFocusedScreen = p14.props.closeFocusedScreen,
			navigation = p14.props.navigation
		})
	})
end
function v93.renderActionBar(p16, _, p18, p19, p20, p21) -- line: 480
	-- upvalues: FFlagAXDurablesSupportWithPostPurchaseFix (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), RoactGamepad (copy), BuyActionBar (copy), FFlagAXDurablesForMIS (copy), FFlagAXMISEnableMultiShopping (copy), n1 (ref), Skeleton (copy)
	local itemId = p16.props.itemId
	local itemType = p16.props.itemType
	local Theme = p18.Theme
	local p18Font = p18.Font
	local v126 = p18Font.BaseSize * p18Font.Header1.RelativeSize
	local v127 = p20 and p20.name
	local Header1Font = p18Font.Header1.Font
	local v129 = if not FFlagAXDurablesSupportWithPostPurchaseFix then p21 else p16.state.selectedTimedOptionDays

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, p19),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 3,
		[Roact.Ref] = p16.actionBarContainerRef,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p16.contentFrameRef else nil,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus then {
			MoveToItemDetailsContainer = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL2, function() -- line: 511
				-- upvalues: p16 (copy)
				p16:getFocusController().moveFocusUp()
			end)
		} else nil
	}, {
		BuyActionBar = Roact.createElement(BuyActionBar, {
			headerPadding = 24,
			leftPadding = 20,
			bottomPadding = 20,
			rightPadding = 20,
			ZIndex = 1,
			itemId = itemId,
			itemType = itemType,
			showTimedOptionInBuyButton = p20 and not not p20.timedOptions or nil,
			hidePrice = p20 and not not p20.timedOptions or nil,
			selectedTimedOptionDays = if not p16.state then nil else v129,
			setSelectedTimedOptionDays = p16.onTimedOptionSelected,
			showSecondaryButton = if not FFlagAXDurablesForMIS then nil else p16:getShouldShowSecondaryButton(),
			secondaryButtonText = if not FFlagAXDurablesForMIS then nil else if not p16.props.isCurrentItemInTryOns then p16.props.localization.tryOnSecondaryButtonText else p16.props.localization.updateSecondaryButtonText,
			onSecondaryButtonActivated = if not FFlagAXDurablesForMIS then nil else if not p16.props.isCurrentItemInTryOns then p16.onTryOnSecondaryButtonActivated else p16.updateTimedOptionSelection,
			topPadding = if not FFlagAXMISEnableMultiShopping then nil else n1
		}),
		ActionBarHeader = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -48, 0, v126),
			Position = UDim2.new(0, 24, 0, 5),
			ZIndex = 2,
			[Roact.Ref] = p16.actionBarHeaderRef
		}, {
			NameLabel = v127 and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 0),
				Font = Header1Font,
				Size = UDim2.new(1, 0, 0, v126),
				Text = v127,
				TextSize = v126,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTruncate = Enum.TextTruncate.AtEnd
			}) or Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v126)
			})
		})
	})
end
function v93.renderContent(p22) -- line: 569
	-- upvalues: FFlagAXMigrateItemDetailsContainerInputBindingsToFocusNavigation (copy), ItemDetailsContainer (copy), ItemDetailsContainer_DEPRECATED (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), FFlagAXTryOnScreenImprovements (copy), FFlagAXEnableHomeTryOnComplexView (copy)
	local itemId = p22.props.itemId
	local itemType = p22.props.itemType
	local itemSubType = p22.props.itemSubType
	local itemDetailsPeekViewRefs = p22.props.itemDetailsPeekViewRefs
	local resultsListRef = p22.props.resultsListRef
	local peekViewFullViewEnabled = p22.props.peekViewFullViewEnabled
	local assetType = p22.props.assetType
	local v138 = p22:getIsTryOnPage()

	if not itemId then
		return nil
	end

	local v139 = if not FFlagAXMigrateItemDetailsContainerInputBindingsToFocusNavigation then ItemDetailsContainer_DEPRECATED else ItemDetailsContainer

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[v139] else v139, {
		actionBarHeaderRef = p22.actionBarHeaderRef,
		clipDetails = not peekViewFullViewEnabled,
		itemId = itemId,
		itemType = itemType,
		itemSubType = itemSubType,
		assetType = assetType,
		onItemInvalid = p22.onItemInvalid,
		showFullWithNoPeekView = p22.props.showFullWithNoPeekView,
		bottomDockedContainerHeight = p22:getBriefViewHeight(),
		resultsListRef = resultsListRef,
		itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
		peekViewFocusController = if not FFlagAXMigrateAXToGlobalAutofocus then p22:getFocusController() else nil,
		NextSelectionDown = p22.actionBarContainerRef,
		NextSelectionUp = p22.backButtonRef,
		ref = if not p22.props.showFullWithNoPeekView then nil else p22.contentFrameRef,
		setItemDetailsScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else p22.setItemDetailsScrollingEnabled,
		simpleView = if not FFlagAXTryOnScreenImprovements then if not FFlagAXEnableHomeTryOnComplexView then nil else v138 and not p22.props.fromHome else p22.props.simpleView,
		onWearTimeSelection = p22.onTimedOptionSelected
	})
end
function v93.getIsTryOnPage(p23) -- line: 613
	-- upvalues: AvatarScreen (copy)
	return p23.props.navigation.state.routeName == AvatarScreen.TryOnItem
end
function v93.getItemDetailsComponent(p24, p25) -- line: 617
	-- upvalues: IsVRAppBuild (copy), ItemDetailsFull (copy), ItemDetailsModal (copy), ItemDetailsPeekView (copy)
	if IsVRAppBuild() then
		return ItemDetailsFull
	end

	if p25 then
		return ItemDetailsModal
	end

	if p24.props.showFullWithNoPeekView then
		return ItemDetailsFull
	end

	return ItemDetailsPeekView
end
function v93.render(p26) -- line: 631
	-- upvalues: withSelectionCursorProvider (copy), withStyle (copy)
	return withSelectionCursorProvider(function(p27) -- line: 632
		-- upvalues: withStyle (copy), p26 (copy)
		return withStyle(function(p28) -- line: 633
			-- upvalues: p26 (copy), p27 (copy)
			return p26:renderWithProviders(p27, p28)
		end)
	end)
end
function v93.renderWithProviders(p29, p30, p31) -- line: 639
	-- upvalues: getSafeAreaSize (copy), Constants2 (copy), PeekViewState (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), RoactGamepad (copy), NavigationUtils (copy), AvatarScreen (copy), GamepadFocusHandlerForPage (copy), GetFFlagAXDisableItemDetailsPageLayerExposure (copy), OnFocusExposureLogger (copy), AvatarMarketplaceBackendIXPTests (copy), AXItemDetails3DPreviewIXP (copy), NavigationEventsLogger (copy), BoundInputsUpdater (copy), FFlagAXDurablesSupportForRFYMigration (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy)
	local isSceneFullView = p29.props.isSceneFullView
	local itemId = p29.props.itemId
	local itemType = p29.props.itemType
	local key = p29.props.navigation.state.key
	local itemDetailsPeekViewRefs = p29.props.itemDetailsPeekViewRefs
	local resultsListRef = p29.props.resultsListRef
	local v153 = p29:getIsTryOnPage()
	local wideMode = p29.props.wideMode
	local v155 = if not v153 then p29.props.itemDetailsViewState else p29.props.itemDetailsTryOnViewState

	if not itemId then
		return
	end

	local fromProfile = p29.props.fromProfile
	local v157 = wideMode and (fromProfile and not v153)
	local isPortrait = p29.props.isPortrait
	local v159 = true
	local uDim2 = UDim2.fromScale(0, 0)
	local uDim2_2 = UDim2.fromScale(1, 1)

	if not isPortrait then
		if fromProfile or v153 then
			local screenSize = p29.props.screenSize
			local globalGuiInset = p29.props.globalGuiInset
			local XOffset = getSafeAreaSize(screenSize, globalGuiInset).X.Offset
			local v165 = math.min(XOffset, 640)

			if v153 and v165 < XOffset then
				v159 = false
			end

			uDim2 = UDim2.fromOffset((XOffset - v165) / 2, 0)
			uDim2_2 = UDim2.new(0, v165, 1, 0)
		else
			uDim2 = UDim2.fromScale(Constants2.LandscapeNavWidth, 0)
			uDim2_2 = UDim2.fromScale(Constants2.LandscapeSceneWidth, 1)
		end
	end

	local v166 = p29:getBriefViewHeight()
	local v167 = p29.props.mountAsFullView and (v155 == PeekViewState.Full or v155 == PeekViewState.Extended)
	local v168 = p29:getItemDetailsComponent(v157)

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not isSceneFullView,
		[Roact.Ref] = itemDetailsPeekViewRefs and itemDetailsPeekViewRefs[key] or nil,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p29:getFocusController() else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v167 and p29.contentFrameRef or p29.actionBarContainerRef else nil,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 710
				-- upvalues: NavigationUtils (copy), p29 (copy)
				NavigationUtils.closeFocusedScreen(p29.props.navigation)
			end),
			OpenItemPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, function() -- line: 713
				-- upvalues: p29 (copy)
				p29.props.openItemPrompt(p29.props.networking, p29.props.analytics, p29.props.overlayClosedCallback, p29.props.navigation, p29.props.avatarRoute)
			end, {
				key = "Feature.Catalog.Action.Buy"
			}),
			OpenClosePeekView = if v157 or p29.props.showFullWithNoPeekView then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 725
				-- upvalues: p29 (copy), PeekViewState (copy)
				if p29.props.itemDetailsExpanded then
					p29.setPeekViewState(PeekViewState.Brief)
					p29:getFocusController().moveFocusTo(p29.actionBarContainerRef)

					return
				end

				p29.setPeekViewState(PeekViewState.Full)
			end, {
				key = not p29.props.itemDetailsExpanded and "Feature.Catalog.Action.OpenDetails" or "Feature.Catalog.Action.CloseDetails"
			}),
			OpenCatalogContextMenu = if p29.props.showFullWithNoPeekView then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, function() -- line: 738
				-- upvalues: p29 (copy), AvatarScreen (copy), itemId (copy), itemType (copy), fromProfile (copy), v153 (copy)
				p29.props.navigation.navigate(AvatarScreen.CatalogContextMenu, {
					itemId = itemId,
					itemType = itemType,
					onOverlayClosed = p29.props.overlayClosedCallback,
					centered = fromProfile or v153
				})
			end, {
				key = "Feature.Catalog.Action.ItemOptions"
			})
		} else nil,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then resultsListRef else nil
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
			focusController = p29:getFocusController()
		}) else nil,
		ItemDetailsExposure = if not GetFFlagAXDisableItemDetailsPageLayerExposure() then Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.ItemDetailsPage
		}) else nil,
		ItemDetails3DPreviewExposure = if not AXItemDetails3DPreviewIXP.isEnabled() then nil else Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AXItemDetails3DPreviewIXP
		}),
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "ItemDetails:" .. key
		}),
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil,
		ItemDetailsContent = Roact.createElement(v168, {
			renderBottomBar = p29.getRenderActionBarCallback(p30, p31, v166, p29.props.itemData, if not FFlagAXDurablesSupportForRFYMigration then nil else p29.state.selectedTimedOptionDays),
			renderContent = p29.renderContentCallback,
			renderTopBar = p29.getRenderTopBarCallback(p31),
			isTryOnPage = v153,
			peekViewState = v155,
			setPeekViewState = p29.setPeekViewState,
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p29:getFocusController() else nil,
			actionBarContainerRef = p29.actionBarContainerRef,
			contentFrameRef = p29.contentFrameRef,
			closeBriefView = p29.closeBriefView,
			viewPosition = uDim2,
			viewSize = uDim2_2,
			briefViewHeight = v166,
			showDropShadow = v159,
			analytics = p29.props.analytics,
			avatarRoute = p29.props.avatarRoute,
			closeAllPeekViews = p29.props.closeAllPeekViews,
			closeFocusedScreen = p29.props.closeFocusedScreen,
			fromProfile = p29.props.fromProfile,
			itemDetailsExpanded = p29.props.itemDetailsExpanded,
			itemId = p29.props.itemId,
			itemType = p29.props.itemType,
			lastInputGroup = p29.props.lastInputGroup,
			mountAnimation = p29.props.mountAnimation,
			mountAsFullView = p29.props.mountAsFullView,
			navigation = p29.props.navigation,
			peekViewFullViewEnabled = p29.props.peekViewFullViewEnabled,
			peekViewShowing = p29.props.peekViewShowing,
			setItemDetailsExpanded = p29.props.setItemDetailsExpanded,
			topBarHeight = p29.props.topBarHeight,
			scrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else p29.state.scrollingEnabled
		})
	})
end

if not FFlagAXMigrateAXToGlobalAutofocus then
	function v93.getFocusController(p32) -- line: 822
		return p32.props.focusController
	end
end

if not FFlagAXMigrateAXToGlobalAutofocus then
	function v93.didUpdate(p33, p34, _) -- line: 827
		-- upvalues: Constants (copy), v61 (copy), FFlagAXDurablesSupportForRFYMigration (copy), FFlagAXDurablesForMIS (copy)
		local key = p33.props.avatarRoute.current.key
		local key2 = p34.avatarRoute.current.key
		local key3 = p33.props.navigation.state.key

		if p33.props.lastInputGroup == Constants.InputType.Gamepad then
			if key == key3 and not p33.props.avatarRoute.isOverlayVisible and p34.avatarRoute.isOverlayVisible then
				p33:getFocusController().captureFocus()
			end

			if key == key3 and key2 ~= key3 then
				v61:debug("gamepad captureFocus: ItemDetails, current pageKey changed: {}", key3)
				p33:getFocusController().captureFocus()
			end
		end

		if FFlagAXDurablesSupportForRFYMigration and not p33.timedOptionDeeplinkUpdated and p33.props.itemData and p33.props.itemData.timedOptions then
			for v176, v177 in p33.props.itemData.timedOptions do
				if v177.selected then
					if v177.days == 0 then
					end

					p33.onTimedOptionSelected(v176)

					if FFlagAXDurablesForMIS then
						return
					end

					p33.timedOptionDeeplinkUpdated = true

					return
				end
			end
		end
	end
else
	function v93.didUpdate(p36, p37, _) -- line: 871
		-- upvalues: FFlagAXDurablesSupportForRFYMigration (copy), FFlagAXDurablesSupportWithPostPurchaseFix (copy)
		if FFlagAXDurablesSupportForRFYMigration and (not p36.timedOptionDeeplinkUpdated and p36.props.itemData and p36.props.itemData.timedOptions) then
			for v181, v182 in p36.props.itemData.timedOptions do
				if v182.selected then
					if v182.days == 0 then
					end

					p36.onTimedOptionSelected(v181)
					p36.timedOptionDeeplinkUpdated = true

					break
				end
			end
		end

		if FFlagAXDurablesSupportWithPostPurchaseFix and p36.props.itemData and p36.props.itemData.timedOptions and p36.props.itemData.isOwned and (not p37.itemData or not p37.itemData.isOwned) then
			for v183, v184 in p36.props.itemData.timedOptions do
				if v184.selected then
					p36.onTimedOptionSelected(v183)

					return
				end
			end
		end
	end
end

function v93.didMount(p39) -- line: 908
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), NavigationUtils (copy), Constants (copy), v61 (copy), FFlagQRCodeItemRedemptionEnabled (copy), PeekViewState (copy)
	if not FFlagAXMigrateAXToGlobalAutofocus then
		local v186 = NavigationUtils.isFirstItemDetailsPage(p39.props.navigation)

		if p39.props.lastInputGroup == Constants.InputType.Gamepad and not v186 then
			v61:debug("gamepad captureFocus: ItemDetails, didMount")
			p39:getFocusController().captureFocus()
		end
	end

	if p39.props.redeemQRCodeItem and FFlagQRCodeItemRedemptionEnabled then
		p39.props.redeemQRCodeItemPrompt(p39.props.networking, p39.props.analytics, p39.props.itemId, p39.props.itemType)
	end

	if p39.props.showFullWithNoPeekView then
		p39.setPeekViewState(PeekViewState.Full)
	end

	p39.isMounted = true
end
function v93.willUnmount(p40) -- line: 935
	-- upvalues: AvatarScreen (copy), NavigationUtils (copy), PeekViewState (copy)
	p40.isMounted = false

	local v188 = p40.props.avatarRoute.current.name == AvatarScreen.ItemDetails
	local v189 = p40.props.navigation.state.routeName == AvatarScreen.ItemDetails
	local v190 = v188 and v189

	if NavigationUtils.isFirstItemDetailsPage(p40.props.navigation) and not v190 then
		p40.props.setItemDetailsPeekViewState(PeekViewState.Closed)

		if p40.props.onItemDetailsClosed ~= nil then
			p40.props.onItemDetailsClosed()
		end
	end
end

local function mapStateToProps(p41, p42) -- line: 957
	-- upvalues: ItemData (copy), FFlagAXDurablesForMIS (copy), getTryOnItemReducerKey (copy), AvatarScreen (copy), Utils (copy), FormFactor (copy), selectIsPortrait (copy), tutils (copy)
	local itemId = p42.itemId
	local itemType = p42.itemType
	local v195 = ItemData(p41.AvatarExperience.Common, itemId, itemType)
	local v196 = if not FFlagAXDurablesForMIS then nil else p41.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v197 = if not FFlagAXDurablesForMIS then nil else v196 and v196[getTryOnItemReducerKey(itemId, itemType)] ~= nil
	local key = p42.navigation.state.key
	local avatarRoute = p42.avatarRoute
	local key4 = avatarRoute.current.key
	local v201 = p42.navigation.state.routeName == AvatarScreen.TryOnItem
	local v202 = FFlagAXDurablesForMIS and (p42.avatarRoute.opaque and p42.avatarRoute.opaque.name == AvatarScreen.AvatarEditor)

	if v201 and v195 ~= nil and v195.name == nil then
		v195 = nil
	end

	return {
		isSceneFullView = Utils.getIsSceneFullViewFromState(p41, avatarRoute),
		itemData = if not v201 or (v195 == nil or v195.name ~= nil) then v195 else nil,
		wideMode = p41.FormFactor == FormFactor.WIDE,
		peekViewShowing = key4 == key,
		topBarHeight = Utils.getTopBarHeightAvatarScene(p41),
		itemDetailsExpanded = p41.AvatarExperience.Common.ItemDetailsExpanded,
		playerMembership = p41.Users[p41.LocalUserId] and p41.Users[p41.LocalUserId].membership or Enum.MembershipType.None,
		itemDetailsTryOnViewState = p41.AvatarExperience.Common.ItemDetailsPeekView.tryOnViewState,
		itemDetailsViewState = p41.AvatarExperience.Common.ItemDetailsPeekView.viewState,
		screenSize = p41.ScreenSize,
		globalGuiInset = p41.GlobalGuiInset,
		isPortrait = selectIsPortrait(p41),
		numberOfTryOnItems = if not FFlagAXDurablesForMIS then nil else tutils.fieldCount(v196),
		isCurrentItemInTryOns = if not FFlagAXDurablesForMIS then nil else v197,
		isAvatarEditorOpaqueRoute = if not FFlagAXDurablesForMIS then nil else v202
	}
end
local function mapDispatchToProps(p43) -- line: 1004
	-- upvalues: CloseAllPeekViews (copy), CloseAllItemDetails (copy), CloseFocusedScreen (copy), SetItemDetailsExpanded (copy), SetCurrentToastMessage (copy), OpenItemPrompt (copy), RedeemQRCodeItem (copy), SetItemDetailsPeekViewState (copy), SetItemTryOnPeekViewState (copy), FFlagAXDurablesForMIS (copy), SetSelectedTimedOption (copy), CloseMatchingScreens (copy), ToggleTryOnThunk (copy)
	return {
		closeAllPeekViews = function(p44) -- line: 1006
			-- upvalues: p43 (copy), CloseAllPeekViews (copy)
			p43(CloseAllPeekViews(p44))
		end,
		closeFiltersAndItemDetails = function(p45) -- line: 1010
			-- upvalues: p43 (copy), CloseAllItemDetails (copy)
			p43(CloseAllItemDetails(p45))
		end,
		closeFocusedScreen = function(p46) -- line: 1014
			-- upvalues: p43 (copy), CloseFocusedScreen (copy)
			p43(CloseFocusedScreen(p46))
		end,
		setItemDetailsExpanded = function(p47) -- line: 1018
			-- upvalues: p43 (copy), SetItemDetailsExpanded (copy)
			p43(SetItemDetailsExpanded(p47))
		end,
		setCurrentToastMessage = function(p48) -- line: 1022
			-- upvalues: p43 (copy), SetCurrentToastMessage (copy)
			p43(SetCurrentToastMessage(p48))
		end,
		openItemPrompt = function(p49, p50, p51, p52, p53) -- line: 1026
			-- upvalues: p43 (copy), OpenItemPrompt (copy)
			p43(OpenItemPrompt(p49, p50, p51, p52, p53))
		end,
		redeemQRCodeItemPrompt = function(p54, p55, p56, p57) -- line: 1030
			-- upvalues: p43 (copy), RedeemQRCodeItem (copy)
			p43(RedeemQRCodeItem(p54, p55, p56, p57))
		end,
		setItemDetailsPeekViewState = function(p58) -- line: 1034
			-- upvalues: p43 (copy), SetItemDetailsPeekViewState (copy)
			p43(SetItemDetailsPeekViewState(p58))
		end,
		setItemTryOnPeekViewState = function(p59) -- line: 1038
			-- upvalues: p43 (copy), SetItemTryOnPeekViewState (copy)
			p43(SetItemTryOnPeekViewState(p59))
		end,
		setSelectedTimedOption = if not FFlagAXDurablesForMIS then nil else function(p60, p61, p62) -- line: 1043
			-- upvalues: p43 (copy), SetSelectedTimedOption (copy)
			p43(SetSelectedTimedOption({
				itemId = p60,
				itemType = p61,
				selectedTimedOptionIndex = p62
			}))
		end,
		closeMatchingScreens = if not FFlagAXDurablesForMIS then nil else function(p63, p64) -- line: 1053
			-- upvalues: p43 (copy), CloseMatchingScreens (copy)
			p43(CloseMatchingScreens(p63, p64))
		end,
		toggleTryOnThunk = if not FFlagAXDurablesForMIS then nil else function(p65, p66, p67, p68, p69, p70, p71, p72, p73) -- line: 1059
			-- upvalues: p43 (copy), ToggleTryOnThunk (copy)
			p43(ToggleTryOnThunk(p65, p66, p67, p68, p69, p70, p71, p72, nil, false, false, p73))
		end
	}
end

local v96 = withLastInputGroup(v93)
local v97 = RoactServices.connect({
	networking = RoactNetworking,
	analytics = Analytics
})(v96)
local v98 = withMappedNavigationParams((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v97)))
local u99 = RoactAppPolicy.connect(function(p74, _) -- line: 1102
	return {
		peekViewFullViewEnabled = p74.getItemDetailsFullView(),
		showPremiumContent = p74.getShowCatalogPremiumContent()
	}
end)(v98)

local function ItemDetailsPageContainer(p76) -- line: 1109
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), FFlagAXDurablesForMIS (copy), useLocalization (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), Cryo (copy), Roact (copy), u99 (ref)
	local v207 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil

	if not FFlagAXMigrateAXToGlobalAutofocus and p76.focusController then
		v207 = p76.focusController
	end

	local v208 = if not FFlagAXDurablesForMIS then nil else useLocalization({
		updateSecondaryButtonText = "Feature.Avatar.Action.Update",
		tryOnSecondaryButtonText = "Feature.Avatar.Action.TryOn"
	})
	local v209 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v207 else nil)
	local v210 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v209
	})
	local v211 = Cryo.Dictionary.join(p76, {
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v207 else nil,
		overlayClosedCallback = v209,
		localization = if not FFlagAXDurablesForMIS then nil else v208
	})

	return Roact.createElement("Frame", {
		[Roact.Ref] = v210,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		ItemDetails = React.createElement(u99, v211)
	})
end

return ItemDetailsPageContainer
