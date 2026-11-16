local TokenBucketRateLimiter = {}
TokenBucketRateLimiter.__index = TokenBucketRateLimiter

function TokenBucketRateLimiter.new(data)
	local object = setmetatable({}, TokenBucketRateLimiter)

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

function TokenBucketRateLimiter:refill()
	local now = tick()
	local v = now - self.lastRefillTime

	if v < 0 then
		self.lastRefillTime = now
		return
	end

	local v2 = math.floor(v / self.refillIntervalSeconds)

	if v2 > 0 then
		local v3 = v2 * self.refillRate

		self.currentTokens = math.min(self.maxTokens, self.currentTokens + v3)

		self.lastRefillTime += v2 * self.refillIntervalSeconds
	end
end

function TokenBucketRateLimiter:consume(value: number?): boolean
	local v = value or 1

	self:refill()

	if v <= self.currentTokens then
		self.currentTokens -= v
		return true
	end

	return false
end

function TokenBucketRateLimiter:getAvailableTokens()
	self:refill()
	return self.currentTokens
end

function TokenBucketRateLimiter.getMaxTokens(p)
	return p.maxTokens
end

function TokenBucketRateLimiter:hasTokensAvailable(): boolean
	return self:getAvailableTokens() > 0
end

function TokenBucketRateLimiter:reset()
	self.currentTokens = self.maxTokens
	self.lastRefillTime = tick()
end

function TokenBucketRateLimiter:toString()
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

return TokenBucketRateLimiter
