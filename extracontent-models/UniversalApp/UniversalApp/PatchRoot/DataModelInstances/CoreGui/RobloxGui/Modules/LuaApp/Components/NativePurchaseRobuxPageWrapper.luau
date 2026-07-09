local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local MemStorageService = game:GetService("MemStorageService")
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local GenericNativePageWrapper = require(Modules.LuaApp.Components.GenericNativePageWrapper)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local AppWebView = require(Modules.LuaApp.Components.WebView.AppWebView)
local WebViewWindow = require(Modules.LuaApp.Enum.WebViewWindow)
local GetRobuxBalance = require(Modules.LuaApp.Http.Requests.EconomyAPI.GetRobuxBalance)
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local NativePurchaseComplete = require(Modules.LuaApp.Thunks.NativePurchaseComplete)
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback
local FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 = require(Modules.LuaApp.Flags.FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2)
local NativePurchaseRobuxPageWrapperAnalytics = require(Modules.LuaApp.Components.EventReceivers.Analytics.NativePurchaseRobuxPageWrapperAnalytics)
local NativePurchaseRobuxPageWrapperAnalytics2 = NativePurchaseRobuxPageWrapperAnalytics.NativePurchaseRobuxPageWrapperAnalytics
local TimingData = NativePurchaseRobuxPageWrapperAnalytics.TimingData
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local v26 = Roact.PureComponent:extend("NativePurchaseRobuxPageWrapper")
local GetFFlagEnableUnifiedStaticWebViews = require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews)
local GetFFlagCleanUpNativePurchaseRobuxTitle = require(Modules.LuaApp.Flags.GetFFlagCleanUpNativePurchaseRobuxTitle)
local v29 = game:DefineFastFlag("NativePurchaseRobuxPageWrapperEnableTelemetry", false)
local GetFFlagWebViewServiceHasBackButtonVisibility = require(Modules.LuaApp.Flags.GetFFlagWebViewServiceHasBackButtonVisibility)
local PurchasingPerformance = require(CorePackages.Workspace.Packages.PurchasingPerformance)
local BuyRobuxPageTTIManager = PurchasingPerformance.BuyRobuxPageTTIManager
local FFlagEnableBuyRobuxPageTTI = PurchasingPerformance.Flags.FFlagEnableBuyRobuxPageTTI
local GetFFlagWebViewHasHideHeader = require(Modules.LuaApp.Flags.GetFFlagWebViewHasHideHeader)

v26.defaultProps = {
	economyGetBalance = GetRobuxBalance,
	memStorageService = MemStorageService
}

function v26.init(p1) -- line: 61
	-- upvalues: FFlagEnableBuyRobuxPageTTI (copy), BuyRobuxPageTTIManager (copy), v29 (copy), HttpService (copy), TimingData (copy), NativePurchaseRobuxPageWrapperAnalytics2 (copy), TelemetryService (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy), MemStorageKeys (copy), NumberLocalization (copy)
	p1.webViewUrl = if not FFlagEnableBuyRobuxPageTTI or (p1.props.url == nil or BuyRobuxPageTTIManager.getTtiStartMs() == nil) then nil else BuyRobuxPageTTIManager.appendTtiStartMsToUrl(p1.props.url)

	if v29 then
		local timestamp = tick()
		local guid = HttpService:GenerateGUID(false)

		p1.timingData = TimingData.new(guid, timestamp)
		p1.analytics = NativePurchaseRobuxPageWrapperAnalytics2.new(TelemetryService)
		p1.analytics:onInit(p1.timingData)
	end

	if FFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then
		p1.onClose = getSubscriptionPurchaseCloseCallback()
	end

	p1.state = {
		localizedTitle = "--"
	}

	function p1.getRobuxBalance() -- line: 89
		-- upvalues: v29 (copy), p1 (copy), MemStorageKeys (copy), NumberLocalization (copy)
		local timestamp = nil

		if v29 and p1.timingData then
			timestamp = tick()
			p1.timingData.get_robux_balance_start = timestamp
			p1.analytics:onApiCall(p1.timingData, "getRobuxBalance")
		end

		p1.props.economyGetBalance(p1.props.networking):andThen(function(p2) -- line: 99
			-- upvalues: v29 (copy), p1 (copy), timestamp (ref), MemStorageKeys (copy), NumberLocalization (copy)
			local v64 = p2 and p2.responseBody.robux or "--"

			if v29 and (p1.timingData and timestamp) then
				local timestamp2 = tick()

				p1.timingData:setApiTiming(timestamp, timestamp2)
				p1.analytics:onApiResponse(p1.timingData, "getRobuxBalance", (tostring(v64)))
			end

			p1.props.memStorageService:SetItem(MemStorageKeys.RobuxBalance, v64)

			local v66 = NumberLocalization.localize(v64, p1.props.localization:GetLocale()) or "--"
			local v67 = p1.props.localization:Format("Purchasing.RobloxProducts.Label.RobuxBalance", v66)

			p1:setState({
				localizedTitle = v67
			})
		end)
	end
