local default = require("@luauforge/bundled/hFI").default
local module = require("@luauforge/bundled/hFJ")
local timeToInteractiveTracker = require("@luauforge/bundled/hFK").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone

local fFlagLuaAppHomePagePLTDualLog = module.FFlagLuaAppHomePagePLTDualLog
local fIntHomePagePLTSampleRate = module.FIntHomePagePLTSampleRate

local v5 = false

local flag = false
local flag2 = false
local flag3 = false

local v6 = nil

return {
	beginVisit = function()
		local v7 = v5 and "warm" or "cold"
		v5 = true
		v6 = v7

		flag = false
		flag2 = false
		flag3 = false

		default:logEvent("home_page_load_begin", { launch_type = v7 })

		if fFlagLuaAppHomePagePLTDualLog then
			timeToInteractiveTracker.trackStart("HomePage_PLT")
			timeToInteractiveTracker.updateMetadata("HomePage_PLT", {
				coldStart = v7 == "cold",
				page = "Home"
			})
		end
	end,
	logRenderStarted = function()
		if flag then
			return
		end

		flag = true
		default:logEvent("home_page_render_started", { launch_type = v6 })

		if fFlagLuaAppHomePagePLTDualLog then
			timeToInteractiveTracker.trackMilestone("HomePage_PLT", milestone.RenderStarted)
		end
	end,
	logSurfaceMounted = function()
		if flag2 then
			return
		end

		flag2 = true
		default:logEvent("home_page_surface_mounted", { launch_type = v6 })

		if fFlagLuaAppHomePagePLTDualLog then
			timeToInteractiveTracker.trackMilestone("HomePage_PLT", milestone.SurfaceMounted)
		end
	end,
	logFunctionallyReadyAndEnd = function()
		if flag3 then
			return
		end

		flag3 = true
		default:logEvent("home_page_functionally_ready", { launch_type = v6 })
		default:logEvent("home_page_load_end", { launch_type = v6 })

		if fFlagLuaAppHomePagePLTDualLog then
			timeToInteractiveTracker.trackMilestone("HomePage_PLT", milestone.FunctionallyReady)
			timeToInteractiveTracker.trackEnd("HomePage_PLT", {
				samplingRateOverride = fIntHomePagePLTSampleRate
			})
		end
	end,
	isWarmVisit = function(): boolean
		return v6 == "warm"
	end
}
