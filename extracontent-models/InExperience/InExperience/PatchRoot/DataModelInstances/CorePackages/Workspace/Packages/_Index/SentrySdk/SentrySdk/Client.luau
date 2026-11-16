local RobloxTransport = require(script.Parent.RobloxTransport)
local Version = require(script.Parent.Version)
local RunService = game:GetService("RunService")

local isStudio = RunService:IsStudio()

local function isBundled(): boolean -- 1 equivalent call inferred from this helper
	return type(_G.LUAUFORGE_BUNDLED_FILE_PATH) == "string"
end

local function isTableEmpty(extra): boolean -- 2 equivalent calls inferred from this helper
	return next(extra) == nil
end

local function parseJSON(object, json: string)
	if type(json) ~= "string" then
		return nil, "Input is not a string"
	end

	local success, result = pcall(function()
		return object:JSONDecode(json)
	end)

	if success then
		return result, nil
	end

	return nil, (tostring(result))
end

local function createCallbackWithEventId(httpService, callback) -- 3 equivalent calls inferred from this helper
	if callback then
		return function(flag: boolean, p)
			local id = nil
			local v = nil

			if flag and p and p.body then
				if type(p.body) == "table" and p.body.Body then
					local v2 = httpService
					local body = p.body.Body
					local result

					if type(body) == "string" then
						local success
						success, result = pcall(function()
							return v2:JSONDecode(body)
						end)

						if not success then
							tostring(result)
							result = nil
						end
					end

					if result and result.id then
						id = result.id
					end
				end

				v = p
			elseif p then
				v = p
			end

			callback(flag, v, id)
		end
	end

	return nil
end

local class = {}
class.__index = class

function class:new(config, httpService)
	if not config.dsn then
		error("DSN is required")
	end

	return (setmetatable({
		transport = RobloxTransport:new(config.dsn, httpService),
		httpService = httpService,
		user = nil,
		tags = {},
		extra = {},
		breadcrumbs = {},
		config = config
	}, class))
end

function class:_buildDebugMeta()
	local LUAUFORGE_SENTRY_DEBUG_IDS = _G.LUAUFORGE_SENTRY_DEBUG_IDS

	if type(LUAUFORGE_SENTRY_DEBUG_IDS) ~= "table" then
		return nil
	end

	local images = {}

	for k, debug_id in LUAUFORGE_SENTRY_DEBUG_IDS do
		table.insert(images, { type = "sourcemap", code_file = k, debug_id = debug_id })
	end

	if #images == 0 then
		return nil
	end

	return { images = images }
end

function class.capture_message(data, message: string, value: string?, callback, p)
	local v = {
		message = { message = message },
		level = value or "info",
		timestamp = os.time(),
		environment = data.config.environment or "production",
		release = data.config.release or "unknown",
		platform = "roblox",
		sdk = { name = "sentry.lua", version = Version.SDK_VERSION },
		server_name = "roblox-server",
		user = data.user,
		tags = data.tags,
		extra = 0,
		breadcrumbs = 0,
		contexts = 0
	}
	local extra

	if not isTableEmpty(data.extra) then -- inferred equivalent call
		extra = data.extra
	end

	v.extra = extra
	v.breadcrumbs = p or data.breadcrumbs
	v.contexts = {
		roblox = {
			version = Version.SDK_VERSION,
			place_id = tostring(game.PlaceId),
			job_id = game.JobId or "unknown"
		}
	}

	local httpService = data.httpService

	data.transport:send(v, createCallbackWithEventId(httpService, callback)) -- inferred equivalent call
end

function class:capture_exception(data, value: string?, items, threads, callback, p, p2: number?, items2)
	local contexts = {
		roblox = {
			version = Version.SDK_VERSION,
			place_id = tostring(game.PlaceId),
			job_id = game.JobId or "unknown"
		}
	}

	if items then
		for k, item in pairs(items) do
			contexts[k] = item
		end
	end

	local v = {
		type = data.type or "RobloxError",
		value = data.message or tostring(data)
	}

	if data.stacktrace and data.stacktrace.frames and #data.stacktrace.frames > 0 then
		v.stacktrace = data.stacktrace

		if isBundled() then -- inferred equivalent call
			for _, frame in data.stacktrace.frames do
				frame.platform = "javascript"
			end
		end
	end

	local exception = {
		values = { v }
	}

	if isStudio then
		print("🔍 Exception structure:", exception)
	end

	local v2 = {
		exception = exception,
		level = value or "error",
		timestamp = p2 or os.time(),
		environment = self.config.environment or "production",
		release = self.config.release or "unknown",
		platform = "roblox",
		sdk = { name = "sentry.lua", version = Version.SDK_VERSION },
		server_name = "roblox-server",
		user = self.user,
		tags = self.tags,
		extra = 0,
		breadcrumbs = 0,
		contexts = 0
	}
	local extra

	if not isTableEmpty(self.extra) then -- inferred equivalent call
		extra = self.extra
	end

	v2.extra = extra
	v2.breadcrumbs = p or self.breadcrumbs
	v2.contexts = contexts

	if items2 then
		v2.tags = table.clone(self.tags)

		for k, item in items2 do
			v2.tags[k] = item
		end
	end

	if threads then
		v2.threads = threads
	end

	v2.debug_meta = self:_buildDebugMeta()

	local httpService = self.httpService

	self.transport:send(v2, createCallbackWithEventId(httpService, callback)) -- inferred equivalent call
end

function class.send_event_with_attachments(p, p2: string, list, callback)
	if p2 and #list ~= 0 then
		local httpService = p.httpService

		p.transport:send_attachments(p2, list, createCallbackWithEventId(httpService, callback)) -- inferred equivalent call
	elseif callback then
		callback(false, { error = "eventId and attachments are required" }, nil)
	end
end

function class:set_user(user)
	self.user = user
end

function class.set_tag(p, p2: string, p3)
	p.tags[p2] = tostring(p3)
end

function class.set_extra(p, p2: string, p3)
	p.extra[p2] = p3
end

function class.add_breadcrumb(p, p2)
	p2.timestamp = os.time()
	table.insert(p.breadcrumbs, p2)

	if #p.breadcrumbs > 50 then
		table.remove(p.breadcrumbs, 1)
	end
end

return class
