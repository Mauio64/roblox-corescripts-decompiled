local WebViewService = game:GetService("WebViewService")
local GuiService = game:GetService("GuiService")
local TelemetryService = game:GetService("TelemetryService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AsyncQueue = require(CorePackages.Workspace.Packages.AppCommonLib).AsyncQueue
local WebViewStateTracker = require(CorePackages.Workspace.Packages.WebViewUtils).WebViewStateTracker
local FFlagEnableWebViewStateTracker = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableWebViewStateTracker
local GetFFlagLuaAppEnableWebViewTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableWebViewTelemetry
local WebViewStub = require(Modules.LuaApp.Components.WebViewStub)
local GetFFlagWebViewServiceHasBackButtonVisibility = require(Modules.LuaApp.Flags.GetFFlagWebViewServiceHasBackButtonVisibility)
local GetFFlagWebViewHasHideHeader = require(Modules.LuaApp.Flags.GetFFlagWebViewHasHideHeader)
local GetFFlagFixWebViewParamsEmptyArrayCast = require(Modules.LuaApp.Flags.GetFFlagFixWebViewParamsEmptyArrayCast)
local FFlagFixSelectionWithWebViews = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFixSelectionWithWebViews
local v16 = AsyncQueue.new()
local t1 = {
	eventName = "WebViewParamsEmpty",
	description = "Counts WebView opens whose WebViewParams would have been an all-nil (Array-shaped) Lua table.",
	lastUpdated = {
		2026,
		6,
		2
	},
	backends = { "RobloxTelemetryCounter" }
}

local function getDomain(s1: string) -- line: 47
	local v23 = string.match(s1, "^[%a][%w+.-]*://([^/?#]+)") or s1

	return string.match(v23, "^([^:?#]+)") or v23
end

local t2 = {
	eventName = "WebViewOpenRequest",
	description = "Counter for WebView open requests via WebViewService OpenWindow/OpenWindowV2",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2026,
		5,
		29
	}
}

