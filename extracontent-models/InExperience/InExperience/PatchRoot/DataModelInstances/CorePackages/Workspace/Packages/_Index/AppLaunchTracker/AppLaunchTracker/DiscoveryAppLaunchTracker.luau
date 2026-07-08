local AppLaunchTracker = script:FindFirstAncestor("AppLaunchTracker")
local RoduxPerfTracker = require(AppLaunchTracker.RoduxPerfTracker)
local DiscoveryAppLaunchEvents = require(AppLaunchTracker.DiscoveryAppLaunchEvents)

require(AppLaunchTracker.AppLaunchTrackerTypes)

local u4 = require(AppLaunchTracker.Flags).FIntAppLaunchTrackerEnableHundredthsPercent >= math.random(10000)
local v5 = game:DefineFastFlag("LuaAppShouldTrackTopThunks", false)
local v6 = game:DefineFastInt("LuaAppLaunchTrackerTimeoutSec", 60)
local v7 = game:DefineFastString("LuaAppLaunchTrackerMilestones", "lua_app_starter_script_requires_begin,lua_app_starter_script_requires_end,startup_page_did_mount,fetch_homepage_data_begin,home_page_container_init,fetch_homepage_data_end,home_page_interactive_legacy,home_page_interactive")
local t1 = {}

t1.__index = t1

function t1.isEnabled() -- line: 45
	-- upvalues: u4 (ref)
	return u4
end
function t1.disable() -- line: 49
	-- upvalues: u4 (ref)
	u4 = false
end
function t1.new(p1) -- line: 53
	-- upvalues: v7 (copy), DiscoveryAppLaunchEvents (copy), RoduxPerfTracker (copy), v5 (copy), t1 (copy), v6 (copy), u4 (ref)
	local ok, result = pcall(function() -- line: 54
		-- upvalues: v7 (copy)
		local t2 = {}

		for match in v7:gmatch("([A-Za-z0-9_]+)") do
			t2[match] = true
		end

		return t2
	end)

	if not ok then
		DiscoveryAppLaunchEvents.reportError(p1, "Failed to parse FStringLuaAppLaunchTrackerMilestones")
	end

	local v12 = setmetatable({
		numTileRenders = 0,
		numTilesInit = 0,
		numFeedRenders = 0,
		numFeedItems = 0,
		totalSduiDuration = 0,
		previousMilestone = "",
		previousMilestoneTime = 0,
		roduxTracker = RoduxPerfTracker.new(true, v5, true),
		loggingProtocol = p1,
		supportedMilestones = if not ok then {} else result
	}, t1)

	if v6 > 0 then
		task.delay(v6, function() -- line: 82
			-- upvalues: u4 (ref), DiscoveryAppLaunchEvents (copy), p1 (copy), v12 (copy), t1 (copy)
			if u4 then
				DiscoveryAppLaunchEvents.reportError(p1, `Timeout after previousMilestone: { v12.previousMilestone }`)
				v12.roduxTracker:stopTracking()
				t1.disable()
			end
		end)
	end

	return v12
end
function t1.trackTileRender(p2) -- line: 97
	p2.numTileRenders = p2.numTileRenders + 1
end
function t1.trackTileInit(p3) -- line: 100
	p3.numTilesInit = p3.numTilesInit + 1
end
function t1.trackFeedRender(p4) -- line: 103
	p4.numFeedRenders = p4.numFeedRenders + 1
end
function t1.trackNumFeedItems(p5, n1: number) -- line: 106
	p5.numFeedItems = n1
end
function t1.trackSduiDuration(p6, n2: number) -- line: 110
	p6.totalSduiDuration = p6.totalSduiDuration + n2
end
function t1.onMilestoneChanged(p7, s1: string) -- line: 114
	-- upvalues: u4 (ref), DiscoveryAppLaunchEvents (copy)
	if not u4 then
		return
	end

	if not p7.supportedMilestones[s1] then
		return
	end

	local elapsed = os.clock()

	if p7.previousMilestoneTime > 0 then
		local v23 = (elapsed - p7.previousMilestoneTime) * 1000
		local v24 = p7.roduxTracker:getStats()

		DiscoveryAppLaunchEvents.reportStatsforMilestone(p7.loggingProtocol, s1, p7.previousMilestone, v23, v24, p7.numTilesInit, p7.numTileRenders, p7.numFeedItems, p7.numFeedRenders, p7.totalSduiDuration)
	end

	p7.roduxTracker:clear()
	p7.numFeedRenders = 0
	p7.numTilesInit = 0
	p7.numTileRenders = 0
	p7.totalSduiDuration = 0
	p7.previousMilestone = s1
	p7.previousMilestoneTime = elapsed
end
function t1.stopTracking(p8) -- line: 152
	-- upvalues: t1 (copy)
	p8.roduxTracker:stopTracking()
	t1.disable()
end
function t1.createDefault(...) -- line: 157
	-- upvalues: t1 (copy)
	t1.default = t1.new(...)
end

return t1
