local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 = require(Modules.LuaApp.Flags.FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2)
local t1 = {}

t1.__index = t1

function t1.new(s1: string, n1: number) -- line: 27
	-- upvalues: t1 (copy)
	local t2 = {
		did_mount_time = nil,
		render_time = nil,
		webview_load_time = nil,
		get_robux_balance_start = nil,
		get_robux_balance_response = nil,
		api_latency_ms = nil,
		init_to_mount_latency_ms = nil,
		mount_to_render_latency_ms = nil,
		buyrobux_latency_metrics_session_id = s1,
		init_time = n1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.setMountTime(t3: {[any]: any}, n2: number) -- line: 46
	t3.did_mount_time = n2

	if t3.init_time then
		t3.init_to_mount_latency_ms = (n2 - t3.init_time) * 1000
	end
end
function t1.setRenderTime(t4: {[any]: any}, n3: number) -- line: 53
	t4.render_time = n3

	if t4.did_mount_time then
		t4.mount_to_render_latency_ms = (n3 - t4.did_mount_time) * 1000
	end
end
function t1.setApiTiming(t5: {[any]: any}, n4: number, n5: number) -- line: 60
	t5.get_robux_balance_start = n4
	t5.get_robux_balance_response = n5
	t5.api_latency_ms = (n5 - n4) * 1000
end
function t1.setWebViewLoadTime(t6: {[any]: any}, n6: number) -- line: 66
	t6.webview_load_time = n6
end

local t7 = {}

t7.__index = t7

local v7 = game:DefineFastInt("NativePurchaseRobuxPageWrapperEventThrottlingPercentage", 100)
local v8 = game:DefineFastInt("NativePurchaseRobuxPageWrapperStatThrottlingPercentage", 1000)

t7.EventName = if not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 then {
	Init = "NativePurchaseRobuxPageWrapper:Init",
	Mount = "NativePurchaseRobuxPageWrapper:Mount",
	ApiCall = "NativePurchaseRobuxPageWrapper:ApiCall",
	ApiResponse = "NativePurchaseRobuxPageWrapper:ApiResponse",
	Render = "NativePurchaseRobuxPageWrapper:Render",
	WebViewLoad = "NativePurchaseRobuxPageWrapper:WebViewLoad"
} else {
	Init = "NativePurchaseRobuxPageWrapper_Init",
	Mount = "NativePurchaseRobuxPageWrapper_Mount",
	ApiCall = "NativePurchaseRobuxPageWrapper_ApiCall",
	ApiResponse = "NativePurchaseRobuxPageWrapper_ApiResponse",
	Render = "NativePurchaseRobuxPageWrapper_Render",
	WebViewLoad = "NativePurchaseRobuxPageWrapper_WebViewLoad"
}
t7.TelemetryStat = {
	InitToMountLatency = {
		description = "Stat for tracking initialization to mount latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = "",
		eventName = not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and "NativePurchaseRobuxPageWrapper:InitToMountLatency" or "NativePurchaseRobuxPageWrapper_InitToMountLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			8,
			13
		},
		throttlingPercentage = v8
	},
	ApiLatency = {
		description = "Stat for tracking API response latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = "",
		eventName = not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and "NativePurchaseRobuxPageWrapper:ApiLatency" or "NativePurchaseRobuxPageWrapper_ApiLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			8,
			13
		},
		throttlingPercentage = v8
	},
	InitToRenderLatency = {
		description = "Stat for tracking initialization to render latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = "",
		eventName = not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and "NativePurchaseRobuxPageWrapper:InitToRenderLatency" or "NativePurchaseRobuxPageWrapper_InitToRenderLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			8,
			13
		},
		throttlingPercentage = v8
	},
	MountToRenderLatency = {
		description = "Stat for tracking mount to render latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = "",
		eventName = not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and "NativePurchaseRobuxPageWrapper:MountToRenderLatency" or "NativePurchaseRobuxPageWrapper_MountToRenderLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			8,
			13
		},
		throttlingPercentage = v8
	},
	RenderToWebViewLatency = {
		description = "Stat for tracking render to WebView load latency in NativePurchaseRobuxPageWrapper to detect performance issues",
		links = "",
		eventName = not FFlagNativePurchaseRobuxPageWrapperEnableTelemetryV2 and "NativePurchaseRobuxPageWrapper:RenderToWebViewLatency" or "NativePurchaseRobuxPageWrapper_RenderToWebViewLatency",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			8,
			13
		},
		throttlingPercentage = v8
	}
}

function t7.sendWebViewMetrics(t8: {[any]: any}, s2: string, t9: {[any]: any}, t10: {[any]: any}) -- line: 155
	-- upvalues: LoggingProtocol (copy), v7 (copy)
	local t11 = {
		eventName = "BuyRobuxWebViewMetrics",
		description = "Event sent to track BuyRobux WebView latency metrics and lifecycle events",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = v7,
		lastUpdated = {
			2025,
			8,
			13
		}
	}
	local t12 = {
		triggering_context = "NativePurchaseRobuxPage",
		component_name = "NativePurchaseRobuxPageWrapper",
		target = "client",
		buyrobux_latency_metrics_session_id = t9.buyrobux_latency_metrics_session_id,
		lifecycle_event_type = s2,
		local_timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
	}

	for k, v in pairs(t10) do
		t12[k] = v
	end

	t8.telemetryService:LogEvent(t11, {
		customFields = t12
	})
