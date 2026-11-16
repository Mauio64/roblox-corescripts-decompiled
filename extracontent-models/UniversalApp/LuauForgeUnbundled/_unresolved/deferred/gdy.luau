local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local BrowserService = game:GetService("BrowserService")
local GuiService = game:GetService("GuiService")

local MemStorageService = game:GetService("MemStorageService")
local module = require("@luauforge/bundled/fBr")

local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local module2 = require("@luauforge/bundled/edB")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/eda")

local module4 = require("@luauforge/deferred/gcb")
local module5 = require("@luauforge/bundled/fot")
local module6 = require("@luauforge/deferred/fuc")
local module7 = require("@luauforge/bundled/fus")
local module8 = require("@luauforge/deferred/gdz")
local module9 = require("@luauforge/bundled/gdA")
local module10 = require("@luauforge/bundled/gdB")
local module11 = require("@luauforge/bundled/fsq")

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fzr").Utils.getSubscriptionPurchaseCloseCallback

local module12 = require("@luauforge/deferred/gdK")

local module13 = require("@luauforge/deferred/gdL")
local nativePurchaseRobuxPageWrapperAnalytics = module13.NativePurchaseRobuxPageWrapperAnalytics
local timingData = module13.TimingData

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local extended = Roact.PureComponent:extend("NativePurchaseRobuxPageWrapper")

local module14 = require("@luauforge/bundled/fQI")

local module15 = require("@luauforge/deferred/gdM")

local defineFastFlag = game:DefineFastFlag("NativePurchaseRobuxPageWrapperEnableTelemetry", false)

local module16 = require("@luauforge/bundled/fui")

local module17 = require("@luauforge/bundled/ftw")
local buyRobuxPageTTIManager = module17.BuyRobuxPageTTIManager
local fFlagEnableBuyRobuxPageTTI = module17.Flags.FFlagEnableBuyRobuxPageTTI
local module18 = require("@luauforge/deferred/fuj")
local module19 = require("@luauforge/bundled/gdJ")

local module20 = require("@luauforge/deferred/gdN")
local module21 = require("@luauforge/bundled/dMB")
local module22 = require("@luauforge/deferred/gdO")

local v5 = {
	eventName = "NativePurchaseRobuxPageWrapper_PostPurchaseRedirect",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 7, 15 },
	description = "Counter to track post-purchase redirect to checkout success page. redirect_method is BrowserService or GuiService.",
	links = ""
}

local v6 = {
	eventName = "NativePurchaseRobuxPageWrapper_PostPurchaseSuccess",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 7, 15 },
	description = "Counter to track NativePurchaseStatus.Success with has_checkout_session_id indicating whether a checkoutSessionId was present.",
	links = ""
}

local v7 = {
	eventName = "NativePurchaseRobuxPageWrapper_PostPurchaseIXPExposure",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 7, 15 },
	description = "Counter to track IXP exposures to the PostPurchase experiment. post_purchase_enabled_for_user indicates treatment (true) vs control (false).",
	links = ""
}

local v8 = {
	eventName = "NativePurchaseRobuxPageWrapper_PostPurchaseDuplicateExposure",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 7, 15 },
	description = "Counter to track when a second NativePurchaseStatus.Success fires after exposure was already logged, indicating duplicate Success signals.",
	links = ""
}

extended.defaultProps = {
	economyGetBalance = module8,
	memStorageService = MemStorageService
}

function extended:init()
	local v9 = if fFlagEnableBuyRobuxPageTTI and self.props.url ~= nil and buyRobuxPageTTIManager.getTtiStartMs() ~= nil then buyRobuxPageTTIManager.appendTtiStartMsToUrl(self.props.url) else nil
	self.webViewUrl = v9

	if defineFastFlag then
		local now = tick()

		local guid = HttpService:GenerateGUID(false)

		self.timingData = timingData.new(guid, now)

		self.analytics = nativePurchaseRobuxPageWrapperAnalytics.new(TelemetryService)
		self.analytics:onInit(self.timingData)
	end

	if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then
		self.onClose = getSubscriptionPurchaseCloseCallback()
	end

	self.state = { localizedTitle = "--" }

	function self.getRobuxBalance()
		local now

		if defineFastFlag and self.timingData then
			now = tick()

			self.timingData.get_robux_balance_start = now

			self.analytics:onApiCall(self.timingData, "getRobuxBalance")
		else
			now = nil
		end

		self.props.economyGetBalance(self.props.networking):andThen(function(p2)
			local robux = p2 and p2.responseBody.robux or "--"

			if defineFastFlag and self.timingData and now then
				local now2 = tick()

				self.timingData:setApiTiming(now, now2)

				self.analytics:onApiResponse(self.timingData, "getRobuxBalance", (tostring(robux)))
			end

			self.props.memStorageService:SetItem(module.RobuxBalance, robux)

			local v10 = numberLocalization.localize(robux, self.props.localization:GetLocale()) or "--"

			self:setState({
				localizedTitle = self.props.localization:Format(
					"Purchasing.RobloxProducts.Label.RobuxBalance",
					v10
				)
			})
		end)
	end
