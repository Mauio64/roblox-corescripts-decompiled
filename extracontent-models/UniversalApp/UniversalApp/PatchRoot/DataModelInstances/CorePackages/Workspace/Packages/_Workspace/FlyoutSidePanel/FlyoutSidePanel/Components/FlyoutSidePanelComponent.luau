local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local useLocalRobuxBalance = require(Parent.RobloxAppHooks).useLocalRobuxBalance
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Divider = Foundation.Divider
local createNextOrder = require(Parent.ReactUtils).createNextOrder
local Constants = require(script.Parent.Parent.Constants)
local useFlyoutNavigationItems = require(script.Parent.Parent.Hooks.useFlyoutNavigationItems)
local DrawerContainer = require(Parent.Drawer).DrawerContainer
local RobuxPill = require(script.Parent.RobuxPill)
local FlyoutNavigationList = require(script.Parent.FlyoutNavigationList)
local FlyoutQuickSigninButton = require(script.Parent.FlyoutQuickSigninButton)
local FlyoutReportLogs = require(script.Parent.FlyoutReportLogs)
local FlyoutSwitchAccountButton = require(script.Parent.FlyoutSwitchAccountButton)
local FlyoutProfileCard = require(script.Parent.FlyoutProfileCard)
local useDismissFlyoutOnPartyTopBanner = require(script.Parent.Parent.Hooks.useDismissFlyoutOnPartyTopBanner)
local useSetDrawerVisible = require(Parent.Drawer).Hooks.useSetDrawerVisible
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local TermsPrivacyFooter = require(script.Parent.TermsPrivacyFooter)
local FFlagFlyoutTermsPrivacyFooter = require(script.Parent.Parent.Flags.FFlagFlyoutTermsPrivacyFooter)
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local v28 = game:DefineFastFlag("EnableBlackbirdUpsellOnFlyoutMenu", false)
local FFlagEnableFlyoutMenuRobuxCardRefactor = SharedFlags.FFlagEnableFlyoutMenuRobuxCardRefactor
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local v31 = if not FFlagEnableBlackbirdCheck then nil else require(script.Parent.Parent.Hooks.useHasRobloxSubscription)
local v32 = if not FFlagEnableBlackbird or (not FFlagEnableBlackbirdOnFlyoutMenu or not v28) then nil else require(script.Parent.BlackbirdUpsellBanner)

local function selectStatusBarHeight(p1) -- line: 64
	return p1.TopBar.statusBarHeight or 0
end
local function selectGlobalGuiInset(p2) -- line: 68
	return p2.GlobalGuiInset or {
		left = 0,
		top = 0,
		right = 0,
		bottom = 0
	}
end

