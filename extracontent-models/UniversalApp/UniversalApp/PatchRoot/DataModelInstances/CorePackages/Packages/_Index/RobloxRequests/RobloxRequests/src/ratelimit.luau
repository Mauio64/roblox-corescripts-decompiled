local Ratelimit = {}
Ratelimit.__index = Ratelimit

local function log(p)
	return p
end

if not Ratelimit.ratelimit then
	Ratelimit.ratelimit = {}
end

function Ratelimit.get(id, rate, window_size)
	local self = setmetatable({}, Ratelimit)

	if not Ratelimit.ratelimit[id] then
		Ratelimit.ratelimit[id] = {}

		Ratelimit.ratelimit[id].windows = {}
	end

	Ratelimit.ratelimit[id].window_size = window_size
	Ratelimit.ratelimit[id].rate = rate

	self.id = id
	self.window_size = Ratelimit.ratelimit[id].window_size
	self.rate = Ratelimit.ratelimit[id].rate

	local _id = self.id

	return self
end

function Ratelimit:window()
	return (math.floor(tick() / self.window_size))
end

function Ratelimit:progress()
	return tick() % self.window_size / self.window_size
end

function Ratelimit:increment()
	local window = self:window()

	if not Ratelimit.ratelimit[self.id].windows[window] then
		Ratelimit.ratelimit[self.id].windows[window] = 0
	end

	Ratelimit.ratelimit[self.id].windows[window] = Ratelimit.ratelimit[self.id].windows[window] + 1

	return Ratelimit.ratelimit[self.id].windows[window]
end

function Ratelimit:weighted(value)
	local progress = self:progress()
	local window = self:window()

	local v = (Ratelimit.ratelimit[self.id].windows[window] or 0) + (value or 0)
	local v2 = Ratelimit.ratelimit[self.id].windows[window - 1] or 0

	return v * progress + v2 * (1 - progress)
end

function Ratelimit:consumption()
	return self:weighted() / self.rate
end

function Ratelimit:request(): boolean
	if self:weighted(1) > self.rate then
		return false
	end

	self:increment()
	return true
end

return Ratelimit
