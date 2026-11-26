local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuyRobuxRouting/SharedFlags")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/BuyRobuxRouting/IxpServiceWrapper").IXPServiceWrapper
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/BuyRobuxRouting/UniversalAppPolicy").getAppFeaturePolicies

local isSduiBuyRobuxSupported = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/BuyRobuxRouting/isSduiBuyRobuxSupported")
local FFlagBuyRobuxRoutingAppendWebContext = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/BuyRobuxRouting/Flags/FFlagBuyRobuxRoutingAppendWebContext")

local fFlagEnableBuyRobuxNextJS = SharedFlags.FFlagEnableBuyRobuxNextJS
local fFlagBuyRobuxLatencyIxpEnabled = SharedFlags.FFlagBuyRobuxLatencyIxpEnabled
local fFlagEnableBuyRobuxSdui = SharedFlags.FFlagEnableBuyRobuxSdui
local fStringPaymentsBuyRobuxLayer = SharedFlags.FStringPaymentsBuyRobuxLayer
local fFlagBypassBuyRobuxSduiSupportForWebRouting = SharedFlags.FFlagBypassBuyRobuxSduiSupportForWebRouting
local logBuyRobuxRoutingDecision = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/BuyRobuxRouting/logBuyRobuxRoutingDecision")

local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

local function isExcludedRegion()
	local appFeaturePolicies = getAppFeaturePolicies()
	return appFeaturePolicies.useLuobuAuthentication()
		or appFeaturePolicies.getUseVNGUserAgreementPopup()
		or appFeaturePolicies.getRedirectBuyRobuxToVNG()
		or appFeaturePolicies.getShowVNGTosForRobuxUpsell()
end

local function buildUrl(p2, p3)
	local v6 = {}

	if p3.analyticId ~= nil then
		table.insert(v6, "analyticId=" .. HttpService:UrlEncode(p3.analyticId))
	end

	if p3.productId ~= nil then
		table.insert(v6, "product_id=" .. HttpService:UrlEncode(p3.productId))
	end

	return v5 .. p2 .. (not (#v6 > 0) and "" or "?" .. table.concat(v6, "&"))
end

local function appendRoutingContext(value, p2)
	local v6 = {}

	if p2 ~= nil then
		table.insert(v6, "variant=" .. HttpService:UrlEncode(p2))
	end

	table.insert(v6, "startMs=" .. tostring(DateTime.now().UnixTimestampMillis))
	return value .. (string.find(value, "?", 1, true) and "&" or "?") .. table.concat(v6, "&")
end

local function webDestination(p2, p3)
	return { kind = "web", url = p2, shouldExpose = p3 }
end

local function resolveDestinationWithWebContext(p2)
	local appFeaturePolicies = getAppFeaturePolicies()

	if
		appFeaturePolicies.useLuobuAuthentication()
		or appFeaturePolicies.getUseVNGUserAgreementPopup()
		or appFeaturePolicies.getRedirectBuyRobuxToVNG()
		or appFeaturePolicies.getShowVNGTosForRobuxUpsell()
	then
		logBuyRobuxRoutingDecision("controlWeb", "excludedRegion")
		return {
			kind = "web",
			url = appendRoutingContext(buildUrl("upgrades/robux", p2), nil),
			shouldExpose = false
		}
	end

	if not (fFlagBypassBuyRobuxSduiSupportForWebRouting or isSduiBuyRobuxSupported()) then
		logBuyRobuxRoutingDecision("controlWeb", "sduiNotSupported")
		return {
			kind = "web",
			url = appendRoutingContext(buildUrl("upgrades/robux", p2), nil),
			shouldExpose = false
		}
	end

	if fFlagEnableBuyRobuxSdui then
		logBuyRobuxRoutingDecision("nativeSdui", "experimentArm")
		return { kind = "native", shouldExpose = fFlagBuyRobuxLatencyIxpEnabled }
	end

	if fFlagEnableBuyRobuxNextJS then
		logBuyRobuxRoutingDecision("nextJsWeb", "experimentArm")
		return {
			kind = "web",
			url = appendRoutingContext(buildUrl("upgrades/robux/v2", p2), "nextjs"),
			shouldExpose = fFlagBuyRobuxLatencyIxpEnabled
		}
	end

	logBuyRobuxRoutingDecision("controlWeb", "experimentArm")
	return {
		kind = "web",
		url = appendRoutingContext(buildUrl("upgrades/robux", p2), "control"),
		shouldExpose = fFlagBuyRobuxLatencyIxpEnabled
	}
end

local function resolveDestination(p2)
	local url = buildUrl("upgrades/robux", p2)
	local appFeaturePolicies = getAppFeaturePolicies()

	if
		appFeaturePolicies.useLuobuAuthentication()
		or appFeaturePolicies.getUseVNGUserAgreementPopup()
		or appFeaturePolicies.getRedirectBuyRobuxToVNG()
		or appFeaturePolicies.getShowVNGTosForRobuxUpsell()
	then
		logBuyRobuxRoutingDecision("controlWeb", "excludedRegion")
		return { kind = "web", url = url, shouldExpose = false }
	end

	if not (fFlagBypassBuyRobuxSduiSupportForWebRouting or isSduiBuyRobuxSupported()) then
		logBuyRobuxRoutingDecision("controlWeb", "sduiNotSupported")
		return { kind = "web", url = url, shouldExpose = false }
	end

	if fFlagEnableBuyRobuxSdui then
		logBuyRobuxRoutingDecision("nativeSdui", "experimentArm")
		return { kind = "native", shouldExpose = fFlagBuyRobuxLatencyIxpEnabled }
	end

	if fFlagEnableBuyRobuxNextJS then
		logBuyRobuxRoutingDecision("nextJsWeb", "experimentArm")
		return {
			kind = "web",
			url = buildUrl("upgrades/robux/v2", p2),
			shouldExpose = fFlagBuyRobuxLatencyIxpEnabled
		}
	end

	logBuyRobuxRoutingDecision("controlWeb", "experimentArm")
	return { kind = "web", url = url, shouldExpose = fFlagBuyRobuxLatencyIxpEnabled }
end

if not FFlagBuyRobuxRoutingAppendWebContext then
	resolveDestinationWithWebContext = resolveDestination
end

return {
	fallbackWebUrl = function(p2)
		return buildUrl("upgrades/robux", p2)
	end,
	resolveDestination = resolveDestinationWithWebContext,
	logExposure = function(p2)
		if p2.shouldExpose and fStringPaymentsBuyRobuxLayer ~= "" then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringPaymentsBuyRobuxLayer)
		end
	end,
	resolveAndLogDestination = function(p2)
		local v6 = if FFlagBuyRobuxRoutingAppendWebContext then resolveDestinationWithWebContext(p2) else resolveDestination(p2)

		if v6.shouldExpose and fStringPaymentsBuyRobuxLayer ~= "" then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringPaymentsBuyRobuxLayer)
		end

		return v6
	end
}
