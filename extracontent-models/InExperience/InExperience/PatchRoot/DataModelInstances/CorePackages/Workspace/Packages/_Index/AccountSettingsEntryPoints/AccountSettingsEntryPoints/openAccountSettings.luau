local parent = script.Parent
local parent2 = parent.Parent

local ArgCheck = require(parent2.ArgCheck)
local AppCommonLib = require(parent2.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface

local AccountSettingsPage = require(parent.AccountSettingsPage)
local WebViewWindow = require(parent.WebViewWindow)

local function supportsWebViews()
	local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
	return UniversalAppPolicy.getAppFeaturePolicies().getWebViewSupport()
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

local function openAccountSettings(p, p2, data)
	ArgCheck.isType(p2, "table", "openAccountSettings options")
	local v = type(p2) ~= "table" and {} or p2
	ArgCheck.isNonEmptyString(v.surfaceKey, "options.surfaceKey")

	local onClosed = v.onClosed
	local internal = data and data.internal
	local v2

	if internal and internal.presentation then
		v2 = internal.presentation
	else
		local isConsole = data and data.isConsole or isTenFootInterface
		local supportsWebViews2 = data and data.supportsWebViews or supportsWebViews
		v2 = (isConsole() or not supportsWebViews2()) and "QrCode" or "Webview"
	end

	if v2 ~= "QrCode" then
		(data and data.webViewWindow or WebViewWindow.getDefault()).open(
			AccountSettingsPage.getUrl(p),
			AccountSettingsPage.getTitle(p),
			{
				windowType = (data and data.isInApp or isInApp)() and "Fullscreen" or "Dialog",
				onClosed = onClosed
			}
		)

		return
	end

	local v3 = data and data.showQrCode

	if not v3 then
		local QrCodePresenter = require(parent.QrCodePresenter)
		v3 = QrCodePresenter.show
	end

	v3(p, onClosed)
end

return openAccountSettings
