local AppLaunchTracker = script:FindFirstAncestor("AppLaunchTracker")
local RoduxPerfTracker = require(AppLaunchTracker.RoduxPerfTracker)
local DiscoveryAppLaunchEvents = require(AppLaunchTracker.DiscoveryAppLaunchEvents)
require(AppLaunchTracker.AppLaunchTrackerTypes)

local Flags = require(AppLaunchTracker.Flags)
local v = Flags.FIntAppLaunchTrackerEnableHundredthsPercent >= math.random(10000)

local defineFastFlag = game:DefineFastFlag("LuaAppShouldTrackTopThunks", false)
local defineFastInt = game:DefineFastInt("LuaAppLaunchTrackerTimeoutSec", 60)
local defineFastString = game:DefineFastString(
	"LuaAppLaunchTrackerMilestones",
	"lua_app_starter_script_requires_begin,lua_app_starter_script_requires_end,startup_page_did_mount,fetch_homepage_data_begin,home_page_container_init,fetch_homepage_data_end,home_page_interactive_legacy,home_page_interactive"
)

local DiscoveryAppLaunchTracker = {}
DiscoveryAppLaunchTracker.__index = DiscoveryAppLaunchTracker

function DiscoveryAppLaunchTracker.isEnabled()
	return v
end

function DiscoveryAppLaunchTracker.disable()
	v = false
end

function DiscoveryAppLaunchTracker.new(loggingProtocol)
	local success, result = pcall(function()
		local v2 = defineFastString:gmatch("([A-Za-z0-9_]+)")
		local result = {}

		for k in v2 do
			result[k] = true
		end

		return result
	end)

	if not success then
		DiscoveryAppLaunchEvents.reportError(loggingProtocol, "Failed to parse FStringLuaAppLaunchTrackerMilestones")
	end

	local object = setmetatable({
		roduxTracker = RoduxPerfTracker.new(true, defineFastFlag, true),
		numTileRenders = 0,
		numTilesInit = 0,
		numFeedRenders = 0,
		numFeedItems = 0,
		totalSduiDuration = 0,
		previousMilestone = "",
		previousMilestoneTime = 0,
		loggingProtocol = loggingProtocol,
		supportedMilestones = not success and {} or result
	}, DiscoveryAppLaunchTracker)

	if defineFastInt > 0 then
		task.delay(defineFastInt, function()
			if v then
				DiscoveryAppLaunchEvents.reportError(
					loggingProtocol,
					`Timeout after previousMilestone: {object.previousMilestone}`
				)

				object.roduxTracker:stopTracking()
				DiscoveryAppLaunchTracker.disable()
			end
		end)
	end

	return object
end

function DiscoveryAppLaunchTracker:trackTileRender()
	self.numTileRenders += 1
end
function DiscoveryAppLaunchTracker:trackTileInit()
	self.numTilesInit += 1
end
function DiscoveryAppLaunchTracker:trackFeedRender()
	self.numFeedRenders += 1
end
function DiscoveryAppLaunchTracker:trackNumFeedItems(numFeedItems: number)
	self.numFeedItems = numFeedItems
end

function DiscoveryAppLaunchTracker:trackSduiDuration(p: number)
	self.totalSduiDuration += p
end

function DiscoveryAppLaunchTracker:onMilestoneChanged(previousMilestone: string)
	if not (v and self.supportedMilestones[previousMilestone]) then
		return
	end

	local now = os.clock()

	if self.previousMilestoneTime > 0 then
		local v2 = (now - self.previousMilestoneTime) * 1000
		local stats = self.roduxTracker:getStats()
		DiscoveryAppLaunchEvents.reportStatsforMilestone(
			self.loggingProtocol,
			previousMilestone,
			self.previousMilestone,
			v2,
			stats,
			self.numTilesInit,
			self.numTileRenders,
			self.numFeedItems,
			self.numFeedRenders,
			self.totalSduiDuration
		)
	end

	self.roduxTracker:clear()
	self.numFeedRenders = 0
	self.numTilesInit = 0
	self.numTileRenders = 0
	self.totalSduiDuration = 0

	self.previousMilestone = previousMilestone
	self.previousMilestoneTime = now
end

function DiscoveryAppLaunchTracker:stopTracking()
	self.roduxTracker:stopTracking()
	DiscoveryAppLaunchTracker.disable()
end

function DiscoveryAppLaunchTracker.createDefault(...)
	DiscoveryAppLaunchTracker.default = DiscoveryAppLaunchTracker.new(...)
end

return DiscoveryAppLaunchTracker
