local MessagingService = game:GetService("MessagingService")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local json = require(script.Parent.json)

local isStudio = RunService:IsStudio()

local function dlog(...)
	print("[http]", ...)
end

local Cache = {}

Cache.settings = {}
Cache.max_size = 1e999
Cache.data = {}

function Cache.update_settings(p, p2)
	local v = type(p) == "table" and p or { p }
	local count = 0

	while count < #v do
		count += 1

		local v2 = v[count]

		if v2:sub(1, 7) == "http://" then
			v[count] = v2:sub(8)
			v2 = v[count]
		elseif v2:sub(1, 8) == "https://" then
			v[count] = v2:sub(9)
			v2 = v[count]
		end

		if v2:sub(1, 2) == "*." then
			table.insert(v, v2:sub(3))
		end

		if v2:find("/") then
			continue
		end

		table.insert(v, v2 .. "/")
		table.insert(v, v2 .. "/*")
	end

	for _, v2 in ipairs(v) do
		Cache.settings[v2] = p2

		if p2.cache_locally ~= false or p2.cache_globally then
			continue
		end

		Cache.settings[v2] = nil
	end
end

function Cache.cache_locally(p, options)
	local v = options or {}
	v.cache_globally = false

	Cache.update_settings(p, v)
end

function Cache.cache_globally(p, options)
	local v = options or {}
	v.cache_globally = true

	Cache.update_settings(p, v)
end

function Cache.should_cache(value)
	local v = value:split("?")[1]

	for k, _ in pairs(Cache.settings) do
		if v:match(".*://" .. k:gsub("%*", ".*")) then
			return k
		end
	end

	return false
end

function Cache.is_cached(p, p2): boolean
	local should_cache = Cache.should_cache(p)
	local setting = Cache.settings[should_cache]

	if not should_cache then
		return false
	end

	if Cache.data[p2] == nil then
		if not Cache.settings[should_cache].cache_globally then
			return false
		end

		return if Cache.global_cache_index[p2] then true else false
	end

	return not (setting.expires and tick() - Cache.data[p2].timestamp > setting.expires)
end

Cache.global_cache_index = {}
local v = {}

local success, result = pcall(function()
	return DataStoreService:GetDataStore("HttpRequestsCache")
end)

if success then
	local success2, result2 = pcall(function()
		return result:GetAsync("index") or {}
	end)

	if success2 then
		Cache.global_cache_index = result2

		Cache.global_cache_update_interval = 20

		coroutine.wrap(function()
			while wait(Cache.global_cache_update_interval) do
				pcall(function()
					local count = 0

					for k, v2 in pairs(v) do
						result:SetAsync(k, v2)
						count += 1
					end

					if count > 0 then
						dlog(("pushing %s requests to global cache index"):format(count))
					end

					local v2 = {}

					result:UpdateAsync("index", function(options)
						local result3 = options or {}

						for k, _ in pairs(v) do
							table.insert(v2, k)

							result3[k] = true
							Cache.global_cache_index[k] = true
						end

						return result3
					end)

					if not isStudio then
						MessagingService:PublishAsync("RequestsCacheIndex", json.enc(v2))
					end

					v = {}
				end)
			end
		end)()

		if not isStudio then
			MessagingService:SubscribeAsync("RequestsCacheIndex", function(p)
				local dec = json.dec(p.Data)

				for _, v2 in ipairs(dec) do
					Cache.global_cache_index[v2] = true
				end
			end)
		end
	end
end

function Cache.get_expire(p)
	local should_cache = Cache.should_cache(p)

	return Cache.settings[should_cache].expires or 1e999
end

function Cache.get_cached(p, p2)
	local should_cache = Cache.should_cache(p)

	local v2 = Cache.data[p2]

	if v2 then
		return v2, "local"
	end

	if success and Cache.settings[should_cache].cache_globally then
		dlog("accessing datastore cache for", p2)

		return result:GetAsync(p2), "global"
	end
end

function Cache.update_cache(p, p2, p3)
	print(("[http] %s added to cache"):format(p))

	p3.timestamp = tick()

	Cache.data[p2] = p3

	local should_cache = Cache.should_cache(p)

	if success and Cache.settings[should_cache].cache_globally then
		dlog("queued", p2)
		v[p2] = p3
	end
end

return Cache
