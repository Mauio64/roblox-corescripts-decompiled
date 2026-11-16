local parent = script:FindFirstAncestor("ErrorReporters").Parent
local HttpService = game:GetService("HttpService")

local Cryo = require(parent.Cryo)
local t = require(parent.t)

local ProcessErrorStack = require(script.Parent.Parent.ProcessErrorStack)

local strictInterface = t.strictInterface({
	guessed_frame = t.optional(t.boolean),
	funcName = t.optional(t.string),
	address = t.optional(t.string),
	line = t.optional(t.string),
	column = t.optional(t.string),
	sourceCode = t.optional(t.string),
	library = t.optional(t.string),
	debug_identifier = t.optional(t.string),
	faulted = t.optional(t.boolean),
	registers = t.optional(t.map(t.string, t.some(t.string, t.number)))
})

local strictInterface2 = t.strictInterface({
	name = t.optional(t.string),
	fault = t.optional(t.boolean),
	stack = t.optional(t.array(strictInterface))
})

local strictInterface3 = t.strictInterface({
	name = t.string,
	registers = t.map(t.string, t.string)
})

local strictInterface4 = t.strictInterface({
	text = t.optional(t.string),
	startLine = t.optional(t.number),
	startColumn = t.optional(t.number),
	startPos = t.optional(t.number),
	path = t.optional(t.string),
	tabWidth = t.optional(t.number)
})

local strictInterface5 = t.strictInterface({ read = t.boolean, write = t.boolean, exec = t.boolean })

local strictInterface6 = t.strictInterface({
	start = t.string,
	size = t.optional(t.number),
	data = t.optional(t.string),
	perms = t.optional(strictInterface5)
})

local strictInterface7 = t.strictInterface({
	start = t.string,
	size = t.number,
	code_file = t.optional(t.string),
	version = t.optional(t.string),
	debug_file = t.optional(t.string),
	debug_identifier = t.optional(t.string),
	debug_file_exists = t.optional(t.boolean)
})

local optional = t.optional(t.map(t.string, t.some(t.string, t.number, t.boolean)))

local optional2 = t.optional(t.map(t.string, function(p)
	local function checkTypeRecursive(items)
		if type(items) ~= "table" then
			return t.some(t.string, t.number, t.boolean)(items)
		end

		for k, item in pairs(items) do
			local v, v2 = checkTypeRecursive(item)

			if not v then
				return false, string.format("error when checking key: %s - %s", k, v2)
			end
		end

		return true
	end

	return checkTypeRecursive(p)
end))

local intersection = t.intersection(t.strictInterface({
	uuid = t.string,
	timestamp = t.number,
	lang = t.string,
	langVersion = t.string,
	agent = t.string,
	agentVersion = t.string,
	threads = t.map(t.string, strictInterface2),
	mainThread = t.string,
	attributes = optional,
	annotations = optional2,
	symbolication = t.optional(t.literal("minidump")),
	entryThread = t.optional(t.string),
	arch = t.optional(strictInterface3),
	fingerprint = t.optional(t.string),
	classifiers = t.optional(t.array(t.string)),
	sourceCode = t.optional(t.map(t.string, strictInterface4)),
	memory = t.optional(t.array(strictInterface6)),
	modules = t.optional(t.array(strictInterface7))
}), function(p)
	local threads = p.threads
	local flag = false

	for _, thread in pairs(threads) do
		local stack = thread.stack

		if stack ~= nil then
			for _, v in ipairs(stack) do
				if v.registers ~= nil then
					flag = true
					break
				end
			end
		end

		if flag then
			break
		end
	end

	if flag and p.arch == nil then
		return false, "arch must exist if you want to have registers in the stack"
	end

	return true
end)

local BacktraceReport = { IAttributes = optional, IAnnotations = optional2 }

BacktraceReport.__index = BacktraceReport

function BacktraceReport.validate(p)
	return intersection(p)
end

function BacktraceReport.new()
	local v = {
		uuid = HttpService:GenerateGUID(false):lower(),
		timestamp = os.time(),
		lang = "lua",
		langVersion = "Roblox",
		agent = "backtrace-Lua",
		agentVersion = "0.1.0",
		threads = {},
		mainThread = "default"
	}

	setmetatable(v, BacktraceReport)

	return v
end

function BacktraceReport:addAttributes(p)
	if type(p) ~= "table" then
		warn("Cannot add attributes of type: ", (type(p)))
		return
	end

	local attributes = self.attributes or {}

	self.attributes = Cryo.Dictionary.join(attributes, p)
end

function BacktraceReport:addAnnotations(p)
	if type(p) ~= "table" then
		warn("Cannot add annotations of type: ", (type(p)))
		return
	end

	local annotations = self.annotations or {}

	self.annotations = Cryo.Dictionary.join(annotations, p)
end

function BacktraceReport:addStackToThread(stack, name)
	local threads = self.threads

	self.threads = Cryo.Dictionary.join(threads, {
		[name] = { name = name, stack = stack }
	})
end

function BacktraceReport:addStackToMainThread(p)
	self:addStackToThread(p, self.mainThread)
end

local function fn(sourceCode) -- 2 equivalent calls inferred from this helper
	if not sourceCode or type(sourceCode) ~= "table" then
		return ""
	end

	local keys = Cryo.Dictionary.keys(sourceCode)

	if #keys > 0 then
		local v = sourceCode[keys[1]]

		if v and v.path ~= nil then
			return v.path
		end
	end

	return ""
end

function BacktraceReport.fromMessageAndStack(errormessage, p)
	local v = BacktraceReport.new()

	v:addAttributes({ ["error.message"] = errormessage })

	local v2, sourceCode = ProcessErrorStack(p)
	v:addStackToMainThread(v2)
	v.sourceCode = sourceCode

	v:addAttributes({ MainSourcePath = fn(v.sourceCode) }) -- inferred equivalent call

	return v
end

function BacktraceReport.fromDetails(data)
	local result = BacktraceReport.new()

	result:addAttributes({ ["error.message"] = data.message })

	result.sourceCode = {}
	local v = 0

	for i, stack in ipairs(data.stacks) do
		local v2, v3
		v2, v3, v = ProcessErrorStack(stack, v)

		if i == 1 then
			result:addStackToMainThread(v2)
		else
			result:addStackToThread(v2, "stack" .. i)
		end

		result.sourceCode = Cryo.Dictionary.join(result.sourceCode, v3)
	end

	result:addAnnotations(data.annotations)

	result:addAttributes({ MainSourcePath = fn(result.sourceCode) }) -- inferred equivalent call

	return result
end

return BacktraceReport
