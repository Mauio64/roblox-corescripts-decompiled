local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/ArgCheck")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/AppCommonLib").isTenFootInterface

local AccountSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/AccountSettingsPage")
local WebViewWindow = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/WebViewWindow")

local function supportsWebViews()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/UniversalAppPolicy").getAppFeaturePolicies().getWebViewSupport()
end

local function isInApp(): boolean
	return game.GameId == 0
end

local function getPresentation(data)
	local internal = data and data.internal

	if internal and internal.presentation then
		return internal.presentation
	end

	local isConsole = data and data.isConsole or isTenFootInterface
	local supportsWebViews2 = data and data.supportsWebViews or supportsWebViews

	if isConsole() or not supportsWebViews2() then
		return "QrCode"
	end

	return "Webview"
end

local function openAccountSettings(p2, p3, data)
	ArgCheck.isType(p3, "table", "openAccountSettings options")
	local v5 = type(p3) ~= "table" and {} or p3
	ArgCheck.isNonEmptyString(v5.surfaceKey, "options.surfaceKey")

	local onClosed = v5.onClosed
	local internal = data and data.internal
	local v6

	if internal and internal.presentation then
		v6 = internal.presentation
	else
		local isConsole = data and data.isConsole or isTenFootInterface
		local supportsWebViews2 = data and data.supportsWebViews or supportsWebViews
		v6 = (isConsole() or not supportsWebViews2()) and "QrCode" or "Webview"
	end

	if v6 == "QrCode" then
		(data and data.showQrCode or require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/QrCodePresenter").show)(p2, onClosed)
	else
		(data and data.webViewWindow or WebViewWindow.getDefault()).open(
			AccountSettingsPage.getUrl(p2),
			AccountSettingsPage.getTitle(p2),
			{
				windowType = (data and data.isInApp or isInApp)() and "Fullscreen" or "Dialog",
				onClosed = onClosed
			}
		)
	end
end

return openAccountSettings
