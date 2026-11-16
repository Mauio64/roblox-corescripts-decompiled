local AppStorageService = game:GetService("AppStorageService")

local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local AuthCommon = require(parent.AuthCommon)
local AuthBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local useOpenDisclaimerLinks = AuthCommon.Hooks.useOpenDisclaimerLinks
local isLoggedOutUserId = AuthCommon.Utils.isLoggedOutUserId
local updateLoginEntryData = AuthCommon.Utils.updateLoginEntryData
local User = AuthCommon.Thunks.User
local AuthLocalStorageKeys = AuthCommon.Enums.AuthLocalStorageKeys
local LogoutReasonNames = AuthCommon.Enums.LogoutReasonNames
local FFlagAccountUpgradeHideAccountOnSignOut = require(AccountUpgrade.Flags.FFlagAccountUpgradeHideAccountOnSignOut)
local FFlagAccountUpgradeOAuthDialogFitsContent = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthDialogFitsContent)
local FFlagAccountUpgradeDialogDarkTheme = require(AccountUpgrade.Flags.FFlagAccountUpgradeDialogDarkTheme)

local AccountUpgradeAppShellFlow = require(AccountUpgrade.AppShell.AccountUpgradeAppShellFlow)
local AccountUpgradeFlow = require(AccountUpgrade.AccountUpgradeFlow)
local AccountUpgradePage = require(AccountUpgrade.MobilePage.AccountUpgradePage)
local FFlagAccountUpgradeFullPageOnPhone = require(AccountUpgrade.MobilePage.FFlagAccountUpgradeFullPageOnPhone)
local useMobilePage = require(AccountUpgrade.MobilePage.useMobilePage)
require(AccountUpgrade.Components.useAccountUpgradeViewModel)
local OAuth = AccountUpgradeFlow.OAuth

local View = Foundation.View

local style = {
	themeName = Foundation.Enums.ColorMode.Dark,
	fontName = Style.Constants.FontName.Gotham
}

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)

local function renderLandingArt()
	return React.createElement(AuthBackgroundContainer)
end

local function BirthdayCompliancePage(props)
	local v = useDispatch()
	local v2 = useRoactService(RoactServiceTags.RoactNetworking)
	local v3 = useRoactService(RoactServiceTags.AppGuiService)

	local currentUsername = useSelector(function(p)
		local v4

		if p.Users and p.LocalUserId then
			v4 = p.Users[p.LocalUserId]
		end

		return if v4 then v4.name else nil
	end)

	local refreshUserAccess = props.refreshUserAccess
	local onUnrecoverableFailure = React.useCallback(function()
		v(refreshUserAccess(v2))
	end, { v, refreshUserAccess, v2 })

	local refreshUserAccessAfterUpgrade = props.refreshUserAccessAfterUpgrade or refreshUserAccess
	local onComplete = React.useCallback(function()
		v(refreshUserAccessAfterUpgrade(v2))
	end, { v, refreshUserAccessAfterUpgrade, v2 })

	local v4 = useStore()
	local logoutThunk = props.LogoutThunk
	local onSignOut = React.useMemo(function()
		if logoutThunk == nil then
			return nil
		end

		return function()
			local localUserId = v4:getState().LocalUserId
			local username

			if FFlagAccountUpgradeHideAccountOnSignOut then
				username = User.fromLocalStorage().username
			end

			v(logoutThunk(v2, v3, LogoutReasonNames.Moderation))

			if FFlagAccountUpgradeHideAccountOnSignOut then
				updateLoginEntryData(tostring(localUserId), { showInAccountPicker = false })

				if AppStorageService:GetItem(AuthLocalStorageKeys.CredentialValue) == username then
					AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, "")
					AppStorageService:Flush()
				end
			end
		end
	end, { v, logoutThunk, v2, v3, v4 })
	local onLegalLinkSelected

	if FFlagAccountUpgradeOAuthDialogFitsContent then
		local v5 = useOpenDisclaimerLinks()
		onLegalLinkSelected = React.useCallback(function(p)
			if p == "terms" then
				v5.openTerms()
			else
				v5.openPrivacy()
			end
		end, { v5 })
	end

	local setDarkThemeOverride = props.setDarkThemeOverride
	local clearThemeOverride = props.clearThemeOverride
	React.useEffect(function()
		if setDarkThemeOverride then
			setDarkThemeOverride()
		end

		return function()
			if clearThemeOverride and not isLoggedOutUserId(v4:getState().LocalUserId) then
				clearThemeOverride()
			end
		end
	end, { v4, setDarkThemeOverride, clearThemeOverride })
	local v5

	if FFlagAccountUpgradeFullPageOnPhone then
		v5 = useMobilePage()
	end

	if v5 then
		return React.createElement(AccountUpgradePage, {
			flow = OAuth,
			currentUsername = currentUsername,
			onSignOut = onSignOut,
			onLegalLinkSelected = onLegalLinkSelected,
			onComplete = onComplete,
			onUnrecoverableFailure = onUnrecoverableFailure
		})
	end

	local flow = React.createElement(AccountUpgradeAppShellFlow, {
		flow = OAuth,
		currentUsername = currentUsername,
		hasBackdrop = true,
		onSignOut = onSignOut,
		onLegalLinkSelected = onLegalLinkSelected,
		onComplete = onComplete,
		onUnrecoverableFailure = onUnrecoverableFailure
	})

	if FFlagAccountUpgradeDialogDarkTheme then
		flow = React.createElement(View, { tag = "size-full" }, {
			Theme = React.createElement(Style.UiModeStyleProvider, { style = style }, {
				Flow = flow
			})
		})
	end

	return React.createElement(
		FullscreenPageWithSafeArea,
		{ includeStatusBar = true, renderFullscreenBackground = renderLandingArt },
		{ Flow = flow }
	)
end

return BirthdayCompliancePage
