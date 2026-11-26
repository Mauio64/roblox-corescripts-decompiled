local class = {}
class.__index = class

function class.new(data)
	local object = setmetatable({}, class)

	object.maxTokens = data.maxTokens
	object.refillRate = data.refillRate
	object.refillIntervalSeconds = data.refillIntervalSeconds
	object.currentTokens = data.initialTokens or data.maxTokens
	object.lastRefillTime = tick()

	if object.currentTokens > object.maxTokens then
		object.currentTokens = object.maxTokens
	end

	return object
end

function class:refill()
	local now = tick()
	local v5 = now - self.lastRefillTime

	if v5 < 0 then
		self.lastRefillTime = now
		return
	end

	local v6 = math.floor(v5 / self.refillIntervalSeconds)

	if v6 > 0 then
		local v7 = v6 * self.refillRate

		self.currentTokens = math.min(self.maxTokens, self.currentTokens + v7)

		self.lastRefillTime += v6 * self.refillIntervalSeconds
	end
end

function class:consume(value): boolean
	local v5 = value or 1

	self:refill()

	if v5 <= self.currentTokens then
		self.currentTokens -= v5
		return true
	end

	return false
end

function class:getAvailableTokens()
	self:refill()
	return self.currentTokens
end

function class.getMaxTokens(p2)
	return p2.maxTokens
end

function class:hasTokensAvailable(): boolean
	return self:getAvailableTokens() > 0
end

function class:reset()
	self.currentTokens = self.maxTokens
	self.lastRefillTime = tick()
end

function class:toString()
	self:refill()

	return string.format(
		"TokenBucketRateLimiter{tokens=%d/%d, refillRate=%d/%ds, nextRefillIn=%.1fs}",
		self.currentTokens,
		self.maxTokens,
		self.refillRate,
		self.refillIntervalSeconds,
		self.refillIntervalSeconds - (tick() - self.lastRefillTime) % self.refillIntervalSeconds
	)
end

return class
