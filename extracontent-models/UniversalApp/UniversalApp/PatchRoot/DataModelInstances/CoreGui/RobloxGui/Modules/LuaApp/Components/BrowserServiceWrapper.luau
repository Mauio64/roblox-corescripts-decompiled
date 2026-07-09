local Modules = game:GetService("CoreGui").RobloxGui.Modules
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)
local AppWebView = require(Modules.LuaApp.Components.WebView.AppWebView)
local WebViewWindow = require(Modules.LuaApp.Enum.WebViewWindow)
local GetFFlagReplaceBrowserServiceWrapper = require(Modules.LuaApp.Flags.GetFFlagReplaceBrowserServiceWrapper)
local WebViewStateTracker = require(CorePackages.Workspace.Packages.WebViewUtils).WebViewStateTracker
local BackDisableStore = require(CorePackages.Workspace.Packages.BackDisableStore)
local FFlagEnableWebViewStateTracker = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableWebViewStateTracker
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagUseBackDisableSignalStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBackDisableSignalStore
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local v17 = Roact.PureComponent:extend("BrowserServiceWrapper")

function v17.didMount(p1) -- line: 37
	-- upvalues: BrowserService (copy), FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), HttpService (copy)
	p1.connections = {
		BrowserService.BrowserWindowClosed:Connect(function() -- line: 39
			-- upvalues: FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), p1 (copy)
			if FFlagEnableWebViewStateTracker then
				WebViewStateTracker.markClosed()
			end

			if p1.props.windowClosedCallback then
				p1.props.windowClosedCallback()
			end
		end),
		BrowserService.JavaScriptCallback:Connect(function(p2) -- line: 47
			-- upvalues: p1 (copy)
			if p1.props.javaScriptCallback then
				p1.props.javaScriptCallback(p2)
			end
		end)
	}

	local json = HttpService:JSONEncode({
		command = "open",
		url = p1.props.url,
		title = p1.props.title,
		visible = p1.props.webViewVisible,
		modal = p1.props.modal,
		isGenericWebview = p1.props.isGenericWebview,
		enableOverlayReplacement = p1.props.enableOverlayReplacement
	})

	if FFlagEnableWebViewStateTracker then
		WebViewStateTracker.markOpen(p1.props.url, p1.props.title, p1.props.webViewVisible)
	end

	BrowserService:SendCommand(json)
end
function v17.didUpdate(p3, p4, _) -- line: 69
	-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), BrowserService (copy), HttpService (copy)
	if p4.webViewVisible ~= p3.props.webViewVisible then
		local t1 = {
			command = "config",
			visible = p3.props.webViewVisible == true
		}

		if p3.props.ignoreBackNavigationDisabled ~= true then
			if FFlagUseBackDisableSignalStore then
				t1.backNavigationDisabled = BackDisableStore.getIsDisabled(false)
			else
				t1.backNavigationDisabled = p3.props.backNavigationDisableCounter > 0
			end
		end

		if FFlagEnableWebViewStateTracker then
			WebViewStateTracker.updateMetadata(p3.props.url, p3.props.title, p3.props.webViewVisible)
		end

		BrowserService:SendCommand(HttpService:JSONEncode(t1))
	end
end
function v17.willUnmount(p6) -- line: 91
	-- upvalues: BrowserService (copy)
	for _, v in ipairs(p6.connections) do
		v:Disconnect()
	end

	BrowserService:CloseBrowserWindow()
end
function v17.render(p7) -- line: 98
	-- upvalues: Roact (copy), NativePageWrapper (copy)
	return Roact.createElement(NativePageWrapper, {
		isVisible = p7.props.isVisible,
		displayOrder = p7.props.displayOrder,
		backNavigationHandledByParent = p7.props.backNavigationHandledByParent
	})
end

if not FFlagUseBackDisableSignalStore then
	v17 = RoactRodux.connect(function(p8, _) -- line: 107
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
		return {
			backNavigationDisableCounter = if not FFlagUseNavigationSelectors then p8.Navigation.backNavigationDisableCounter else Selectors.selectBackNavigationDisableCounter(p8)
		}
	end)(v17)
end

if GetFFlagReplaceBrowserServiceWrapper() then
	return function(t2: {[any]: any}) -- line: 117
		-- upvalues: Roact (copy), AppWebView (copy), WebViewWindow (copy)
		return Roact.createElement(AppWebView, {
			url = t2.url,
			title = t2.title,
			isVisible = t2.webViewVisible,
			windowType = if not t2.modal then WebViewWindow.Default else WebViewWindow.Dialog,
			windowCloseCallback = t2.windowClosedCallback,
			javaScriptCallback = t2.javaScriptCallback,
			overlayProps = {
				isVisible = t2.isVisible,
				DisplayOrder = t2.displayOrder
			}
		})
	end
end

return v17
