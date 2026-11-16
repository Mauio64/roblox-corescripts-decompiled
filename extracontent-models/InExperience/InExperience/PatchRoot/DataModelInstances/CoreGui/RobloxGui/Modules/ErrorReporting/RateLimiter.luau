local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local t = require(CorePackages.Packages.t)

local strictInterface = t.strictInterface({
	period = t.number,
	threshold = t.number,
	processInterval = t.number
})

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.new(data)
	assert(strictInterface(data))

	return (setmetatable({
		_period = data.period,
		_threshold = data.threshold,
		_processInterval = data.processInterval,
		_lastProcessed = 0,
		_counts = {},
		_lastOccurrences = {}
	}, RateLimiter))
end

function RateLimiter:increment(p, p2)
	local v = p2 or os.clock()
	self._lastOccurrences[p] = v

	if self._counts[p] == nil then
		self._counts[p] = 1
		return
	end

	self._counts[p] += 1
end

function RateLimiter:isRateLimited(p): boolean
	local count = self._counts[p]
	return count ~= nil and self._threshold < count
end

function RateLimiter:startDecrementClock()
	self._decrementConnection = RunService.Heartbeat:Connect(function()
		self:stepDecrementClock(os.clock())
	end)
end

function RateLimiter:stepDecrementClock(lastProcessed)
	if lastProcessed - self._lastProcessed > self._processInterval then
		for k, lastOccurrence in pairs(self._lastOccurrences) do
			if not (lastProcessed - lastOccurrence > self._period) then
				continue
			end

			self._counts[k] -= 1

			if not (self._counts[k] <= 0) then
				continue
			end

			self._counts[k] = nil
			self._lastOccurrences[k] = nil
		end

		self._lastProcessed = lastProcessed
	end
end

return RateLimiter
