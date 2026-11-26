local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useSelector
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useScreenSize
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UniversalAppPolicy").useAppPolicy
local useLocalRobuxBalance = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useLocalRobuxBalance
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local divider = Foundation.Divider
local createNextOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/ReactUtils").createNextOrder
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Constants")
local useFlyoutNavigationItems = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutNavigationItems")
local drawerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").DrawerContainer
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Responsive").useDeviceInsets
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/RobuxPill")
local FlyoutNavigationList = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutNavigationList")
local FlyoutQuickSigninButton = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutQuickSigninButton")
local FlyoutReportLogs = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutReportLogs")
local FlyoutSwitchAccountButton = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutSwitchAccountButton")
local FlyoutProfileCard = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutProfileCard")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/SwitchAccountTooltip")
local useFlyoutSwitchAccount = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutSwitchAccount")
local useDismissFlyoutOnPartyTopBanner = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useDismissFlyoutOnPartyTopBanner")
local useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useSetDrawerVisible

local FFlagFlyoutSidePanelUseSharedProfileCard = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutSidePanelUseSharedProfileCard")

local profileCard = if FFlagFlyoutSidePanelUseSharedProfileCard then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/ProfileCard").ProfileCard else nil

local useFlyoutSidePanelLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutSidePanelLogging")
local flyoutAccountSwitcherIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedExperimentDefinition").FlyoutAccountSwitcherIXP
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")

local module17 = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/TermsPrivacyFooter")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local defineFastFlag = game:DefineFastFlag("EnableBlackbirdUpsellOnFlyoutMenu", false)
local fFlagEnableFlyoutMenuRobuxCardRefactor = SharedFlags.FFlagEnableFlyoutMenuRobuxCardRefactor
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagEnablePlusReferralFlyoutEntry = SharedFlags.FFlagEnablePlusReferralFlyoutEntry
local fFlagEnablePlusReferralRecipientFlyoutEntry = SharedFlags.FFlagEnablePlusReferralRecipientFlyoutEntry
local fFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local fFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Display").shouldUseDeviceSafeInsets
local fFlagFlyoutSidePanelUseProfileFrameThumbnail = SharedFlags.FFlagFlyoutSidePanelUseProfileFrameThumbnail
local defineFastFlag2 = game:DefineFastFlag("FlyoutScaleMenuWidth", false)

local v5 = if fFlagEnableBlackbirdCheck then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useHasRobloxSubscription") else nil
local v6

if fFlagEnablePlusReferralFlyoutEntry or fFlagEnablePlusReferralRecipientFlyoutEntry then
	v6 = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/usePlusReferralFlyoutBannerBlindness")
else
	v6 = nil
end

local defineFastInt = game:DefineFastInt("PlusReferralRecipientFlyoutBannerMaxImpressions", 10)

local v7 = if fFlagEnablePlusReferralFlyoutEntry then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/PlusReferralBanner") else nil

local v8 = if fFlagEnablePlusReferralRecipientFlyoutEntry then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/PlusReferralRecipientBanner") else nil
local v9

if fFlagEnableBlackbird and fFlagEnableBlackbirdOnFlyoutMenu and defineFastFlag then
	v9 = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/BlackbirdUpsellBanner")
else
	v9 = nil
end

local function selectStatusBarHeight(p2)
	return p2.TopBar.statusBarHeight or 0
end

local function selectGlobalGuiInset(p2)
	return p2.GlobalGuiInset or { left = 0, top = 0, right = 0, bottom = 0 }
end

local function getFlyoutMenuWidth(p2, p3)
	local v10 = p2 - Constants.FLYOUT_SIDE_PADDING * p3
	return (math.min(Constants.FLYOUT_SIDE_PANEL_WIDTH * p3, v10))
end

