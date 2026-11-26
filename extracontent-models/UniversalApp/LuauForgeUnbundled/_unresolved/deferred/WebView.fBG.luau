local WebViewService = game:GetService("WebViewService")
local GuiService = game:GetService("GuiService")
local TelemetryService = game:GetService("TelemetryService")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local asyncQueue = require("@game/CorePackages/Workspace/Packages/AppCommonLib").AsyncQueue
local webViewStateTracker = require("@luauforge/bundled/fBH").WebViewStateTracker

local fFlagEnableWebViewStateTracker = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableWebViewStateTracker

local module = require("@luauforge/deferred/fBI")

local module2 = require("@luauforge/bundled/fBJ")
local module3 = require("@luauforge/deferred/fBK")
local fFlagFixSelectionWithWebViews = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixSelectionWithWebViews

local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local v5 = asyncQueue.new()

local v6 = {
	eventName = "WebViewParamsEmpty",
	description = "Counts WebView opens whose WebViewParams would have been an all-nil (Array-shaped) Lua table.",
	lastUpdated = { 2026, 6, 2 },
	backends = { "RobloxTelemetryCounter" }
}

local function getDomain(value)
	local v7 = string.match(value, "^[%a][%w+.-]*://([^/?#]+)") or value
	return string.match(v7, "^([^:?#]+)") or v7
end

local v7 = {
	eventName = "WebViewOpenRequest",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 5, 29 },
	description = "Counter for WebView open requests via WebViewService OpenWindow/OpenWindowV2"
}

local function useWebView(data)
	local webViewService = data.webViewService or WebViewService
	local webViewLock = data.webViewLock or v5
	local telemetryService = data.telemetryService or TelemetryService
	local state, setState = React.useState(false)

	React.useEffect(function()
		return (webViewLock:request(function()
			setState(true)
		end))
	end, { webViewLock })

	local ref = React.useRef(true)

	local useEffect = React.useEffect
	local function fn()
		if not state then
			return
		end

		if ref.current then
			ref.current = false

			if fFlagEnableWebViewStateTracker then
				webViewStateTracker.markOpen(data.url, data.title, data.isVisible, data.hasBackButton)
			end

			telemetryService:LogCounter(v7, {
				customFields = { url = data.url },
				standardizedFields = { "addOSInfo" }
			}, 1)

			if module3() then
				local v8 = {
					Title = data.title,
					IsVisible = data.isVisible,
					TransitionAnimation = data.transitionAnimation,
					BackButtonVisible = data.hasBackButton,
					HideHeader = data.hideHeader,
					ShowDomainAsTitle = 0
				}

				local v9 = if fFlagLuaAppEnableNxMRoduxApportioning then data.showDomainAsTitle else nil
				v8.ShowDomainAsTitle = v9

				if next(v8) then
					webViewService:OpenWindowV2(data.url, v8)
					return
				end

				local v13 = { url = data.url, domain = 0 }
				local url = data.url
				local v14 = string.match(url, "^[%a][%w+.-]*://([^/?#]+)") or url
				v13.domain = string.match(v14, "^([^:?#]+)") or v14
				telemetryService:LogCounter(v6, { customFields = v13 }, 1)

				webViewService:OpenWindowV2(data.url, nil)
			elseif module2 and module2() then
				local url = data.url
				local title = data.title
				local isVisible = data.isVisible

				local transitionAnimation = data.transitionAnimation
				local v10 = if fFlagLuaAppEnableNxMRoduxApportioning then data.showDomainAsTitle else false
				webViewService:OpenWindow(
					url,
					title,
					isVisible,
					"",
					transitionAnimation,
					v10,
					data.hasBackButton
				)
			elseif fFlagLuaAppEnableNxMRoduxApportioning then
				webViewService:OpenWindow(
					data.url,
					data.title,
					data.isVisible,
					"",
					data.transitionAnimation,
					data.showDomainAsTitle
				)
			else
				webViewService:OpenWindow(data.url, data.title, data.isVisible, data.transitionAnimation)
			end
		else
			if fFlagEnableWebViewStateTracker then
				webViewStateTracker.updateMetadata(data.url, data.title, data.isVisible, data.hasBackButton)
			end

			if module2() then
				local url = data.url
				local title = data.title
				local isVisible = data.isVisible

				local transitionAnimation = data.transitionAnimation
				local v10 = if fFlagLuaAppEnableNxMRoduxApportioning then data.showDomainAsTitle else false
				webViewService:MutateWindow(
					url,
					title,
					isVisible,
					"",
					transitionAnimation,
					v10,
					data.hasBackButton
				)
			elseif fFlagLuaAppEnableNxMRoduxApportioning then
				webViewService:MutateWindow(
					data.url,
					data.title,
					data.isVisible,
					"",
					data.transitionAnimation,
					data.showDomainAsTitle
				)
			else
				webViewService:MutateWindow(data.url, data.title, data.isVisible, data.transitionAnimation)
			end
		end
	end

	local url = data.url
	local title = data.title
	local isVisible = data.isVisible
	local transitionAnimation = data.transitionAnimation
	local showDomainAsTitle = if fFlagLuaAppEnableNxMRoduxApportioning then data.showDomainAsTitle else nil
	local hasBackButton = if module2() or module3() then data.hasBackButton else nil

	local v9 = if module3() then data.hideHeader else nil
	useEffect(fn, {
		state,
		url,
		title,
		isVisible,
		transitionAnimation,
		showDomainAsTitle,
		hasBackButton,
		v9,
		webViewService,
		telemetryService
	})

	React.useEffect(function()
		if state then
			return function()
				webViewService:CloseWindow()
			end
		end
	end, { state, webViewService })

	React.useEffect(function()
		if not state or not fFlagEnableWebViewStateTracker and data.windowCloseCallback == nil then
			return
		end

		local onWindowClosedConnection = webViewService.OnWindowClosed:Connect(function()
			if fFlagEnableWebViewStateTracker then
				webViewStateTracker.markClosed()
			end

			if data.windowCloseCallback then
				data.windowCloseCallback()
			end
		end)

		return function()
			onWindowClosedConnection:Disconnect()
		end
	end, { state, data.windowCloseCallback, webViewService.OnWindowClosed })

	React.useEffect(function()
		if not (state and data.javaScriptCallback ~= nil) then
			return
		end

		local onJavaScriptCallConnection = webViewService.OnJavaScriptCall:Connect(data.javaScriptCallback)

		return function()
			onJavaScriptCallConnection:Disconnect()
		end
	end, { state, data.javaScriptCallback, webViewService.OnJavaScriptCall })

	if fFlagFixSelectionWithWebViews then
		React.useEffect(function()
			if not state then
				return
			end

			local coreGuiNavigationEnabled = GuiService.CoreGuiNavigationEnabled
			GuiService.CoreGuiNavigationEnabled = false

			return function()
				GuiService.CoreGuiNavigationEnabled = coreGuiNavigationEnabled
			end
		end, { state })
	end
end

local function WebView(p2)
	useWebView(p2)

	local overlayProps = p2.overlayProps or {}

	return React.createElement(module, {
		isVisible = overlayProps.isVisible,
		DisplayOrder = overlayProps.DisplayOrder
	})
end

return WebView
