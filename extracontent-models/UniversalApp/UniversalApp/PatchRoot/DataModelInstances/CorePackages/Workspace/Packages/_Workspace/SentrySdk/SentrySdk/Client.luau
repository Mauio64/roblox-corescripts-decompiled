local RobloxTransport = require(script.Parent.RobloxTransport)
local Version = require(script.Parent.Version)
local v3 = game:GetService("RunService"):IsStudio()

local function isBundled() -- line: 8
	return type(_G.LUAUFORGE_BUNDLED_FILE_PATH) == "string"
end
local function isTableEmpty(t1: {[any]: any}) -- line: 13
	return next(t1) == nil
end
local function parseJSON(p1, s1: string) -- line: 18
	if type(s1) ~= "string" then
		return nil, "Input is not a string"
	end

	local ok, result = pcall(function() -- line: 23
		-- upvalues: p1 (copy), s1 (copy)
		return p1:JSONDecode(s1)
	end)

	if ok then
		return result, nil
	end

	return nil, (tostring(result))
end
local function createCallbackWithEventId(p2, p3: ((...any) -> ...any)?) -- line: 35
	if not p3 then
		return nil
	end

	return function(b1: boolean, t2: {[any]: any}?) -- line: 46
		-- upvalues: p2 (copy), p3 (copy)
		local id = nil
		local v70 = nil

		if b1 and (t2 and t2.body) then
			if type(t2.body) == "table" and t2.body.Body then
				local v71 = p2
				local Body = t2.body.Body
				local v73

				if type(Body) ~= "string" then
					v73 = nil
				else
					local ok, result = pcall(function() -- line: 23
						-- upvalues: v71 (copy), Body (copy)
						return v71:JSONDecode(Body)
					end)

					if ok then
						v73 = result
					else
						v73 = nil
						tostring(result)
					end
				end

				if v73 and v73.id then
					id = v73.id
				end
			end

			v70 = t2
		elseif t2 then
			v70 = t2
		end

		p3(b1, v70, id)
	end
end

local t3 = {}

t3.__index = t3

function t3.new(_: {[any]: any}, t5: {[any]: any}, p4) -- line: 148
	-- upvalues: RobloxTransport (copy), t3 (copy)
	if not t5.dsn then
		error("DSN is required")
	end

	return (setmetatable({
		user = nil,
		transport = RobloxTransport:new(t5.dsn, p4),
		httpService = p4,
		tags = {},
		extra = {},
		breadcrumbs = {},
		config = t5
	}, t3))
end
function t3._buildDebugMeta(_) -- line: 179
	local LUAUFORGE_SENTRY_DEBUG_IDS = _G.LUAUFORGE_SENTRY_DEBUG_IDS

	if type(LUAUFORGE_SENTRY_DEBUG_IDS) ~= "table" then
		return nil
	end

	local t6 = {}

	for v22, v23 in LUAUFORGE_SENTRY_DEBUG_IDS do
		table.insert(t6, {
			type = "sourcemap",
			code_file = v22,
			debug_id = v23
		})
	end

	if #t6 == 0 then
		return nil
	end

	return {
		images = t6
	}
end
function t3.capture_message(t7: {[any]: any}, s2: string, s3: string?, p6: ((...any) -> ...any)?) -- line: 205
	-- upvalues: Version (copy)
	local v28 = s3 or "info"
	local t8 = {
		platform = "roblox",
		server_name = "roblox-server",
		message = {
			message = s2
		},
		level = v28,
		timestamp = os.time(),
		environment = t7.config.environment or "production",
		release = t7.config.release or "unknown",
		sdk = {
			name = "sentry.lua",
			version = Version.SDK_VERSION
		},
		user = t7.user,
		tags = t7.tags
	}
	local extra = t7.extra

	t8.extra = if next(extra) ~= nil then t7.extra else nil
	t8.breadcrumbs = t7.breadcrumbs
	t8.contexts = {
		roblox = {
			version = Version.SDK_VERSION,
			place_id = tostring(game.PlaceId),
			job_id = game.JobId or "unknown"
		}
	}

	local httpService = t7.httpService
	local v32 = p6 and function(b2: boolean, t9: {[any]: any}?) -- line: 46
		-- upvalues: httpService (copy), p6 (copy)
		local id = nil
		local v79 = nil

		if b2 and (t9 and t9.body) then
			if type(t9.body) == "table" and t9.body.Body then
				local v80 = httpService
				local Body = t9.body.Body
				local v82

				if type(Body) ~= "string" then
					v82 = nil
				else
					local ok, result = pcall(function() -- line: 23
						-- upvalues: v80 (copy), Body (copy)
						return v80:JSONDecode(Body)
					end)

					if ok then
						v82 = result
					else
						v82 = nil
						tostring(result)
					end
				end

				if v82 and v82.id then
					id = v82.id
				end
			end

			v79 = t9
		elseif t9 then
			v79 = t9
		end

		p6(b2, v79, id)
	end or nil

	t7.transport:send(t8, v32)
