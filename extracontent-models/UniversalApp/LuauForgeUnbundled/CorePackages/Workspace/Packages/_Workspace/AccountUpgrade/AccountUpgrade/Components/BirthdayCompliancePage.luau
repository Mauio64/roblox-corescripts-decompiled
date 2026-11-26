local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Style")
local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AppBlox").FullscreenPageWithSafeArea
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon")
local authBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local useOpenDisclaimerLinks = AuthCommon.Hooks.useOpenDisclaimerLinks
local isLoggedOutUserId = AuthCommon.Utils.isLoggedOutUserId
local updateLoginEntryData = AuthCommon.Utils.updateLoginEntryData
local user = AuthCommon.Thunks.User
local authLocalStorageKeys = AuthCommon.Enums.AuthLocalStorageKeys
local logoutReasonNames = AuthCommon.Enums.LogoutReasonNames
local FFlagAccountUpgradeHideAccountOnSignOut = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeHideAccountOnSignOut")
local FFlagAccountUpgradeOAuthDialogFitsContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthDialogFitsContent")
local FFlagAccountUpgradeDialogDarkTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeDialogDarkTheme")

local AccountUpgradeAppShellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AppShell/AccountUpgradeAppShellFlow")
local AccountUpgradeFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local AccountUpgradePage = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/AccountUpgradePage")
local FFlagAccountUpgradeFullPageOnPhone = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/FFlagAccountUpgradeFullPageOnPhone")
local useMobilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/useMobilePage")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/useAccountUpgradeViewModel")
local oAuth = AccountUpgradeFlow.OAuth

local view = Foundation.View

local v5 = {
	themeName = Foundation.Enums.ColorMode.Dark,
	fontName = Style.Constants.FontName.Gotham
}

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RoactServiceTags")

local function renderLandingArt()
	return React.createElement(authBackgroundContainer)
end

local function BirthdayCompliancePage(props)
	local v6 = useDispatch()
	local v7 = useRoactService(RoactServiceTags.RoactNetworking)
	local v8 = useRoactService(RoactServiceTags.AppGuiService)

	local v9 = useSelector(function(p2)
		local v10 = if p2.Users and p2.LocalUserId then p2.Users[p2.LocalUserId] else nil

		if v10 then
			return v10.name
		end

		return nil
	end)

	local refreshUserAccess = props.refreshUserAccess
	local v10 = React.useCallback(function()
		v6(refreshUserAccess(v7))
	end, { v6, refreshUserAccess, v7 })

	local refreshUserAccessAfterUpgrade = props.refreshUserAccessAfterUpgrade or refreshUserAccess
	local v11 = React.useCallback(function()
		v6(refreshUserAccessAfterUpgrade(v7))
	end, { v6, refreshUserAccessAfterUpgrade, v7 })

	local v12 = useStore()
	local logoutThunk = props.LogoutThunk
	local v13 = React.useMemo(function()
		if logoutThunk == nil then
			return nil
		end

		return function()
			local localUserId = v12:getState().LocalUserId
			local username = if FFlagAccountUpgradeHideAccountOnSignOut then user.fromLocalStorage().username else nil
			v6(logoutThunk(v7, v8, logoutReasonNames.Moderation))

			if FFlagAccountUpgradeHideAccountOnSignOut then
				updateLoginEntryData(tostring(localUserId), {
					showInAccountPicker = false
				})

				if AppStorageService:GetItem(authLocalStorageKeys.CredentialValue) == username then
					AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, "")
					AppStorageService:Flush()
				end
			end
		end
	end, { v6, logoutThunk, v7, v8, v12 })
	local v14

	if FFlagAccountUpgradeOAuthDialogFitsContent then
		local v15 = useOpenDisclaimerLinks()
		v14 = React.useCallback(function(p2)
			if p2 == "terms" then
				v15.openTerms()
			else
				v15.openPrivacy()
			end
		end, { v15 })
	end

	local setDarkThemeOverride = props.setDarkThemeOverride
	local clearThemeOverride = props.clearThemeOverride
	React.useEffect(function()
		if setDarkThemeOverride then
			setDarkThemeOverride()
		end

		return function()
			if clearThemeOverride and not isLoggedOutUserId(v12:getState().LocalUserId) then
				clearThemeOverride()
			end
		end
	end, { v12, setDarkThemeOverride, clearThemeOverride })

	local v15 = if FFlagAccountUpgradeFullPageOnPhone then useMobilePage() else nil

	if v15 then
		return React.createElement(AccountUpgradePage, {
			flow = oAuth,
			currentUsername = v9,
			onSignOut = v13,
			onLegalLinkSelected = v14,
			onComplete = v11,
			onUnrecoverableFailure = v10
		})
	end

	local v16 = React.createElement(AccountUpgradeAppShellFlow, {
		flow = oAuth,
		currentUsername = v9,
		hasBackdrop = true,
		onSignOut = v13,
		onLegalLinkSelected = v14,
		onComplete = v11,
		onUnrecoverableFailure = v10
	})

	if FFlagAccountUpgradeDialogDarkTheme then
		v16 = React.createElement(view, { tag = "size-full" }, {
			Theme = React.createElement(Style.UiModeStyleProvider, { style = v5 }, {
				Flow = v16
			})
		})
	end

	return React.createElement(
		fullscreenPageWithSafeArea,
		{ includeStatusBar = true, renderFullscreenBackground = renderLandingArt },
		{ Flow = v16 }
	)
end

return BirthdayCompliancePage