return React.memo(function(t1: {[any]: any}, _) -- line: 72
	-- upvalues: useTokens (copy), useLocalRobuxBalance (copy), useSelector (copy), selectStatusBarHeight (copy), selectGlobalGuiInset (copy), useScreenSize (copy), Constants (copy), useAppPolicy (copy), FFlagEnableBlackbirdCheck (copy), v31 (copy), v32 (copy), useFlyoutNavigationItems (copy), createNextOrder (copy), useSetDrawerVisible (copy), React (copy), FlyoutAnalytics (copy), FlyoutProfileCard (copy), FFlagEnableFlyoutMenuRobuxCardRefactor (copy), RobuxPill (copy), Foundation (copy), Divider (copy), FlyoutNavigationList (copy), FlyoutSwitchAccountButton (copy), FlyoutQuickSigninButton (copy), FlyoutReportLogs (copy), FFlagFlyoutTermsPrivacyFooter (copy), TermsPrivacyFooter (copy), useDismissFlyoutOnPartyTopBanner (copy), DrawerContainer (copy)
	local v39 = useTokens()
	local v40 = useLocalRobuxBalance()
	local v41 = useSelector(selectStatusBarHeight)
	local v42 = useSelector(selectGlobalGuiInset)
	local v43 = v42.top + v41
	local bottom = v42.bottom
	local left = v42.left
	local v46 = useScreenSize()
	local v47 = if not (v46.X - Constants.FLYOUT_SIDE_PADDING < Constants.FLYOUT_SIDE_PANEL_WIDTH) then Constants.FLYOUT_SIDE_PANEL_WIDTH else v46.X - Constants.FLYOUT_SIDE_PADDING
	local v48 = useAppPolicy(function(p4) -- line: 87
		return p4.getDisableBlackbirdEntrypoints() or false
	end)
	local v49 = not not FFlagEnableBlackbirdCheck and v31()
	local v50 = not v48 and (v32 ~= nil and not v49)
	local v51 = v40 and v40 >= 0
	local v52 = v51 or v50
	local v53 = useFlyoutNavigationItems()
	local v54 = createNextOrder()
	local v55 = useSetDrawerVisible()
	local v56 = React.useCallback(function() -- line: 99
		-- upvalues: v55 (copy)
		v55(false)
	end, { v55 })
	local v57 = React.useCallback(function(p5) -- line: 102
		-- upvalues: FlyoutAnalytics (copy)
		FlyoutAnalytics.onFlyoutSidePanelClosed(p5)
	end, {})
	local v58 = React.createElement(React.Fragment, nil, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v39.Padding.XLarge),
			PaddingBottom = UDim.new(0, v39.Padding.XLarge),
			PaddingLeft = UDim.new(0, v39.Padding.XLarge),
			PaddingRight = UDim.new(0, v39.Padding.XLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v39.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		ProfileCard = React.createElement(FlyoutProfileCard, {
			layoutOrder = v54(),
			localUserModel = t1.localUserModel,
			isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v49,
			onProfileActivated = t1.onProfileActivated,
			closeDrawer = v56
		}),
		RobuxPill = if FFlagEnableFlyoutMenuRobuxCardRefactor or not v51 then nil else React.createElement(RobuxPill, {
			layoutOrder = v54(),
			openPurchaseRobuxPage = t1.openPurchaseRobuxPage,
			robuxBalance = v40,
			closeDrawer = v56
		}),
		RobuxCard = if not FFlagEnableFlyoutMenuRobuxCardRefactor or not v52 then nil else React.createElement(Foundation.View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = v54(),
			stroke = {
				Color = v39.Color.Stroke.Default.Color3,
				Transparency = v39.Color.Stroke.Default.Transparency,
				Thickness = v39.Stroke.Standard
			},
			cornerRadius = UDim.new(0, v39.Radius.Medium)
		}, {
			RobuxPill = if not v51 then nil else React.createElement(RobuxPill, {
				layoutOrder = 1,
				openPurchaseRobuxPage = t1.openPurchaseRobuxPage,
				robuxBalance = v40,
				closeDrawer = v56
			}),
			UpsellDivider = if not v51 or not v50 then nil else React.createElement(Divider, {
				LayoutOrder = 2
			}),
			BlackbirdUpsellBanner = if not v50 then nil else React.createElement(v32, {
				layoutOrder = 3,
				closeDrawer = v56
			})
		}),
		MyLibrary = React.createElement(FlyoutNavigationList, {
			layoutOrder = v54(),
			navigationItems = v53.myLibraryItems,
			closeDrawer = v56,
			buildCreatorWebNavUrl = t1.buildCreatorWebNavUrl
		}),
		Divider = React.createElement(Divider, {
			LayoutOrder = v54()
		}),
		AdditionalNavigation = React.createElement(FlyoutNavigationList, {
			layoutOrder = v54(),
			navigationItems = v53.additionalNavigationItems,
			closeDrawer = v56,
			buildCreatorWebNavUrl = t1.buildCreatorWebNavUrl
		}),
		SwitchAccountButton = if not t1.onSwitchAccountActivated then nil else React.createElement(FlyoutSwitchAccountButton, {
			layoutOrder = v54(),
			onSwitchAccountActivated = t1.onSwitchAccountActivated,
			closeDrawer = v56
		}),
		QuickSigninButton = React.createElement(FlyoutQuickSigninButton, {
			layoutOrder = v54(),
			closeDrawer = v56
		}),
		LogOut = t1.renderLogOut(v54()),
		ReportLogs = if not t1.openReportLogConfirmation then nil else React.createElement(FlyoutReportLogs, {
			layoutOrder = v54(),
			openReportLogConfirmation = t1.openReportLogConfirmation,
			closeDrawer = v56
		}),
		TermsPrivacyFooter = if not FFlagFlyoutTermsPrivacyFooter then nil else React.createElement(TermsPrivacyFooter, {
			layoutOrder = v54(),
			closeDrawer = v56
		})
	})

	useDismissFlyoutOnPartyTopBanner()

	return React.createElement(DrawerContainer, {
		displayOrder = t1.displayOrder,
		menuWidth = v47,
		children = v58,
		leftOffset = left,
		topOffset = v43,
		bottomOffset = bottom,
		backgroundStyle = v39.Color.Surface.Surface_0,
		onDrawerClosedAnalytics = v57
	})
end)
