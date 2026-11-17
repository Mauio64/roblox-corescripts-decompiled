local BuyRobuxRouting = script:FindFirstAncestor("BuyRobuxRouting")
local parent = BuyRobuxRouting.Parent

local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")

local SharedFlags = require(parent.SharedFlags)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local isSduiBuyRobuxSupported = require(BuyRobuxRouting.isSduiBuyRobuxSupported)
local FFlagBuyRobuxRoutingAppendWebContext = require(BuyRobuxRouting.Flags.FFlagBuyRobuxRoutingAppendWebContext)

local FFlagEnableBuyRobuxNextJS = SharedFlags.FFlagEnableBuyRobuxNextJS
local FFlagBuyRobuxLatencyIxpEnabled = SharedFlags.FFlagBuyRobuxLatencyIxpEnabled
local FFlagEnableBuyRobuxSdui = SharedFlags.FFlagEnableBuyRobuxSdui
local FStringPaymentsBuyRobuxLayer = SharedFlags.FStringPaymentsBuyRobuxLayer
local FFlagBypassBuyRobuxSduiSupportForWebRouting = SharedFlags.FFlagBypassBuyRobuxSduiSupportForWebRouting
local logBuyRobuxRoutingDecision = require(script.Parent.logBuyRobuxRoutingDecision)

local v = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

local function isExcludedRegion() -- 2 equivalent calls inferred from this helper
	local appFeaturePolicies = getAppFeaturePolicies()
	return appFeaturePolicies.useLuobuAuthentication()
		or appFeaturePolicies.getUseVNGUserAgreementPopup()
		or appFeaturePolicies.getRedirectBuyRobuxToVNG()
		or appFeaturePolicies.getShowVNGTosForRobuxUpsell()
end

local function buildUrl(p: string, p2)
	local v2 = {}

	if p2.analyticId ~= nil then
		table.insert(v2, "analyticId=" .. HttpService:UrlEncode(p2.analyticId))
	end

	if p2.productId ~= nil then
		table.insert(v2, "product_id=" .. HttpService:UrlEncode(p2.productId))
	end

	return v .. p .. (not (#v2 > 0) and "" or "?" .. table.concat(v2, "&"))
end

local function appendRoutingContext(value: string, p: string?)
	local v2 = {}

	if p ~= nil then
		table.insert(v2, "variant=" .. HttpService:UrlEncode(p))
	end

	table.insert(v2, "startMs=" .. tostring(DateTime.now().UnixTimestampMillis))
	return value .. (string.find(value, "?", 1, true) and "&" or "?") .. table.concat(v2, "&")
end

local function webDestination(url: string, fFlagBuyRobuxLatencyIxpEnabled: boolean) -- 8 equivalent calls inferred from this helper
	return { kind = "web", url = url, shouldExpose = fFlagBuyRobuxLatencyIxpEnabled }
end

local function fallbackWebUrl(p) -- 1 equivalent call inferred from this helper
	return buildUrl("upgrades/robux", p)
end

local function resolveDestinationWithWebContext(p)
	if isExcludedRegion() then -- inferred equivalent call
		logBuyRobuxRoutingDecision("controlWeb", "excludedRegion")
		return webDestination(appendRoutingContext(buildUrl("upgrades/robux", p), nil), false) -- inferred equivalent call
	end

	if not (FFlagBypassBuyRobuxSduiSupportForWebRouting or isSduiBuyRobuxSupported()) then
		logBuyRobuxRoutingDecision("controlWeb", "sduiNotSupported")
		return webDestination(appendRoutingContext(buildUrl("upgrades/robux", p), nil), false) -- inferred equivalent call
	end

	if FFlagEnableBuyRobuxSdui then
		logBuyRobuxRoutingDecision("nativeSdui", "experimentArm")
		return { kind = "native", shouldExpose = FFlagBuyRobuxLatencyIxpEnabled }
	end

	if FFlagEnableBuyRobuxNextJS then
		logBuyRobuxRoutingDecision("nextJsWeb", "experimentArm")

		return webDestination( -- inferred equivalent call
			appendRoutingContext(buildUrl("upgrades/robux/v2", p), "nextjs"),
			FFlagBuyRobuxLatencyIxpEnabled
		)
	end

	logBuyRobuxRoutingDecision("controlWeb", "experimentArm")

	return webDestination( -- inferred equivalent call
		appendRoutingContext(buildUrl("upgrades/robux", p), "control"),
		FFlagBuyRobuxLatencyIxpEnabled
	)
end

local function resolveDestination(p)
	local url = fallbackWebUrl(p) -- inferred equivalent call

	if isExcludedRegion() then -- inferred equivalent call
		logBuyRobuxRoutingDecision("controlWeb", "excludedRegion")
		return webDestination(url, false) -- inferred equivalent call
	end

	if not (FFlagBypassBuyRobuxSduiSupportForWebRouting or isSduiBuyRobuxSupported()) then
		logBuyRobuxRoutingDecision("controlWeb", "sduiNotSupported")
		return webDestination(url, false) -- inferred equivalent call
	end

	if FFlagEnableBuyRobuxSdui then
		logBuyRobuxRoutingDecision("nativeSdui", "experimentArm")
		return { kind = "native", shouldExpose = FFlagBuyRobuxLatencyIxpEnabled }
	end

	if FFlagEnableBuyRobuxNextJS then
		logBuyRobuxRoutingDecision("nextJsWeb", "experimentArm")
		return webDestination(buildUrl("upgrades/robux/v2", p), FFlagBuyRobuxLatencyIxpEnabled) -- inferred equivalent call
	end

	logBuyRobuxRoutingDecision("controlWeb", "experimentArm")
	return webDestination(url, FFlagBuyRobuxLatencyIxpEnabled) -- inferred equivalent call
end

local function logExposure(p) -- 1 equivalent call inferred from this helper
	if p.shouldExpose and FStringPaymentsBuyRobuxLayer ~= "" then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringPaymentsBuyRobuxLayer)
	end
end

if not FFlagBuyRobuxRoutingAppendWebContext then
	resolveDestinationWithWebContext = resolveDestination
end

return {
	fallbackWebUrl = fallbackWebUrl,
	resolveDestination = resolveDestinationWithWebContext,
	logExposure = logExposure,
	resolveAndLogDestination = function(p)
		local v2

		if FFlagBuyRobuxRoutingAppendWebContext then
			v2 = resolveDestinationWithWebContext(p)
		else
			v2 = resolveDestination(p)
		end

		logExposure(v2) -- inferred equivalent call
		return v2
	end
}
