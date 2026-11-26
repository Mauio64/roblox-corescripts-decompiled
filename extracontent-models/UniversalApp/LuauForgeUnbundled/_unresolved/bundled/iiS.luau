local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appBrowserService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppBrowserService
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appGame = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGame
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

local module = require("@luauforge/bundled/egJ")
local module2 = require("@luauforge/bundled/fvN")
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local launchGame = require("@luauforge/bundled/fIT").LaunchGame
local module3 = require("@luauforge/bundled/fzK")
local module4 = require("@luauforge/bundled/dFu")
local chatEntryPointNames = require("@luauforge/bundled/eoT").Enums.ChatEntryPointNames

local module5 = require("@luauforge/bundled/hWK")
local module6 = require("@luauforge/bundled/ehB")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module8 = require("@luauforge/bundled/gDk")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local authSessionRefresh = require("@game/CorePackages/Workspace/Packages/AuthCommon").Http.Requests.AuthSessionRefresh

local fFlagRefreshAuthSessionAfterLanguageChange = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRefreshAuthSessionAfterLanguageChange

local module9 = require("@luauforge/bundled/bZe")
local linkingProtocol = module9.LinkingProtocol
local adConsentAttributionAdapter = module9.AdConsentAttributionAdapter
local readCachedAdConsentRegion = module9.readCachedAdConsentRegion
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableAdConsentUserSettingsPublish = SharedFlags.FFlagEnableAdConsentUserSettingsPublish
local fFlagAdConsentForwardCachedRegion = SharedFlags.FFlagAdConsentForwardCachedRegion
local fFlagMoveAdConsentReceiverToAccountManagement = SharedFlags.FFlagMoveAdConsentReceiverToAccountManagement

local defineFastFlag = game:DefineFastFlag("PushPermissionTriggerEnabled", false)

local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableUnifiedWebViews
local WebViewService = if getFFlagEnableUnifiedWebViews() then game:GetService("WebViewService") else nil

local module11 = require("@luauforge/bundled/fAQ")
local buyRobuxPageTTIManager = module11.BuyRobuxPageTTIManager
local bridge = module11.Bridge
local fFlagEnableBuyRobuxPageTTI = module11.Flags.FFlagEnableBuyRobuxPageTTI

local extended = Roact.Component:extend("UniversalAppRobloxHybridEventReceiver")

extended.defaultProps = { webViewService = WebViewService }

