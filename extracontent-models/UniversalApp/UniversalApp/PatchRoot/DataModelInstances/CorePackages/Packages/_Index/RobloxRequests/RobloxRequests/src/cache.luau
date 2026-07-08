local MessagingService = game:GetService("MessagingService")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local json = require(script.Parent.json)
local v5 = RunService:IsStudio()

local function dlog(...) -- line: 10
	print("[http]", ...)
end

local t1 = {
	settings = {},
	max_size = 1e999,
	data = {}
}

function t1.update_settings(p1, p2) -- line: 22
	-- upvalues: t1 (copy)
	local v15 = type(p1) == "table" and p1 or { p1 }
	local n1 = 0

	while n1 < #v15 do
		n1 += 1

		local v17 = v15[n1]

		if v17:sub(1, 7) == "http://" then
			v15[n1] = v17:sub(8)
			v17 = v15[n1]
		elseif v17:sub(1, 8) == "https://" then
			v15[n1] = v17:sub(9)
			v17 = v15[n1]
		end

		if v17:sub(1, 2) == "*." then
			table.insert(v15, v17:sub(3))
		end

		if not v17:find("/") then
			table.insert(v15, v17 .. "/")
			table.insert(v15, v17 .. "/*")
		end
	end

	for _, v in ipairs(v15) do
		t1.settings[v] = p2

		if p2.cache_locally == false and not p2.cache_globally then
			t1.settings[v] = nil
		end
	end
end
function t1.cache_locally(p3, p4) -- line: 59
	-- upvalues: t1 (copy)
	local v22 = p4 or {}

	v22.cache_globally = false
	t1.update_settings(p3, v22)
end
function t1.cache_globally(p5, p6) -- line: 66
	-- upvalues: t1 (copy)
	local v25 = p6 or {}

	v25.cache_globally = true
	t1.update_settings(p5, v25)
end
function t1.should_cache(p7) -- line: 77
	-- upvalues: t1 (copy)
	local v27 = p7:split("?")[1]

	for k, _ in pairs(t1.settings) do
		if v27:match(".*://" .. k:gsub("%*", ".*")) then
			return k
		end
	end

	return false
end
function t1.is_cached(p8, p9) -- line: 91
	-- upvalues: t1 (copy)
	local v32 = t1.should_cache(p8)
	local v33 = t1.settings[v32]

	if not v32 then
		return false
	end

	if t1.data[p9] ~= nil then
		if v33.expires and tick() - t1.data[p9].timestamp > v33.expires then
			return false
		end

		return true
	end

	if t1.settings[v32].cache_globally then
		if t1.global_cache_index[p9] then
			return true
		end

		return false
	end

	return false
end

t1.global_cache_index = {}

local t2 = {}
local ok, result = pcall(function() -- line: 127
	-- upvalues: DataStoreService (copy)
	return DataStoreService:GetDataStore("HttpRequestsCache")
end)

if ok then
	local ok2, result2 = pcall(function() -- line: 132
		-- upvalues: result (copy)
		return result:GetAsync("index") or {}
	end)

	if ok2 then
		t1.global_cache_index = result2
		t1.global_cache_update_interval = 20
		coroutine.wrap(function() -- line: 140
			-- upvalues: t1 (copy), t2 (ref), result (copy), dlog (copy), v5 (copy), MessagingService (copy), json (copy)
			while wait(t1.global_cache_update_interval) do
				pcall(function() -- line: 142
					-- upvalues: t2 (ref), result (copy), dlog (copy), t1 (copy), v5 (copy), MessagingService (copy), json (copy)
					local n2 = 0

					for k, v in pairs(t2) do
						result:SetAsync(k, v)
						n2 += 1
					end

					if n2 > 0 then
						dlog(("pushing %s requests to global cache index"):format(n2))
					end

					local t3 = {}

					result:UpdateAsync("index", function(p10) -- line: 155
						-- upvalues: t2 (ref), t3 (copy), t1 (copy)
						local v53 = p10 or {}

						for k, _ in pairs(t2) do
							table.insert(t3, k)
							v53[k] = true
							t1.global_cache_index[k] = true
						end

						return v53
					end)

					if not v5 then
						MessagingService:PublishAsync("RequestsCacheIndex", json.enc(t3))
					end

					t2 = {}
				end)
			end
		end)()

		if not v5 then
			MessagingService:SubscribeAsync("RequestsCacheIndex", function(p11) -- line: 177
				-- upvalues: json (copy), t1 (copy)
				local v35 = json.dec(p11.Data)

				for _, v in ipairs(v35) do
					t1.global_cache_index[v] = true
				end
			end)
		end
	end
end

function t1.get_expire(p12) -- line: 192
	-- upvalues: t1 (copy)
	local v39 = t1.should_cache(p12)

	return t1.settings[v39].expires or 1e999
end
function t1.get_cached(p13, p14) -- line: 198
	-- upvalues: t1 (copy), ok (copy), dlog (copy), result (copy)
	local v42 = t1.should_cache(p13)
	local v43 = t1.data[p14]

	if v43 then
		return v43, "local"
	end

	if ok and t1.settings[v42].cache_globally then
		dlog("accessing datastore cache for", p14)

		return result:GetAsync(p14), "global"
	end
end
function t1.update_cache(p15, p16, p17) -- line: 214
	-- upvalues: t1 (copy), ok (copy), dlog (copy), t2 (ref)
	print(("[http] %s added to cache"):format(p15))
	p17.timestamp = tick()
	t1.data[p16] = p17

	local v47 = t1.should_cache(p15)

	if ok and t1.settings[v47].cache_globally then
		dlog("queued", p16)
		t2[p16] = p17

		return
	end
end

return t1
