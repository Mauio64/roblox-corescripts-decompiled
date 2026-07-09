local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactAnalyticsTopBar = require(Modules.LuaApp.Services.RoactAnalyticsTopBar)
local AppPage = require(Modules.LuaApp.AppPage)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local TopBarConstants = require(Modules.LuaApp.Components.TopBar.TopBarConstants)
local GetFFlagEnableUseShowTopBar = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableUseShowTopBar
local FFlagLuaAppImproveAccountSwitcherPeekView = require(Modules.LuaApp.Flags.FFlagLuaAppImproveAccountSwitcherPeekView)
local SocialNetworksInEditProfileIXP = require(CorePackages.Workspace.Packages.EditProfile.Flags).SocialNetworksInEditProfileIXP
local FFlagLuaAppMoveProfileIntoTopBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBar
local v42 = game:DefineFastFlag("LuaAppFixWebViewUnderlyingBackButton", false)
local v43 = game:DefineFastFlag("AXMigrateMakeBackButtonToFocusNavigation3", false)
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagQRInSearchScanner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRInSearchScanner
local FFlagQRInSearchProfileQR = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRInSearchProfileQR
local FFlagCiDeprecateFindFriendsModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCiDeprecateFindFriendsModal
local FFlagTCShareLinkErrorModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCShareLinkErrorModal
local FFlagFixMoreSubMenuTitleFlash = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFixMoreSubMenuTitleFlash
local EngineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagEnableMobileGameJoinCard = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagEnableHomeRobloxLogo = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableHomeRobloxLogo
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3bTopBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3bTopBar
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v57 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v58 = GuiService:IsTenFootInterface()
local v59 = Images["icons/navigation/pushBack"]
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function v61(p1) -- line: 92
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	if FFlagUseNavigationSelectors then
		return Selectors.selectCurrentLegacyRoute(p1)
	end

	local history = p1.Navigation.history

	return history[#history]
end
local function useFocusNavigationBindings(p2, p3: ((...any) -> ...any)) -- line: 102
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v68 = ReactFocusNavigation.useEventMap(t1, p2)
	local v69 = React.useMemo(function() -- line: 104
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p3 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4) -- line: 107
					-- upvalues: p3 (copy)
					p4.cancelled = true
					p3()
				end)
			}
		}
	end, { p3 })

	return ReactFocusNavigation.useEventHandlerMap(v69, v68)
