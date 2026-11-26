local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local module2 = require("@luauforge/deferred/gIq")

local class = {}
class.__index = class

function class.new(p2, p3)
	local v5 = {
		buyrobux_latency_metrics_session_id = p2,
		init_time = p3,
		did_mount_time = nil,
		render_time = nil,
		webview_load_time = nil,
		get_robux_balance_start = nil,
		get_robux_balance_response = nil,
		api_latency_ms = nil,
		init_to_mount_latency_ms = nil,
		mount_to_render_latency_ms = nil
	}

	setmetatable(v5, class)
	return v5
end

function class:setMountTime(did_mount_time)
	self.did_mount_time = did_mount_time

	if self.init_time then
		self.init_to_mount_latency_ms = (did_mount_time - self.init_time) * 1000
	end
end

function class:setRenderTime(render_time)
	self.render_time = render_time

	if self.did_mount_time then
		self.mount_to_render_latency_ms = (render_time - self.did_mount_time) * 1000
	end
end

function class:setApiTiming(get_robux_balance_start, get_robux_balance_response)
	self.get_robux_balance_start = get_robux_balance_start
	self.get_robux_balance_response = get_robux_balance_response
	self.api_latency_ms = (get_robux_balance_response - get_robux_balance_start) * 1000
end

function class:setWebViewLoadTime(webview_load_time)
	self.webview_load_time = webview_load_time
end

local class2 = {}
class2.__index = class2

local defineFastInt = game:DefineFastInt("NativePurchaseRobuxPageWrapperEventThrottlingPercentage", 100)

local defineFastInt2 = game:DefineFastInt("NativePurchaseRobuxPageWrapperStatThrottlingPercentage", 1000)

class2.EventName = module2 and {
	Init = "NativePurchaseRobuxPageWrapper_Init",
	Mount = "NativePurchaseRobuxPageWrapper_Mount",
	ApiCall = "NativePurchaseRobuxPageWrapper_ApiCall",
	ApiResponse = "NativePurchaseRobuxPageWrapper_ApiResponse",
	Render = "NativePurchaseRobuxPageWrapper_Render",
	WebViewLoad = "NativePurchaseRobuxPageWrapper_WebViewLoad"
} or {
	Init = "NativePurchaseRobuxPageWrapper:Init",
	Mount = "NativePurchaseRobuxPageWrapper:Mount",
	ApiCall = "NativePurchaseRobuxPageWrapper:ApiCall",
	ApiResponse = "NativePurchaseRobuxPageWrapper:ApiResponse",
	Render = "NativePurchaseRobuxPageWrapper:Render",
	WebViewLoad = "NativePurchaseRobuxPageWrapper:WebViewLoad"
}

class2.TelemetryStat = {
	InitToMountLatency = {
		eventName = module2 and "NativePurchaseRobuxPageWrapper_InitToMountLatency" or "NativePurchaseRobuxPageWrapper:InitToMountLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2025, 8, 13 },
		throttlingPercentage = defineFastInt2,
		description = "Stat for tracking initialization to mount latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = ""
	},
	ApiLatency = {
		eventName = module2 and "NativePurchaseRobuxPageWrapper_ApiLatency" or "NativePurchaseRobuxPageWrapper:ApiLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2025, 8, 13 },
		throttlingPercentage = defineFastInt2,
		description = "Stat for tracking API response latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = ""
	},
	InitToRenderLatency = {
		eventName = module2 and "NativePurchaseRobuxPageWrapper_InitToRenderLatency" or "NativePurchaseRobuxPageWrapper:InitToRenderLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2025, 8, 13 },
		throttlingPercentage = defineFastInt2,
		description = "Stat for tracking initialization to render latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = ""
	},
	MountToRenderLatency = {
		eventName = module2 and "NativePurchaseRobuxPageWrapper_MountToRenderLatency" or "NativePurchaseRobuxPageWrapper:MountToRenderLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2025, 8, 13 },
		throttlingPercentage = defineFastInt2,
		description = "Stat for tracking mount to render latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = ""
	},
	RenderToWebViewLatency = {
		eventName = module2 and "NativePurchaseRobuxPageWrapper_RenderToWebViewLatency" or "NativePurchaseRobuxPageWrapper:RenderToWebViewLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2025, 8, 13 },
		throttlingPercentage = defineFastInt2,
		description = "Stat for tracking render to WebView load latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = ""
	}
}