function extended:init()
	function self.onJavascriptCallback(json)
		local jsonDecode = HttpService:JSONDecode(json)

		if
			jsonDecode.moduleID == "Navigation"
			and jsonDecode.functionName == "startWebChatConversation"
			and jsonDecode.params.userId
		then
			if not getFFlagEnableUnifiedWebViews() then
				self.props.browserService:CloseBrowserWindow()
			end

			self.props.enteredChatFromEntryPoint(chatEntryPointNames.AppShellWebView)

			self.props.guiService:BroadcastNotification(
				tostring(jsonDecode.params.userId),
				module2.LAUNCH_CONVERSATION
			)
		elseif
			jsonDecode.moduleID == "Navigation"
			and jsonDecode.functionName == "openUserProfile"
			and jsonDecode.params.userId
		then
			if getFFlagEnableUnifiedWebViews() then
				self.props.navigateFromWebView({
					name = module4.ViewUserProfile,
					detail = jsonDecode.params.userId
				})
				return
			end

			self.props.browserService:CloseBrowserWindow()
			self.props.navigateDown({
				name = module4.ViewUserProfile,
				detail = jsonDecode.params.userId
			})
		elseif
			jsonDecode.moduleID == "Navigation"
			and jsonDecode.functionName == "navigateToFeature"
			and jsonDecode.params.params.urlPath
		then
			if getFFlagEnableUnifiedWebViews() then
				local v5 = module3.fromString("www:" .. jsonDecode.params.params.urlPath)
				self.props.navigateFromWebView({
					name = module4.GenericWebPage,
					detail = v5(),
					extraProps = {
						title = jsonDecode.params.params.feature or ""
					}
				})
			else
				local v5 = module3.fromString("www:" .. jsonDecode.params.params.urlPath)
				self.props.browserService:CloseBrowserWindow()
				self.props.navigateDown({
					name = module4.GenericWebPage,
					detail = v5(),
					extraProps = {
						title = jsonDecode.params.params.feature or ""
					}
				})
			end
		elseif
			fFlagEnableBuyRobuxPageTTI
			and jsonDecode.moduleID == bridge.MODULE_ID
			and jsonDecode.functionName == bridge.FUNCTION_NAME
			and jsonDecode.params.params
			and jsonDecode.params.params.feature == bridge.FEATURE
		then
			buyRobuxPageTTIManager.handleBridgePayload(jsonDecode.params.params)
		elseif
			jsonDecode.moduleID == "Navigation"
			and jsonDecode.functionName == "navigateToFeature"
			and jsonDecode.params.params.deepLinkUrlPath
		then
			local deepLinkUrlPath = jsonDecode.params.params.deepLinkUrlPath

			if not self.props.linking:isInternalDlicEnabled() then
				self.props.linking:detectURL(deepLinkUrlPath)
				return
			end

			local internalDlic = self.props.linking:createInternalDlic(
				deepLinkUrlPath,
				self.props.linking.DeepLinkSource.LuaWebViewBridge
			)
			self.props.linking:detectDeeplinkIntent(internalDlic)
		elseif
			jsonDecode.moduleID == "Game"
			and jsonDecode.functionName == "launchGame"
			and jsonDecode.params.request.placeId
		then
			self.props.navigateBack()

			if getFFlagEnableUnifiedWebViews() then
				self.props.webViewService:CloseWindow()
			else
				self.props.browserService:CloseBrowserWindow()
			end

			launchGame(jsonDecode.params.request.placeId, "GameDetailPageJSHybridEvent", {
				accessCode = jsonDecode.params.request.accessCode,
				gameInstanceId = jsonDecode.params.request.instanceId,
				linkCode = jsonDecode.params.request.linkCode,
				joinAttemptId = jsonDecode.params.request.joinAttemptId,
				joinAttemptOrigin = jsonDecode.params.request.joinAttemptOrigin
			}, self.props.game, jsonDecode.params.request.joinAttemptOrigin, nil)
		elseif
			jsonDecode.moduleID == "Game"
			and jsonDecode.functionName == "launchGame"
			and jsonDecode.params.request.requestType == "RequestFollowUser"
		then
			self.props.navigateBack()

			if getFFlagEnableUnifiedWebViews() then
				self.props.webViewService:CloseWindow()
			else
				self.props.browserService:CloseBrowserWindow()
			end

			launchGame(
				nil,
				"FollowUserJSHybridEvent",
				{
					userId = jsonDecode.params.request.userId,
					joinAttemptId = jsonDecode.params.request.joinAttemptId,
					joinAttemptOrigin = jsonDecode.params.request.joinAttemptOrigin
				},
				self.props.game,
				jsonDecode.params.request.joinAttemptOrigin,
				nil
			)
		elseif
			jsonDecode.moduleID == "Localization"
			and jsonDecode.functionName == "languageChangeTrigger"
		then
			self.props.navigateBack()

			if getFFlagEnableUnifiedWebViews() then
				self.props.webViewService:CloseWindow()
			else
				self.props.browserService:CloseBrowserWindow()
			end

			local v5 = jsonDecode.params.newRobloxLanguageValue

			if typeof(v5) == "table" then
				v5 = v5.locale
			end

			local v6 = string.gsub(v5, "_", "-")
			AppStorageService:SetItem(localStorageKey.RobloxLocaleId, v6)

			if fFlagRefreshAuthSessionAfterLanguageChange then
				authSessionRefresh(self.props.networkImpl):finally(function()
					self.props.guiService:BroadcastNotification("", module2.RESTART_LUA_APP)
				end)
			else
				self.props.guiService:BroadcastNotification("", module2.RESTART_LUA_APP)
			end
		elseif
			defineFastFlag
			and jsonDecode.moduleID == "Push"
			and jsonDecode.functionName == "pushPermissionTrigger"
		then
			self.props.guiService:BroadcastNotification(jsonDecode.moduleID, module2.APP_READY)
		elseif jsonDecode.moduleID == "Overlay" and jsonDecode.functionName == "close" then
			self.props.navigateBack()

			if getFFlagEnableUnifiedWebViews() then
				self.props.webViewService:CloseWindow()
			else
				self.props.browserService:CloseBrowserWindow()
			end
		elseif
			fFlagEnableAdConsentUserSettingsPublish
			and not fFlagMoveAdConsentReceiverToAccountManagement
			and jsonDecode.moduleID == "AdConsent"
			and jsonDecode.functionName == "adConsentChanged"
		then
			local params = if typeof(jsonDecode.params) == "table" then jsonDecode.params else nil
			local v6 = (if params and typeof(params.params) == "table" then params.params else nil)
				or params
			local allowSellShareData = v6 and v6.allowSellShareData

			local v7 = v6 and v6.isUnder18 and "Disabled" or allowSellShareData

			if v7 ~= nil then
				local v8 = if fFlagAdConsentForwardCachedRegion then readCachedAdConsentRegion() else nil
				adConsentAttributionAdapter.resolveAndPublish(
					linkingProtocol.default,
					"ConsentChanged",
					function()
						return v7
					end,
					v8
				)
			end
		end
	end
end

function extended.render(p2)
	local createElement = Roact.createElement
	local v7 = if getFFlagEnableUnifiedWebViews() then p2.props.webViewService.OnJavaScriptCall else p2.props.browserService.JavaScriptCallback
	return createElement(module, { event = v7, callback = p2.onJavascriptCallback })
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		navigateDown = not getFFlagEnableUnifiedWebViews() and function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module6(p2))
		end or nil,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end,
		navigateFromWebView = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.fromWebView(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module8(p2))
		end,
		enteredChatFromEntryPoint = function(p2)
			return callback(module5(p2))
		end
	}
end)(extended)

local connect = roactServices.connect

if getFFlagEnableUnifiedWebViews() then
	appBrowserService = nil
end

if not fFlagRefreshAuthSessionAfterLanguageChange then
	roactNetworking = nil
end

return (connect({
	browserService = appBrowserService,
	guiService = appGuiService,
	networkImpl = roactNetworking,
	game = appGame,
	linking = appLinking
})(v5))