end
function t3.capture_exception(t10: {[any]: any}, t11: {[any]: any}, s4: string?, t12: {[any]: any}?, p7, p8: ((...any) -> ...any)?) -- line: 248
	-- upvalues: Version (copy), v3 (copy)
	local v39 = s4 or "error"
	local t13 = {
		roblox = {
			version = Version.SDK_VERSION,
			place_id = tostring(game.PlaceId),
			job_id = game.JobId or "unknown"
		}
	}

	if t12 then
		for k, v in pairs(t12) do
			t13[k] = v
		end
	end

	local t14 = {
		type = t11.type or "RobloxError",
		value = t11.message or tostring(t11)
	}

	if t11.stacktrace and t11.stacktrace.frames and #t11.stacktrace.frames > 0 then
		t14.stacktrace = t11.stacktrace

		if type(_G.LUAUFORGE_BUNDLED_FILE_PATH) == "string" then
			for _, v45 in t11.stacktrace.frames do
				v45.platform = "javascript"
			end
		end
	end

	local t15 = {
		values = { t14 }
	}

	if v3 then
		print("🔍 Exception structure:", t15)
	end

	local t16 = {
		platform = "roblox",
		server_name = "roblox-server",
		exception = t15,
		level = v39,
		timestamp = os.time(),
		environment = t10.config.environment or "production",
		release = t10.config.release or "unknown",
		sdk = {
			name = "sentry.lua",
			version = Version.SDK_VERSION
		},
		user = t10.user,
		tags = t10.tags
	}
	local extra = t10.extra

	t16.extra = if next(extra) ~= nil then t10.extra else nil
	t16.breadcrumbs = t10.breadcrumbs
	t16.contexts = t13

	if p7 then
		t16.threads = p7
	end

	t16.debug_meta = t10:_buildDebugMeta()

	local httpService = t10.httpService
	local v50 = p8 and function(b3: boolean, t17: {[any]: any}?) -- line: 46
		-- upvalues: httpService (copy), p8 (copy)
		local id = nil
		local v88 = nil

		if b3 and (t17 and t17.body) then
			if type(t17.body) == "table" and t17.body.Body then
				local v89 = httpService
				local Body = t17.body.Body
				local v91

				if type(Body) ~= "string" then
					v91 = nil
				else
					local ok, result = pcall(function() -- line: 23
						-- upvalues: v89 (copy), Body (copy)
						return v89:JSONDecode(Body)
					end)

					if ok then
						v91 = result
					else
						v91 = nil
						tostring(result)
					end
				end

				if v91 and v91.id then
					id = v91.id
				end
			end

			v88 = t17
		elseif t17 then
			v88 = t17
		end

		p8(b3, v88, id)
	end or nil

	t10.transport:send(t16, v50)
end
function t3.send_event_with_attachments(t18: {[any]: any}, s5: string, t19: {[any]: any}, p9: ((...any) -> ...any)?) -- line: 339
	if not s5 or #t19 == 0 then
		if p9 then
			p9(false, {
				error = "eventId and attachments are required"
			}, nil)
		end

		return
	end

	local httpService = t18.httpService
	local v56 = p9 and function(b4: boolean, t20: {[any]: any}?) -- line: 46
		-- upvalues: httpService (copy), p9 (copy)
		local id = nil
		local v97 = nil

		if b4 and (t20 and t20.body) then
			if type(t20.body) == "table" and t20.body.Body then
				local v98 = httpService
				local Body = t20.body.Body
				local v100

				if type(Body) ~= "string" then
					v100 = nil
				else
					local ok, result = pcall(function() -- line: 23
						-- upvalues: v98 (copy), Body (copy)
						return v98:JSONDecode(Body)
					end)

					if ok then
						v100 = result
					else
						v100 = nil
						tostring(result)
					end
				end

				if v100 and v100.id then
					id = v100.id
				end
			end

			v97 = t20
		elseif t20 then
			v97 = t20
		end

		p9(b4, v97, id)
	end or nil

	t18.transport:send_attachments(s5, t19, v56)
end
function t3.set_user(p10, p11) -- line: 361
	p10.user = p11
end
function t3.set_tag(t21: {[any]: any}, s6: string, p12) -- line: 366
	t21.tags[s6] = tostring(p12)
end
function t3.set_extra(t22: {[any]: any}, s7: string, p13) -- line: 371
	t22.extra[s7] = p13
end
function t3.add_breadcrumb(p14, p15) -- line: 376
	p15.timestamp = os.time()
	table.insert(p14.breadcrumbs, p15)

	if #p14.breadcrumbs > 50 then
		table.remove(p14.breadcrumbs, 1)
	end
end

return t3
