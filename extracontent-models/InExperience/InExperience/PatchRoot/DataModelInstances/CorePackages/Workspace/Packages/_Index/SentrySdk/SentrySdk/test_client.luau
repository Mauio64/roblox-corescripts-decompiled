local module = require("@std/luau")
local module2 = require("@std/fs")
local module3 = require("@std/json")
local module4 = require("@std/net")
local module5 = require("@std/process")

local dir = module5.args[1]:match("^(.*)/[^/]+$") or "."

local dsn = module5.args[2] or module5.env.SENTRY_DSN

if not dsn or dsn == "" then
	print("ERROR: no DSN provided.")
	print("  lute test_client.lua \"<your-sentry-dsn>\"")
	print("  or set SENTRY_DSN in the environment")
	module5.exit(1)
end

if not module2.exists(dir .. "/Client.lua") then
	print(`ERROR: cannot find {dir}/Client.lua`)
	module5.exit(1)
end

local httpService = {
	JSONEncode = function(_, p)
		return module3.serialize(p)
	end,
	JSONDecode = function(_, p)
		return module3.deserialize(p)
	end,
	RequestInternal = function(_, data)
		return {
			Start = function(_, callback)
				local success, result = pcall(function()
					return module4.request(data.Url, {
						method = data.Method,
						headers = data.Headers,
						body = data.Body
					})
				end)

				if success then
					callback(true, {
						Success = result.ok,
						StatusCode = result.status,
						Body = result.body,
						Headers = result.headers
					})
				else
					callback(false, (tostring(result)))
				end
			end
		}
	end
}

local v = {
	HttpService = httpService,
	RunService = {
		IsStudio = function(_): boolean
			return false
		end,
		GetRobloxVersion = function(_): string
			return "version-9.999.0.9999999"
		end
	}
}
local object = setmetatable({ PlaceId = 0, JobId = "lute-test-job" }, {})
function object.GetService(_, p)
	return v[p]
end

function object.DefineFastFlag(_): boolean
	return false
end

local v2 = {
	print = print,
	warn = print,
	error = error,
	assert = assert,
	pcall = pcall,
	xpcall = xpcall,
	type = type,
	typeof = typeof,
	tostring = tostring,
	tonumber = tonumber,
	next = next,
	pairs = pairs,
	ipairs = ipairs,
	select = select,
	unpack = unpack,
	setmetatable = setmetatable,
	getmetatable = getmetatable,
	rawget = rawget,
	rawset = rawset,
	rawequal = rawequal,
	rawlen = rawlen,
	string = string,
	table = table,
	math = math,
	os = os,
	coroutine = coroutine,
	bit32 = bit32,
	utf8 = utf8,
	buffer = buffer,
	game = object
}

local v3 = {}
local v4 = {}

local v5 = nil
local v6 = nil

local function parentDir(__dir) -- 1 equivalent call inferred from this helper
	return __dir:match("^(.*)/[^/]+$") or "."
end

local function folderNode(dir2) -- 2 equivalent calls inferred from this helper
	return (setmetatable({ __dir = dir2, __isFolder = true }, v6))
end

local function fileNode(base, parent) -- 2 equivalent calls inferred from this helper
	return (setmetatable({ __base = base, __parent = parent, __isFile = true }, v5))
end

v6 = {
	__index = function(parent, p)
		if p == "Parent" then
			return folderNode(parentDir(parent.__dir)) -- inferred equivalent call
		end

		return fileNode(parent.__dir .. "/" .. p, parent) -- inferred equivalent call
	end
}

v5 = {
	__index = function(p, p2)
		if p2 == "Parent" then
			return p.__parent
		end

		error(`unsupported instance access: .{tostring(p2)} on module file`)
	end
}
local function fn(Script)
	local v7 = type(Script) == "table" and Script.__isFile
	assert(v7, "custom require expects a module node")
	local __base = Script.__base

	if v4[__base] ~= nil then
		return v4[__base]
	end

	local v8 = __base .. ".lua"

	if not module2.exists(v8) then
		v8 = __base .. ".luau"
	end

	local fileToString = module2.readFileToString(v8)
	local compile = module.compile(fileToString)

	local object2 = setmetatable({ script = Script, require = fn, _G = v3 }, { __index = v2 })

	local v9 = module.load(compile, v8, object2)()
	v4[__base] = v9
	return v9
end

local parent = folderNode(dir) -- inferred equivalent call
local v7 = fn(fileNode(dir .. "/Client", parent)):new( -- inferred equivalent call
	{ dsn = dsn, environment = "sentry-sdk-test", release = "sentry-sdk-test" },
	httpService
)

v7:set_tag("test_run", "breadcrumb-lute")
v7:add_breadcrumb({ type = "ui", category = "ui.click", message = "client-level crumb" })

local stacktrace = {
	frames = {
		{
			filename = "CartService.lua",
			abs_path = "CartService.lua",
			["function"] = "submitOrder",
			lineno = 142,
			colno = 9,
			in_app = true
		},
		{
			filename = "PurchaseFlow.lua",
			abs_path = "PurchaseFlow.lua",
			["function"] = "startCheckout",
			lineno = 88,
			in_app = true
		}
	}
}

print("Sending exception to Sentry with context, threads, stacktrace, and breadcrumbs...")
v7:capture_exception({
	type = "LuaError",
	message = "Breadcrumb test from lute",
	stacktrace = stacktrace
}, "error", {
	app = { app_version = "1.2.3", app_build = "4567" },
	device = {
		name = "iPhone 15",
		model = "iPhone16,1",
		manufacturer = "Apple",
		memory_size = 8000000000
	},
	checkout = { cart_id = "cart_abc123", item_count = 3 }
}, {
	values = {
		{
			id = 1,
			name = "main",
			main = true,
			crashed = true,
			stacktrace = stacktrace
		},
		{
			id = 2,
			name = "PrefetchWorker",
			main = false,
			crashed = false,
			stacktrace = {
				frames = {
					{
						filename = "PrefetchWorker.lua",
						["function"] = "run",
						lineno = 27,
						in_app = true
					}
				}
			}
		}
	}
}, function(p, p2, p3)
	print("---- Sentry response ----")
	print("callback success:", p)
	print("eventId:", (tostring(p3)))

	if type(p2) == "table" and type(p2.body) == "table" then
		print("HTTP status:", (tostring(p2.body.StatusCode)))
		print("HTTP body:", (tostring(p2.body.Body)))
	elseif type(p2) == "table" then
		print("error:", (tostring(p2.error)))
	end

	print("-------------------------")
end, {
	{
		type = "navigation",
		category = "navigation",
		message = "Opened Avatar editor",
		timestamp = os.time() - 10,
		data = { from = "/home", to = "/avatar" }
	},
	{
		type = "ui",
		category = "ui.click",
		message = "Tapped Buy",
		level = "info",
		timestamp = os.time()
	}
})
