local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks2.useScreenSize
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks3 = require(parent.RobloxAppHooks)
local useLocalRobuxBalance = RobloxAppHooks3.useLocalRobuxBalance
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Divider = Foundation.Divider
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder
local Constants = require(script.Parent.Parent.Constants)
local useFlyoutNavigationItems = require(script.Parent.Parent.Hooks.useFlyoutNavigationItems)
local Drawer = require(parent.Drawer)
local DrawerContainer = Drawer.DrawerContainer
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local RobuxPill = require(script.Parent.RobuxPill)
local FlyoutNavigationList = require(script.Parent.FlyoutNavigationList)
local FlyoutQuickSigninButton = require(script.Parent.FlyoutQuickSigninButton)
local FlyoutReportLogs = require(script.Parent.FlyoutReportLogs)
local FlyoutSwitchAccountButton = require(script.Parent.FlyoutSwitchAccountButton)
local FlyoutProfileCard = require(script.Parent.FlyoutProfileCard)
local SwitchAccountTooltip = require(script.Parent.SwitchAccountTooltip)
local useFlyoutSwitchAccount = require(script.Parent.Parent.Hooks.useFlyoutSwitchAccount)
local useDismissFlyoutOnPartyTopBanner = require(script.Parent.Parent.Hooks.useDismissFlyoutOnPartyTopBanner)
local Drawer2 = require(parent.Drawer)
local useSetDrawerVisible = Drawer2.Hooks.useSetDrawerVisible

local FFlagFlyoutSidePanelUseSharedProfileCard = require(script.Parent.Parent.Flags.FFlagFlyoutSidePanelUseSharedProfileCard)
local profileCard

if FFlagFlyoutSidePanelUseSharedProfileCard then
	local ProfileCard = require(parent.ProfileCard)
	profileCard = ProfileCard.ProfileCard
else
	profileCard = nil
end

local useFlyoutSidePanelLogging = require(script.Parent.Parent.Hooks.useFlyoutSidePanelLogging)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutAccountSwitcherIXP = SharedExperimentDefinition.FlyoutAccountSwitcherIXP
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)

local TermsPrivacyFooter = require(script.Parent.TermsPrivacyFooter)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local defineFastFlag = game:DefineFastFlag("EnableBlackbirdUpsellOnFlyoutMenu", false)
local FFlagEnableFlyoutMenuRobuxCardRefactor = SharedFlags.FFlagEnableFlyoutMenuRobuxCardRefactor
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagEnablePlusReferralFlyoutEntry = SharedFlags.FFlagEnablePlusReferralFlyoutEntry
local FFlagEnablePlusReferralRecipientFlyoutEntry = SharedFlags.FFlagEnablePlusReferralRecipientFlyoutEntry
local FFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
local FFlagFlyoutSidePanelUseProfileFrameThumbnail = SharedFlags.FFlagFlyoutSidePanelUseProfileFrameThumbnail
local defineFastFlag2 = game:DefineFastFlag("FlyoutScaleMenuWidth", false)
local useHasRobloxSubscription

if FFlagEnableBlackbirdCheck then
	useHasRobloxSubscription = require(script.Parent.Parent.Hooks.useHasRobloxSubscription)
else
	useHasRobloxSubscription = nil
end

local usePlusReferralFlyoutBannerBlindness

if FFlagEnablePlusReferralFlyoutEntry or FFlagEnablePlusReferralRecipientFlyoutEntry then
	usePlusReferralFlyoutBannerBlindness = require(script.Parent.Parent.Hooks.usePlusReferralFlyoutBannerBlindness)
else
	usePlusReferralFlyoutBannerBlindness = nil
end

local defineFastInt = game:DefineFastInt("PlusReferralRecipientFlyoutBannerMaxImpressions", 10)
local PlusReferralBanner

if FFlagEnablePlusReferralFlyoutEntry then
	PlusReferralBanner = require(script.Parent.PlusReferralBanner)
else
	PlusReferralBanner = nil
end

local PlusReferralRecipientBanner

if FFlagEnablePlusReferralRecipientFlyoutEntry then
	PlusReferralRecipientBanner = require(script.Parent.PlusReferralRecipientBanner)
else
	PlusReferralRecipientBanner = nil
end

local BlackbirdUpsellBanner

if FFlagEnableBlackbird and FFlagEnableBlackbirdOnFlyoutMenu and defineFastFlag then
	BlackbirdUpsellBanner = require(script.Parent.BlackbirdUpsellBanner)
