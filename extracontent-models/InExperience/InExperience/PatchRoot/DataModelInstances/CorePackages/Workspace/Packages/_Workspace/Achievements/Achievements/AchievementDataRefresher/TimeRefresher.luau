local Achievements = script:FindFirstAncestor("Achievements")
local parent = Achievements.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local Logger = require(Achievements.Logger)
require(parent.Signal)

local TimeRefresher = {}

function TimeRefresher:init(fireDataChanged, intervalInSec: number)
	self.fireDataChanged = fireDataChanged
	self.intervalInSec = intervalInSec
end

function TimeRefresher:start()
	self.timerId = setInterval(self.check, self.intervalInSec * 1000, self)
	self.startTime = os.time()
end

function TimeRefresher.check(p)
	if not p.startTime then
		Logger:error("No recorded start time")

		return
	end

	local v = os.time() - p.startTime
	p.fireDataChanged(v)
end

function TimeRefresher:stop()
	if self.timerId then
		clearInterval(self.timerId)
		self.startTime = nil
	end
end

return TimeRefresher
