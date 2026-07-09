local Parent = script:FindFirstAncestor("HomePageLoadTracker").Parent
local default = require(Parent.LoggingProtocol).default
local u3 = false
local u4 = false
local u5 = false
local u6 = false
local u7 = nil

return {
	beginVisit = function() -- line: 38
		-- upvalues: u3 (ref), u7 (ref), u4 (ref), u5 (ref), u6 (ref), default (copy)
		local v8 = not u3 and "cold" or "warm"

		u3 = true
		u7 = v8
		u4 = false
		u5 = false
		u6 = false
		default:logEvent("home_page_load_begin", {
			launch_type = v8
		})
	end,
	logRenderStarted = function() -- line: 64
		-- upvalues: u4 (ref), default (copy), u7 (ref)
		if u4 then
			return
		end

		u4 = true
		default:logEvent("home_page_render_started", {
			launch_type = u7
		})
	end,
	logSurfaceMounted = function() -- line: 77
		-- upvalues: u5 (ref), default (copy), u7 (ref)
		if u5 then
			return
		end

		u5 = true
		default:logEvent("home_page_surface_mounted", {
			launch_type = u7
		})
	end,
	logFunctionallyReadyAndEnd = function() -- line: 89
		-- upvalues: u6 (ref), default (copy), u7 (ref)
		if u6 then
			return
		end

		u6 = true
		default:logEvent("home_page_functionally_ready", {
			launch_type = u7
		})
		default:logEvent("home_page_load_end", {
			launch_type = u7
		})
	end,
	isWarmVisit = function() -- line: 102
		-- upvalues: u7 (ref)
		return u7 == "warm"
	end
}
