local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Signals = require(CorePackages.Packages.Signals)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage

local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/fvT")
local module3 = require("@luauforge/bundled/dFu")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local tutils = require(CorePackages.Packages.tutils)
local v5 = { navigation = true }
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module5 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module5.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local module6 = require("@luauforge/bundled/dGJ")
local module7 = require("@luauforge/bundled/fAr")

local module8 = require("@luauforge/bundled/fAs")

local socialNetworksInEditProfileIXP = require("@luauforge/bundled/dKb").SocialNetworksInEditProfileIXP

local fFlagLuaAppMoveProfileIntoTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBar
local defineFastFlag = game:DefineFastFlag("LuaAppFixWebViewUnderlyingBackButton", false)
local module9 = require("@luauforge/bundled/dKL")
local fFlagQRInSearchScanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRInSearchScanner
local fFlagQRInSearchProfileQR = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRInSearchProfileQR

local fFlagCiDeprecateFindFriendsModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCiDeprecateFindFriendsModal
local fFlagTCShareLinkErrorModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkErrorModal
local fFlagFixMoreSubMenuTitleFlash = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixMoreSubMenuTitleFlash

local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local fFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMobileGameJoinCard

local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialCarouselBuildPresence
local fFlagEnableHomeRobloxLogo = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableHomeRobloxLogo
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3bTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3bTopBar
local fFlagNavigationCallbackParam = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagNavigationCallbackParam
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3bTopBar then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local iconsnavigationpushBack = images["icons/navigation/pushBack"]

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function routeNameOf(p2)
	return p2 and p2.state and p2.state.routeName or ""
end

