local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fvN")
local module2 = require("@luauforge/bundled/fBF")
local module3 = require("@luauforge/deferred/fBE")
local module4 = require("@luauforge/bundled/egZ")

local module5 = require("@luauforge/deferred/fvQ")
local module6 = require("@luauforge/deferred/fBD")
local module7 = require("@luauforge/deferred/fBL")
local webViewStateTracker = require("@luauforge/bundled/fBH").WebViewStateTracker

local module8 = require("@luauforge/bundled/gvh")
local module9 = require("@luauforge/deferred/fBS")

local fFlagEnableWebViewStateTracker = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableWebViewStateTracker

local defineFastFlag = game:DefineFastFlag("EnableWebViewStateTrackerInGenericWebPageWrapper", false)

local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local function GenericWebPageWrapper(data)
	local isVisible = data.isVisible
	local displayOrder = data.DisplayOrder
	local v5 = if module9 then module7(data.url) or data.url else data.url
	local titleKey = data.titleKey
	local title = data.title
	local searchParams = data.searchParams
	local transitionAnimation = data.transitionAnimation

	local v6 = module3(transitionAnimation)
	assert(
		transitionAnimation == nil or transitionAnimation == module2.None or v6 ~= nil,
		string.format("Unhandled transition animation: %q", (tostring(transitionAnimation)))
	)

	local v7 = transitionAnimation ~= module2.None

	if fFlagEnableWebViewStateTracker and defineFastFlag then
		React.useEffect(function()
			webViewStateTracker.markOpen(v5, title, isVisible)
		end, {})
		React.useEffect(function()
			webViewStateTracker.updateMetadata(v5, title, isVisible)
		end, { v5, title, isVisible })
	end

	local function fn()
		webViewStateTracker.markClosed()

		if data.onClose then
			data.onClose()
		end
	end

	local function fn2(title2)
		local v9 = {
			url = v5,
			title = title2,
			searchParams = searchParams,
			animated = v7,
			transitionAnimation = v6,
			showDomainAsTitle = 0
		}

		local v10 = if fFlagLuaAppEnableNxMRoduxApportioning then data.showDomainAsTitle else nil
		v9.showDomainAsTitle = v10
		local jsonEncode = HttpService:JSONEncode(v9)

		local createElement = React.createElement
		local v12 = {
			isVisible = isVisible,
			DisplayOrder = displayOrder,
			notificationData = jsonEncode,
			notificationType = module.OPEN_CUSTOM_WEBVIEW,
			onClose = 0
		}

		local v13 = if fFlagEnableWebViewStateTracker and defineFastFlag then fn else data.onClose
		v12.onClose = v13
		return createElement(module5, v12)
	end

	if titleKey == nil or title ~= nil then
		return fn2(title)
	end

	return module4({ title = titleKey })(function(p2)
		return fn2(p2.title)
	end)
end

if module8() then
	return function(props)
		local createElement = React.createElement
		local v6 = {
			url = props.url,
			title = props.title,
			titleKey = props.titleKey,
			showDomainAsTitle = 0,
			searchParams = 0,
			transitionAnimation = 0,
			windowCloseCallback = 0,
			overlayProps = 0
		}
		local v7 = if fFlagLuaAppEnableNxMRoduxApportioning then props.showDomainAsTitle else nil
		v6.showDomainAsTitle = v7
		v6.searchParams = props.searchParams
		v6.transitionAnimation = props.transitionAnimation
		v6.windowCloseCallback = props.onClose
		v6.overlayProps = {
			isVisible = props.isVisible,
			DisplayOrder = props.DisplayOrder
		}
		return createElement(module6, v6)
	end
end

return GenericWebPageWrapper