end
local function makeBackButton(p5: ((...any) -> ...any)?, b1: boolean?) -- line: 117
	-- upvalues: Roact (copy), t (copy), Dash (copy), v43 (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), validateImage (copy), FFlagEnableLeftNavOnConsole (copy), GetFFlagEnableUseShowTopBar (copy), v58 (copy), AppPage (copy), AvatarScreen (copy), FFlagFixMoreSubMenuTitleFlash (copy), AppPageProperties (copy), FFlagCiDeprecateFindFriendsModal (copy), FFlagTCShareLinkErrorModal (copy), FFlagQRInSearchScanner (copy), FFlagQRInSearchProfileQR (copy), FFlagLuaAppImproveAccountSwitcherPeekView (copy), SocialNetworksInEditProfileIXP (copy), FFlagEnableMobileGameJoinCard (copy), RunService (copy), EngineFeature (copy), v42 (copy), withStyle (copy), v59 (copy), IconButton (copy), TopBarConstants (copy), IconSize (copy), RoactGamepad (copy), useNavigation (copy), useRoactService (copy), RoactAnalyticsTopBar (copy), FFlagSignalsNavP3bTopBar (copy), v57 (copy), useSignalState (copy), useSelector (copy), v61 (copy), useDispatch (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateBack (copy), useFocusNavigationBindings (copy), Cryo (copy), useTableWrappedCallbackRef (copy), RoactNavigation (copy), RoactServices (copy), RoactRodux (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	local u72 = Roact.PureComponent:extend("BackButton")

	u72.validateProps = t.strictInterface({
		formFactor = t.string,
		isCompactView = t.boolean,
		isSearching = t.boolean,
		isSecondary = t.optional(t.boolean),
		setVisible = Dash.isCallable,
		cancelSearch = Dash.isCallable,
		activateSearch = Dash.isCallable,
		buttonRef = t.optional(t.table),
		onGoBack = if not v43 then nil else t.callback,
		currentRoute = t.table,
		navigateBack = if v43 then nil else Dash.isCallable,
		navigation = t.table,
		analytics = t.table,
		titleText = if not FFlagLuaAppMoveProfileIntoTopBar and (not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo) then nil else t.optional(t.string),
		customIcon = t.optional(validateImage),
		routeName = if not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo then nil else t.optional(t.string)
	})

	local u73 = not v43 and function(p6) -- line: 174
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), GetFFlagEnableUseShowTopBar (copy), v58 (copy), AppPage (copy)
		if not FFlagEnableLeftNavOnConsole and (not GetFFlagEnableUseShowTopBar() and v58) then
			return true
		end

		local currentRoute = p6.currentRoute

		return currentRoute[#currentRoute].name == AppPage.AvatarExperienceRoot
	end or function(p7) -- line: 159
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), GetFFlagEnableUseShowTopBar (copy), v58 (copy), AppPage (copy)
		if not FFlagEnableLeftNavOnConsole and (not GetFFlagEnableUseShowTopBar() and v58) then
			return true
		end

		return p7[#p7].name == AppPage.AvatarExperienceRoot
	end

	local function canGoBackInAvatarExperience(p8) -- line: 191
		-- upvalues: AvatarScreen (copy)
		return (p8 and (not not p8.state and p8.state.routeName) or "") ~= AvatarScreen.AvatarExperienceLandingPage
	end

	function u72.init(p9) -- line: 196
		-- upvalues: v43 (copy), u73 (ref), p5 (copy)
		if not v43 then
			function p9.defaultBackButtonHandler() -- line: 198
				-- upvalues: p9 (copy), u73 (ref), v43 (copy)
				local analytics = p9.props.analytics
				local currentRoute = p9.props.currentRoute
				local navigation = p9.props.navigation
				local navigateBack = p9.props.navigateBack

				if u73(if not v43 then p9.props else p9.props.currentRoute) then
					local routeName = navigation.state.routeName

					analytics.reportBackButtonClick(routeName)
					navigation.goBack()

					return
				end

				local name = currentRoute[#currentRoute].name

				analytics.reportBackButtonClick(name)
				navigateBack()
			end

			p9.onBackButtonActivated = p5 or p9.defaultBackButtonHandler
		end
	end

	local function isVisible(p10) -- line: 223
		-- upvalues: b1 (copy), u73 (ref), v43 (copy), AvatarScreen (copy), FFlagFixMoreSubMenuTitleFlash (copy), AppPageProperties (copy), AppPage (copy), FFlagCiDeprecateFindFriendsModal (copy), FFlagTCShareLinkErrorModal (copy), FFlagQRInSearchScanner (copy), FFlagQRInSearchProfileQR (copy), FFlagLuaAppImproveAccountSwitcherPeekView (copy), SocialNetworksInEditProfileIXP (copy), FFlagEnableMobileGameJoinCard (copy), RunService (copy)
		if b1 then
			return true
		end

		if u73(if not v43 then p10 else p10.currentRoute) then
			local navigation = p10.navigation

			return (navigation and (not not navigation.state and navigation.state.routeName) or "") ~= AvatarScreen.AvatarExperienceLandingPage
		end

		if FFlagFixMoreSubMenuTitleFlash then
			local navigation = p10.navigation
			local v87 = navigation and (not not navigation.state and navigation.state.routeName) or ""

			if AppPageProperties[v87] and AppPageProperties[v87].alwaysShowBackButton then
				return true
			end
		end

		local currentRoute = p10.currentRoute

		for i = #currentRoute, 1, -1 do
			local name = currentRoute[i].name

			if name ~= AppPage.GameDetail and name ~= AppPage.ProfilePlatform and (not FFlagCiDeprecateFindFriendsModal or name ~= AppPage.ContactImporter) and name ~= AppPage.TrustedContactsModal and name ~= AppPage.TrustedFriendsVPCPrologue and (not FFlagTCShareLinkErrorModal or name ~= AppPage.TrustedFriendsShareLinkErrorModal) and name ~= AppPage.FriendsRenameInfoModal and (not FFlagQRInSearchScanner and not FFlagQRInSearchProfileQR or name ~= AppPage.SettingsPermissionInteractiveAlert) and name ~= AppPage.SocialToast and name ~= AppPage.SocialPurchaseExperience and name ~= AppPage.SocialUnableToJoinExperience and name ~= AppPage.InviteLinkExpiredModal and name ~= AppPage.ShareLinkInvalidModal and name ~= AppPage.SocialMessageToast and name ~= AppPage.SquadLobby and name ~= AppPage.InfoPeekView and name ~= AppPage.SponsoredTooltipPeekView and (not FFlagLuaAppImproveAccountSwitcherPeekView or name ~= AppPage.AccountSelectorPeekView) and ((not FFlagLuaAppImproveAccountSwitcherPeekView or name ~= AppPage.AccountSwitchingAddAccountPeekView) and (not SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() or name ~= AppPage.EditSocialNetworks) and (not SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() or name ~= AppPage.EditSocialNetworksError) and name ~= AppPage.GameFilterMenuPeekView and (not FFlagEnableMobileGameJoinCard or name ~= AppPage.GameJoinCard)) then
				if AppPageProperties[name] and AppPageProperties[name].nativeWrapper and not RunService:IsStudio() then
					return false
				end

				return i > 1
			end
		end

		return false
	end

	function u72.updateVisibility(p11, p12) -- line: 294
		-- upvalues: isVisible (copy)
		local v93 = isVisible(p11.props)

		if v93 ~= p12 then
			p11.props.setVisible(v93)
		end
	end
	function u72.didMount(p13) -- line: 301
		p13:updateVisibility(nil)
	end

	local function isNativeWrapperPage(p14) -- line: 305
		-- upvalues: AppPageProperties (copy)
		local name = p14[#p14].name

		return AppPageProperties[name] and AppPageProperties[name].nativeWrapper
	end

	function u72.didUpdate(p15, p16, _) -- line: 310
		-- upvalues: EngineFeature (copy), v42 (copy), AppPageProperties (copy), RunService (copy), isVisible (copy)
		if not EngineFeature and v42 then
			local currentRoute = p15.props.currentRoute
			local name = currentRoute[#currentRoute].name

			if AppPageProperties[name] and AppPageProperties[name].nativeWrapper and not RunService:IsStudio() then
				return nil
			end
		end

		p15:updateVisibility((isVisible(p16)))
	end
	function u72.render(p18) -- line: 323
		-- upvalues: withStyle (copy), v59 (copy), Roact (copy), IconButton (copy), TopBarConstants (copy), IconSize (copy), v43 (copy), RoactGamepad (copy)
		return withStyle(function(p19) -- line: 324
			-- upvalues: p18 (copy), v59 (copy), Roact (copy), IconButton (copy), TopBarConstants (copy), IconSize (copy), v43 (copy), RoactGamepad (copy)
			local v126 = if not p18.props.customIcon then v59 else p18.props.customIcon

			return Roact.createElement(IconButton, {
				size = UDim2.new(0, TopBarConstants.BACK_BUTTON_SIZE, 1, 0),
				position = if not p18.props.isSecondary then nil else UDim2.new(0, 0, 0, -8),
				icon = v126,
				iconSize = IconSize.Medium,
				iconColor3 = p19.Theme.IconEmphasis.Color,
				iconTransparency = p19.Theme.IconEmphasis.Transparency,
				onActivated = if not v43 then p18.onBackButtonActivated else p18.props.onGoBack,
				inputBindings = if not v43 then {
					Back = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p18.onBackButtonActivated)
				} else nil,
				buttonRef = p18.props.buttonRef
			})
		end)
	end

	local function BackButtonContainer(p20) -- line: 347
		-- upvalues: useNavigation (copy), useRoactService (copy), RoactAnalyticsTopBar (copy), FFlagSignalsNavP3bTopBar (copy), v57 (copy), useSignalState (copy), useSelector (copy), v61 (copy), useDispatch (copy), React (copy), p5 (copy), u73 (ref), v43 (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateBack (copy), useFocusNavigationBindings (copy), Cryo (copy), useTableWrappedCallbackRef (copy), u72 (ref)
		local v104 = useNavigation()
		local v105 = useRoactService(RoactAnalyticsTopBar)
		local u107

		if FFlagSignalsNavP3bTopBar then
			local v106 = v57(false)

			u107 = useSignalState(v106.getCurrentLegacyRoute)
		else
			u107 = useSelector(v61)
		end

		local v108 = useDispatch()
		local v109 = React.useCallback(function() -- line: 361
			-- upvalues: p5 (copy), u73 (ref), v43 (copy), u107 (ref), p20 (copy), v104 (copy), v105 (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v108 (copy), NavigateBack (copy)
			if p5 then
				p5()

				return
			end

			if u73(if not v43 then p20 else u107) then
				local routeName = v104.state.routeName

				v105.reportBackButtonClick(routeName)
				v104.goBack()

				return
			end

			local name = u107[#u107].name

			v105.reportBackButtonClick(name)

			if FFlagSignalsNavP3Dispatch then
				v26.back()

				return
			end

			v108(NavigateBack())
		end, {
			p5,
			v105,
			u107,
			v104,
			v108
		})
		local v110 = useFocusNavigationBindings(p20.buttonRef, v109)
		local v111 = Cryo.Dictionary.join(p20, {
			onGoBack = v109,
			buttonRef = useTableWrappedCallbackRef(v110),
			analytics = v105,
			navigation = v104,
			currentRoute = u107
		})

		return React.createElement(u72, v111)
	end

	if v43 then
		return BackButtonContainer
	end

	u72 = RoactNavigation.withNavigation(u72)
	u72 = RoactServices.connect({
		analytics = RoactAnalyticsTopBar
	})(u72)
	u72 = RoactRodux.connect(function(p21, _) -- line: 408
		-- upvalues: FFlagSignalsNavP3bTopBar (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
		return {
			currentRoute = if not FFlagSignalsNavP3bTopBar then if not FFlagUseNavigationSelectors then p21.Navigation.history[#p21.Navigation.history] else Selectors.selectCurrentLegacyRoute(p21) else nil
		}
	end, function(p23) -- line: 418
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateBack (copy)
		return {
			navigateBack = function() -- line: 420
				-- upvalues: FFlagSignalsNavP3Dispatch (copy), v26 (copy), p23 (copy), NavigateBack (copy)
				if FFlagSignalsNavP3Dispatch then
					return v26.back()
				end

				return p23(NavigateBack())
			end
		}
	end)(u72)

	if FFlagSignalsNavP3bTopBar then
		local v78 = u72

		function u72(p24) -- line: 433
			-- upvalues: v57 (copy), useSignalState (copy), React (copy), v78 (copy), Cryo (copy)
			local v116 = v57(false)
			local v117 = useSignalState(v116.getCurrentLegacyRoute)

			return React.createElement(v78, Cryo.Dictionary.union(p24, {
				currentRoute = v117
			}))
		end
	end

	return u72
end

return makeBackButton
