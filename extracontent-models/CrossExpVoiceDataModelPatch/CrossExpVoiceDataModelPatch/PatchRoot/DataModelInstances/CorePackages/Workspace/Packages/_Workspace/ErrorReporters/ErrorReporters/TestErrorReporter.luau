local module = require("@std/luau")
local module2 = require("@std/fs")
local module3 = require("@std/json")
local module4 = require("@std/net")
local module5 = require("@std/process")

local function parentDir(value) -- 2 equivalent calls inferred from this helper
	return value:match("^(.*)/[^/]+$") or "."
end

local function isModuleDir(p) -- 1 equivalent call inferred from this helper
	return module2.exists(p .. "/init.lua") or module2.exists(p .. "/init.luau")
end

local path = module5.args[1]:match("^(.*)/[^/]+$") or "."
local v = parentDir(parentDir(path)) -- inferred equivalent call
local path2 = v .. "/sentry-sdk/src"

local dsn = module5.args[2] or module5.env.SENTRY_DSN

if not dsn or dsn == "" then
	print("ERROR: no DSN provided.")
	print("  lute TestErrorReporter.lua \"<your-sentry-dsn>\"")
	print("  or set SENTRY_DSN in the environment")
	module5.exit(1)
end

for _, v2 in { path .. "/Sentry/SentryReporter.lua", path2 .. "/Client.lua" } do
	if module2.exists(v2) then
		continue
	end

	print(`ERROR: cannot find {v2}`)
	module5.exit(1)
end

local httpService = {
	JSONEncode = function(self, p)
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

local runService = {
	renderStepped = {
		Connect = function()
			return {
				Disconnect = function() end
			}
		end
	}
}

function runService.IsStudio(_): boolean
	return false
end

function runService.GetRobloxVersion(_): string
	return "version-9.999.0.9999999"
end

local v2 = { HttpService = httpService, RunService = runService }
local object = setmetatable({ PlaceId = 0, JobId = "lute-test-job" }, {})
function object.GetService(_, p)
	return v2[p]
end

function object.DefineFastFlag(_, p, p2)
	return p == "SentryReportBreadcrumbs" or p2
end

function object.DefineFastInt(_, _, p)
	return p
end

local object2 = setmetatable({}, {
	__index = function()
		return function()
			return function(): boolean
				return true
			end
		end
	end
})

local v3 = {
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
	tick = os.clock,
	game = object
}

local v4 = {}
local v5 = {}

local v6 = nil

local function makeNode(path3, name, parent) -- 6 equivalent calls inferred from this helper
	return (setmetatable({ __path = path3, __name = name, __parent = parent }, v6))
end

v6 = {
	__index = function(parent, name)
		if type(name) == "string" and name:sub(1, 2) == "__" then
			return (rawget(parent, name))
		end

		if name == "Parent" then
			return parent.__parent
		elseif name == "Name" then
			return parent.__name
		elseif name == "FindFirstAncestor" then
			return function(_, p)
				local __parent = parent.__parent

				while __parent ~= nil do
					if __parent.__name == p then
						return __parent
					end

					__parent = __parent.__parent
				end

				return nil
			end
		end

		local selected = parent.__overrides and parent.__overrides[name]

		if selected == nil then
			return makeNode(parent.__path .. "/" .. name, name, parent) -- inferred equivalent call
		end

		return selected
	end
}
local function fn(Script)
	local v7 = type(Script) == "table" and Script.__path
	assert(v7, "custom require expects a module node")

	if Script.__value ~= nil then
		return Script.__value
	end

	local v8 = Script.__path

	if isModuleDir(v8) then -- inferred equivalent call
		v8 ..= "/init"
	end

	if v5[v8] ~= nil then
		return v5[v8]
	end

	local v9 = v8 .. ".lua"

	if not module2.exists(v9) then
		v9 = v8 .. ".luau"
	end

	local fileToString = module2.readFileToString(v9)
	local compile = module.compile(fileToString)

	local object3 = setmetatable({ script = Script, require = fn, _G = v4 }, { __index = v3 })

	local v10 = module.load(compile, v9, object3)()
	v5[v8] = v10
	return v10
end

local node = makeNode(v, "Packages") -- inferred equivalent call
local node2 = makeNode(path, "ErrorReporters", node) -- inferred equivalent call
node.__overrides = {
	ErrorReporters = node2,
	SentrySdk = makeNode(path2, "SentrySdk", node), -- inferred equivalent call
	Cryo = makeNode(v .. "/Cryo", "Cryo", node), -- inferred equivalent call
	t = makeNode(v .. "/t", "t", node) -- inferred equivalent call
}
node.__overrides.Cryo.__value = {
	Dictionary = {
		join = function(...)
			local result = {}

			for i = 1, select("#", ...) do
				local v7 = select(i, ...)

				if type(v7) ~= "table" then
					continue
				end

				for k, v8 in pairs(v7) do
					result[k] = v8
				end
			end

			return result
		end
	}
}
node.__overrides.t.__value = object2

local v7 = fn(node2.Sentry.SentryReporter)
local v8 = fn(node2.Sentry.ErrorReport)

local v9 = dsn:match("@([^/]+)") or "?"

local v10 = nil

local function summarizeBreadcrumbs()
	local v11 = {}

	for k, breadcrumb in v10.breadcrumbs do
		table.insert(
			v11,
			string.format(
				"      #%d [%s/%s] %s",
				k,
				tostring(breadcrumb.type),
				tostring(breadcrumb.category),
				(tostring(breadcrumb.message))
			)
		)
	end

	return table.concat(v11, "\n")
end

local v11 = v7.new({
	httpService = httpService,
	dsn = dsn,
	environment = "development",
	release = "error-reporter-test",
	sentryClientSuccessCallback = function()
		print("---- Sentry report accepted ----")
		print("  environment:", "development")
		print("  release:", "error-reporter-test")
		print("  dsn host:", v9)
		print("  level:", (tostring(v10.level)))
		print("  message:", (tostring(v10.message)))
		print("  attributes:", httpService:JSONEncode(v10.attributes))
		print("  customMetadata:", httpService:JSONEncode(v10.customMetadata))
		print("  breadcrumbs:", #v10.breadcrumbs)

		if #v10.breadcrumbs > 0 then
			print(summarizeBreadcrumbs())
		end

		print("--------------------------------")
	end,
	sentryClientFailureCallback = function(p)
		print("[callback] sentryClientFailureCallback fired:", (tostring(p)))
	end
})

v10 = v8.fromMessageAndStack(
	"Testing TestErrorReporter",
	"Script 'CartService', Line 142 - submitOrder\nScript 'PurchaseFlow', Line 88 - startCheckout",
	"error"
)

v10:addAttributes({
	appVersion = "1.2.3",
	baseOs = "iOS",
	systemVersion = "17.5",
	deviceName = "iPhone 15",
	networkType = "wifi"
})

v10:addCustomMetadata({
	checkout = { cart_id = "cart_abc123", item_count = 3 }
})

local v12 = {
	type = "navigation",
	category = "navigation",
	message = "Opened Avatar editor",
	data = { from = "/home", to = "/avatar" },
	timestamp = os.time() - 10
}
v10:addBreadcrumb(v12)

v10:addBreadcrumb({ type = "ui", category = "ui.click", message = "Tapped Buy", level = "info" })

print("Report breadcrumbs:", #v10.breadcrumbs)
print("Sending error report to Sentry (context + threads + breadcrumbs)...")

v11:sendErrorReport(v10)

v11:stop()
print("Done. Check the Sentry issue for the breadcrumb trail.")
