local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local t = require(CorePackages.Packages.t)
local Url = require(Modules.LuaApp.Http.Url)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local FFlagEnableDeeplinkResolutionEventReceiver = require(Modules.LuaApp.Flags.FFlagEnableDeeplinkResolutionEventReceiver)
local v14 = Url.APIS_URL .. "v1/resolve/"

game:DefineFastInt("DeferredDeeplinkResolvedThrottleHundredthsPercent", 10000)

local t1 = {
	eventName = "DeferredDeeplinkResolved",
	description = "Outcome of every resolve attempt by DeeplinkResolutionEventReceiver",
	backends = { default.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("DeferredDeeplinkResolvedThrottleHundredthsPercent"),
	lastUpdated = {
		26,
		5,
		18
	}
}

local function getPlatformHeader(p1) -- line: 32
	local Platform = p1:GetPlatform()

	if Platform == Enum.Platform.IOS then
		return "iOS"
	end

	if Platform == Enum.Platform.Android then
		return "Android"
	end

	return "Unknown"
end
local function resolveAndRoute(p2, p3) -- line: 46
	-- upvalues: HttpService (copy), UserInputService (copy), LinkingProtocol (copy), default (copy), IXPServiceWrapper (copy), AppBtidLayers (copy), t1 (copy), v14 (copy)
	local v23 = p3 or {}
	local v24 = v23.httpService or HttpService
	local v25 = v23.userInputService or UserInputService
	local v26 = v23.linkingProtocol or LinkingProtocol.default
	local v27 = v23.loggingProtocol or default
	local v28 = v23.ixpWrapper or IXPServiceWrapper
	local v29 = v23.nowMs or function() -- line: 53
		return DateTime.now().UnixTimestampMillis
	end
	local v30 = if type(p2) ~= "table" then nil else p2.attributionAdName

	if type(v30) ~= "string" or v30 == "" then
		return
	end

	local BTIDLayerData = v28:GetBTIDLayerData(AppBtidLayers.DeferredDeeplinkResolutionLayer)

	v28:LogBrowserTrackerLayerExposure(AppBtidLayers.DeferredDeeplinkResolutionLayer)

	if type(BTIDLayerData) ~= "table" or BTIDLayerData.IsResolutionEnabled ~= true then
		return
	end

	local Platform = v25:GetPlatform()
	local v33 = if Platform ~= Enum.Platform.IOS then Platform ~= Enum.Platform.Android and "Unknown" or "Android" else "iOS"
	local v34 = v29()

	local function emit(p4, p5) -- line: 76
		-- upvalues: v27 (copy), t1 (copy), v30 (copy), v29 (copy), v34 (copy), v33 (copy)
		v27:logRobloxTelemetryEvent(t1, {}, {
			attributionAdName = v30,
			status = p4,
			latencyMs = v29() - v34,
			resolvedUrl = p5 or "",
			platform = v33
		})
	end

	v24:RequestInternal({
		Method = "GET",
		Timeout = 5000,
		Url = v14 .. v24:UrlEncode(v30),
		Headers = {
			["X-Roblox-Platform"] = v33
		},
		CachePolicy = Enum.HttpCachePolicy.None
	}):Start(function(p6, p7) -- line: 96
		-- upvalues: emit (copy), v24 (copy), v26 (copy)
		if not p6 or not p7 then
			emit("NETWORK_ERROR")

			return
		end

		if p7.StatusCode == 404 then
			emit("NOT_FOUND")

			return
		end

		if p7.StatusCode ~= 200 then
			emit("HTTP_ERROR")

			return
		end

		local ok, result = pcall(function() -- line: 110
			-- upvalues: v24 (copy), p7 (copy)
			return v24:JSONDecode(p7.Body)
		end)

		if not ok then
			emit("PARSE_ERROR")

			return
		end

		if type(result) ~= "table" or type(result.url) ~= "string" or result.url == "" then
			emit("EMPTY_URL")

			return
		end

		v26:detectURL(result.url)
		emit("SUCCESS", result.url)
	end)
end

local v18 = Roact.PureComponent:extend("DeeplinkResolutionEventReceiver")

function v18.init(p8) -- line: 129
	-- upvalues: FFlagEnableDeeplinkResolutionEventReceiver (copy), MessageBus (copy), t (copy), resolveAndRoute (copy)
	if not FFlagEnableDeeplinkResolutionEventReceiver then
		return
	end

	p8.subscriber = MessageBus.Subscriber.new()
	p8.subscriber:subscribe({
		mid = MessageBus.getMessageId("Linking", "resolveAttributionAdName"),
		validateParams = t.table
	}, function(p9) -- line: 138
		-- upvalues: resolveAndRoute (copy)
		resolveAndRoute(p9)
	end)
end
function v18.render(_) -- line: 143
	return nil
end

v18._resolveAndRoute = resolveAndRoute

return v18