local function useWebView(t3: {[any]: any}) -- line: 59
	-- upvalues: WebViewService (copy), v16 (copy), TelemetryService (copy), React (copy), FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), GetFFlagLuaAppEnableWebViewTelemetry (copy), t2 (copy), GetFFlagWebViewHasHideHeader (copy), GetFFlagFixWebViewParamsEmptyArrayCast (copy), t1 (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy), FFlagFixSelectionWithWebViews (copy), GuiService (copy)
	local v25 = t3.webViewService or WebViewService
	local v26 = t3.webViewLock or v16
	local v27 = t3.telemetryService or TelemetryService
	local v28, v29 = React.useState(false)

	React.useEffect(function() -- line: 65
		-- upvalues: v26 (copy), v29 (copy)
		return (v26:request(function() -- line: 66
			-- upvalues: v29 (copy)
			v29(true)
		end))
	end, { v26 })

	local v30 = React.useRef(true)

	React.useEffect(function() -- line: 75
		-- upvalues: v28 (copy), v30 (copy), FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), t3 (copy), GetFFlagLuaAppEnableWebViewTelemetry (copy), v27 (copy), t2 (copy), GetFFlagWebViewHasHideHeader (copy), GetFFlagFixWebViewParamsEmptyArrayCast (copy), t1 (copy), v25 (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy)
		if not v28 then
			return
		end

		if v30.current then
			v30.current = false

			if FFlagEnableWebViewStateTracker then
				WebViewStateTracker.markOpen(t3.url, t3.title, t3.isVisible, t3.hasBackButton)
			end

			if GetFFlagLuaAppEnableWebViewTelemetry() then
				v27:LogCounter(t2, {
					customFields = {
						url = t3.url
					},
					standardizedFields = { "addOSInfo" }
				}, 1)
			end

			if GetFFlagWebViewHasHideHeader() then
				local t4 = {
					Title = t3.title,
					IsVisible = t3.isVisible,
					TransitionAnimation = t3.transitionAnimation,
					BackButtonVisible = t3.hasBackButton,
					HideHeader = t3.hideHeader
				}

				if GetFFlagFixWebViewParamsEmptyArrayCast() and not next(t4) then
					local v34 = v27
					local v35 = t1
					local t5 = {}
					local t6 = {
						url = t3.url
					}
					local url = t3.url
					local v39 = string.match(url, "^[%a][%w+.-]*://([^/?#]+)") or url

					t6.domain = string.match(v39, "^([^:?#]+)") or v39
					t5.customFields = t6
					v34:LogCounter(v35, t5, 1)
					v25:OpenWindowV2(t3.url, nil)

					return
				end

				v25:OpenWindowV2(t3.url, t4)

				return
			end

			if GetFFlagWebViewServiceHasBackButtonVisibility and GetFFlagWebViewServiceHasBackButtonVisibility() then
				v25:OpenWindow(t3.url, t3.title, t3.isVisible, "", t3.transitionAnimation, false, t3.hasBackButton)

				return
			end

			v25:OpenWindow(t3.url, t3.title, t3.isVisible, t3.transitionAnimation)

			return
		end

		if FFlagEnableWebViewStateTracker then
			WebViewStateTracker.updateMetadata(t3.url, t3.title, t3.isVisible, t3.hasBackButton)
		end

		if GetFFlagWebViewServiceHasBackButtonVisibility() then
			v25:MutateWindow(t3.url, t3.title, t3.isVisible, "", t3.transitionAnimation, false, t3.hasBackButton)

			return
		end

		v25:MutateWindow(t3.url, t3.title, t3.isVisible, t3.transitionAnimation)
	end, {
		v28,
		t3.url,
		t3.title,
		t3.isVisible,
		t3.transitionAnimation,
		if not GetFFlagWebViewServiceHasBackButtonVisibility() and not GetFFlagWebViewHasHideHeader() then nil else t3.hasBackButton,
		if not GetFFlagWebViewHasHideHeader() then nil else t3.hideHeader,
		v25,
		v27
	})
	React.useEffect(function() -- line: 163
		-- upvalues: v28 (copy), v25 (copy)
		if not v28 then
			return
		end

		return function() -- line: 168
			-- upvalues: v25 (copy)
			v25:CloseWindow()
		end
	end, {
		v28,
		v25
	})
	React.useEffect(function() -- line: 173
		-- upvalues: v28 (copy), FFlagEnableWebViewStateTracker (copy), t3 (copy), v25 (copy), WebViewStateTracker (copy)
		if not v28 then
			return
		end

		if not FFlagEnableWebViewStateTracker and t3.windowCloseCallback == nil then
			return
		end

		local connection = v25.OnWindowClosed:Connect(function() -- line: 182
			-- upvalues: FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), t3 (copy)
			if FFlagEnableWebViewStateTracker then
				WebViewStateTracker.markClosed()
			end

			if t3.windowCloseCallback then
				t3.windowCloseCallback()
			end
		end)

		return function() -- line: 192
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v28,
		t3.windowCloseCallback,
		v25.OnWindowClosed
	})
	React.useEffect(function() -- line: 197
		-- upvalues: v28 (copy), t3 (copy), v25 (copy)
		if not v28 then
			return
		end

		if t3.javaScriptCallback == nil then
			return
		end

		local connection = v25.OnJavaScriptCall:Connect(t3.javaScriptCallback)

		return function() -- line: 208
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v28,
		t3.javaScriptCallback,
		v25.OnJavaScriptCall
	})

	if FFlagFixSelectionWithWebViews then
		React.useEffect(function() -- line: 214
			-- upvalues: v28 (copy), GuiService (copy)
			if not v28 then
				return
			end

			local CoreGuiNavigationEnabled = GuiService.CoreGuiNavigationEnabled

			GuiService.CoreGuiNavigationEnabled = false

			return function() -- line: 222
				-- upvalues: GuiService (copy), CoreGuiNavigationEnabled (copy)
				GuiService.CoreGuiNavigationEnabled = CoreGuiNavigationEnabled
			end
		end, { v28 })
	end
end
local function WebView(t7: {[any]: any}) -- line: 229
	-- upvalues: useWebView (copy), React (copy), WebViewStub (copy)
	useWebView(t7)

	local v32 = t7.overlayProps or {}

	return React.createElement(WebViewStub, {
		isVisible = v32.isVisible,
		DisplayOrder = v32.DisplayOrder
	})
end

return WebView
