local parent = script:FindFirstAncestor("HomePageLoadTracker").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local SharedFlags = require(parent.SharedFlags)
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local Milestone = timeToInteractiveTracker.Milestone

local FFlagLuaAppHomePagePLTDualLog = SharedFlags.FFlagLuaAppHomePagePLTDualLog
local FIntHomePagePLTSampleRate = SharedFlags.FIntHomePagePLTSampleRate

local v = false

local flag = false
local flag2 = false
local flag3 = false

local launch_type = nil
local HomePageLoadTracker = {}

function HomePageLoadTracker.beginVisit()
	local launch_type2 = v and "warm" or "cold"
	v = true
	launch_type = launch_type2

	flag = false
	flag2 = false
	flag3 = false

	default:logEvent("home_page_load_begin", { launch_type = launch_type2 })

	if FFlagLuaAppHomePagePLTDualLog then
		timeToInteractiveTracker.trackStart("HomePage_PLT")
		timeToInteractiveTracker.updateMetadata("HomePage_PLT", {
			coldStart = launch_type2 == "cold",
			page = "Home"
		})
	end
end

function HomePageLoadTracker.logRenderStarted()
	if flag then
		return
	end

	flag = true
	default:logEvent("home_page_render_started", { launch_type = launch_type })

	if FFlagLuaAppHomePagePLTDualLog then
		timeToInteractiveTracker.trackMilestone("HomePage_PLT", Milestone.RenderStarted)
	end
end

function HomePageLoadTracker.logSurfaceMounted()
	if flag2 then
		return
	end

	flag2 = true
	default:logEvent("home_page_surface_mounted", { launch_type = launch_type })

	if FFlagLuaAppHomePagePLTDualLog then
		timeToInteractiveTracker.trackMilestone("HomePage_PLT", Milestone.SurfaceMounted)
	end
end

function HomePageLoadTracker.logFunctionallyReadyAndEnd()
	if flag3 then
		return
	end

	flag3 = true
	default:logEvent("home_page_functionally_ready", { launch_type = launch_type })
	default:logEvent("home_page_load_end", { launch_type = launch_type })

	if FFlagLuaAppHomePagePLTDualLog then
		timeToInteractiveTracker.trackMilestone("HomePage_PLT", Milestone.FunctionallyReady)
		timeToInteractiveTracker.trackEnd("HomePage_PLT", {
			samplingRateOverride = FIntHomePagePLTSampleRate
		})
	end
end

function HomePageLoadTracker.isWarmVisit(): boolean
	return launch_type == "warm"
end

return HomePageLoadTracker
