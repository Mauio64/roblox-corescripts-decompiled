local t1 = {}

t1.__index = t1

local function log(p1) -- line: 13
	return p1
end

if not t1.ratelimit then
	t1.ratelimit = {}
end

function t1.get(p2, p3, p4) -- line: 22
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	if not t1.ratelimit[p2] then
		t1.ratelimit[p2] = {}
		t1.ratelimit[p2].windows = {}
	end

	t1.ratelimit[p2].window_size = p4
	t1.ratelimit[p2].rate = p3
	self.id = p2
	self.window_size = t1.ratelimit[p2].window_size
	self.rate = t1.ratelimit[p2].rate

	local _ = self.id

	return self
end
function t1.window(p5) -- line: 44
	return (math.floor(tick() / p5.window_size))
end
function t1.progress(p6) -- line: 48
	return tick() % p6.window_size / p6.window_size
end
function t1.increment(p7) -- line: 54
	-- upvalues: t1 (copy)
	local v12 = p7:window()

	if not t1.ratelimit[p7.id].windows[v12] then
		t1.ratelimit[p7.id].windows[v12] = 0
	end

	t1.ratelimit[p7.id].windows[v12] = t1.ratelimit[p7.id].windows[v12] + 1

	return t1.ratelimit[p7.id].windows[v12]
end
function t1.weighted(p8, p9) -- line: 70
	-- upvalues: t1 (copy)
	local v15 = p9 or 0
	local v16 = p8:progress()
	local v17 = p8:window()
	local v18 = (t1.ratelimit[p8.id].windows[v17] or 0) + v15
	local v19 = t1.ratelimit[p8.id].windows[v17 - 1] or 0

	return v18 * v16 + v19 * (1 - v16)
end
function t1.consumption(p10) -- line: 84
	return p10:weighted() / p10.rate
end
function t1.request(p11) -- line: 90
	if p11:weighted(1) > p11.rate then
		return false
	end

	p11:increment()

	return true
end

return t1