end
function v26.didMount(p3) -- line: 124
	-- upvalues: FFlagEnableBuyRobuxPageTTI (copy), BuyRobuxPageTTIManager (copy), v29 (copy), GetFFlagCleanUpNativePurchaseRobuxTitle (copy), MemStorageKeys (copy), NumberLocalization (copy)
	if FFlagEnableBuyRobuxPageTTI and BuyRobuxPageTTIManager.getTtiStartMs() ~= nil then
		if not p3.didFirePrimaryDataStartedUA then
			p3.didFirePrimaryDataStartedUA = true
			BuyRobuxPageTTIManager.L2.primaryDataStartedUA()
			BuyRobuxPageTTIManager.simulateWebPayload()
		end

		BuyRobuxPageTTIManager.L2.surfaceMountedUA()
	end

	if v29 and p3.timingData then
		local timestamp = tick()

		p3.timingData:setMountTime(timestamp)

		if p3.analytics then
			p3.analytics:onMount(p3.timingData)
		end
	end

	if GetFFlagCleanUpNativePurchaseRobuxTitle() then
		p3.getRobuxBalance()
		p3.connection = p3.props.memStorageService:bind(MemStorageKeys.RefreshRobuxBalance, p3.getRobuxBalance)

		return
	end

	local timestamp = tick()

	if v29 then
		p3.timingData.get_robux_balance_start = timestamp
		p3.analytics:onApiCall(p3.timingData, "getRobuxBalance")
	end

	p3.props.economyGetBalance(p3.props.networking):andThen(function(p4) -- line: 156
		-- upvalues: timestamp (copy), v29 (copy), p3 (copy), MemStorageKeys (copy), NumberLocalization (copy)
		local timestamp3 = tick()
		local v55 = p4 and p4.responseBody.robux or "--"
		local v56 = timestamp3 - timestamp

		if v29 then
			p3.timingData.get_robux_balance_response = timestamp3
			p3.timingData.api_latency_ms = v56 * 1000
			p3.analytics:onApiResponse(p3.timingData, "getRobuxBalance", (tostring(v55)))
		end

		p3.props.memStorageService:SetItem(MemStorageKeys.RobuxBalance, v55)

		local v57 = NumberLocalization.localize(v55, p3.props.localization:GetLocale()) or "--"
		local v58 = p3.props.localization:Format("Purchasing.RobloxProducts.Label.RobuxBalance", v57)

		p3.props.memStorageService:SetItem(MemStorageKeys.RobuxBalanceLocalized, v58)
	end)
	p3.connection = p3.props.memStorageService:bind(MemStorageKeys.RefreshRobuxBalance, function(_) -- line: 178
		-- upvalues: p3 (copy), MemStorageKeys (copy), NumberLocalization (copy)
		p3.props.economyGetBalance(p3.props.networking):andThen(function(p6) -- line: 179
			-- upvalues: p3 (copy), MemStorageKeys (copy), NumberLocalization (copy)
			local v69 = p6 and p6.responseBody.robux or "--"

			p3.props.memStorageService:SetItem(MemStorageKeys.RobuxBalance, v69)

			local v70 = NumberLocalization.localize(v69, p3.props.localization:GetLocale()) or "--"
			local v71 = p3.props.localization:Format("Purchasing.RobloxProducts.Label.RobuxBalance", v70)

			p3.props.memStorageService:SetItem(MemStorageKeys.RobuxBalanceLocalized, v71)
		end)
	end)
end
function v26.willUnmount(p7) -- line: 197
	if p7.connection ~= nil then
		p7.connection:Disconnect()
		p7.connection = nil
	end

	if p7.props.nativeProductId then
		p7.props.onNativePurchaseAttempt(p7.props.networking, p7.props.nativeProductId)
	end
