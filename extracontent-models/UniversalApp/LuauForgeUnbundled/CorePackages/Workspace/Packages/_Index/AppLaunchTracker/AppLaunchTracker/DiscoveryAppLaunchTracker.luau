local RoduxPerfTracker = require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/AppLaunchTracker/RoduxPerfTracker")
local DiscoveryAppLaunchEvents = require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/AppLaunchTracker/DiscoveryAppLaunchEvents")
require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/AppLaunchTracker/AppLaunchTrackerTypes")

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/AppLaunchTracker/Flags").FIntAppLaunchTrackerEnableHundredthsPercent >= math.random(10000)

local defineFastFlag = game:DefineFastFlag("LuaAppShouldTrackTopThunks", false)
local defineFastInt = game:DefineFastInt("LuaAppLaunchTrackerTimeoutSec", 60)
local defineFastString = game:DefineFastString(
	"LuaAppLaunchTrackerMilestones",
	"lua_app_starter_script_requires_begin,lua_app_starter_script_requires_end,startup_page_did_mount,fetch_homepage_data_begin,home_page_container_init,fetch_homepage_data_end,home_page_interactive_legacy,home_page_interactive"
)

local class = {}
class.__index = class

function class.isEnabled()
	return v5
end

function class.disable()
	v5 = false
end

function class.new(p2)
	local success, result = pcall(function()
		local v6 = defineFastString:gmatch("([A-Za-z0-9_]+)")
		local result2 = {}

		for k in v6 do
			result2[k] = true
		end

		return result2
	end)

	if not success then
		DiscoveryAppLaunchEvents.reportError(p2, "Failed to parse FStringLuaAppLaunchTrackerMilestones")
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
		loggingProtocol = p2,
		supportedMilestones = not success and {} or result
	}, class)

	if defineFastInt > 0 then
		task.delay(defineFastInt, function()
			if v5 then
				DiscoveryAppLaunchEvents.reportError(p2, `Timeout after previousMilestone: {object.previousMilestone}`)

				object.roduxTracker:stopTracking()
				class.disable()
			end
		end)
	end

	return object
end

function class:trackTileRender()
	self.numTileRenders += 1
end
function class:trackTileInit()
	self.numTilesInit += 1
end
function class:trackFeedRender()
	self.numFeedRenders += 1
end
function class:trackNumFeedItems(numFeedItems)
	self.numFeedItems = numFeedItems
end

function class:trackSduiDuration(p3)
	self.totalSduiDuration += p3
end

function class:onMilestoneChanged(previousMilestone)
	if not (v5 and self.supportedMilestones[previousMilestone]) then
		return
	end

	local now = os.clock()

	if self.previousMilestoneTime > 0 then
		local v6 = (now - self.previousMilestoneTime) * 1000
		local stats = self.roduxTracker:getStats()
		DiscoveryAppLaunchEvents.reportStatsforMilestone(
			self.loggingProtocol,
			previousMilestone,
			self.previousMilestone,
			v6,
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

function class:stopTracking()
	self.roduxTracker:stopTracking()
	class.disable()
end

function class.createDefault(...)
	class.default = class.new(...)
end

return class