end
function t7.onInit(t13: {[any]: any}, t14: {[any]: any}) -- line: 187
	-- upvalues: t7 (copy)
	t13:sendWebViewMetrics(t7.EventName.Init, t14, {
		init_time = tostring(t14.init_time)
	})
end
function t7.onMount(t15: {[any]: any}, t16: {[any]: any}) -- line: 193
	-- upvalues: t7 (copy), LoggingProtocol (copy)
	if not t16.did_mount_time then
		return
	end

	local v33 = t16.did_mount_time - t16.init_time

	t15:sendWebViewMetrics(t7.EventName.Mount, t16, {
		init_time = tostring(t16.init_time),
		did_mount_time = tostring(t16.did_mount_time),
		init_to_mount_latency_ms = tostring(v33 * 1000)
	})
	LoggingProtocol.default:logRobloxTelemetryStat(t7.TelemetryStat.InitToMountLatency, v33 * 1000, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client"
	})
end
function t7.onApiCall(t17: {[any]: any}, t18: {[any]: any}, s3: string) -- line: 216
	-- upvalues: t7 (copy)
	if not t18.get_robux_balance_start then
		return
	end

	t17:sendWebViewMetrics(t7.EventName.ApiCall, t18, {
		get_robux_balance_start = tostring(t18.get_robux_balance_start),
		api_call_type = s3
	})
end
function t7.onApiResponse(t19: {[any]: any}, t20: {[any]: any}, s4: string, s5: string) -- line: 227
	-- upvalues: t7 (copy), LoggingProtocol (copy)
	if not t20.get_robux_balance_start or (not t20.get_robux_balance_response or not t20.api_latency_ms) then
		return
	end

	t19:sendWebViewMetrics(t7.EventName.ApiResponse, t20, {
		get_robux_balance_start = tostring(t20.get_robux_balance_start),
		get_robux_balance_response = tostring(t20.get_robux_balance_response),
		api_latency_ms = tostring(t20.api_latency_ms),
		api_call_type = s4,
		robux_balance = s5
	})
	LoggingProtocol.default:logRobloxTelemetryStat(t7.TelemetryStat.ApiLatency, t20.api_latency_ms, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client",
		api_call_type = s4
	})
end
function t7.onRender(t21: {[any]: any}, t22: {[any]: any}) -- line: 259
	-- upvalues: t7 (copy), LoggingProtocol (copy)
	if not t22.render_time then
		return
	end

	local render_time = t22.render_time
	local v44 = render_time - t22.init_time
	local n7 = 0
	local t23 = {
		init_time = tostring(t22.init_time),
		render_time = tostring(render_time),
		init_to_render_latency_ms = tostring(v44 * 1000)
	}

	if t22.did_mount_time then
		local v47 = t22.did_mount_time - t22.init_time

		n7 = render_time - t22.did_mount_time
		t23.did_mount_time = tostring(t22.did_mount_time)
		t23.init_to_mount_latency_ms = tostring(v47 * 1000)
		t23.mount_to_render_latency_ms = tostring(n7 * 1000)
	end

	t21:sendWebViewMetrics(t7.EventName.Render, t22, t23)
	LoggingProtocol.default:logRobloxTelemetryStat(t7.TelemetryStat.InitToRenderLatency, v44 * 1000, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client"
	})

	if t22.did_mount_time then
		LoggingProtocol.default:logRobloxTelemetryStat(t7.TelemetryStat.MountToRenderLatency, n7 * 1000, {
			component = "NativePurchaseRobuxPageWrapper",
			target = "client"
		})
	end
end
function t7.onWebViewLoad(t24: {[any]: any}, t25: {[any]: any}, n8: number) -- line: 306
	-- upvalues: t7 (copy), LoggingProtocol (copy)
	if not t25.webview_load_time then
		return
	end

	local webview_load_time = t25.webview_load_time
	local v52 = webview_load_time - n8

	t24:sendWebViewMetrics(t7.EventName.WebViewLoad, t25, {
		render_time = tostring(n8),
		webview_load_time = tostring(webview_load_time),
		render_to_webview_latency_ms = tostring(v52 * 1000)
	})
	LoggingProtocol.default:logRobloxTelemetryStat(t7.TelemetryStat.RenderToWebViewLatency, v52 * 1000, {
		component = "NativePurchaseRobuxPageWrapper",
		target = "client"
	})
end
function t7.new(p1) -- line: 330
	-- upvalues: t7 (copy)
	local t26 = {
		telemetryService = p1
	}

	setmetatable(t26, t7)

	return t26
end

return {
	NativePurchaseRobuxPageWrapperAnalytics = t7,
	TimingData = t1
}