end

function extended:didMount()
	if fFlagEnableBuyRobuxPageTTI and buyRobuxPageTTIManager.getTtiStartMs() ~= nil then
		if not self.didFirePrimaryDataStartedUA then
			self.didFirePrimaryDataStartedUA = true
			buyRobuxPageTTIManager.L2.primaryDataStartedUA()
			buyRobuxPageTTIManager.simulateWebPayload()
		end

		buyRobuxPageTTIManager.L2.surfaceMountedUA()
	end

	if defineFastFlag and self.timingData then
		local now = tick()

		self.timingData:setMountTime(now)

		if self.analytics then
			self.analytics:onMount(self.timingData)
		end
	end

	if module15() then
		self.getRobuxBalance()

		self.connection = self.props.memStorageService:bind(
			module.RefreshRobuxBalance,
			self.getRobuxBalance
		)
	else
		local now = tick()

		if defineFastFlag then
			self.timingData.get_robux_balance_start = now
			self.analytics:onApiCall(self.timingData, "getRobuxBalance")
		end

		self.props.economyGetBalance(self.props.networking):andThen(function(p2)
			local now2 = tick()
			local robux = p2 and p2.responseBody.robux or "--"

			local v9 = now2 - now

			if defineFastFlag then
				self.timingData.get_robux_balance_response = now2
				self.timingData.api_latency_ms = v9 * 1000

				self.analytics:onApiResponse(self.timingData, "getRobuxBalance", (tostring(robux)))
			end

			self.props.memStorageService:SetItem(module.RobuxBalance, robux)

			local v10 = numberLocalization.localize(robux, self.props.localization:GetLocale()) or "--"

			local formatted = self.props.localization:Format(
				"Purchasing.RobloxProducts.Label.RobuxBalance",
				v10
			)
			self.props.memStorageService:SetItem(module.RobuxBalanceLocalized, formatted)
		end)

		self.connection = self.props.memStorageService:bind(module.RefreshRobuxBalance, function(p2)
			self.props.economyGetBalance(self.props.networking):andThen(function(p3)
				local robux = p3 and p3.responseBody.robux or "--"
				self.props.memStorageService:SetItem(module.RobuxBalance, robux)

				local v9 = numberLocalization.localize(robux, self.props.localization:GetLocale()) or "--"

				local formatted = self.props.localization:Format(
					"Purchasing.RobloxProducts.Label.RobuxBalance",
					v9
				)

				self.props.memStorageService:SetItem(module.RobuxBalanceLocalized, formatted)
			end)
		end)
	end
end

function extended:didUpdate(p2)
	if not (module19 or module20()) then
		return
	end

	if
		p2.nativePurchaseStatus ~= module9.Success
		and self.props.nativePurchaseStatus == module9.Success
	then
		local v9 = not (self.props.checkoutSessionId == nil) and self.props.checkoutSessionId ~= ""

		if module20() then
			TelemetryService:LogCounter(v6, {
				customFields = { has_checkout_session_id = tostring(v9) }
			}, 1)
		end

		if module19 and v9 then
			if self.didFirePostPurchaseExposure then
				if module20() then
					TelemetryService:LogCounter(v8, {}, 1)
				end
			else
				self.didFirePostPurchaseExposure = true
				module21.logExposure(module22)

				if module20() then
					TelemetryService:LogCounter(v7, {
						customFields = {
							post_purchase_enabled_for_user = tostring(self.props.postPurchaseEnabledForUser == true)
						}
					}, 1)
				end
			end

			if self.props.postPurchaseEnabledForUser then
				local v10 = module11.fromString("www:upgrades/checkout/success?checkoutSessionId={checkoutSessionId}")({
					checkoutSessionId = self.props.checkoutSessionId
				})

				if module14() then
					if module20() then
						TelemetryService:LogCounter(v5, {
							customFields = { redirect_method = "BrowserService" }
						}, 1)
					end

					BrowserService:ExecuteJavaScript("window.location.href = " .. HttpService:JSONEncode(v10) .. ";")
				else
					if module20() then
						TelemetryService:LogCounter(v5, {
							customFields = { redirect_method = "GuiService" }
						}, 1)
					end

					GuiService:BroadcastNotification(v10, module5.POST_PURCHASE)
				end
			end
		end
	end