function class2:sendWebViewMetrics(p3, p4, items)
	local v5 = {
		eventName = "BuyRobuxWebViewMetrics",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 8, 13 },
		description = "Event sent to track BuyRobux WebView latency metrics and lifecycle events",
		links = ""
	}

	local v6 = {
		buyrobux_latency_metrics_session_id = p4.buyrobux_latency_metrics_session_id,
		triggering_context = "NativePurchaseRobuxPage",
		lifecycle_event_type = p3,
		component_name = "NativePurchaseRobuxPageWrapper",
		target = "client",
		local_timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
	}

	for k, item in pairs(items) do
		v6[k] = item
	end

	self.telemetryService:LogEvent(v5, { customFields = v6 })
end

function class2:onInit(p2)
	self:sendWebViewMetrics(class2.EventName.Init, p2, {
		init_time = tostring(p2.init_time)
	})
end

function class2:onMount(p2)
	if not p2.did_mount_time then
		return
	end

	local v5 = p2.did_mount_time - p2.init_time

	self:sendWebViewMetrics(class2.EventName.Mount, p2, {
		init_time = tostring(p2.init_time),
		did_mount_time = tostring(p2.did_mount_time),
		init_to_mount_latency_ms = tostring(v5 * 1000)
	})

	LoggingProtocol.default:logRobloxTelemetryStat(class2.TelemetryStat.InitToMountLatency, v5 * 1000, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client"
	})
end

function class2:onApiCall(p2, p3)
	if not p2.get_robux_balance_start then
		return
	end

	self:sendWebViewMetrics(class2.EventName.ApiCall, p2, {
		get_robux_balance_start = tostring(p2.get_robux_balance_start),
		api_call_type = p3
	})
end

function class2:onApiResponse(data, p2, p3)
	if data.get_robux_balance_start and data.get_robux_balance_response and data.api_latency_ms then
		self:sendWebViewMetrics(class2.EventName.ApiResponse, data, {
			get_robux_balance_start = tostring(data.get_robux_balance_start),
			get_robux_balance_response = tostring(data.get_robux_balance_response),
			api_latency_ms = tostring(data.api_latency_ms),
			api_call_type = p2,
			robux_balance = p3
		})

		LoggingProtocol.default:logRobloxTelemetryStat(class2.TelemetryStat.ApiLatency, data.api_latency_ms, {
			component = "NativePurchaseRobuxPageWrapper",
			target = "client",
			api_call_type = p2
		})
	end
end

function class2:onRender(data)
	if not data.render_time then
		return
	end

	local render_time = data.render_time
	local v5 = render_time - data.init_time

	local v6 = {
		init_time = tostring(data.init_time),
		render_time = tostring(render_time),
		init_to_render_latency_ms = tostring(v5 * 1000)
	}
	local v7

	if data.did_mount_time then
		local v8 = data.did_mount_time - data.init_time
		v7 = render_time - data.did_mount_time
		v6.did_mount_time = tostring(data.did_mount_time)
		v6.init_to_mount_latency_ms = tostring(v8 * 1000)
		v6.mount_to_render_latency_ms = tostring(v7 * 1000)
	else
		v7 = 0
	end

	self:sendWebViewMetrics(class2.EventName.Render, data, v6)

	LoggingProtocol.default:logRobloxTelemetryStat(class2.TelemetryStat.InitToRenderLatency, v5 * 1000, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client"
	})

	if data.did_mount_time then
		LoggingProtocol.default:logRobloxTelemetryStat(class2.TelemetryStat.MountToRenderLatency, v7 * 1000, {
			component = "NativePurchaseRobuxPageWrapper",
			target = "client"
		})
	end
end

function class2:onWebViewLoad(p2, p3)
	if not p2.webview_load_time then
		return
	end

	local webview_load_time = p2.webview_load_time
	local v5 = webview_load_time - p3

	self:sendWebViewMetrics(class2.EventName.WebViewLoad, p2, {
		render_time = tostring(p3),
		webview_load_time = tostring(webview_load_time),
		render_to_webview_latency_ms = tostring(v5 * 1000)
	})

	LoggingProtocol.default:logRobloxTelemetryStat(class2.TelemetryStat.RenderToWebViewLatency, v5 * 1000, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client"
	})
end

function class2.new(p2)
	local v5 = { telemetryService = p2 }

	setmetatable(v5, class2)

	return v5
end

return { NativePurchaseRobuxPageWrapperAnalytics = class2, TimingData = class }
