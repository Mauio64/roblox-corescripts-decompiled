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
local FFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local v32 = if not FFlagEnableBlackbirdCheck then nil else require(script.Parent.Parent.Hooks.useHasRobloxSubscription)
local v33 = if not FFlagEnableBlackbird or (not FFlagEnableBlackbirdOnFlyoutMenu or not v28) then nil else require(script.Parent.BlackbirdUpsellBanner)

local function selectStatusBarHeight(p1) -- line: 65
	return p1.TopBar.statusBarHeight or 0
end
local function selectGlobalGuiInset(p2) -- line: 69
	return p2.GlobalGuiInset or {
		left = 0,
		top = 0,
		right = 0,
		bottom = 0
	}
end

return React.memo(function(t1: {[any]: any}, _) -- line: 73
	-- upvalues: useTokens (copy), useLocalRobuxBalance (copy), useSelector (copy), selectStatusBarHeight (copy), selectGlobalGuiInset (copy), FFlagEnableFlyoutOnNavRail (copy), useScreenSize (copy), Constants (copy), useAppPolicy (copy), FFlagEnableBlackbirdCheck (copy), v32 (copy), v33 (copy), useFlyoutNavigationItems (copy), createNextOrder (copy), useSetDrawerVisible (copy), React (copy), FlyoutAnalytics (copy), FlyoutProfileCard (copy), FFlagEnableFlyoutMenuRobuxCardRefactor (copy), RobuxPill (copy), Foundation (copy), Divider (copy), FlyoutNavigationList (copy), FlyoutSwitchAccountButton (copy), FlyoutQuickSigninButton (copy), FlyoutReportLogs (copy), FFlagFlyoutTermsPrivacyFooter (copy), TermsPrivacyFooter (copy), useDismissFlyoutOnPartyTopBanner (copy), DrawerContainer (copy)
	local v40 = useTokens()
	local v41 = useLocalRobuxBalance()
	local v42 = useSelector(selectStatusBarHeight)
	local v43 = useSelector(selectGlobalGuiInset)
	local v44 = v43.top + v42
	local bottom = v43.bottom
	local v46 = if not FFlagEnableFlyoutOnNavRail then v43.left else nil
	local v47 = useScreenSize()
	local v48 = if not (v47.X - Constants.FLYOUT_SIDE_PADDING < Constants.FLYOUT_SIDE_PANEL_WIDTH) then Constants.FLYOUT_SIDE_PANEL_WIDTH else v47.X - Constants.FLYOUT_SIDE_PADDING
	local v49 = useAppPolicy(function(p4) -- line: 88
		return p4.getDisableBlackbirdEntrypoints() or false
	end)
	local v50 = not not FFlagEnableBlackbirdCheck and v32()
	local v51 = not v49 and (v33 ~= nil and not v50)
	local v52 = v41 and v41 >= 0
	local v53 = v52 or v51
	local v54 = useFlyoutNavigationItems()
	local v55 = createNextOrder()
	local v56 = useSetDrawerVisible()
	local v57 = React.useCallback(function() -- line: 100
		-- upvalues: v56 (copy)
		v56(false)
	end, { v56 })
	local v58 = React.useCallback(function(p5) -- line: 103
		-- upvalues: FlyoutAnalytics (copy)
		FlyoutAnalytics.onFlyoutSidePanelClosed(p5)
	end, {})
	local v59 = React.createElement(React.Fragment, nil, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v40.Padding.XLarge),
			PaddingBottom = UDim.new(0, v40.Padding.XLarge),
			PaddingLeft = UDim.new(0, v40.Padding.XLarge),
			PaddingRight = UDim.new(0, v40.Padding.XLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v40.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		ProfileCard = React.createElement(FlyoutProfileCard, {
			layoutOrder = v55(),
			localUserModel = t1.localUserModel,
			isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v50,
			onProfileActivated = t1.onProfileActivated,
			closeDrawer = v57
		}),
		RobuxPill = if FFlagEnableFlyoutMenuRobuxCardRefactor or not v52 then nil else React.createElement(RobuxPill, {
			layoutOrder = v55(),
			openPurchaseRobuxPage = t1.openPurchaseRobuxPage,
			robuxBalance = v41,
			closeDrawer = v57
		}),
		RobuxCard = if not FFlagEnableFlyoutMenuRobuxCardRefactor or not v53 then nil else React.createElement(Foundation.View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = v55(),
			stroke = {
				Color = v40.Color.Stroke.Default.Color3,
				Transparency = v40.Color.Stroke.Default.Transparency,
				Thickness = v40.Stroke.Standard
			},
			cornerRadius = UDim.new(0, v40.Radius.Medium)
		}, {
			RobuxPill = if not v52 then nil else React.createElement(RobuxPill, {
				layoutOrder = 1,
				openPurchaseRobuxPage = t1.openPurchaseRobuxPage,
				robuxBalance = v41,
				closeDrawer = v57
			}),
			UpsellDivider = if not v52 or not v51 then nil else React.createElement(Divider, {
				LayoutOrder = 2
			}),
			BlackbirdUpsellBanner = if not v51 then nil else React.createElement(v33, {
				layoutOrder = 3,
				closeDrawer = v57
			})
		}),
		MyLibrary = React.createElement(FlyoutNavigationList, {
			layoutOrder = v55(),
			navigationItems = v54.myLibraryItems,
			closeDrawer = v57,
			buildCreatorWebNavUrl = t1.buildCreatorWebNavUrl
		}),
		Divider = React.createElement(Divider, {
			LayoutOrder = v55()
		}),
		AdditionalNavigation = React.createElement(FlyoutNavigationList, {
			layoutOrder = v55(),
			navigationItems = v54.additionalNavigationItems,
			closeDrawer = v57,
			buildCreatorWebNavUrl = t1.buildCreatorWebNavUrl
		}),
		SwitchAccountButton = if not t1.onSwitchAccountActivated then nil else React.createElement(FlyoutSwitchAccountButton, {
			layoutOrder = v55(),
			onSwitchAccountActivated = t1.onSwitchAccountActivated,
			closeDrawer = v57
		}),
		QuickSigninButton = React.createElement(FlyoutQuickSigninButton, {
			layoutOrder = v55(),
			closeDrawer = v57
		}),
		LogOut = t1.renderLogOut(v55()),
		ReportLogs = if not t1.openReportLogConfirmation then nil else React.createElement(FlyoutReportLogs, {
			layoutOrder = v55(),
			openReportLogConfirmation = t1.openReportLogConfirmation,
			closeDrawer = v57
		}),
		TermsPrivacyFooter = if not FFlagFlyoutTermsPrivacyFooter then nil else React.createElement(TermsPrivacyFooter, {
			layoutOrder = v55(),
			closeDrawer = v57
		})
	})

	useDismissFlyoutOnPartyTopBanner()

	return React.createElement(DrawerContainer, {
		displayOrder = t1.displayOrder,
		menuWidth = v48,
		children = v59,
		leftOffset = v46,
		topOffset = v44,
		bottomOffset = bottom,
		backgroundStyle = v40.Color.Surface.Surface_0,
		onDrawerClosedAnalytics = v58
	})
end)