end

function extended:willUnmount()
	if self.connection ~= nil then
		self.connection:Disconnect()
		self.connection = nil
	end

	if self.props.nativeProductId then
		self.props.onNativePurchaseAttempt(self.props.networking, self.props.nativeProductId)
	end
end

function extended:render()
	local now = tick()

	if
		fFlagEnableBuyRobuxPageTTI
		and buyRobuxPageTTIManager.getTtiStartMs() ~= nil
		and not self.didFireRenderStartedUA
	then
		self.didFireRenderStartedUA = true
		buyRobuxPageTTIManager.L2.renderStartedUA()
	end

	if defineFastFlag and self.timingData then
		self.timingData:setRenderTime(now)

		self.analytics:onRender(self.timingData)
	end

	local isVisible = self.props.isVisible
	local displayOrder = self.props.DisplayOrder
	local v9

	if fFlagEnableBuyRobuxPageTTI and self.webViewUrl ~= nil then
		v9 = self.webViewUrl
	else
		v9 = self.props.url
	end

	local transitionAnimation = self.props.transitionAnimation

	if module14() then
		if module15() then
			local v10 = if module12 then now else tick()

			if defineFastFlag and self.timingData then
				self.timingData:setWebViewLoadTime(v10)

				self.analytics:onWebViewLoad(self.timingData, now)
			end

			local createElement = Roact.createElement
			local v12 = {
				url = v9,
				title = self.state.localizedTitle,
				windowType = module7.Dialog,
				transitionAnimation = transitionAnimation,
				hasBackButton = 0,
				windowCloseCallback = 0,
				hideHeader = 0,
				overlayProps = 0
			}

			local v13 = if module16() then false else nil
			v12.hasBackButton = v13
			v12.windowCloseCallback = self.onClose
			v12.hideHeader = module18() and true or nil
			v12.overlayProps = { isVisible = isVisible, DisplayOrder = displayOrder }
			return (createElement(module6, v12))
		else
			if module12 and self.timingData then
				self.timingData:setWebViewLoadTime(now)

				self.analytics:onWebViewLoad(self.timingData, now)
			end

			local createElement = Roact.createElement
			local v11 = {
				url = v9,
				titleKey = "Feature.BuyRobux.Heading.Banner",
				windowType = module7.Dialog,
				transitionAnimation = transitionAnimation,
				hasBackButton = 0,
				windowCloseCallback = 0,
				hideHeader = 0,
				overlayProps = 0
			}

			local v12 = if module16() then false else nil
			v11.hasBackButton = v12
			v11.windowCloseCallback = self.onClose
			v11.hideHeader = module18() and true or nil
			v11.overlayProps = { isVisible = isVisible, DisplayOrder = displayOrder }
			return (createElement(module6, v11))
		end
	else
		if module12 and self.timingData then
			self.timingData:setWebViewLoadTime(now)

			self.analytics:onWebViewLoad(self.timingData, now)
		end

		return Roact.createElement(module4, {
			isVisible = isVisible,
			DisplayOrder = displayOrder,
			notificationType = module5.PURCHASE_ROBUX,
			titleTextLocalizationKey = "Feature.BuyRobux.Heading.Banner",
			transitionAnimation = transitionAnimation,
			onClose = self.onClose
		})
	end
end

local v9 = roactServices.connect({ localization = module2, networking = module3 })(extended)

local v10 = RoactRodux.connect(function(p2, p3)
	local v11 = module19 or module20()
	local v12 = {
		nativeProductId = p2.NativePurchase.nativeProductId,
		nativePurchaseStatus = 0,
		checkoutSessionId = 0
	}
	local v13 = if v11 then p2.NativePurchase.purchaseStatus else nil
	v12.nativePurchaseStatus = v13
	local v14 = if v11 then p2.NativePurchase.checkoutSessionId else nil
	v12.checkoutSessionId = v14
	return v12
end, function(callback)
	return {
		onNativePurchaseAttempt = function(p2, p3)
			callback(module10(p2, p3, module9.Polling))
		end
	}
end)(v9)

if module19 then
	v10 = module21.connectTestVariables({
		postPurchaseEnabledForUser = module22.EnabledForUser
	})(v10)
end

return v10