local function fn(p2)
	if fFlagUseNavigationSelectors then
		return selectors.selectCurrentLegacyRoute(p2)
	end

	local history = p2.Navigation.history
	return history[#history]
end

local function useFocusNavigationBindings(buttonRef, callback)
	local v6 = ReactFocusNavigation.useEventMap(navigateBacks, buttonRef)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					p2.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local function isNativeWrapperPage(list)
	local name = list[#list].name
	return module6[name] and module6[name].nativeWrapper
end

local function useBackButtonRouteProps(current, isVisible)
	local legacyNavigationStore = getLegacyNavigationStore(false)
	local routeName = current and current.state and current.state.routeName or ""

	local v6 = React.useMemo(function()
		local v7 = {
			state = { routeName = routeName }
		}
		return Signals.createComputed(function(p2)
			local currentLegacyRoute = legacyNavigationStore.getCurrentLegacyRoute(p2)
			local v8 = {
				routeIsVisible = isVisible({
					currentRoute = currentLegacyRoute,
					navigation = v7
				}),
				isNativeWrapperPage = 0
			}
			local name = currentLegacyRoute[#currentLegacyRoute].name
			v8.isNativeWrapperPage = (module6[name] and module6[name].nativeWrapper) == true
			return v8
		end, Dash.shallowEqual)
	end, { legacyNavigationStore, routeName, isVisible })

	local ref = React.useRef(current)
	ref.current = current
	return useSignalState(v6), ref
end

local function makeBackButton(callback, p2)
	local extended = Roact.PureComponent:extend("BackButton")

	local strictInterface = t.strictInterface
	local v6 = {
		formFactor = t.string,
		isCompactView = t.boolean,
		isSearching = t.boolean,
		isSecondary = t.optional(t.boolean),
		setVisible = Dash.isCallable,
		cancelSearch = Dash.isCallable,
		activateSearch = Dash.isCallable,
		buttonRef = t.optional(t.table),
		onGoBack = t.callback,
		currentRoute = 0,
		routeIsVisible = 0,
		isNativeWrapperPage = 0,
		navigation = 0,
		analytics = 0,
		titleText = 0,
		customIcon = 0,
		routeName = 0
	}

	local v7 = if not fFlagSignalsNavP3bTopBar then t.table else nil
	v6.currentRoute = v7
	local v8 = if fFlagSignalsNavP3bTopBar then t.boolean else nil
	v6.routeIsVisible = v8
	local v9 = if fFlagSignalsNavP3bTopBar then t.boolean else nil
	v6.isNativeWrapperPage = v9

	v6.navigation = t.table

	v6.analytics = t.table

	local v10 = if fFlagLuaAppMoveProfileIntoTopBar or module9 or fFlagEnableHomeRobloxLogo then t.optional(t.string) else nil
	v6.titleText = v10

	v6.customIcon = t.optional(validateImage)

	local v11 = if module9 or fFlagEnableHomeRobloxLogo then t.optional(t.string) else nil
	v6.routeName = v11
	extended.validateProps = strictInterface(v6)

	local function isAvatarExperienceRoute(list): boolean
		return list[#list].name == module3.AvatarExperienceRoot
	end

	local function canGoBackInAvatarExperience(p3): boolean
		return (p3 and p3.state and p3.state.routeName or "") ~= avatarScreen.AvatarExperienceLandingPage
	end

	local function isVisible(p3): boolean
		if p2 then
			return true
		end

		local currentRoute = p3.currentRoute

		if currentRoute[#currentRoute].name == module3.AvatarExperienceRoot then
			local navigation = p3.navigation
			return (navigation and navigation.state and navigation.state.routeName or "") ~= avatarScreen.AvatarExperienceLandingPage
		end

		if fFlagFixMoreSubMenuTitleFlash then
			local navigation = p3.navigation
			local routeName = navigation and navigation.state and navigation.state.routeName or ""

			if module6[routeName] and module6[routeName].alwaysShowBackButton then
				return true
			end
		end

		local currentRoute2 = p3.currentRoute

		for i = #currentRoute2, 1, -1 do
			local name = currentRoute2[i].name

			if
				name ~= module3.GameDetail
				and name ~= module3.ProfilePlatform
				and (not fFlagCiDeprecateFindFriendsModal or name ~= module3.ContactImporter)
				and name ~= module3.TrustedContactsModal
				and name ~= module3.TrustedFriendsVPCPrologue
				and (not fFlagTCShareLinkErrorModal or name ~= module3.TrustedFriendsShareLinkErrorModal)
				and name ~= module3.FriendsRenameInfoModal
				and (not (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR) or name ~= module3.SettingsPermissionInteractiveAlert)
				and name ~= module3.SocialToast
				and name ~= module3.SocialPurchaseExperience
				and name ~= module3.SocialUnableToJoinExperience
				and name ~= module3.InviteLinkExpiredModal
				and name ~= module3.ShareLinkInvalidModal
				and name ~= module3.SocialMessageToast
				and name ~= module3.SquadLobby
				and name ~= module3.InfoPeekView
				and name ~= module3.SponsoredTooltipPeekView
				and (not module8 or name ~= module3.AccountSelectorPeekView)
				and (not module8 or name ~= module3.AccountSwitchingAddAccountPeekView)
				and (not socialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() or name ~= module3.EditSocialNetworks)
				and (not socialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() or name ~= module3.EditSocialNetworksError)
				and name ~= module3.GameFilterMenuPeekView
				and (not fFlagEnableMobileGameJoinCard or name ~= module3.GameJoinCard)
				and (not fFlagSocialCarouselBuildPresence or name ~= module3.BuildJoinCard)
			then
				if module6[name] and module6[name].nativeWrapper and not RunService:IsStudio() then
					return false
				end

				return i > 1
			end
		end

		return false
	end

	function extended:updateVisibility(p4)
		local v12 = if fFlagSignalsNavP3bTopBar then self.props.routeIsVisible else isVisible(self.props)

		if v12 ~= p4 then
			self.props.setVisible(v12)
		end
	end

	function extended:didMount()
		self:updateVisibility(nil)
	end

	function extended:didUpdate(p3, p4)
		if not engineFeature and defineFastFlag then
			local v12

			if fFlagSignalsNavP3bTopBar then
				v12 = self.props.isNativeWrapperPage
			else
				local currentRoute = self.props.currentRoute
				local name = currentRoute[#currentRoute].name
				v12 = module6[name] and module6[name].nativeWrapper
			end

			if v12 and not RunService:IsStudio() then
				return nil
			end
		end

		local v12 = if fFlagSignalsNavP3bTopBar then p3.routeIsVisible else isVisible(p3)
		self:updateVisibility(v12)
	end

	function extended.render(p3)
		return withStyle(function(p4)
			local v12 = if p3.props.customIcon then p3.props.customIcon else iconsnavigationpushBack

			local createElement = Roact.createElement
			local v14 = {
				size = UDim2.new(0, module7.BACK_BUTTON_SIZE, 1, 0),
				position = 0,
				icon = 0,
				iconSize = 0,
				iconColor3 = 0,
				iconTransparency = 0,
				onActivated = 0,
				buttonRef = 0
			}
			local v15 = if p3.props.isSecondary then UDim2.new(0, 0, 0, -8) else nil
			v14.position = v15
			v14.icon = v12
			v14.iconSize = iconSize.Medium
			v14.iconColor3 = p4.Theme.IconEmphasis.Color
			v14.iconTransparency = p4.Theme.IconEmphasis.Transparency
			v14.onActivated = p3.props.onGoBack
			v14.buttonRef = p3.props.buttonRef
			return createElement(iconButton, v14)
		end)
	end

	if fFlagSignalsNavP3bTopBar then
		extended = React.memo(extended, function(p3, p4)
			local navigation = p3.navigation
			local routeName = navigation and navigation.state and navigation.state.routeName or ""

			local navigation2 = p4.navigation
			local routeName2 = navigation2 and navigation2.state and navigation2.state.routeName or ""

			return tutils.shallowEqual(p3, p4, v5) and routeName == routeName2
		end)
	end

	local function BackButtonContainer(p3)
		local v12 = useNavigation()
		local v13 = module(module2)
		local v14 = nil
		local v15 = nil
		local v16 = nil

		if fFlagSignalsNavP3bTopBar then
			v15, v16 = useBackButtonRouteProps(v12, isVisible)
		else
			v14 = useSelector(fn)
		end

		local v17 = useDispatch()
		local v18

		if fFlagSignalsNavP3bTopBar then
			v18 = { callback, v13, v17 }
		else
			v18 = { callback, v13, v14, v12, v17 }
		end

		local v19 = React.useCallback(function()
			if callback ~= nil then
				local v20 = callback()

				if not fFlagNavigationCallbackParam or v20 ~= false then
					return
				end
			end

			local v20

			if fFlagSignalsNavP3bTopBar then
				v20 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
			else
				v20 = v14
			end

			local v21 = if fFlagSignalsNavP3bTopBar then v16.current else v12

			if v20[#v20].name == module3.AvatarExperienceRoot then
				local routeName = v21.state.routeName
				v13.reportBackButtonClick(routeName)
				v21.goBack()
			else
				local name = v20[#v20].name
				v13.reportBackButtonClick(name)

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back()
				else
					v17(RobloxAppToastsRodux())
				end
			end
		end, v18)

		local v20 = useFocusNavigationBindings(p3.buttonRef, v19)

		local join = Cryo.Dictionary.join
		local v21 = {
			onGoBack = v19,
			buttonRef = useTableWrappedCallbackRef(v20),
			analytics = v13,
			navigation = v12,
			currentRoute = 0
		}

		local v22 = if fFlagSignalsNavP3bTopBar then Cryo.None else v14
		v21.currentRoute = v22
		local v23 = join(p3, v21, v15 or {})

		return React.createElement(extended, v23)
	end

	return BackButtonContainer
end

return makeBackButton
