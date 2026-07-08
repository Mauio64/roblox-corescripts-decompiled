local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 36
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.maxTokens = t2.maxTokens
	self.refillRate = t2.refillRate
	self.refillIntervalSeconds = t2.refillIntervalSeconds
	self.currentTokens = t2.initialTokens or t2.maxTokens
	self.lastRefillTime = tick()

	if self.currentTokens > self.maxTokens then
		self.currentTokens = self.maxTokens
	end

	return self
end
function t1.refill(p1) -- line: 58
	local timestamp = tick()
	local v6 = timestamp - p1.lastRefillTime

	if v6 < 0 then
		p1.lastRefillTime = timestamp

		return
	end

	local v7 = math.floor(v6 / p1.refillIntervalSeconds)

	if v7 > 0 then
		local v8 = v7 * p1.refillRate

		p1.currentTokens = math.min(p1.maxTokens, p1.currentTokens + v8)
		p1.lastRefillTime = p1.lastRefillTime + v7 * p1.refillIntervalSeconds
	end
end
function t1.consume(t3: {[any]: any}, n1: number?) -- line: 93
	local v11 = n1 or 1

	t3:refill()

	if v11 <= t3.currentTokens then
		t3.currentTokens = t3.currentTokens - v11

		return true
	end

	return false
end
function t1.getAvailableTokens(p2) -- line: 113
	p2:refill()

	return p2.currentTokens
end
function t1.getMaxTokens(p3) -- line: 123
	return p3.maxTokens
end
function t1.hasTokensAvailable(p4) -- line: 132
	return p4:getAvailableTokens() > 0
end
function t1.reset(p5) -- line: 139
	p5.currentTokens = p5.maxTokens
	p5.lastRefillTime = tick()
end
function t1.toString(p6) -- line: 149
	p6:refill()

	return string.format("TokenBucketRateLimiter{tokens=%d/%d, refillRate=%d/%ds, nextRefillIn=%.1fs}", p6.currentTokens, p6.maxTokens, p6.refillRate, p6.refillIntervalSeconds, p6.refillIntervalSeconds - (tick() - p6.lastRefillTime) % p6.refillIntervalSeconds)
end

return t1
