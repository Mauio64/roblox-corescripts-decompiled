local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/deferred/fow")
local module3 = require("@luauforge/deferred/fuc")
local module4 = require("@luauforge/deferred/fuk")
local module5 = require("@luauforge/bundled/fus")

local module6 = require("@luauforge/deferred/fut")
local module7 = require("@luauforge/deferred/fur")
local webViewStateTracker = require("@luauforge/bundled/fug").WebViewStateTracker
local module8 = require("@luauforge/bundled/fuu")

local fFlagEnableWebViewStateTracker = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableWebViewStateTracker

local extended = module.PureComponent:extend("BrowserServiceWrapper")

function extended:didMount()
	local v5 = if module7 then module4(self.props.url) else self.props.url
	self.connections = {
		BrowserService.BrowserWindowClosed:Connect(function()
			if fFlagEnableWebViewStateTracker then
				webViewStateTracker.markClosed()
			end

			if self.props.windowClosedCallback then
				self.props.windowClosedCallback()
			end
		end),
		BrowserService.JavaScriptCallback:Connect(function(p3)
			if self.props.javaScriptCallback then
				self.props.javaScriptCallback(p3)
			end
		end)
	}

	local jsonEncode = HttpService:JSONEncode({
		command = "open",
		url = v5,
		title = self.props.title,
		visible = self.props.webViewVisible,
		modal = self.props.modal,
		isGenericWebview = self.props.isGenericWebview,
		enableOverlayReplacement = self.props.enableOverlayReplacement
	})

	if fFlagEnableWebViewStateTracker then
		webViewStateTracker.markOpen(self.props.url, self.props.title, self.props.webViewVisible)
	end

	BrowserService:SendCommand(jsonEncode)
end

function extended.didUpdate(p2, p3, p4)
	if p3.webViewVisible ~= p2.props.webViewVisible then
		local v5 = {
			command = "config",
			visible = p2.props.webViewVisible == true
		}

		if p2.props.ignoreBackNavigationDisabled ~= true then
			v5.backNavigationDisabled = module8.getIsDisabled(false)
		end

		if fFlagEnableWebViewStateTracker then
			webViewStateTracker.updateMetadata(p2.props.url, p2.props.title, p2.props.webViewVisible)
		end

		BrowserService:SendCommand(HttpService:JSONEncode(v5))
	end
end

function extended.willUnmount(p2)
	for i, connection in ipairs(p2.connections) do
		connection:Disconnect()
	end

	BrowserService:CloseBrowserWindow()
end

function extended.render(p2)
	return module.createElement(module2, {
		isVisible = p2.props.isVisible,
		displayOrder = p2.props.displayOrder,
		backNavigationHandledByParent = p2.props.backNavigationHandledByParent
	})
end

if module6() then
	return function(props)
		local createElement = module.createElement
		local v6 = {
			url = props.url,
			title = props.title,
			isVisible = props.webViewVisible,
			windowType = 0,
			windowCloseCallback = 0,
			javaScriptCallback = 0,
			overlayProps = 0
		}
		local v7 = if props.modal then module5.Dialog else module5.Default
		v6.windowType = v7
		v6.windowCloseCallback = props.windowClosedCallback
		v6.javaScriptCallback = props.javaScriptCallback
		v6.overlayProps = {
			isVisible = props.isVisible,
			DisplayOrder = props.displayOrder
		}
		return createElement(module3, v6)
	end
end

return extended
