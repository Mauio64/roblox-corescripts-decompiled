local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local messageBus = require("@luauforge/bundled/ggr").MessageBus
local linkingProtocol = require("@luauforge/bundled/bZe").LinkingProtocol
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/dVn")

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local v5 = module.APIS_URL .. "v1/resolve/"

game:DefineFastInt("DeferredDeeplinkResolvedThrottleHundredthsPercent", 10000)
local v6 = {
	eventName = "DeferredDeeplinkResolved",
	backends = { default.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("DeferredDeeplinkResolvedThrottleHundredthsPercent"),
	lastUpdated = { 26, 5, 18 },
	description = "Outcome of every resolve attempt by DeeplinkResolutionEventReceiver"
}

local function getPlatformHeader(object): string
	local platform = object:GetPlatform()

	if platform == Enum.Platform.IOS then
		return "iOS"
	end

	if platform == Enum.Platform.Android then
		return "Android"
	end

	return "Unknown"
end

local function resolveAndRoute(p2, options)
	local v7 = options or {}
	local httpService = v7.httpService or HttpService
	local userInputService = v7.userInputService or UserInputService
	local linkingProtocol2 = v7.linkingProtocol or linkingProtocol.default
	local loggingProtocol = v7.loggingProtocol or default
	local nowMs = v7.nowMs or function()
		return DateTime.now().UnixTimestampMillis
	end

	local attributionAdName = if type(p2) == "table" then p2.attributionAdName else nil

	if type(attributionAdName) ~= "string" or attributionAdName == "" then
		return
	end

	local platform = userInputService:GetPlatform()
	local v8 = platform == Enum.Platform.IOS and "iOS"
		or platform == Enum.Platform.Android and "Android"
		or "Unknown"

	local v9 = nowMs()

	local function emit(p3, value)
		loggingProtocol:logRobloxTelemetryEvent(v6, {}, {
			attributionAdName = attributionAdName,
			status = p3,
			latencyMs = nowMs() - v9,
			resolvedUrl = value or "",
			platform = v8
		})
	end

	httpService:RequestInternal({
		Url = v5 .. httpService:UrlEncode(attributionAdName),
		Method = "GET",
		Headers = { ["X-Roblox-Platform"] = v8 },
		Timeout = 5000,
		CachePolicy = Enum.HttpCachePolicy.None
	}):Start(function(p3, p4)
		if not (p3 and p4) then
			emit("NETWORK_ERROR")
			return
		end

		if p4.StatusCode == 404 then
			emit("NOT_FOUND")
			return
		end

		if p4.StatusCode ~= 200 then
			emit("HTTP_ERROR")
			return
		end

		local success, result = pcall(function()
			return httpService:JSONDecode(p4.Body)
		end)

		if not success then
			emit("PARSE_ERROR")
			return
		end

		if type(result) ~= "table" or type(result.url) ~= "string" or result.url == "" then
			emit("EMPTY_URL")
			return
		end

		linkingProtocol2:detectURL(result.url)
		emit("SUCCESS", result.url)
	end)
end

local extended = Roact.PureComponent:extend("DeeplinkResolutionEventReceiver")

function extended:init()
	self.subscriber = messageBus.Subscriber.new()
	self.subscriber:subscribe(
		{
			mid = messageBus.getMessageId("Linking", "resolveAttributionAdName"),
			validateParams = t.table
		},
		function(p3)
			resolveAndRoute(p3)
		end
	)
end

function extended.render(p2): nil
	return nil
end

extended._resolveAndRoute = resolveAndRoute

return extended
