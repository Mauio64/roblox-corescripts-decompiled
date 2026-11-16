local RobloxTransport = require("@game/CorePackages/Workspace/Packages/_Index/SentrySdk/SentrySdk/RobloxTransport")
local Version = require("@game/CorePackages/Workspace/Packages/_Index/SentrySdk/SentrySdk/Version")
local RunService = game:GetService("RunService")

local isStudio = RunService:IsStudio()

local function isBundled(): boolean
	return true
end

local function isTableEmpty(items): boolean
	return next(items) == nil
end

local function parseJSON(object, json)
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

local function createCallbackWithEventId(p2, callback)
	if callback then
		return function(p3, p4)
			local id = nil
			local v5 = nil

			if p3 and p4 and p4.body then
				if type(p4.body) == "table" and p4.body.Body then
					local v6 = p2
					local body = p4.body.Body
					local result

					if type(body) == "string" then
						local success
						success, result = pcall(function()
							return v6:JSONDecode(body)
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

				v5 = p4
			elseif p4 then
				v5 = p4
			end

			callback(p3, v5, id)
		end
	end

	return nil
end

local class = {}
class.__index = class

function class.new(p2, p3, p4)
	if not p3.dsn then
		error("DSN is required")
	end

	return (setmetatable({
		transport = RobloxTransport:new(p3.dsn, p4),
		httpService = p4,
		user = nil,
		tags = {},
		extra = {},
		breadcrumbs = {},
		config = p3
	}, class))
end

function class:_buildDebugMeta()
	local v5 = LUAUFORGE_SENTRY_DEBUG_IDS

	if type(v5) ~= "table" then
		return nil
	end

	local v6 = {}

	for k, v7 in v5 do
		table.insert(v6, { type = "sourcemap", code_file = k, debug_id = v7 })
	end

	if #v6 == 0 then
		return nil
	end

	return { images = v6 }
end

function class.capture_message(data, p2, value, callback, p3)
	local v5 = {
		message = { message = p2 },
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
	local extra = data.extra
	local v6 = if next(extra) ~= nil then data.extra else nil
	v5.extra = v6
	v5.breadcrumbs = p3 or data.breadcrumbs
	v5.contexts = {
		roblox = {
			version = Version.SDK_VERSION,
			place_id = tostring(game.PlaceId),
			job_id = game.JobId or "unknown"
		}
	}

	local httpService = data.httpService
	data.transport:send(v5, callback and function(p4, p5)
		local id = nil
		local v7 = nil

		if p4 and p5 and p5.body then
			if type(p5.body) == "table" and p5.body.Body then
				local v8 = httpService
				local body = p5.body.Body
				local result

				if type(body) == "string" then
					local success
					success, result = pcall(function()
						return v8:JSONDecode(body)
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

			v7 = p5
		elseif p5 then
			v7 = p5
		end

		callback(p4, v7, id)
	end or nil)
end

function class:capture_exception(data, value, items, threads, callback, p2, p3, items2)
	local v6 = {
		roblox = {
			version = Version.SDK_VERSION,
			place_id = tostring(game.PlaceId),
			job_id = game.JobId or "unknown"
		}
	}

	if items then
		for k, item in pairs(items) do
			v6[k] = item
		end
	end

	local v7 = {
		type = data.type or "RobloxError",
		value = data.message or tostring(data)
	}

	if data.stacktrace and data.stacktrace.frames and #data.stacktrace.frames > 0 then
		v7.stacktrace = data.stacktrace

		for k, frame in data.stacktrace.frames do
			frame.platform = "javascript"
		end
	end

	local v8 = {
		values = { v7 }
	}

	if isStudio then
		print("🔍 Exception structure:", v8)
	end

	local v9 = {
		exception = v8,
		level = value or "error",
		timestamp = p3 or os.time(),
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
	local extra = self.extra
	local v10 = if next(extra) ~= nil then self.extra else nil
	v9.extra = v10
	v9.breadcrumbs = p2 or self.breadcrumbs
	v9.contexts = v6

	if items2 then
		v9.tags = table.clone(self.tags)

		for k, item in items2 do
			v9.tags[k] = item
		end
	end

	if threads then
		v9.threads = threads
	end

	v9.debug_meta = self:_buildDebugMeta()

	local httpService = self.httpService
	self.transport:send(v9, callback and function(p4, p5)
		local id = nil
		local v11 = nil

		if p4 and p5 and p5.body then
			if type(p5.body) == "table" and p5.body.Body then
				local v12 = httpService
				local body = p5.body.Body
				local result

				if type(body) == "string" then
					local success
					success, result = pcall(function()
						return v12:JSONDecode(body)
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

			v11 = p5
		elseif p5 then
			v11 = p5
		end

		callback(p4, v11, id)
	end or nil)
end

function class:send_event_with_attachments(p3, list, callback)
	if p3 and #list ~= 0 then
		local httpService = self.httpService
		self.transport:send_attachments(p3, list, callback and function(p4, p5)
			local id = nil
			local v5 = nil

			if p4 and p5 and p5.body then
				if type(p5.body) == "table" and p5.body.Body then
					local v6 = httpService
					local body = p5.body.Body
					local result

					if type(body) == "string" then
						local success
						success, result = pcall(function()
							return v6:JSONDecode(body)
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

				v5 = p5
			elseif p5 then
				v5 = p5
			end

			callback(p4, v5, id)
		end or nil)
	elseif callback then
		callback(false, { error = "eventId and attachments are required" }, nil)
	end
end

function class:set_user(user)
	self.user = user
end

function class:set_tag(p3, p4)
	self.tags[p3] = tostring(p4)
end

function class.set_extra(p2, p3, p4)
	p2.extra[p3] = p4
end

function class.add_breadcrumb(p2, p3)
	p3.timestamp = os.time()
	table.insert(p2.breadcrumbs, p3)

	if #p2.breadcrumbs > 50 then
		table.remove(p2.breadcrumbs, 1)
	end
end

return class