end
function v26.render(p8) -- line: 209
	-- upvalues: FFlagEnableBuyRobuxPageTTI (copy), BuyRobuxPageTTIManager (copy), v29 (copy), GetFFlagEnableUnifiedStaticWebViews (copy), GetFFlagCleanUpNativePurchaseRobuxTitle (copy), FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 (copy), Roact (copy), AppWebView (copy), WebViewWindow (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy), GetFFlagWebViewHasHideHeader (copy), GenericNativePageWrapper (copy), NotificationType (copy)
	local timestamp = tick()

	if FFlagEnableBuyRobuxPageTTI and (BuyRobuxPageTTIManager.getTtiStartMs() ~= nil and not p8.didFireRenderStartedUA) then
		p8.didFireRenderStartedUA = true
		BuyRobuxPageTTIManager.L2.renderStartedUA()
	end

	if v29 and p8.timingData then
		p8.timingData:setRenderTime(timestamp)
		p8.analytics:onRender(p8.timingData)
	end

	local isVisible = p8.props.isVisible
	local DisplayOrder = p8.props.DisplayOrder
	local v47 = if not FFlagEnableBuyRobuxPageTTI or p8.webViewUrl == nil then p8.props.url else p8.webViewUrl
	local transitionAnimation = p8.props.transitionAnimation

	if GetFFlagEnableUnifiedStaticWebViews() then
		if GetFFlagCleanUpNativePurchaseRobuxTitle() then
			return ((function() -- line: 233
				-- upvalues: FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 (copy), timestamp (copy), v29 (copy), p8 (copy), Roact (copy), AppWebView (copy), v47 (copy), WebViewWindow (copy), transitionAnimation (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy), GetFFlagWebViewHasHideHeader (copy), isVisible (copy), DisplayOrder (copy)
				local v60 = if not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 then tick() else timestamp

				if v29 and p8.timingData then
					p8.timingData:setWebViewLoadTime(v60)
					p8.analytics:onWebViewLoad(p8.timingData, timestamp)
				end

				return Roact.createElement(AppWebView, {
					url = v47,
					title = p8.state.localizedTitle,
					windowType = WebViewWindow.Dialog,
					transitionAnimation = transitionAnimation,
					hasBackButton = not GetFFlagWebViewServiceHasBackButtonVisibility() and nil,
					windowCloseCallback = p8.onClose,
					hideHeader = not not GetFFlagWebViewHasHideHeader() or nil,
					overlayProps = {
						isVisible = isVisible,
						DisplayOrder = DisplayOrder
					}
				})
			end)())
		end

		return ((function() -- line: 257
			-- upvalues: FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 (copy), p8 (copy), timestamp (copy), Roact (copy), AppWebView (copy), v47 (copy), WebViewWindow (copy), transitionAnimation (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy), GetFFlagWebViewHasHideHeader (copy), isVisible (copy), DisplayOrder (copy)
			if FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and p8.timingData then
				p8.timingData:setWebViewLoadTime(timestamp)
				p8.analytics:onWebViewLoad(p8.timingData, timestamp)
			end

			return Roact.createElement(AppWebView, {
				titleKey = "Feature.BuyRobux.Heading.Banner",
				url = v47,
				windowType = WebViewWindow.Dialog,
				transitionAnimation = transitionAnimation,
				hasBackButton = not GetFFlagWebViewServiceHasBackButtonVisibility() and nil,
				windowCloseCallback = p8.onClose,
				hideHeader = not not GetFFlagWebViewHasHideHeader() or nil,
				overlayProps = {
					isVisible = isVisible,
					DisplayOrder = DisplayOrder
				}
			})
		end)())
	end

	if FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and p8.timingData then
		p8.timingData:setWebViewLoadTime(timestamp)
		p8.analytics:onWebViewLoad(p8.timingData, timestamp)
	end

	return Roact.createElement(GenericNativePageWrapper, {
		titleTextLocalizationKey = "Feature.BuyRobux.Heading.Banner",
		isVisible = isVisible,
		DisplayOrder = DisplayOrder,
		notificationType = NotificationType.PURCHASE_ROBUX,
		transitionAnimation = transitionAnimation,
		onClose = p8.onClose
	})
end

local v35 = RoactServices.connect({
	localization = RoactLocalization,
	networking = RoactNetworking
})(v26)

return (RoactRodux.connect(function(p9, _) -- line: 299
	return {
		nativeProductId = p9.NativePurchase.nativeProductId
	}
end, function(p11) -- line: 303
	-- upvalues: NativePurchaseComplete (copy), NativePurchaseStatus (copy)
	return {
		onNativePurchaseAttempt = function(p12, p13) -- line: 305
			-- upvalues: p11 (copy), NativePurchaseComplete (copy), NativePurchaseStatus (copy)
			p11(NativePurchaseComplete(p12, p13, NativePurchaseStatus.Polling))
		end
	}
end)(v35))