else
	BlackbirdUpsellBanner = nil
end

local function selectStatusBarHeight(p)
	return p.TopBar.statusBarHeight or 0
end

local function selectGlobalGuiInset(p)
	return p.GlobalGuiInset or { left = 0, top = 0, right = 0, bottom = 0 }
end

local function getFlyoutMenuWidth(x: number, scale: number) -- 1 equivalent call inferred from this helper
	local v = x - Constants.FLYOUT_SIDE_PADDING * scale
	return (math.min(Constants.FLYOUT_SIDE_PANEL_WIDTH * scale, v))
end

return React.memo(function(props, _)
	local v = useTokens()
	local robuxBalance = useLocalRobuxBalance()
	local v2 = useSelector(selectStatusBarHeight)
	local v3 = useSelector(selectGlobalGuiInset)
	local deviceSafeInsets

	if FFlagFixOverlayTopInsetForDeviceSafeInsets then
		deviceSafeInsets = useDeviceInsets()

		if not shouldUseDeviceSafeInsets then
			deviceSafeInsets = nil
		end
	end

	local topOffset = v3.top + v2
	local bottomOffset = deviceSafeInsets and 0 or v3.bottom
	local left

	if not FFlagEnableFlyoutOnNavRail then
		left = v3.left
	end

	local v4 = useScreenSize()
	local menuWidth

	if defineFastFlag2 then
		menuWidth = getFlyoutMenuWidth(v4.X, v.Config.UI.Scale) -- inferred equivalent call
	elseif v4.X - Constants.FLYOUT_SIDE_PADDING < Constants.FLYOUT_SIDE_PANEL_WIDTH then
		menuWidth = v4.X - Constants.FLYOUT_SIDE_PADDING
	else
		menuWidth = Constants.FLYOUT_SIDE_PANEL_WIDTH
	end

	local v5 = useAppPolicy(function(p)
		return p.getDisableBlackbirdEntrypoints() or false
	end)
	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = useHasRobloxSubscription()
	else
		isRobloxSubscriber = false
	end

	local referrerId, v6, v7

	if FFlagEnablePlusReferralRecipientFlyoutEntry then
		local pendingReferral = props.pendingReferral
		local recipientEligibility = props.recipientEligibility
		local v8

		if pendingReferral then
			v8 = pendingReferral.hasPending
		else
			v8 = false
		end

		if pendingReferral then
			referrerId = pendingReferral.referrerId
		end

		local v9

		if recipientEligibility then
			v9 = recipientEligibility.eligible
		else
			v9 = false
		end

		local v10 = usePlusReferralFlyoutBannerBlindness(
			not isRobloxSubscriber and v8 and v9,
			"RobloxPlusUpsellImpressionCount4",
			defineFastInt
		)
		v6 = not v5 and FFlagEnableBlackbird and not isRobloxSubscriber and v8 and v9 and v10
		local v11

		if recipientEligibility then
			v11 = recipientEligibility.isLoading
		else
			v11 = false
		end

		if pendingReferral then
			v7 = pendingReferral.isLoading or v8 and v11
		else
			v7 = false
		end
	else
		v6 = false
		v7 = false
	end

	local v8 = not v5

	if v8 then
		if BlackbirdUpsellBanner == nil then
			v8 = false
		else
			v8 = not (isRobloxSubscriber or v6 or v7)
		end
	end

	local v9

	if FFlagEnablePlusReferralFlyoutEntry then
		local senderEligibility = props.senderEligibility
		local v10

		if senderEligibility then
			v10 = senderEligibility.eligible
		else
			v10 = false
		end

		local v11 = usePlusReferralFlyoutBannerBlindness(isRobloxSubscriber and v10, "RobloxPlusUpsellImpressionCount2")
		v9 = isRobloxSubscriber and v10 and v11
	else
		v9 = false
	end

	local v10 = robuxBalance and robuxBalance >= 0
	local v11 = useFlyoutNavigationItems()
	local nextOrder = createNextOrder()
	local v12 = useSetDrawerVisible()
	local v13

	if FFlagFlyoutSidePanelUseSharedProfileCard then
		v13 = useRoactService(AppEventIngestService)
	else
		v13 = nil
	end

	useFlyoutSidePanelLogging(v11.myLibraryItems)

	local closeDrawer = React.useCallback(function()
		v12(false)
	end, { v12 })
	local v14

	if FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
		v14 = useFlyoutSwitchAccount(props.onSwitchAccountActivated, closeDrawer)
	end

	local onDrawerClosedAnalytics = React.useCallback(function(p)
		FlyoutAnalytics.onFlyoutSidePanelClosed(p)
	end, {})
	local onProfileActivated

	if FFlagFlyoutSidePanelUseSharedProfileCard then
		onProfileActivated = React.useCallback(function()
			closeDrawer()

			if props.onProfileActivated then
				props.onProfileActivated()
				local id = props.localUserModel and props.localUserModel.id or ""
				FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v13, "Profile", id)
			end
		end, { closeDrawer, v13, props.localUserModel, props.onProfileActivated })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.XLarge),
			PaddingBottom = UDim.new(0, v.Padding.XLarge),
			PaddingLeft = UDim.new(0, v.Padding.XLarge),
			PaddingRight = UDim.new(0, v.Padding.XLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v.Gap.Large),
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
	local profileCard2

	if FFlagFlyoutSidePanelUseSharedProfileCard then
		local createElement2 = React.createElement
		local v15 = {
			layoutOrder = nextOrder(),
			localUserModel = props.localUserModel,
			isRobloxSubscriber = 0,
			onProfileActivated = 0,
			onSwitchAccountActivated = 0,
			switchAccountAnchorRef = 0,
			useProfileFrameThumbnail = 0
		}

		if not FFlagEnableBlackbirdCheck then
			isRobloxSubscriber = nil
		end

		v15.isRobloxSubscriber = isRobloxSubscriber
		v15.onProfileActivated = onProfileActivated
		local onSwitchAccountActivated

		if FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
			onSwitchAccountActivated = v14.onActivated
		end

		v15.onSwitchAccountActivated = onSwitchAccountActivated
		local switchAccountAnchorRef

		if FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
			switchAccountAnchorRef = v14.anchorRef
		end

		v15.switchAccountAnchorRef = switchAccountAnchorRef

		v15.useProfileFrameThumbnail = FFlagFlyoutSidePanelUseProfileFrameThumbnail
		profileCard2 = createElement2(profileCard, v15)
	else
		local createElement2 = React.createElement
		local v15 = {
			layoutOrder = nextOrder(),
			localUserModel = props.localUserModel,
			isRobloxSubscriber = 0,
			onProfileActivated = 0,
			closeDrawer = 0
		}

		if not FFlagEnableBlackbirdCheck then
			isRobloxSubscriber = nil
		end

		v15.isRobloxSubscriber = isRobloxSubscriber
		v15.onProfileActivated = props.onProfileActivated
		v15.closeDrawer = closeDrawer
		profileCard2 = createElement2(FlyoutProfileCard, v15)
	end

	children.ProfileCard = profileCard2
	local switchAccountTooltip

	if FlyoutAccountSwitcherIXP.isSwitchAccountTooltipEnabled() then
		switchAccountTooltip = React.createElement(SwitchAccountTooltip, {
			anchorRef = v14.anchorRef,
			isEligible = props.onSwitchAccountActivated ~= nil,
			dismissRef = v14.dismissRef
		})
	end

	children.SwitchAccountTooltip = switchAccountTooltip
	local robuxPill

	if not (FFlagEnableFlyoutMenuRobuxCardRefactor or not v10) then
		robuxPill = React.createElement(RobuxPill, {
			layoutOrder = nextOrder(),
			openPurchaseRobuxPage = props.openPurchaseRobuxPage,
			robuxBalance = robuxBalance,
			closeDrawer = closeDrawer
		})
	end

	children.RobuxPill = robuxPill
	local robuxCard

	if FFlagEnableFlyoutMenuRobuxCardRefactor and (v10 or v8 or v9 or v6) then
		local createElement2 = React.createElement
		local view = Foundation.View
		local v15 = {
			tag = "col size-full-0 auto-y",
			LayoutOrder = nextOrder(),
			stroke = {
				Color = v.Color.Stroke.Default.Color3,
				Transparency = v.Color.Stroke.Default.Transparency,
				Thickness = v.Stroke.Standard
			},
			cornerRadius = UDim.new(0, v.Radius.Medium)
		}
		local robuxPill2

		if v10 then
			robuxPill2 = React.createElement(RobuxPill, {
				layoutOrder = 1,
				openPurchaseRobuxPage = props.openPurchaseRobuxPage,
				robuxBalance = robuxBalance,
				closeDrawer = closeDrawer
			})
		end

		local upsellDivider

		if v10 and v8 then
			upsellDivider = React.createElement(Divider, { LayoutOrder = 2 })
		end

		local blackbirdUpsellBanner

		if v8 then
			blackbirdUpsellBanner = React.createElement(BlackbirdUpsellBanner, {
				layoutOrder = 3,
				closeDrawer = closeDrawer
			})
		end

		local plusReferralDivider

		if v9 and (v10 or v8) then
			plusReferralDivider = React.createElement(Divider, { LayoutOrder = 4 })
		end

		local plusReferralBanner

		if v9 then
			plusReferralBanner = React.createElement(PlusReferralBanner, {
				layoutOrder = 5,
				closeDrawer = closeDrawer
			})
		end

		local plusReferralRecipientDivider

		if v6 and (v10 or v8 or v9) then
			plusReferralRecipientDivider = React.createElement(Divider, { LayoutOrder = 6 })
		end

		local plusReferralRecipientBanner

		if v6 then
			plusReferralRecipientBanner = React.createElement(PlusReferralRecipientBanner, {
				layoutOrder = 7,
				closeDrawer = closeDrawer,
				referrerId = referrerId,
				onOpenReferralSheet = props.onOpenReferralSheet
			})
		end

		robuxCard = createElement2(view, v15, {
			RobuxPill = robuxPill2,
			UpsellDivider = upsellDivider,
			BlackbirdUpsellBanner = blackbirdUpsellBanner,
			PlusReferralDivider = plusReferralDivider,
			PlusReferralBanner = plusReferralBanner,
			PlusReferralRecipientDivider = plusReferralRecipientDivider,
			PlusReferralRecipientBanner = plusReferralRecipientBanner
		})
	end

	children.RobuxCard = robuxCard

	children.MyLibrary = React.createElement(FlyoutNavigationList, {
		layoutOrder = nextOrder(),
		navigationItems = v11.myLibraryItems,
		closeDrawer = closeDrawer,
		buildCreatorWebNavUrl = props.buildCreatorWebNavUrl
	})

	children.Divider = React.createElement(Divider, { LayoutOrder = nextOrder() })

	children.AdditionalNavigation = React.createElement(FlyoutNavigationList, {
		layoutOrder = nextOrder(),
		navigationItems = v11.additionalNavigationItems,
		closeDrawer = closeDrawer,
		buildCreatorWebNavUrl = props.buildCreatorWebNavUrl
	})
	local switchAccountButton

	if props.onSwitchAccountActivated and FlyoutAccountSwitcherIXP.isBottomButtonEnabled() then
		local createElement2 = React.createElement
		local v15 = { layoutOrder = nextOrder(), onSwitchAccountActivated = 0, closeDrawer = 0 }
		local onSwitchAccountActivated

		if FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
			onSwitchAccountActivated = v14.onActivated
		else
			onSwitchAccountActivated = props.onSwitchAccountActivated
		end

		v15.onSwitchAccountActivated = onSwitchAccountActivated
		local closeDrawer2

		if not FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
			closeDrawer2 = closeDrawer
		end

		v15.closeDrawer = closeDrawer2
		switchAccountButton = createElement2(FlyoutSwitchAccountButton, v15)
	end

	children.SwitchAccountButton = switchAccountButton

	children.QuickSigninButton = React.createElement(FlyoutQuickSigninButton, {
		layoutOrder = nextOrder(),
		closeDrawer = closeDrawer
	})

	children.LogOut = props.renderLogOut(nextOrder())
	local reportLogs

	if props.openReportLogConfirmation then
		reportLogs = React.createElement(FlyoutReportLogs, {
			layoutOrder = nextOrder(),
			openReportLogConfirmation = props.openReportLogConfirmation,
			closeDrawer = closeDrawer
		})
	end

	children.ReportLogs = reportLogs

	children.TermsPrivacyFooter = React.createElement(TermsPrivacyFooter, {
		layoutOrder = nextOrder(),
		closeDrawer = closeDrawer
	})
	local element = createElement(fragment, nil, children)

	useDismissFlyoutOnPartyTopBanner()
	return React.createElement(DrawerContainer, {
		displayOrder = props.displayOrder,
		menuWidth = menuWidth,
		children = element,
		leftOffset = left,
		topOffset = topOffset,
		bottomOffset = bottomOffset,
		deviceSafeInsets = deviceSafeInsets,
		backgroundStyle = v.Color.Surface.Surface_0,
		onDrawerClosedAnalytics = onDrawerClosedAnalytics
	})
end)