return React.memo(function(props, p2)
	local v10 = useTokens()
	local v11 = useLocalRobuxBalance()
	local v12 = useSelector(selectStatusBarHeight)
	local v13 = useSelector(selectGlobalGuiInset)
	local v14

	if fFlagFixOverlayTopInsetForDeviceSafeInsets then
		v14 = useDeviceInsets()

		if not shouldUseDeviceSafeInsets then
			v14 = nil
		end
	end

	local v15 = v13.top + v12
	local v16 = v14 and 0 or v13.bottom
	local left = if not fFlagEnableFlyoutOnNavRail then v13.left else nil
	local v17 = useScreenSize()
	local v18

	if defineFastFlag2 then
		local x = v17.X
		local scale = v10.Config.UI.Scale
		local v19 = x - Constants.FLYOUT_SIDE_PADDING * scale
		v18 = math.min(Constants.FLYOUT_SIDE_PANEL_WIDTH * scale, v19)
	elseif v17.X - Constants.FLYOUT_SIDE_PADDING < Constants.FLYOUT_SIDE_PANEL_WIDTH then
		v18 = v17.X - Constants.FLYOUT_SIDE_PADDING
	else
		v18 = Constants.FLYOUT_SIDE_PANEL_WIDTH
	end

	local v19 = useAppPolicy(function(p3)
		return p3.getDisableBlackbirdEntrypoints() or false
	end)

	local v20 = if fFlagEnableBlackbirdCheck then v5() else false
	local referrerId, v21, v22

	if fFlagEnablePlusReferralRecipientFlyoutEntry then
		local pendingReferral = props.pendingReferral
		local recipientEligibility = props.recipientEligibility
		local v23 = if pendingReferral then pendingReferral.hasPending else false

		if pendingReferral then
			referrerId = pendingReferral.referrerId
		end

		local v24 = if recipientEligibility then recipientEligibility.eligible else false
		local v25 = v6(not v20 and v23 and v24, "RobloxPlusUpsellImpressionCount4", defineFastInt)
		v21 = not v19 and fFlagEnableBlackbird and not v20 and v23 and v24 and v25
		local v26 = if recipientEligibility then recipientEligibility.isLoading else false

		v22 = if pendingReferral then pendingReferral.isLoading or v23 and v26 else false
	else
		v21 = false
		v22 = false
	end

	local v23 = not v19

	if v23 then
		v23 = not (v9 == nil) and not (v20 or v21 or v22)
	end

	local v24

	if fFlagEnablePlusReferralFlyoutEntry then
		local senderEligibility = props.senderEligibility
		local v25 = if senderEligibility then senderEligibility.eligible else false
		local v26 = v6(v20 and v25, "RobloxPlusUpsellImpressionCount2")
		v24 = v20 and v25 and v26
	else
		v24 = false
	end

	local v25 = v11 and v11 >= 0
	local v27 = useFlyoutNavigationItems()
	local nextOrder = createNextOrder()
	local v28 = useSetDrawerVisible()

	local v29 = if FFlagFlyoutSidePanelUseSharedProfileCard then useRoactService(appEventIngestService) else nil

	useFlyoutSidePanelLogging(v27.myLibraryItems)

	local v30 = React.useCallback(function()
		v28(false)
	end, { v28 })
	local v31

	if flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
		v31 = useFlyoutSwitchAccount(props.onSwitchAccountActivated, v30)
	end

	local v32 = React.useCallback(function(p3)
		FlyoutAnalytics.onFlyoutSidePanelClosed(p3)
	end, {})
	local v33

	if FFlagFlyoutSidePanelUseSharedProfileCard then
		v33 = React.useCallback(function()
			v30()

			if props.onProfileActivated then
				props.onProfileActivated()
				local id = props.localUserModel and props.localUserModel.id or ""
				FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v29, "Profile", id)
			end
		end, { v30, v29, props.localUserModel, props.onProfileActivated })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v10.Padding.XLarge),
			PaddingBottom = UDim.new(0, v10.Padding.XLarge),
			PaddingLeft = UDim.new(0, v10.Padding.XLarge),
			PaddingRight = UDim.new(0, v10.Padding.XLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v10.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		ProfileCard = 0,
		SwitchAccountTooltip = 0,
		RobuxPill = 0,
		RobuxCard = 0,
		MyLibrary = 0,
		Divider = 0,
		AdditionalNavigation = 0,
		SwitchAccountButton = 0,
		QuickSigninButton = 0,
		LogOut = 0,
		ReportLogs = 0,
		TermsPrivacyFooter = 0
	}
	local v35

	if FFlagFlyoutSidePanelUseSharedProfileCard then
		local createElement2 = React.createElement
		local v37 = {
			layoutOrder = nextOrder(),
			localUserModel = props.localUserModel,
			isRobloxSubscriber = 0,
			onProfileActivated = 0,
			onSwitchAccountActivated = 0,
			switchAccountAnchorRef = 0,
			useProfileFrameThumbnail = 0
		}

		if not fFlagEnableBlackbirdCheck then
			v20 = nil
		end

		v37.isRobloxSubscriber = v20
		v37.onProfileActivated = v33
		local v38 = if flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then v31.onActivated else nil
		v37.onSwitchAccountActivated = v38

		local v39 = if flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then v31.anchorRef else nil
		v37.switchAccountAnchorRef = v39

		v37.useProfileFrameThumbnail = fFlagFlyoutSidePanelUseProfileFrameThumbnail
		v35 = createElement2(profileCard, v37)
	else
		local createElement2 = React.createElement
		local v37 = {
			layoutOrder = nextOrder(),
			localUserModel = props.localUserModel,
			isRobloxSubscriber = 0,
			onProfileActivated = 0,
			closeDrawer = 0
		}

		if not fFlagEnableBlackbirdCheck then
			v20 = nil
		end

		v37.isRobloxSubscriber = v20
		v37.onProfileActivated = props.onProfileActivated
		v37.closeDrawer = v30
		v35 = createElement2(FlyoutProfileCard, v37)
	end

	children.ProfileCard = v35

	local v36 = if flyoutAccountSwitcherIXP.isSwitchAccountTooltipEnabled() then React.createElement(module11, {
		anchorRef = v31.anchorRef,
		isEligible = props.onSwitchAccountActivated ~= nil,
		dismissRef = v31.dismissRef
	}) else nil
	children.SwitchAccountTooltip = v36

	local v37 = if not (fFlagEnableFlyoutMenuRobuxCardRefactor or not v25) then React.createElement(module5, {
		layoutOrder = nextOrder(),
		openPurchaseRobuxPage = props.openPurchaseRobuxPage,
		robuxBalance = v11,
		closeDrawer = v30
	}) else nil
	children.RobuxPill = v37
	local v38

	if fFlagEnableFlyoutMenuRobuxCardRefactor and (v25 or v23 or v24 or v21) then
		local createElement2 = React.createElement
		local view = Foundation.View
		local v39 = {
			tag = "col size-full-0 auto-y",
			LayoutOrder = nextOrder(),
			stroke = {
				Color = v10.Color.Stroke.Default.Color3,
				Transparency = v10.Color.Stroke.Default.Transparency,
				Thickness = v10.Stroke.Standard
			},
			cornerRadius = UDim.new(0, v10.Radius.Medium)
		}

		local v41 = if v25 then React.createElement(module5, {
			layoutOrder = 1,
			openPurchaseRobuxPage = props.openPurchaseRobuxPage,
			robuxBalance = v11,
			closeDrawer = v30
		}) else nil

		local v42 = if v25 and v23 then React.createElement(divider, {
			LayoutOrder = 2
		}) else nil

		local v43 = if v23 then React.createElement(v9, {
			layoutOrder = 3,
			closeDrawer = v30
		}) else nil

		local v44 = if v24 and (v25 or v23) then React.createElement(divider, {
			LayoutOrder = 4
		}) else nil

		local v45 = if v24 then React.createElement(v7, {
			layoutOrder = 5,
			closeDrawer = v30
		}) else nil

		local v46 = if v21 and (v25 or v23 or v24) then React.createElement(divider, {
			LayoutOrder = 6
		}) else nil

		local v47 = if v21 then React.createElement(v8, {
			layoutOrder = 7,
			closeDrawer = v30,
			referrerId = referrerId,
			onOpenReferralSheet = props.onOpenReferralSheet
		}) else nil
		v38 = createElement2(view, v39, {
			RobuxPill = v41,
			UpsellDivider = v42,
			BlackbirdUpsellBanner = v43,
			PlusReferralDivider = v44,
			PlusReferralBanner = v45,
			PlusReferralRecipientDivider = v46,
			PlusReferralRecipientBanner = v47
		})
	end

	children.RobuxCard = v38

	children.MyLibrary = React.createElement(FlyoutNavigationList, {
		layoutOrder = nextOrder(),
		navigationItems = v27.myLibraryItems,
		closeDrawer = v30,
		buildCreatorWebNavUrl = props.buildCreatorWebNavUrl
	})

	children.Divider = React.createElement(divider, { LayoutOrder = nextOrder() })

	children.AdditionalNavigation = React.createElement(FlyoutNavigationList, {
		layoutOrder = nextOrder(),
		navigationItems = v27.additionalNavigationItems,
		closeDrawer = v30,
		buildCreatorWebNavUrl = props.buildCreatorWebNavUrl
	})
	local v39

	if props.onSwitchAccountActivated and flyoutAccountSwitcherIXP.isBottomButtonEnabled() then
		local createElement2 = React.createElement
		local v41 = {
			layoutOrder = nextOrder(),
			onSwitchAccountActivated = 0,
			closeDrawer = 0
		}
		local v42 = if flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then v31.onActivated else props.onSwitchAccountActivated
		v41.onSwitchAccountActivated = v42

		local v43 = if not flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then v30 else nil
		v41.closeDrawer = v43
		v39 = createElement2(FlyoutSwitchAccountButton, v41)
	end

	children.SwitchAccountButton = v39

	children.QuickSigninButton = React.createElement(FlyoutQuickSigninButton, {
		layoutOrder = nextOrder(),
		closeDrawer = v30
	})

	children.LogOut = props.renderLogOut(nextOrder())
	local v40 = if props.openReportLogConfirmation then React.createElement(FlyoutReportLogs, {
		layoutOrder = nextOrder(),
		openReportLogConfirmation = props.openReportLogConfirmation,
		closeDrawer = v30
	}) else nil
	children.ReportLogs = v40

	children.TermsPrivacyFooter = React.createElement(module17, {
		layoutOrder = nextOrder(),
		closeDrawer = v30
	})
	local element = createElement(fragment, nil, children)

	useDismissFlyoutOnPartyTopBanner()
	return React.createElement(drawerContainer, {
		displayOrder = props.displayOrder,
		menuWidth = v18,
		children = element,
		leftOffset = left,
		topOffset = v15,
		bottomOffset = v16,
		deviceSafeInsets = v14,
		backgroundStyle = v10.Color.Surface.Surface_0,
		onDrawerClosedAnalytics = v32
	})
end)
